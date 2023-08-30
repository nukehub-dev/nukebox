# Changelog


## [0.0.1] - 31/08/2023

### Added
- Initial release of NuclearBoy Installer Script.
- Automated installation process for PyNE, OpenMC, DAGMC, and Geant4 software.
- User-friendly installation script for setting up nuclear engineering and simulation tools.
- Support for setting installation directory, environment name, and Geant4 data library path.
- Option to automatically install Geant4 data.
- Python virtual environment creation using `venv`.
- Installation of required dependencies and packages.
- MOAB (Mesh-Oriented datABase) version 5.4.1 installation.
- Geant4 version 11.1.1 installation with optional data.
- DAGMC installation with MOAB and Geant4 support.
- OpenMC installation with DAGMC support.
- PyNE installation with MOAB and DAGMC support.
- Creation of program file for environment activation.
- Creation of symbolic link for easy environment activation from any location.

### Fixed
- Set cython<3 (#2)

[0.0.1]: https://github.com/ahnaf-tahmid-chowdhury/NuclearBoy/releases/tag/0.0.1
