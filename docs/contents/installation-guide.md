# Installation Guide

Follow these steps to install **NukeBox** on your local machine.

## Step 1: Download NukeBox

You can download the latest release of **NukeBox** from the [GitHub releases page](https://github.com/nukehub-dev/NukeBox/releases/latest). You have multiple options for downloading:

```{eval-rst}
.. tabs::

   .. tab:: Wget

      .. code-block:: sh

         wget "https://github.com/nukehub-dev/NukeBox/archive/refs/tags/v0.1.3.tar.gz" -O - | tar -xz


   .. tab:: Curl

      .. code-block:: sh

         curl -L "https://github.com/nukehub-dev/NukeBox/archive/refs/tags/v0.1.3.tar.gz" | tar -xz

   .. tab:: Git

      .. note::
         This will download the most recent commit

      .. code-block:: sh

         git clone "https://github.com/nukehub-dev/NukeBox.git"

```

## Step 2: Navigate to the NukeBox Directory

```sh
cd NukeBox*
```

## Step 3: Make the Installation Script Executable

```sh
chmod +x install-nukebox.sh
```

## Step 4: Run the Installation Script

```sh
./install-nukebox.sh
```

During the installation process, you'll be prompted for various configuration options. Here are the details of those options:

## Installation Options

1. **Installation Directory Path**: Set the path where all the software will be installed. You can use the current directory or specify a custom directory.

2. **Environment Name**: Enter a name for the virtual environment that will be created. The default name is `nuclearkid`, but you can provide a custom name.

3. **Geant4 Data Library Path**: If you choose to install Geant4 data, provide the path for the Geant4 data library. The default is a directory within the virtual environment.

4. **Cross Section Library Path**: If you choose to install cross sections, provide the path for the cross section library. The default is a directory within the virtual environment.

5. **Auto Download Geant4 Data**: Choose whether to automatically download Geant4 data. Enter `y` for yes or `n` for no.

6. **Auto Download Cross Sections**: Choose whether to automatically download cross sections. Enter `y` for yes or `n` for no.

Follow the prompts and configure NukeBox according to your preferences. Once the installation is complete, you'll have **NukeBox** set up and ready to use on your system.

## Quick Installation

You can also provide the configuration options directly from the command line. Use the following format:

```sh
./install-nukebox.sh -d <installation-directory> \
   -e <environment-name> \
   -g <geant4-data-library-path> \
   -c <cross-section-library-path>
```

## Recommended Packages

The installer script provides a list of recommended Python packages in the `packages.txt` file. These packages complement the functionality of the installed software. To install them, use:

```sh
nuke activate
pip3 install -r packages.txt --default-timeout=0
```

Please ensure that you have appropriate permissions to install software on your system. The script may require you to enter your administrator password `sudo` during the installation process.
