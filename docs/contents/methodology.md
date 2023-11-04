# Methodology 

## 1. Operating System Detection

The installation script begins by attempting to automatically detect the user's operating system and its version. It checks for the presence of specific system files such as `/etc/lsb-release`, `/etc/debian_version`, and the `lsb_release` binary. If the script successfully detects the operating system, it proceeds with the installation. If detection fails, the user is notified that their OS is not supported, and they are given the option to manually override the OS detection.

## 2. Dependencies Installation

The script proceeds to install various system-level dependencies required for the subsequent software installations. These dependencies are installed using the `apt-get` package manager and include:

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

## 3. Python Environment Setup

The script creates a Python virtual environment using the `venv` tool in a specified installation directory. Within this virtual environment, it installs the following Python packages using `pip3`:

- `numpy`
- `cython<3`
- `setuptools`
- `jinja2`
- `progress`
- `tables`
- `future`

These packages are necessary for the subsequent installation of scientific computing and simulation tools.

## 4. MOAB Installation

The script proceeds to install MOAB (Mesh-Oriented datABase) version 5.4.1. MOAB is a software component that facilitates the storage and access of mesh data in applications. The installation includes support for HDF5 and Python.

## 5. Geant4 Installation

Next, the script installs Geant4 version 11.1.2. Geant4 is a toolkit for simulating the passage of particles through matter. Users have the option to specify a path for installing data libraries. Python support is enabled using the [geant4-pybind](https://github.com/HaarigerHarald/geant4_pybind) package.

## 6. OpenMC Installation

OpenMC, an open-source Monte Carlo particle transport simulation code, is installed with support for DAGMC. This enables users to perform neutron criticality and radiation shielding simulations using DAGMC geometry.

## 7. DAGMC Installation

DAGMC (Direct Accelerated Geometry Monte Carlo) is an extension of Geant4 that allows the direct use of CAD geometry in Monte Carlo radiation transport simulations. The script installs DAGMC with support for MOAB and Geant4.

## 8. PyNE Installation

The script proceeds to install PyNE (Nuclear Engineering Toolkit), a Python package for nuclear engineering and data processing. PyNE provides various functionalities, including nuclear data and geometry processing. The installation includes support for MOAB and DAGMC.

## 9. Create Program File

To simplify the usage of the installed tools, the script creates an executable program file (a shell script) in the specified installation directory. This script can be used to activate the virtual environment and set up the environment variables.

## 10. Add to Path

Finally, the script ensures that the **NukeBox** installation directory is added to the user's `PATH` environment variable, making it easier to access the installed tools from the command line.

The installation process described above ensures that the required software components and dependencies are properly configured for nuclear engineering and simulation tasks, providing users with a complete environment for their work.