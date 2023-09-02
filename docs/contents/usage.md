Certainly! Here's the provided information in more detail using Markdown format:

# Activation and Usage

The **NuclearBoy** is a powerful package manager toolkit, specifically crafted for managing and updating various nuclear physics components and libraries. This guide will walk you through the activation, usage, and available commands of this package manager.

## Installation

Before using the **NuclearBoy**, you need to install it. Once the installation is complete, the script will create a program file named after the specified environment name, such as `nuclear-boy`.

## Commands

**NuclearBoy** supports the following commands:

### Display Help

To display the help message, use the `-h` or `--help` flag:

```sh
nuclear-boy -h
```

### Display Version

To display the version information, use the `-V` or `--version` flag:

```sh
nuclear-boy -V
```

### Activate Environment

To activate the **NuclearBoy** environment, simply use the `activate` command:

```sh
nuclear-boy activate
```

### Deactivate Environment

To deactivate the **NuclearBoy** environment, use the `deactivate` command:

```sh
nuclear-boy deactivate
```

### Update Components

You can update specific components individually or update all components at once. Here are the available update commands:

- Update NuclearBoy (Core):

```sh
nuclear-boy update core
```

- Update Geant4 to the latest version:

```sh
nuclear-boy update geant4
```

- Update DAGMC to the latest version:

```sh
nuclear-boy update dagmc
```

- Update OpenMC to the latest version:

```sh
nuclear-boy update openmc
```

- Update PyNE to the latest version:

```sh
nuclear-boy update pyne
```

- Update all components (NuclearBoy, Geant4, DAGMC, OpenMC, and PyNE):

```sh
nuclear-boy update all
```

### Set Cross-Section Data Library

You can set the path for the cross-section data library using the `endf` command. Choose from the following libraries:

- ENDF/B-VII.0 (70):

```sh
nuclear-boy endf endfb70
```

- ENDF/B-VII.1 (71):

```sh
nuclear-boy endf endfb71
```

- ENDF/B-VIII.0/X (80X):

```sh
nuclear-boy endf lib80x
```

### Uninstall NuclearBoy

To completely uninstall **NuclearBoy**, use the `uninstall` command:

```sh
nuclear-boy uninstall
```

## General Usage

The general usage format for **NuclearBoy** is as follows:

```sh
nuclear-boy <command> [options]
```

## Examples

Here are some examples of how to use the **NuclearBoy** commands:

- Activate the NuclearBoy environment:

```sh
nuclear-boy activate
```

- Update Geant4 to the latest version:

```sh
nuclear-boy update geant4
```

- Update all components:

```sh
nuclear-boy update all
```

- Set the cross-section data library to ENDF/B-VII.0 (70):

```sh
nuclear-boy endf endfb70
```

- Uninstall NuclearBoy:

```sh
nuclear-boy uninstall
```

Feel free to use these commands to manage and update your nuclear physics components efficiently with the **NuclearBoy** package manager!