#!/bin/bash

# Enable Shell exit on any error
set -e

# Set the version
Version="0.1.0"

# Parse command line arguments
while getopts ":d:e:g:c:" opt; do
  case $opt in
  d)
    install_dir="$OPTARG"
    ;;
  e)
    env_name="$OPTARG"
    ;;
  g)
    geant4_data_lib="$OPTARG"
    ;;
  c)
    cross_section_data_lib="$OPTARG"
    ;;
  \?)
    echo "Invalid option: -$OPTARG" >&2
    exit 1
    ;;
  :)
    echo "Option -$OPTARG requires an argument." >&2
    exit 1
    ;;
  esac
done

detect_os() {
  if [[ (-z "${os}") && (-z "${dist}") ]]; then
    # some systems dont have lsb-release yet have the lsb_release binary and
    # vice-versa
    if [ -e /etc/lsb-release ]; then
      . /etc/lsb-release

      if [ "${ID}" = "raspbian" ]; then
        os=${ID}
        dist=$(cut --delimiter='.' -f1 /etc/debian_version)
      else
        os=${DISTRIB_ID}
        dist=${DISTRIB_CODENAME}

        if [ -z "$dist" ]; then
          dist=${DISTRIB_RELEASE}
        fi
      fi

    elif [ $(which lsb_release 2>/dev/null) ]; then
      dist=$(lsb_release -c | cut -f2)
      os=$(lsb_release -i | cut -f2 | awk '{ print tolower($1) }')

    elif [ -e /etc/debian_version ]; then
      # some Debians have jessie/sid in their /etc/debian_version
      # while others have '6.0.7'
      os=$(cat /etc/issue | head -1 | awk '{ print tolower($1) }')
      if grep -q '/' /etc/debian_version; then
        dist=$(cut --delimiter='/' -f1 /etc/debian_version)
      else
        dist=$(cut --delimiter='.' -f1 /etc/debian_version)
      fi

    else
      echo "Unfortunately, your operating system distribution and version are not supported by this script."
      echo
      echo "You can override the OS detection by setting os= and dist= prior to running this script."
      echo
      echo "For example, to force Ubuntu Trusty: os=ubuntu dist=trusty ./script.sh"
      echo
      exit 1
    fi
  fi

  # remove whitespace from OS and dist name
  os="${os// /}"
  dist="${dist// /}"

  echo "Detected operating system as $os/$dist."
}

detect_version_id() {
  # detect version_id and round down float to integer
  if [ -f /etc/os-release ]; then
    . /etc/os-release
    version_id=${VERSION_ID%%.*}
  elif [ -f /usr/lib/os-release ]; then
    . /usr/lib/os-release
    version_id=${VERSION_ID%%.*}
  else
    version_id="1"
  fi

  echo "Detected version id as $version_id"
}

set_install_directory() {
  if [ -z "$install_dir" ]; then
    working_dir="$(cd -P "$(dirname -- "${BASH_SOURCE}")" >/dev/null 2>&1 && pwd)"
    while true; do
      echo "Please enter the installation directory path:"
      echo "(Press enter for current directory: $working_dir)"
      read -p "Directory path: " install_dir

      if [ -z "$install_dir" ]; then
        install_dir=$working_dir
        echo "Installing application in current directory: $install_dir"
        break
      elif [ -d "$install_dir" ]; then
        echo "Installing application in directory: $install_dir"
        break
      else
        echo "Error: Directory $install_dir does not exist."
        echo
      fi
    done
  elif [ -d "$install_dir" ]; then
    echo "Installing application in directory: $install_dir"
  else
    mkdir -p $install_dir
  fi
}

set_env_name() {
  if [ -z "$env_name" ]; then
    read -p "Enter environment name (or press enter for default 'nuclear-boy'): " env_name

    if [ -z "$env_name" ]; then
      env_name="nuclear-boy"
      echo "Using default environment name: $env_name"
    else
      echo "Using custom environment name: $env_name"
    fi
  else
    echo "Using custom environment name: $env_name"
  fi
  env_dir="$install_dir/$env_name"
}

get_sudo_password() {
  # Check if the user is already root
  if [ "$(id -u)" -eq 0 ]; then
    echo "User is already root. No need for sudo password."
    return
  fi

  # Ask for the administrator password upfront
  sudo -v

  # Keep-alive: update existing sudo time stamp until the script has finished
  while true; do
    sudo -n true
    sleep 60
    kill -0 "$$" || exit
  done 2>/dev/null &
}

# list of package installed through apt-get
apt_package_list="software-properties-common \
                  python3-dev \
                  python3-pip \
                  python3-venv \
                  wget \
                  build-essential \
                  git \
                  cmake \
                  gfortran \
                  qtbase5-dev \
                  libblas-dev \
                  liblapack-dev \
                  libeigen3-dev \
                  hdf5-tools \
                  g++ \
                  libhdf5-dev \
                  libboost-dev \
                  libboost-python-dev \
                  cython3"

# list of python package
pip_package_list="numpy \
                  cython<3 \
                  setuptools \
                  jinja2 \
                  progress \
                  tables \
                  future"

setup_dependencies() {
  echo "--------------------------"
  echo "Installing dependencies..."
  echo "--------------------------"
  # Check if the OS supports apt-get
  if ! command -v apt-get &>/dev/null; then
    echo "Unfortunately, your operating system does not support apt-get."
    exit 1
  fi
  sudo apt-get update
  sudo apt-get install ${apt_package_list} -y --fix-missing
  echo "Dependencies installed"
}

setup_python_env() {
  echo "---------------------------------"
  echo "Setting up virtual environment..."
  echo "---------------------------------"
  create_new_env() {
    echo "Creating Python virtual env in ${env_dir}"
    /usr/bin/python3 -m venv $env_dir
    source $env_dir/bin/activate
    pip3 install wheel
    pip3 install ${pip_package_list}
    # create log directory
    mkdir -p ${env_dir}/var/log
    echo "$Version" >${env_dir}/var/log/Version.id
    echo "Python virtual env created."
  }
  if [ -d "${env_dir}/bin" ]; then
    echo "Virtual environment already exists!"
    core_old_version=$(cat ${env_dir}/var/log/Version.id)
    core_new_version=$Version
    while true; do
      read -p "Update NuclearBoy from $core_old_version to $core_new_version? (y/n): " -n 1 -r
      echo
      if [[ $REPLY =~ ^[Yy]$ ]]; then
        source $env_dir/bin/activate
        break
      elif [[ $REPLY =~ ^[Nn]$ ]]; then
        read -p "Do you want to delete the previous NuclearBoy and create a new one? (y/n): " -n 1 -r
        echo
        if [[ $REPLY =~ ^[Yy]$ ]]; then
          rm -rf "${env_dir}"
          create_new_env
          break
        fi
      else
        echo "Error: Invalid input."
      fi
    done
  else
    create_new_env
  fi
}

set_ld_library_path() {
  # hdf5 std directory
  hdf5_libdir=/usr/lib/x86_64-linux-gnu/hdf5/serial
  # need to put libhdf5.so on LD_LIBRARY_PATH
  if [ -z $LD_LIBRARY_PATH ]; then
    export LD_LIBRARY_PATH="${hdf5_libdir}:${env_dir}/lib"
  else
    export LD_LIBRARY_PATH="${hdf5_libdir}:${env_dir}/lib:$LD_LIBRARY_PATH"
  fi
}

install_moab() {
  echo "------------------"
  echo "Installing MOAB..."
  echo "------------------"
  cd ${env_dir}
  # make a new temporary directory
  mkdir -p .tmp
  cd .tmp
  # clone and version
  git clone --branch release/v5.4.1 --single-branch https://bitbucket.org/fathomteam/moab moab-repo
  cd moab-repo
  mkdir -p build
  cd build
  # cmake, build and install
  cmake ../ -DENABLE_HDF5=ON -DHDF5_ROOT=${hdf5_libdir} \
    -DBUILD_SHARED_LIBS=ON \
    -DENABLE_PYMOAB=ON \
    -DENABLE_BLASLAPACK=OFF \
    -DENABLE_FORTRAN=OFF \
    -DCMAKE_INSTALL_PREFIX=${env_dir}
  make
  make install
  cd ${env_dir}
  # Remove the temporary directory
  rm -rf ${env_dir}/.tmp
  echo "MOAB installed"
}

set_geant4_data_lib() {
  if [ -z "$geant4_data_lib" ]; then
    while true; do
      read -p "Enter Geant4 data library path (or press enter for default '$env_dir/G4Data'): " geant4_data_lib
      if [ -z "$geant4_data_lib" ]; then
        geant4_data_lib=$env_dir/G4Data
        mkdir -p $geant4_data_lib
        echo "Using default library path: $geant4_data_lib"
        break
      elif [ -d "$geant4_data_lib" ]; then
        echo "Using custom library path: $geant4_data_lib"
        break
      else
        echo "Error: Directory $geant4_data_lib does not exist."
        echo "Please enter a valid directory."
      fi
    done
  elif [ -d "$geant4_data_lib" ]; then
    echo "Using custom Geant4 data library path: $geant4_data_lib"
  else
    mkdir -p $geant4_data_lib
  fi
}

clarify_download_geant4_data() {
  while true; do
    echo -n "Download Geant4 data? (default: y 10s) (y/n): 
"
    if read -t 10 download_geant4_data || [ $? -eq 142 ]; then
      if [ -z "$download_geant4_data" ] || [ "$download_geant4_data" == "y" ]; then
        install_geant4_data="ON"
        break
      elif [ "$download_geant4_data" == "n" ]; then
        install_geant4_data="OFF"
        break
      else
        echo "Error: Invalid input."
      fi
    else
      install_geant4_data="ON"
      break
    fi
  done
}

install_geant4() {
  echo "--------------------"
  echo "Installing Geant4..."
  echo "--------------------"
  cd ${env_dir}
  # make a new temporary directory
  mkdir -p .tmp
  cd .tmp
  # Set Geant4 version
  geant4_version='v11.1.2'
  # clone and version
  wget https://github.com/Geant4/geant4/archive/refs/tags/${geant4_version}.tar.gz
  tar -xzvf ${geant4_version}.tar.gz
  # Navigate to the extracted directory
  cd $(tar tzf ${geant4_version}.tar.gz | head -1 | cut -f1 -d"/")
  # Create the directory if it doesn't exist
  mkdir -p "${env_dir}/var/log/"
  # Store the Geant4 version
  echo "$geant4_version" >${env_dir}/var/log/Geant4.version.txt
  # Create Build directory
  mkdir -p build
  cd build
  # cmake, build and install
  cmake ../ -DCMAKE_INSTALL_PREFIX=$env_dir \
    -DGEANT4_USE_QT=ON \
    -DGEANT4_USE_OPENGL_X11=OFF \
    -DGEANT4_USE_SYSTEM_EXPAT=OFF \
    -DGEANT4_BUILD_TLS_MODEL=global-dynamic \
    -DGEANT4_BUILD_MULTITHREADED=ON \
    -DGEANT4_INSTALL_DATA=$install_geant4_data \
    -DGEANT4_INSTALL_DATADIR=$geant4_data_lib \
    -DGEANT4_INSTALL_DATA_TIMEOUT=0
  make
  make install
  # Enable Python bindings
  $env_dir/bin/python3 -m pip install -U geant4-pybind
  cd ${env_dir}
  # Remove the temporary directory
  rm -rf ${env_dir}/.tmp
  echo "Geant4 installed"
}

install_dagmc() {
  echo "-------------------"
  echo "Installing DAGMC..."
  echo "-------------------"
  # pre-setup check that the directory we need are in place
  cd ${env_dir}
  # make a new temporary directory
  mkdir -p .tmp
  cd .tmp
  # clone the repository
  git clone https://github.com/ahnaf-tahmid-chowdhury/DAGMC.git dagmc-repo
  cd dagmc-repo
  # Get the latest commit hash of the develop branch
  dagmc_version=$(git rev-parse origin/develop)
  echo "$dagmc_version" >${env_dir}/var/log/DAGMC.version.txt
  mkdir -p build
  cd build
  # cmake, build and install
  cmake ../ -DMOAB_CMAKE_CONFIG=$env_dir/lib/cmake/MOAB \
    -DMOAB_DIR=$env_dir \
    -DBUILD_STATIC_LIBS=OFF \
    -DBUILD_GEANT4=ON \
    -DGeant4_CMAKE_CONFIG=$env_dir/lib/cmake/Geant4 \
    -DGEANT4_DIR=$env_dir \
    -DBUILD_TALLY=ON \
    -DCMAKE_INSTALL_PREFIX=$env_dir
  make
  make install
  cd ${env_dir}
  # Remove the temporary directory
  rm -rf "${env_dir}/.tmp"
  echo "DAGMC installed"
}

set_cross_section_lib() {
  if [ -z "$cross_section_data_lib" ]; then
    while true; do
      read -p "Enter Cross Section data library path (or press enter for default '$env_dir/CrossSectionData'): " cross_section_data_lib
      if [ -z "$cross_section_data_lib" ]; then
        cross_section_data_lib=$env_dir/CrossSectionData
        mkdir -p $cross_section_data_lib
        echo "Using default library path: $cross_section_data_lib"
        break
      elif [ -d "$cross_section_data_lib" ]; then
        echo "Using custom library path: $cross_section_data_lib"
        break
      else
        echo "Error: Directory $cross_section_data_lib does not exist."
        echo "Please enter a valid directory."
      fi
    done
  elif [ -d "$cross_section_data_lib" ]; then
    echo "Using custom Cross Section data library path: $cross_section_data_lib"
  else
    mkdir -p $cross_section_data_lib
  fi
}

clarify_download_cross_section_data() {
  while true; do
    echo -n "Download Cross Section data? (default: y 10s) (y/n): 
"
    if read -t 10 download_cross_section_data || [ $? -eq 142 ]; then
      if [ -z "$download_cross_section_data" ]; then
        download_cross_section_data="y"
        break
      elif [ "$download_cross_section_data" == "y" ] || [ "$download_cross_section_data" == "n" ]; then
        break
      else
        echo "Error: Invalid input."
      fi
    else
      download_cross_section_data="y"
      echo "Will download Cross Section data."
      break
    fi
  done
}

download_cross_section_data() {
  if [ "$download_cross_section_data" == "y" ]; then
    mkdir -p ${cross_section_data_lib}
    cd ${cross_section_data_lib}
    # Function to download and extract data
    download_and_extract() {
      local url=$1
      local filename=$(basename $url)
      mkdir -p tmp
      cd tmp
      wget $url
      cd ..
      tar -Jxvf tmp/$filename
      rm -rf tmp
    }

    # Check if files and extracted folders exist
    if [ -d "mcnp_endfb70" ]; then
      echo -n "ENDF/B-VII.0 already exists. Do you want to download and extract it again? (default: y 10s) (y/n):
"
      if read -t 10 choice_mcnp_endfb70 || [ $? -eq 142 ]; then
        if [ "$choice_mcnp_endfb70" == "y" ] || [ -z "$choice_mcnp_endfb70" ]; then
          echo "Downloading ENDF/B-VII.0"
          download_and_extract "https://anl.box.com/shared/static/t25g7g6v0emygu50lr2ych1cf6o7454b.xz"
          echo "Download and extraction of mcnp_endfb70 complete"
        else
          echo "Skipping download and extraction of mcnp_endfb70."
        fi
      fi
    else
      echo "Downloading ENDF/B-VII.0"
      download_and_extract "https://anl.box.com/shared/static/t25g7g6v0emygu50lr2ych1cf6o7454b.xz"
      echo "Download and extraction of mcnp_endfb70 complete"
    fi
    if [ -d "mcnp_endfb71" ]; then
      echo -n "ENDF/B-VII.1 already exists. Do you want to download and extract it again? (default: y 10s) (y/n):
"
      if read -t 10 choice_mcnp_endfb71 || [ $? -eq 142 ]; then
        if [ "$choice_mcnp_endfb71" == "y" ] || [ -z "$choice_mcnp_endfb71" ]; then
          echo "Downloading ENDF/B-VII.1"
          download_and_extract "https://anl.box.com/shared/static/d359skd2w6wrm86om2997a1bxgigc8pu.xz"
          echo "Download and extraction of mcnp_endfb71 complete"
        else
          echo "Skipping download and extraction of mcnp_endfb71."
        fi
      fi
    else
      echo "Downloading ENDF/B-VII.1"
      download_and_extract "https://anl.box.com/shared/static/d359skd2w6wrm86om2997a1bxgigc8pu.xz"
      echo "Download and extraction of mcnp_endfb71 complete"
    fi

    if [ -d "lib80x_hdf5" ]; then
      echo -n "ENDF/B-VIII.0 already exists. Do you want to download and extract it again? (default: y 10s) (y/n):
"
      if read -t 10 choice_lib80x || [ $? -eq 142 ]; then
        if [ "$choice_lib80x" == "y" ] || [ -z "$choice_lib80x" ]; then
          echo "Downloading ENDF/B-VIII.0"
          download_and_extract "https://anl.box.com/shared/static/nd7p4jherolkx4b1rfaw5uqp58nxtstr.xz"
          echo "Download and extraction of lib80x complete"
        else
          echo "Skipping download and extraction of lib80x."
        fi
      fi
    else
      echo "Downloading ENDF/B-VIII.0"
      download_and_extract "https://anl.box.com/shared/static/nd7p4jherolkx4b1rfaw5uqp58nxtstr.xz"
      echo "Download and extraction of lib80x complete"
    fi
  fi
}

install_openmc() {
  echo "--------------------"
  echo "Installing OpenMC..."
  echo "--------------------"
  cd ${env_dir}
  # create a new temporary directory
  mkdir -p .tmp
  cd .tmp
  git clone https://github.com/openmc-dev/openmc.git openmc-repo
  cd openmc-repo
  git checkout develop
  # Get the latest commit hash of the develop branch
  openmc_version=$(git rev-parse origin/develop)
  echo "$openmc_version" >${env_dir}/var/log/OpenMC.version.txt
  mkdir -p bld
  cd bld
  # cmake, build and install
  cmake ../ -DCMAKE_INSTALL_PREFIX=$env_dir \
    -DOPENMC_USE_DAGMC=ON \
    -DDAGMC_ROOT=$env_dir
  make
  make install
  cd ..
  pip3 install .
  cd ${env_dir}
  # Remove the temporary directory
  rm -rf "${env_dir}/.tmp"
  echo "OpenMC installed"
}

install_pyne() {
  echo "------------------"
  echo "Installing PyNE..."
  echo "------------------"
  # pre-setup
  cd ${env_dir}
  # make a new temporary directory
  mkdir -p .tmp
  cd .tmp
  # clone and version
  git clone https://github.com/pyne/pyne.git pyne-repo
  cd pyne-repo
  # Get the latest commit hash of the develop branch
  pyne_version=$(git rev-parse origin/develop)
  echo "$pyne_version" >${env_dir}/var/log/PyNE.version.txt
  # Run setup
  python3 setup.py install --prefix ${env_dir} \
    --moab ${env_dir} \
    --dagmc ${env_dir} \
    --clean
  cd ${env_dir}
  # Remove the temporary directory
  rm -rf "${env_dir}/.tmp"
  echo "PyNE installed"
  echo "Making PyNE nuclear data"
  nuc_data_make
}

create_program_file() {
  echo "Creating program..."
  if [ -f "${env_dir}/${env_name}" ]; then
    rm "${env_dir}/${env_name}"
  fi
  cat >${env_dir}/${env_name} <<EOF
#!/bin/bash

if [ -z \$LD_LIBRARY_PATH ]; then
  export LD_LIBRARY_PATH="${hdf5_libdir}:${env_dir}/lib"
else
  export LD_LIBRARY_PATH="${hdf5_libdir}:${env_dir}/lib:\$LD_LIBRARY_PATH"
fi

export GEANT4_DATA_DIR="${geant4_data_lib}"

export OPENMC_CROSS_SECTIONS="${cross_section_data_lib}/lib80x_hdf5/cross_sections.xml"

__${env_name}_activate(){
  source ${env_dir}/bin/activate 
}

__${env_name}_deactivate(){
  deactivate
}

__${env_name}_set_cross_sections_path() {
  if [ -n "\$OPENMC_CROSS_SECTIONS" ]; then
      unset OPENMC_CROSS_SECTIONS
  fi
  local cmd=\$1
  case \$cmd in
  endfb70) export OPENMC_CROSS_SECTIONS="${cross_section_data_lib}/mcnp_endfb70/cross_sections.xml" ;;
  endfb71) export OPENMC_CROSS_SECTIONS="${cross_section_data_lib}/mcnp_endfb71/cross_sections.xml" ;;
  lib80x) export OPENMC_CROSS_SECTIONS="${cross_section_data_lib}/lib80x_hdf5/cross_sections.xml" ;;
  *) echo "Error: Invalid input. Use '${env_name} --help' for more information.";
  esac
}

__${env_name}_update_geant4_worker(){
  echo "Updating Geant4 from \$geant4_old_version to \$geant4_latest_version"
  while true; do
    echo "Do you want to download the latest Geant4 Data? (y/n): "
    read -r REPLY
    if [[ \$REPLY =~ ^[Yy]\$ ]]; then
      download_geant4_data="ON"
      break
    elif [[ \$REPLY =~ ^[Nn]\$ ]]; then
      download_geant4_data="OFF"
      break
    else
      echo "Error: Invalid input."
    fi
  done
  # Get the current working directory
  current_working_dir=\$(pwd)
  # Navigate to the existing Geant4 installation directory
  cd ${env_dir}
  # Make a new temporary directory
  mkdir -p .tmp
  cd .tmp
  # Download and extract the latest Geant4 version
  wget https://github.com/Geant4/geant4/archive/refs/tags/\${geant4_latest_version}.tar.gz
  tar -xzvf \${geant4_latest_version}.tar.gz
  cd \$(tar tzf \${geant4_version}.tar.gz | head -1 | cut -f1 -d"/")
  mkdir -p build
  cd build
  # cmake, build, and install
  cmake ../ -DCMAKE_INSTALL_PREFIX=$env_dir \\
    -DGEANT4_USE_QT=ON \\
    -DGEANT4_USE_OPENGL_X11=OFF \\
    -DGEANT4_USE_SYSTEM_EXPAT=OFF \\
    -DGEANT4_BUILD_TLS_MODEL=global-dynamic \\
    -DGEANT4_BUILD_MULTITHREADED=ON \\
    -DGEANT4_INSTALL_DATA=\$download_geant4_data \\
    -DGEANT4_INSTALL_DATADIR=$geant4_data_lib \\
    -DGEANT4_INSTALL_DATA_TIMEOUT=0
  make
  make install
  $env_dir/bin/python3 -m pip install -U geant4-pybind
  echo "Geant4 has been updated to the latest version."
  # Update the stored version tag
  echo "\$geant4_latest_version" >\${env_dir}/var/log/Geant4.version.txt
  # Remove the temporary directory
  rm -rf "${env_dir}/.tmp"
  cd \$current_working_dir
}

__${env_name}_update_geant4() {
  echo "--------------------"
  echo "Updating Geant4..."
  echo "--------------------"
  # Get the latest version tag from the Geant4 GitHub repository
  geant4_latest_beta_version=\$(git ls-remote --tags https://github.com/Geant4/geant4.git | grep -oP 'refs/tags/v\d+\.\d+\.\d+.beta+\^\{\}' | grep -oP 'v\d+\.\d+\.\d+.beta+' | sort -V | tail -n1)
  geant4_latest_stable_version=\$(git ls-remote --tags https://github.com/Geant4/geant4.git | grep -oP 'refs/tags/v\d+\.\d+\.\d+\^\{\}' | grep -oP 'v\d+\.\d+\.\d+' | sort -V | tail -n1)
  # Read the previously stored version tag from the file
  geant4_old_version=\$(cat ${env_dir}/var/log/Geant4.version.txt)
  # Compare the new and old version tags
  if [[ "\$geant4_latest_beta_version" < "\$geant4_old_version" ]]; then
    echo "Geant4 is already up to date."
  else
    if [[ "\$geant4_latest_beta_version" > "\$geant4_latest_stable_version" ]]; then
      if [[ "\$geant4_latest_stable_version" > "\$geant4_old_version" ]]; then
        echo "New Geant4 stable version is available: \$geant4_latest_stable_version"
        echo "There is also a beta version available: \$geant4_latest_beta_version"
        while true; do
          echo "Which version would you like to use? (stable/beta): "
          read -r REPLY
          if [[ \$REPLY =~ ^[Ss][Tt][Aa][Bb][Ee]\$ ]]; then
            geant4_latest_version="\$geant4_latest_stable_version"
            break
          elif [[ \$REPLY =~ ^[Bb][Ee][Tt][Aa][Ll]\$ ]]; then
            geant4_latest_version="\$geant4_latest_beta_version"
            break
          else
            echo "Error: Invalid input."
          fi
        done
        __${env_name}_update_geant4_worker
      else
        echo "New Geant4 beta version is available: \$geant4_latest_beta_version"
        while true; do
          echo "Do you want to use the beta version? (y/n): "
          read -r REPLY
          if [[ \$REPLY =~ ^[Yy]\$ ]]; then
            geant4_latest_version="\$geant4_latest_beta_version"
            __${env_name}_update_geant4_worker
            break
          elif [[ \$REPLY =~ ^[Nn]\$ ]]; then
            echo "Geant4 update cancelled."
            break
          else
            echo "Error: Invalid input."
          fi
        done
      fi
    fi
  fi
}

__${env_name}_update_openmc() {
  echo "---------------------"
  echo "Updating OpenMC..."
  echo "---------------------"
  # Get the latest commit hash of the develop branch
  openmc_new_version=\$(git ls-remote https://github.com/openmc-dev/openmc.git refs/heads/develop | awk '{print \$1}')
  # Read the previously stored commit hash from the file
  openmc_old_version=\$(cat ${env_dir}/var/log/OpenMC.version.txt)
  # Compare the new and old commit hashes
  if [[ "\$openmc_new_version" == "\$openmc_old_version" ]]; then
    echo "OpenMC is already up to date."
  else
    while true; do
      echo "Update OpenMC from \$openmc_old_version to \$openmc_new_version? (y/n): "
      read -r REPLY
      if [[ \$REPLY =~ ^[Yy]\$ ]]; then
        # Get the current working directory
        current_working_dir=\$(pwd)
        # Navigate to the existing OpenMC installation directory
        cd ${env_dir}
        # Make a new temporary directory
        mkdir -p .tmp
        cd .tmp
        # Remove the existing OpenMC repository if it exists
        rm -rf openmc-repo
        # Clone the latest version of the OpenMC repository
        git clone https://github.com/openmc-dev/openmc.git openmc-repo
        cd openmc-repo
        git checkout develop
        # Perform the update steps
        mkdir -p bld
        cd bld
        cmake ../ -DCMAKE_INSTALL_PREFIX=$env_dir \\
          -DOPENMC_USE_DAGMC=ON \\
          -DDAGMC_ROOT=$env_dir
        make
        make install
        cd ..
        pip3 install .
        echo "OpenMC has been updated to the latest version."
        # Update the stored commit hash
        echo "\$openmc_new_version" >${env_dir}/var/log/OpenMC.version.txt
        # Remove the temporary directory
        rm -rf "${env_dir}/.tmp"
        cd \$current_working_dir
        break
      elif [[ \$REPLY =~ ^[Nn]\$ ]]; then
        echo "OpenMC update cancelled."
        break
      else
        echo "Error: Invalid input."
      fi
    done
  fi
}

__${env_name}_update_dagmc() {
  echo "-------------------"
  echo "Updating DAGMC..."
  echo "-------------------"
  # Get the latest commit hash of the develop branch
  dagmc_new_version=\$(git ls-remote https://github.com/ahnaf-tahmid-chowdhury/DAGMC.git refs/heads/develop | awk '{print \$1}')
  # Read the previously stored commit hash from the file
  dagmc_old_version=\$(cat ${env_dir}/var/log/DAGMC.version.txt)
  # Compare the new and old commit hashes
  if [[ "\$dagmc_new_version" == "\$dagmc_old_version" ]]; then
    echo "DAGMC is already up to date."
  else
    while true; do
      echo "Update DAGMC from \$dagmc_old_version to \$dagmc_new_version? (y/n): "
      read -r REPLY
      if [[ \$REPLY =~ ^[Yy]\$ ]]; then
        # Get the current working directory
        current_working_dir=\$(pwd)
        # Navigate to the existing DAGMC installation directory
        cd ${env_dir}
        # Make a new temporary directory
        mkdir -p .tmp
        cd .tmp
        # Remove the existing DAGMC repository if it exists
        rm -rf dagmc-repo
        # Clone the latest version of the DAGMC repository
        git clone https://github.com/ahnaf-tahmid-chowdhury/DAGMC.git dagmc-repo
        cd dagmc-repo
        git checkout develop
        # Perform the update steps
        mkdir -p build
        cd build
        cmake ../ -DMOAB_CMAKE_CONFIG=$env_dir/lib/cmake/MOAB \\
          -DMOAB_DIR=$env_dir \\
          -DBUILD_STATIC_LIBS=OFF \\
          -DBUILD_GEANT4=ON \\
          -DGeant4_CMAKE_CONFIG=$env_dir/lib/cmake/Geant4 \\
          -DGEANT4_DIR=$env_dir \\
          -DBUILD_TALLY=ON \\
          -DCMAKE_INSTALL_PREFIX=$env_dir
        make
        make install
        echo "DAGMC has been updated to the latest version."
        # Update the stored commit hash
        echo "\$dagmc_new_version" >${env_dir}/var/log/DAGMC.version.txt
        # Remove the temporary directory
        rm -rf "${env_dir}/.tmp"
        cd \$current_working_dir
        break
      elif [[ \$REPLY =~ ^[Nn]\$ ]]; then
        echo "DAGMC update cancelled."
        break
      else
        echo "Error: Invalid input."
      fi
    done
  fi
}

__${env_name}_update_pyne() {
  echo "------------------"
  echo "Updating PyNE..."
  echo "------------------"
  # Get the latest commit hash of the develop branch
  pyne_new_version=\$(git ls-remote https://github.com/pyne/pyne.git refs/heads/develop | awk '{print \$1}')
  # Read the previously stored commit hash from the file
  pyne_old_version=\$(cat ${env_dir}/var/log/PyNE.version.txt)
  # Compare the new and old commit hashes
  if [[ "\$pyne_new_version" == "\$pyne_old_version" ]]; then
    echo "PyNE is already up to date."
  else
    while true; do
      echo "Update PyNE from \$pyne_old_version to \$pyne_new_version? (y/n): "
      read -r REPLY
      if [[ \$REPLY =~ ^[Yy]\$ ]]; then
        # Get the current working directory
        current_working_dir=\$(pwd)
        # Navigate to the existing PyNE installation directory
        cd ${env_dir}
        # Make a new temporary directory
        mkdir -p .tmp
        cd .tmp
        # Remove the existing PyNE repository if it exists
        rm -rf pyne-repo
        # Clone the latest version of the PyNE repository
        git clone https://github.com/pyne/pyne.git pyne-repo
        cd pyne-repo
        # Run Setup
        python3 setup.py install --prefix ${env_dir} \\
          --moab ${env_dir} \\
          --dagmc ${env_dir} \\
          --clean
        # Perform any additional steps needed after installation/update
        echo "Making PyNE nuclear data"
        nuc_data_make
        echo "PyNE has been updated to the latest version."
        # Update the stored commit hash
        echo "\$pyne_new_version" >${env_dir}/var/log/PyNE.version.txt
        # Remove the temporary directory
        rm -rf "${env_dir}/.tmp"
        cd \$current_working_dir
        break
      elif [[ \$REPLY =~ ^[Nn]\$ ]]; then
        echo "PyNE update cancelled."
        break
      else
        echo "Error: Invalid input."
      fi
    done
  fi
}

__${env_name}_update_core(){
  echo "----------------------"
  echo "Updating NuclearBoy..."
  echo "----------------------"
  # Get the latest commit hash of the develop branch
  core_new_version=\$(git ls-remote https://github.com/ahnaf-tahmid-chowdhury/NuclearBoy.git develop | awk '{print \$1}')
  # Read the previously stored commit hash from the file
  core_old_version=\$(cat ${env_dir}/var/log/Version.id)
  # Compare the new and old commit hashes
  if [[ "\$core_new_version" == "\$core_old_version" ]]; then
    echo "NuclearBoy is already up to date."
  else
    while true; do
      echo "Update NuclearBoy from \$core_old_version to \$core_new_version? (y/n): "
      read -r REPLY
      if [[ \$REPLY =~ ^[Yy]\$ ]]; then
        # Get the current working directory
        current_working_dir=\$(pwd)
        # Navigate to the existing NuclearBoy installation directory
        cd ${env_dir}
        # Make a new temporary directory
        mkdir -p .tmp
        cd .tmp
        # Remove the existing NuclearBoy repository if it exists
        rm -rf NuclearBoy
        # Clone the latest version of the NuclearBoy repository
        git clone https://github.com/ahnaf-tahmid-chowdhury/NuclearBoy.git NuclearBoy
        cd NuclearBoy
        # Run Setup
        ./install-nuclear-boy.sh -d ${install_dir} -e ${env_name}
        # Remove the temporary directory
        rm -rf ${env_dir}/.tmp
        cd \$current_working_dir
        break
      elif [[ \$REPLY =~ ^[Nn]\$ ]]; then
        echo "NuclearBoy update cancelled."
        break
      else
        echo "Error: Invalid input."
      fi
    done
  fi
}

__${env_name}_update(){
  local comd=\$1
  case \$comd in
  geant4) __${env_name}_update_geant4 ;;
  openmc) __${env_name}_update_openmc ;;
  pyne) __${env_name}_update_pyne ;;
  dagmc) __${env_name}_update_dagmc ;;
  core) __${env_name}_update_core ;;
  all) __${env_name}_update_core && __${env_name}_update_geant4 && __${env_name}_update_openmc && __${env_name}_update_dagmc && __${env_name}_update_pyne ;;
  *) echo "Error: Invalid input. Use '${env_name} --help' for more information.";
  esac
}

__${env_name}_uninstall(){
  echo "You are about to uninstall ${env_name}."
  echo -e "\033[31mAre you sure? (y/n) \033[0m"
  read -r REPLY
  if [[ \$REPLY =~ ^[Yy]\$ ]]; then
    echo -e "\033[31mType '${env_name}' to confirm: \033[0m"
    read -r REPLY
      if [[ "\$REPLY" == "${env_name}" ]]; then
      echo "Uninstalling ${env_name}..."
      echo "Removing ${env_name} directory..."
      rm -rf ${env_dir}
      remove_from_shell(){
        echo "Removing ${env_name} from your shell."
        local config_file="\$1"
        if [ -f "\$config_file" ]; then
          sed -i '/#<<< NuclearBoy >>>#/,/#>>> NuclearBoy <<<#/d' "\$config_file"
          echo "Removed ${env_name} from \$config_file."
        fi
      }
      remove_from_shell "\$HOME/.bashrc"
      remove_from_shell "\$HOME/.zshrc"
      remove_from_shell "\$HOME/.config/fish/config.fish"
      echo "${env_name} uninstalled."
    else
      echo "Name does not match. Uninstall cancelled."
    fi
  else
    echo "Uninstall cancelled."
  fi
}

__${env_name}_help() {
  echo "NuclearBoy: Package Manager for Nuclear Engineering Development


Commands:

  -h, --help         Display this help message

  -V, --version      Display version

  activate           Activate the NuclearBoy environment

  deactivate         Deactivate the NuclearBoy environment

  update <module>    Update component
                      - core:     Update NuclearBoy
                      - geant4:   Update Geant4 to the latest version
                      - openmc:   Update OpenMC to the latest version
                      - dagmc:    Update DAGMC to the latest version
                      - pyne:     Update PyNE to the latest version
                      - all:      Update all components
  
  endf <library>     Set the path for cross-section data library:
                      - endfb70: ENDF/B-VII.0 (70)
                      - endfb71: ENDF/B-VII.1 (71)
                      - lib80x:  ENDF/B-VIII.0/X (80X)
  
  uninstall          Uninstall the NuclearBoy toolkit


Usage:

  ${env_name} <command> [options]


Note:
  - Use 'activate' to activate the NuclearBoy environment.
  - Use 'deactivate' to deactivate the NuclearBoy environment.
  - Use 'update' with specific components to update them individually.
  - Use 'update all' to update all components.
  - Use 'endf <library>' to set the cross-section data library path.
  - Use 'uninstall' to completely uninstall the NuclearBoy toolkit.


Examples:
  ${env_name} activate
  ${env_name} update geant4
  ${env_name} update all
  ${env_name} endf endfb70
  ${env_name} uninstall
  
  
Project Home: https://github.com/ahnaf-tahmid-chowdhury/NuclearBoy"
}

__${env_name}_version(){
  echo "NuclearBoy version ${Version}"
}

${env_name}() {
  local comd=\$1
  case \$comd in
  activate) __${env_name}_activate ;;
  deactivate) __${env_name}_deactivate ;;
  update) __${env_name}_update \$2 ;;
  endf) __${env_name}_set_cross_sections_path \$2 ;;
  uninstall) __${env_name}_uninstall ;;
  -h|--help) __${env_name}_help ;;
  -V|--version) __${env_name}_version ;;
  *) echo "Error: Invalid input. Use '${env_name} --help' for more information.";
  esac
}

EOF
  chmod +x ${env_dir}/${env_name}
  echo "${env_name} created."
}

add_to_shell() {
  echo "Adding ${env_name} to your shell."
  # Backup shell configuration files
  backup_dir="$HOME/.shell_config_backup"
  mkdir -p "$backup_dir"
  backup_and_append() {
    config_file="$1"
    if [ -f "$config_file" ]; then
      # Backup the original file
      backup_file="$backup_dir/$(basename $config_file)_$(date +%Y%m%d%H%M%S)"
      cp "$config_file" "$backup_file"
      # Append to the config file if not already present
      if ! grep -q "#<<< NuclearBoy >>>#" "$config_file" && ! grep -q "#>>> NuclearBoy <<<#" "$config_file"; then
        echo "Adding to $config_file"
        cat >>"$config_file" <<EOF
#<<< NuclearBoy >>>#
if [ -f "${env_dir}/${env_name}" ]; then
  source ${env_dir}/${env_name}
fi
#>>> NuclearBoy <<<#

EOF
      fi
    fi
  }
  # Backup and append to different shell configuration files
  backup_and_append "$HOME/.bashrc"
  backup_and_append "$HOME/.zshrc"
  backup_and_append "$HOME/.config/fish/config.fish"
  echo "${env_name} added to your shell."
  echo "Backup files have been saved to ${backup_dir}"
  echo "Please restart your shell for changes to take effect."
}

main() {
  detect_os
  detect_version_id
  echo
  echo -e "\033[1mWelcome to the NuclearBoy installer!\033[0m"
  echo "This package manager sets up a development 
environment for nuclear physics simulations and calculations. 
It automates the installation of various packages 
and libraries (PyNE, OpenMC, DAGMC, and Geant4) required 
for running nuclear physics simulations and analyses."
  echo
  set_install_directory
  set_env_name
  set_geant4_data_lib
  clarify_download_geant4_data
  set_cross_section_lib
  clarify_download_cross_section_data
  get_sudo_password
  setup_dependencies
  setup_python_env
  set_ld_library_path
  install_moab
  install_geant4
  install_dagmc
  install_openmc
  download_cross_section_data
  install_pyne
  create_program_file
  add_to_shell
  echo "==============================================="
  echo "NuclearBoy installation finished"
  echo "To activate NuclearBoy in your terminal type:"
  echo "${env_name} activate"
  echo "Recommended packages can be installed through:"
  echo "pip3 install -r packages.txt --default-timeout=0"
  echo "================================================"
}
main
