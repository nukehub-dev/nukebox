# Changelog

## [v0.1.3] - 06/09/2023

### Changed
- Move ownership to `nukehub-dev`.

## [v0.1.2] - 06/09/2023

### Added
- Sphinx documentation. (#6 #7)
- ReadTheDocs webpage. (#6 #7)

### Changed
- Remove ethicalads. (#8 #9)
- Rename `nuclearboy` to `nuclearkid`. (#10)
- Rename NuclearBoy to NuclearKid. (#10 #11)

### Fixed
- Tab colors. (#13)

### Documentation
- Updated user guide to install the NuclearKid from releases. (#12)
- Updated welcome page and templates. (#12)

[v0.1.2]: https://github.com/ahnaf-tahmid-chowdhury/NuclearKid/releases/tag/v0.1.2


## [v0.1.1] - 01/09/2023

### Changed
- Set logo height to 64px. (#4)

### Fixed
- Fixed uninstall issue. (#4)

### Added Project Enhancements
- Added DOI badge for the project. (#4)

### Documentation
- Updated user guide to install the NuclearBoy from releases. (#4)
- Updated development guide. (#4)

### Miscellaneous
- Other minor improvements, optimizations, and code refinements.(#4)


[v0.1.1]: https://github.com/ahnaf-tahmid-chowdhury/NuclearKid/releases/tag/v0.1.1


## [v0.1.0] - 01/09/2023

### Added
- New command-line interface (CLI) for managing the NuclearBoy environment and its components. (#3)
- Support for specifying the Geant4 data library and cross section library paths during installation and through CLI. (#3)
- Option to automatically download Geant4 data and cross sections during installation. (#3)
- Ability to update individual components (Geant4, DAGMC, OpenMC, PyNE) using the CLI. (#3)
- `endf` command to set the cross-section data library path for different libraries (ENDF/B versions). (#3)
- `uninstall` command to completely uninstall the NuclearBoy toolkit. (#3)
- Quick installation option allowing configuration options to be provided directly from the command line. (#3)
- Include a build status and a release version badge. (#3)

### Changed
- Enhanced the user experience by providing a more comprehensive CLI for managing the NuclearBoy environment. (#3)
- Improved documentation with clear instructions and examples for using the new CLI commands. (#3)
- Updated installation process to include new configuration options in the script. (#3)
- Enhanced error handling and user feedback during installation and updates. (#3)
- Updated and improved the script's help messages to explain the new CLI commands and options. (#3)

### Fixed
- Addressed minor bugs and issues from the previous version. (#3)
- Improved compatibility and robustness across different Linux-based systems. (#3)

### Updated
- Upgraded Geant4 version to 11.1.2. (#3)
- Improved overall reliability and stability of the installation process. (#3)
- Updated package recommendations in `packages.txt`. (#3)

### Added Project Enhancements
- Added `build_and_test.yml` GitHub Actions workflow for automated testing. (#3)
- Added `test_build.py` to conduct testing using pytest. (#3)
- Added templates for GitHub issues and pull requests (ISSUE_TEMPLATE, pull request template). (#3)
- Included CONTRIBUTING.md and CODE_OF_CONDUCT.md to facilitate contribution guidelines and code of conduct. (#3)
- Included SECURITY.md to facilitate security guidelines. (#3)
- Added a logo for the project.(#3)

### Documentation
- Updated and expanded the README to include detailed information about the new CLI commands and options.(#3)
- Improved clarity and organization of installation instructions.(#3)
- Added information about the new features and improvements in version 0.1.0.(#3)

### Miscellaneous
- Other minor improvements, optimizations, and code refinements.(#3)

### Deprecated
- Deprecated the old method of environment activation and program usage. (#3)

[v0.1.0]: https://github.com/ahnaf-tahmid-chowdhury/NuclearKid/releases/tag/v0.1.0



## [v0.0.1] - 30/08/2023

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

[v0.0.1]: https://github.com/ahnaf-tahmid-chowdhury/NuclearKid/releases/tag/v0.0.1