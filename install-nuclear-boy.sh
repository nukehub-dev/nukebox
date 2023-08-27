#!/bin/bash

set -e

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
}

set_env_name() {
  read -p "Enter environment name (or press enter for default 'nuclear-boy'): " env_name

  if [ -z "$env_name" ]; then
    env_name="nuclear-boy"
    echo "Using default environment name: $env_name"
  else
    echo "Using custom environment name: $env_name"
  fi
  env_dir="$install_dir/$env_name"
}

get_sudo_password() {
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
  if [ -d "${env_dir}" ]; then
    echo "Virtual environment already exists. Deleting..."
    rm -rf "${env_dir}"
  fi
  echo "Creating Python virtual env in ${env_dir}"
  /usr/bin/python3 -m venv $env_dir
  source $env_dir/bin/activate
  pip3 install wheel
  pip3 install ${pip_package_list}
  echo "Python virtual env created."
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
  rm -rf "${env_dir}/moab-repo"
  echo "MOAB installed"
}

set_geant4_data_lib() {
  while true; do
    read -p "Enter Geant4 data library path (or press enter for default '$env_dir/G4data'): " geant4_data_lib

    if [ -z "$geant4_data_lib" ]; then
      geant4_data_lib=$env_dir/G4data
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
}

clarify_download_geant4_data() {
  while true; do
    read -t 10 -p "Download Geant4 data? (default: y 10s) (y/n): " download_geant4_data
    if [ "$download_geant4_data" == "y" || -z "$download_geant4_data"]; then
      install_geant4_data="ON"
      break
    elif [ "$download_geant4_data" == "n"]; then
      install_geant4_data="OFF"
      break
    else
      echo "Error: Invalid input."
    fi
  done
}

install_geant4() {
  echo "--------------------"
  echo "Installing Geant4..."
  echo "--------------------"
  cd ${env_dir}
  # clone and version
  wget https://github.com/Geant4/geant4/archive/refs/tags/v11.1.1.tar.gz
  tar -xzvf v11.1.1.tar.gz
  cd geant4-11.1.1
  mkdir -p build
  cd build
  # cmake, build and install
  cmake ../ -DGEANT4_INSTALL_DATA=$install_geant4_data \
    -DGEANT4_INSTALL_DATADIR=$geant4_data_lib \
    -DGEANT4_USE_QT=ON \
    -DGEANT4_USE_OPENGL_X11=OFF \
    -DGEANT4_USE_SYSTEM_EXPAT=OFF \
    -DCMAKE_INSTALL_PREFIX=$env_dir
  make
  make install
  cd ${env_dir}
  rm -rf "${env_dir}/geant4-11.1.1"
  rm -rf "${env_dir}/v11.1.1.tar.gz"
  echo "Geant4 installed"
}

install_dagmc() {
  echo "-------------------"
  echo "Installing DAGMC..."
  echo "-------------------"
  # pre-setup check that the directory we need are in place
  cd ${env_dir}
  # clone and version
  git clone https://github.com/ahnaf-tahmid-chowdhury/DAGMC.git dagmc-repo
  cd dagmc-repo
  git checkout develop
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
  rm -rf "${env_dir}/dagmc-repo"
  echo "DAGMC installed"
}

set_cross_section_lib() {
  while true; do
    read -p "Enter Cross Section data library path (or press enter for default '$env_dir/CrossSectionData'): " cross_section_data_lib
    if [ -z "$cross_section_data_lib" ]; then
      cross_section_data_lib=$env_dir/CrossSectionData
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
}

clarify_download_cross_section_data() {
  while true; do
    read -t 10 -p "Download Cross Section data? (default: y 10s) (y/n): " download_cross_section_data
    if [ -z "$download_cross_section_data" ]; then
      $download_cross_section_data="y"
      break
    elif [ "$download_cross_section_data" == "y" || "$download_cross_section_data" == "n" ]; then
      break
    else
      echo "Error: Invalid input."
    fi
  done
}

download_cross_section_data() {
  if [ "$download_cross_section_data" == "y" ]; then
    cd ${cross_section_data_lib}
    # Function to download and extract data
    download_and_extract() {
      local url=$1
      local filename=$2
      wget $url
      tar -Jxvf $filename
      rm $filename
    }

    # Check if files and extracted folders exist
    if [ -f "mcnp_endfb70.tar.xz" ] || [ ! -d "mcnp_endfb70" ]; then
      read -t 10 -p "File mcnp_endfb70.tar.xz already exists. Do you want to download and extract it again? (default: y 10s) (y/n): " choice_mcnp_endfb70
      if [ "$choice_mcnp_endfb70" == "y" ] || [ -z "$choice_mcnp_endfb70" ]; then
        echo "Downloading ENDF/B-VII.0"
        download_and_extract "https://anl.box.com/shared/static/t25g7g6v0emygu50lr2ych1cf6o7454b.xz" "mcnp_endfb70.tar.xz"
        echo "Download and extraction of mcnp_endfb70.tar.xz complete"
      else
        echo "Skipping download and extraction of mcnp_endfb70.tar.xz."
      fi
    else
      echo "Downloading ENDF/B-VII.0"
      download_and_extract "https://anl.box.com/shared/static/t25g7g6v0emygu50lr2ych1cf6o7454b.xz" "mcnp_endfb70.tar.xz"
      echo "Download and extraction of mcnp_endfb70.tar.xz complete"
    fi

    if [ -f "mcnp_endfb71.tar.xz" ] || [ ! -d "mcnp_endfb71" ]; then
      read -t 10 -p "File mcnp_endfb71.tar.xz already exists. Do you want to download and extract it again? (default: y 10s) (y/n): " choice_mcnp_endfb71
      if [ "$choice_mcnp_endfb71" == "y" ] || [ -z "$choice_mcnp_endfb71" ]; then
        echo "Downloading ENDF/B-VII.1"
        download_and_extract "https://anl.box.com/shared/static/d359skd2w6wrm86om2997a1bxgigc8pu.xz" "mcnp_endfb71.tar.xz"
        echo "Download and extraction of mcnp_endfb71.tar.xz complete"
      else
        echo "Skipping download and extraction of mcnp_endfb71.tar.xz."
      fi
    else
      echo "Downloading ENDF/B-VII.1"
      download_and_extract "https://anl.box.com/shared/static/d359skd2w6wrm86om2997a1bxgigc8pu.xz" "mcnp_endfb71.tar.xz"
      echo "Download and extraction of mcnp_endfb71.tar.xz complete"
    fi

    if [ -f "lib80x.tar.xz" ] || [ ! -d "lib80x" ]; then
      read -t 10 -p "File lib80x.tar.xz already exists. Do you want to download and extract it again? (default: y 10s) (y/n): " choice_lib80x
      if [ "$choice_lib80x" == "y" ] || [ -z "$choice_lib80x" ]; then
        echo "Downloading ENDF/B-VIII.0"
        download_and_extract "https://anl.box.com/shared/static/nd7p4jherolkx4b1rfaw5uqp58nxtstr.xz" "lib80x.tar.xz"
        echo "Download and extraction of lib80x.tar.xz complete"
      else
        echo "Skipping download and extraction of lib80x.tar.xz."
      fi
    else
      echo "Downloading ENDF/B-VIII.0"
      download_and_extract "https://anl.box.com/shared/static/nd7p4jherolkx4b1rfaw5uqp58nxtstr.xz" "lib80x.tar.xz"
      echo "Download and extraction of lib80x.tar.xz complete"
    fi
  fi
}

install_openmc() {
  echo "--------------------"
  echo "Installing OpenMC..."
  echo "--------------------"
  cd ${env_dir}
  git clone https://github.com/openmc-dev/openmc.git openmc-repo
  cd openmc-repo
  git checkout develop
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
  rm -rf "${env_dir}/openmc-repo"
  echo "OpenMC installed"
}

install_pyne() {
  echo "------------------"
  echo "Installing PyNE..."
  echo "------------------"
  # pre-setup
  cd ${env_dir}
  # clone and version
  git clone https://github.com/pyne/pyne.git pyne-repo
  cd pyne-repo
  python3 setup.py install --prefix ${env_dir} \
    --moab ${env_dir} \
    --dagmc ${env_dir} \
    --clean
  cd ${env_dir}
  rm -rf "${env_dir}/pyne-repo"
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

if [ -z $LD_LIBRARY_PATH ]; then
  export LD_LIBRARY_PATH="${hdf5_libdir}:${env_dir}/lib"
else
  export LD_LIBRARY_PATH="${hdf5_libdir}:${env_dir}/lib:$LD_LIBRARY_PATH"
fi

export OPENMC_CROSS_SECTIONS="${cross_section_data_lib}/lib80x"

__${env_name}_activate(){
  source ${env_dir}/bin/activate 
}

__${env_name}_deactivate(){
  deactivate
}

__${env_name}_set_cross_sections_path() {
  if [ -n "$OPENMC_CROSS_SECTIONS" ]; then
      unset OPENMC_CROSS_SECTIONS
  fi
  local cmd=$1
  case $cmd in
  endfb70) export OPENMC_CROSS_SECTIONS="${cross_section_data_lib}/mcnp_endfb70" ;;
  endfb71) export OPENMC_CROSS_SECTIONS="${cross_section_data_lib}/mcnp_endfb71" ;;
  lib80x) export OPENMC_CROSS_SECTIONS="${cross_section_data_lib}/lib80x" ;;
  help) echo "Usage: ${env_name} [activate|deactivate|endf [endfb70|endfb71|lib80x]]" ;;
  *) echo "Error: Invalid input.";
  esac
}

${env_name}() {
  local comd=$1
  case $comd in
  activate) __${env_name}_activate ;;
  deactivate) __${env_name}_deactivate ;;
  endf) __${env_name}_set_cross_sections_path $2 ;;
  help) echo "Usage: ${env_name} [activate|deactivate|endf [endfb70|endfb71|lib80x]]" ;;
  *) echo "Error: Invalid input. Use '${env_name} help' for more information.";
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
      if ! grep -q "${env_dir}/${env_name}" "$config_file"; then
        echo "Adding to $config_file"
        cat >> "$config_file" <<EOF
if [ -f "${env_dir}/${env_name}" ]; then
  source ${env_dir}/${env_name}
fi

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
  echo "Welcome to the Nuclear Boy installer!"
  echo "This script will install the PyNE, OpenMC, DAGMC and Geant4 on your system."
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
  #source $env_dir/bin/activate
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
