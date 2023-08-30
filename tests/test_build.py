import pytest

try:
    import pymoab
except ImportError:
    pymoab = None

try:
    from geant4_pybind import *
except ImportError:
    geant4 = False

try:
    import openmc
except ImportError:
    openmc = None

try:
    from pyne import dagmc
except ImportError:
    dagmc = None

try:
    import pyne
except ImportError:
    pyne = None


@pytest.mark.parametrize(
    "package, package_name",
    [
        (pymoab, "MOAB"),
        (geant4, "Geant4"),
        (openmc, "OpenMC"),
        (dagmc, "DAGMC"),
        (pyne, "PyNE"),
    ],
)
def test_package_installed(package, package_name):
    assert package is not None, f"{package_name} is not installed!"
