# Changelog


## [v0.1.0] - Unreleased

### Added
- New command-line interface (CLI) for managing the NuclearBoy environment and its components.
- Support for specifying the Geant4 data library and cross section library paths during installation and through CLI.
- Option to automatically download Geant4 data and cross sections during installation.
- Ability to update individual components (Geant4, DAGMC, OpenMC, PyNE) using the CLI.
- `endf` command to set the cross-section data library path for different libraries (ENDF/B versions).
- `uninstall` command to completely uninstall the NuclearBoy toolkit.
- Quick installation option allowing configuration options to be provided directly from the command line.
- Added badges to the README, including a build status badge.

### Changed
- Enhanced the user experience by providing a more comprehensive CLI for managing the NuclearBoy environment.
- Improved documentation with clear instructions and examples for using the new CLI commands.
- Updated installation process to include new configuration options in the script.
- Enhanced error handling and user feedback during installation and updates.
- Updated and improved the script's help messages to explain the new CLI commands and options.

### Fixed
- Addressed minor bugs and issues from the previous version.
- Improved compatibility and robustness across different Linux-based systems.

### Updated
- Upgraded Geant4 version to 11.1.2.
- Improved overall reliability and stability of the installation process.
- Updated package recommendations in `packages.txt`.

### Added Project Enhancements
- Added `build_and_test.yml` GitHub Actions workflow for automated testing.
- Added `test_build.py` to conduct testing using pytest.
- Added templates for GitHub issues and pull requests (ISSUE_TEMPLATE, pull request template).
- Included CONTRIBUTING.md and CODE_OF_CONDUCT.md to facilitate contribution guidelines and code of conduct.
- Added a logo for the project.

### Documentation
- Updated and expanded the README to include detailed information about the new CLI commands and options.
- Improved clarity and organization of installation instructions.
- Added information about the new features and improvements in version 0.1.0.

### Miscellaneous
- Other minor improvements, optimizations, and code refinements.

### Deprecated
- Deprecated the old method of environment activation and program usage.

[v0.1.0]: https://github.com/ahnaf-tahmid-chowdhury/NuclearBoy/releases/tag/0.1.0



## [v0.0.1] - 31/08/2023

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

[v0.0.1]: https://github.com/ahnaf-tahmid-chowdhury/NuclearBoy/releases/tag/0.0.1
