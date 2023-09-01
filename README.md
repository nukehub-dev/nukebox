# <img src=".github/logo/nuclear-boy.svg" alt="" style="height: 60px">NuclearBoy</h1>

![Build and Test](https://img.shields.io/github/actions/workflow/status/ahnaf-tahmid-chowdhury/NuclearBoy/run_build_and_test.yml?style=flat-square&logo=githubactions&logoColor=white&label=Build%20and%20Test
)
![Release](https://img.shields.io/github/v/release/ahnaf-tahmid-chowdhury/NuclearBoy?style=flat-square&logo=github&label=Release&include_prereleases)

This package manager is designed to set up a development environment for nuclear physics simulations and calculations. It automates the installation/update of various packages and libraries ([PyNE][pyne], [OpenMC][openmc], [DAGMC][dagmc], and [Geant4][geant4]) required for running nuclear physics simulations and analyses.

[pyne]: https://pyne.io/
[openmc]: https://docs.openmc.org/en/stable/
[dagmc]: https://svalinn.github.io/DAGMC/
[geant4]: https://geant4.web.cern.ch/

## Usage

1. Clone the repository or download the [latest release](https://github.com/ahnaf-tahmid-chowdhury/NuclearBoy/releases/latest) directly to your local machine.

   ```sh
   git clone https://github.com/ahnaf-tahmid-chowdhury/NuclearBoy.git \
     --depth 1 \
     --branch master
   ```

2. Make the script executable.

   ```sh
   cd NuclearBoy
   chmod +x install-nuclear-boy.sh
   ```

3. Run the script.

   ```sh
   ./install-nuclear-boy.sh
   ```

The script will guide you through the installation process and prompt you for necessary configuration options.

## Installation Options

During the installation process, you'll be asked for the following configuration options:

1. **Installation Directory Path**: Set the path where all the software will be installed. You can use the current directory or specify a custom directory.

2. **Environment Name**: Enter a name for the virtual environment that will be created. The default name is `nuclear-boy`, but you can provide a custom name.

3. **Geant4 Data Library Path**: If you choose to install Geant4 data, provide the path for the Geant4 data library. The default is a directory within the virtual environment.

4. **Cross Section Library Path**: If you choose to install cross sections, provide the path for the cross section library. The default is a directory within the virtual environment.

4. **Auto Download Geant4 Data**: Choose whether to automatically download Geant4 data. Enter `y` for yes or `n` for no.

5. **Auto Download Cross Sections**: Choose whether to automatically download cross sections. Enter `y` for yes or `n` for no.

## Quick Installation

You can also provide the configuration options directly from the command line.

```sh
./install-nuclear-boy.sh -d <installation-directory> \
   -e <environment-name> \
   -g <geant4-data-library-path> \
   -c <cross-section-library-path>
```

## How it Works

1. **Operating System Detection:**
   The script attempts to automatically detect the operating system and its version. It supports systems with `/etc/lsb-release`, `/etc/debian_version`, and systems with `lsb_release` binary. If the detection fails, the script will notify the user that their OS is not supported and provide an option to manually override the OS detection.

2. **Dependencies Installation:**
   The script installs various packages through `apt-get`. The following packages are installed:
   - `software-properties-common`
   - `python3-dev`
   - `python3-pip`
   - `python3-venv`
   - `wget`
   - `build-essential`
   - `git`
   - `cmake`
   - `gfortran`
   - `qtbase5-dev`
   - `libblas-dev`
   - `liblapack-dev`
   - `libeigen3-dev`
   - `hdf5-tools`
   - `g++`
   - `libhdf5-dev`
   - `libboost-dev`
   - `libboost-python-dev`
   - `cython3`

3. **Python Environment Setup:**
   The script creates a Python virtual environment using `venv` in the specified installation directory. It installs the following Python packages using `pip3`:
   - `numpy`
   - `cython<3`
   - `setuptools`
   - `jinja2`
   - `progress`
   - `tables`
   - `future`

4. **MOAB (Mesh-Oriented datABase) Installation:**
   MOAB is a software component that provides a flexible, efficient, and easy-to-use interface for storing and accessing mesh data in MOAB-based applications. The script installs MOAB version 5.4.1 with support for HDF5 and Python.

5. **Geant4 (for GEometry ANd Tracking) Installation:**
   Geant4 is a software toolkit that simulates the passage of particles through matter. The script installs version 11.1.2 of Geant4, with the option to install data libraries in a specified path. The [geant4-pybind](https://github.com/HaarigerHarald/geant4_pybind) package is used to enable Python support.

6. **DAGMC (Direct Accelerated Geometry Monte Carlo) Installation:**
   DAGMC is an extension of Geant4 that enables direct use of CAD (Computer-Aided Design) geometry in Monte Carlo radiation transport simulations. The script installs DAGMC with support for MOAB and Geant4.

7. **OpenMC (Open Monte Carlo) Installation:**
   OpenMC is an open-source Monte Carlo particle transport simulation code that focuses on neutron criticality and radiation shielding problems. The script installs OpenMC with support for DAGMC.

8. **PyNE (Nuclear Engineering Toolkit) Installation:**
   PyNE is a Python package for nuclear engineering and data processing. It provides various functionalities, including nuclear data, geometry processing, and more. The script installs PyNE with support for MOAB and DAGMC.

9. **Create Program File:**
   The script creates an executable program file (shell script) in the specified installation directory with the given environment name.

10. **Add to Path:**
   The script adds the NuclearBoy directory to the user's `PATH` environment variable.

## Activation and Usage

Once the installation is complete, the script will create a program file named after the specified environment name (e.g., `nuclear-boy`). 

**Commands:**
- `-h` or `--help`: Display help
- `-V` or `--version`: Display version
- `activate`: Activate the NuclearBoy environment
- `deactivate`: Deactivate the NuclearBoy environment
- `update <module>`: Update component
  - `core`: Update NuclearBoy
  - `geant4`: Update Geant4 to the latest version
  - `dagmc`: Update DAGMC to the latest version
  - `openmc`: Update OpenMC to the latest version
  - `pyne`: Update PyNE to the latest version
  - `all`: Update all components (NuclearBoy, Geant4, DAGMC, OpenMC, and PyNE)
- `endf <library>`: Set the path for cross-section data library:
  - `endfb70`: ENDF/B-VII.0 (70)
  - `endfb71`: ENDF/B-VII.1 (71)
  - `lib80x`: ENDF/B-VIII.0/X (80X)
- `uninstall`: Uninstall the NuclearBoy toolkit

**Usage:**
```sh
nuclear-boy <command> [options]
```

**Note:**
- Use `activate` to activate the NuclearBoy environment.
- Use `deactivate` to deactivate the NuclearBoy environment.
- Use `update` with specific components to update them individually.
- Use `update all` to update all components.
- Use `endf <library>` to set the cross-section data library path.
- Use `uninstall` to completely uninstall the NuclearBoy toolkit.

**Examples:**
```sh
nuclear-boy activate
nuclear-boy update geant4
nuclear-boy update all
nuclear-boy endf endfb70
nuclear-boy uninstall
```

## Recommended Packages

The installer script provides a list of recommended Python packages in the `packages.txt` file. These packages complement the functionality of the installed software. To install them, use:

```sh
nuclear-boy activate
pip3 install -r packages.txt --default-timeout=0
```

Please ensure that you have appropriate permissions to install software on your system. The script may require you to enter your administrator password (sudo) during the installation process.

## Important Notes

- The script is primarily designed for systems that use `apt-get` package manager. If your system doesn't support `apt-get`, the installation process may not work as expected.
- The script is intended for use with Linux-based systems, and its compatibility with other operating systems (e.g., macOS, Windows) may vary.
- Use the script at your own risk. Always review and understand the code before executing any script on your system.
- Before running the script, make sure to read and understand the installation process, as it may involve modifying your system's settings.

## License

This project is licensed under the [MIT License](LICENSE).

## Disclaimer

The NuclearBoy program is provided for informational purposes only. The authors and contributors are not responsible for any damages or issues caused by using this script. Use it at your own risk.

## Contributing

Contributions to this project are welcome. If you find any issues or have improvements to suggest, feel free to open a GitHub issue or create a pull request.

## Contact

For any questions or inquiries, please contact the maintainers of this project:

- [Ahnaf Tahmid Chowdhury](https://github.com/ahnaf-tahmid-chowdhury)
