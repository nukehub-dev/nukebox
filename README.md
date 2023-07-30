# NuclearBoy Installer Script

The NuclearBoy installer script automates the installation process for [PyNE][pyne], [OpenMC][openmc], [DAGMC][dagmc], and [Geant4][geant4] software on your system. These tools are commonly used in nuclear engineering and simulation applications.

[pyne]: https://pyne.io/
[openmc]: https://docs.openmc.org/en/stable/
[dagmc]: https://svalinn.github.io/DAGMC/
[geant4]: https://geant4.web.cern.ch/

## Usage

1. Clone the repository or download the script directly to your local machine.

   ```sh
   git clone https://github.com/ahnaf-tahmid-chowdhury/NuclearBoy.git
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

2. **Environment Name**: Enter a name for the Python virtual environment that will be created. The default name is "nuclear-boy," but you can provide a custom name.

3. **Geant4 Data Library Path**: If you choose to install Geant4 data, provide the path for the Geant4 data library. The default is a directory within the virtual environment.

4. **Auto Install Geant4 Data**: Choose whether to automatically install Geant4 data. Enter "y" for yes or "n" for no.

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
   - `cython`
   - `setuptools`
   - `jinja2`
   - `progress`
   - `tables`
   - `future`

4. **MOAB (Mesh-Oriented datABase) Installation:**
   MOAB is a software component that provides a flexible, efficient, and easy-to-use interface for storing and accessing mesh data in MOAB-based applications. The script installs MOAB version 5.4.1 with support for HDF5 and Python.

5. **Geant4 Installation:**
   Geant4 is a toolkit for the simulation of the passage of particles through matter. The script installs Geant4 version 11.1.1 with optional data installation, using the specified Geant4 data library path.

6. **DAGMC (Direct Accelerated Geometry Monte Carlo) Installation:**
   DAGMC is an extension of Geant4 that enables direct use of CAD (Computer-Aided Design) geometry in Monte Carlo radiation transport simulations. The script installs DAGMC with support for MOAB and Geant4.

7. **OpenMC Installation:**
   OpenMC is an open-source Monte Carlo particle transport simulation code that focuses on neutron criticality and radiation shielding problems. The script installs OpenMC with support for DAGMC.

8. **PyNE Installation:**
   PyNE is a Python package for nuclear engineering and data processing. It provides various functionalities, including nuclear data, geometry processing, and more. The script installs PyNE with support for MOAB and DAGMC.

9. **Create Program File:**
   The script creates an executable program file (shell script) in the specified installation directory with the given environment name.

10. **Create Shortcut:**
    The script creates a symbolic link to the program file in the `/usr/bin/` directory, allowing users to run the NuclearBoy environment from any location by simply typing the specified environment name in the terminal.

## Activation and Usage

Once the installation is complete, the script will create a program file named after the specified environment name (e.g., `nuclear-boy`). This program file allows you to activate the virtual environment and set the necessary environment variables for the installed software.

To activate the NuclearBoy environment in your terminal, run:

```sh
source nuclear-boy
```

After activation, you can use the installed tools such as PyNE, OpenMC, DAGMC, and Geant4 within the virtual environment.

## Recommended Packages

The installer script provides a list of recommended Python packages in the `packages.txt` file. These packages complement the functionality of the installed software. To install them, use:

```sh
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

The NuclearBoy installer script is provided for informational purposes only. The authors and contributors are not responsible for any damages or issues caused by using this script. Use it at your own risk.

## Contributing

Contributions to this project are welcome. If you find any issues or have improvements to suggest, feel free to open a GitHub issue or create a pull request.

## Contact

For any questions or inquiries, please contact the maintainers of this project:

- Ahnaf Tahmid Chowdhury ([tahmid@nse.mist.ac.bd](mailto:tahmid@nse.mist.ac.bd))
