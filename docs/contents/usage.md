Certainly! Here's the provided information in more detail using Markdown format:

# Activation and Usage

The **NukeBox** is a powerful package manager toolkit, specifically crafted for managing and updating various nuclear physics components and libraries. This guide will walk you through the activation, usage, and available commands of this package manager.

## Installation

Before using the **NukeBox**, you need to install it. Once the installation is complete, the script will create a program file named after the specified environment name, such as `nuke`.

## Commands

**NukeBox** supports the following commands:

### Display Help

To display the help message, use the `-h` or `--help` flag:

```sh
nuke -h
```

### Display Version

To display the version information, use the `-V` or `--version` flag:

```sh
nuke -V
```

### Activate Environment

To activate the **NukeBox** environment, simply use the `activate` command:

```sh
nuke activate
```

### Deactivate Environment

To deactivate the **NukeBox** environment, use the `deactivate` command:

```sh
nuke deactivate
```

### Update Components

You can update specific components individually or update all components at once. Here are the available update commands:

- Update NukeBox (Core):

```sh
nuke update core
```

- Update Geant4 to the latest version:

```sh
nuke update geant4
```

- Update DAGMC to the latest version:

```sh
nuke update dagmc
```

- Update OpenMC to the latest version:

```sh
nuke update openmc
```

- Update PyNE to the latest version:

```sh
nuke update pyne
```

- Update all components (NukeBox, Geant4, DAGMC, OpenMC, and PyNE):

```sh
nuke update all
```

### Set Cross-Section Data Library

You can set the path for the cross-section data library using the `endf` command. Choose from the following libraries:

- ENDF/B-VII.0 (70):

```sh
nuke endf endfb70
```

- ENDF/B-VII.1 (71):

```sh
nuke endf endfb71
```

- ENDF/B-VIII.0/X (80X):

```sh
nuke endf lib80x
```

### Uninstall NukeBox

To completely uninstall **NukeBox**, use the `uninstall` command:

```sh
nuke uninstall
```

## General Usage

The general usage format for **NukeBox** is as follows:

```sh
nuke <command> [options]
```

## Examples

Here are some examples of how to use the **NukeBox** commands:

- Activate the NukeBox environment:

```sh
nuke activate
```

- Update Geant4 to the latest version:

```sh
nuke update geant4
```

- Update all components:

```sh
nuke update all
```

- Set the cross-section data library to ENDF/B-VII.0 (70):

```sh
nuke endf endfb70
```

- Uninstall NukeBox:

```sh
nuke uninstall
```

Feel free to use these commands to manage and update your nuclear physics components efficiently with the **NukeBox** package manager!