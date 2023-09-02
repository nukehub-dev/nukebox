# Welcome to NuclearBoy

## 📦 What is NuclearBoy?
**NuclearBoy** is an efficient package manager specifically crafted to simplify the installation and management of vital packages and libraries required for nuclear physics simulations and analyses. It automates the setup procedure for essential tools like [PyNE][pyne], [OpenMC][openmc], [DAGMC][dagmc], and [Geant4][geant4], making the life of nuclear physics enthusiasts much more convenient.

[pyne]: https://pyne.io/
[openmc]: https://docs.openmc.org/en/stable/
[dagmc]: https://svalinn.github.io/DAGMC/
[geant4]: https://geant4.web.cern.ch/

## 🚀 How to Get Started?
- Download the latest release.
- Extract it onto your local machine.
- Navigate to the NuclearBoy directory.
- Execute the `install-nuclear-boy.sh` script.
- Follow the prompts to customize your installation.

## 🛠 Installation Options
**NuclearBoy** provides installation flexibility, allowing you to choose your installation directory, environment name, Geant4 data library path, and cross-section library path. You can even opt to automatically download Geant4 data and cross-sections.

## ⚙ How It Works
**NuclearBoy** takes care of all the heavy lifting for you. It identifies your operating system, installs necessary dependencies, and configures Python environments. It also offers convenient commands for activation, deactivation, updating, and more!

## 🚨 Important Notes
Before running the script on your system, please carefully review it and understand the installation process. Safety first!

Currently, **NuclearBoy** supports Debian-based distributions. It compiles packages from source, which can be time-consuming. Our team is actively working on creating binary packages for internal components.

## 📜 License
**NuclearBoy** is distributed under the [MIT License](contents/license).

## 🤝 Contributing
Contributions to this project are highly encouraged! If you encounter issues or have suggestions for improvements, please don't hesitate to get in touch. Check our [Contributing Guidelines](contents/contributing) for more information.


```{toctree}
:maxdepth: 1
:caption: Contents
:hidden: true

contents/installation-guide
contents/releasenotes/index
contents/methodology
contents/usage
contents/contributing
contents/importent-notes
contents/code-of-conduct
contents/license
contents/contact
```




