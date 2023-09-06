Certainly! Here's the provided information in more detail using Markdown format:

# Activation and Usage

The **NuclearKid** is a powerful package manager toolkit, specifically crafted for managing and updating various nuclear physics components and libraries. This guide will walk you through the activation, usage, and available commands of this package manager.

## Installation

Before using the **NuclearKid**, you need to install it. Once the installation is complete, the script will create a program file named after the specified environment name, such as `nuclearkid`.

## Commands

**NuclearKid** supports the following commands:

### Display Help

To display the help message, use the `-h` or `--help` flag:

```sh
nuclearkid -h
```

### Display Version

To display the version information, use the `-V` or `--version` flag:

```sh
nuclearkid -V
```

### Activate Environment

To activate the **NuclearKid** environment, simply use the `activate` command:

```sh
nuclearkid activate
```

### Deactivate Environment

To deactivate the **NuclearKid** environment, use the `deactivate` command:

```sh
nuclearkid deactivate
```

### Update Components

You can update specific components individually or update all components at once. Here are the available update commands:

- Update NuclearKid (Core):

```sh
nuclearkid update core
```

- Update Geant4 to the latest version:

```sh
nuclearkid update geant4
```

- Update DAGMC to the latest version:

```sh
nuclearkid update dagmc
```

- Update OpenMC to the latest version:

```sh
nuclearkid update openmc
```

- Update PyNE to the latest version:

```sh
nuclearkid update pyne
```

- Update all components (NuclearKid, Geant4, DAGMC, OpenMC, and PyNE):

```sh
nuclearkid update all
```

### Set Cross-Section Data Library

You can set the path for the cross-section data library using the `endf` command. Choose from the following libraries:

- ENDF/B-VII.0 (70):

```sh
nuclearkid endf endfb70
```

- ENDF/B-VII.1 (71):

```sh
nuclearkid endf endfb71
```

- ENDF/B-VIII.0/X (80X):

```sh
nuclearkid endf lib80x
```

### Uninstall NuclearKid

To completely uninstall **NuclearKid**, use the `uninstall` command:

```sh
nuclearkid uninstall
```

## General Usage

The general usage format for **NuclearKid** is as follows:

```sh
nuclearkid <command> [options]
```

## Examples

Here are some examples of how to use the **NuclearKid** commands:

- Activate the NuclearKid environment:

```sh
nuclearkid activate
```

- Update Geant4 to the latest version:

```sh
nuclearkid update geant4
```

- Update all components:

```sh
nuclearkid update all
```

- Set the cross-section data library to ENDF/B-VII.0 (70):

```sh
nuclearkid endf endfb70
```

- Uninstall NuclearKid:

```sh
nuclearkid uninstall
```

Feel free to use these commands to manage and update your nuclear physics components efficiently with the **NuclearKid** package manager!