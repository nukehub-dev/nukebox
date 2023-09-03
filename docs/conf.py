# Configuration file for the Sphinx documentation builder.
#
# For the full list of built-in configuration values, see the documentation:
# https://www.sphinx-doc.org/en/master/usage/configuration.html

# -- Project information -----------------------------------------------------
# https://www.sphinx-doc.org/en/master/usage/configuration.html#project-information

import re

# Define a regular expression pattern to match the Version variable in install.sh
version_pattern = r'Version\s*=\s*"([^"]+)"'

# Read the install.sh file
with open("../install-nuclear-boy.sh", "r") as install_file:
    install_contents = install_file.read()

# Search for the version using the pattern
match = re.search(version_pattern, install_contents)

if match:
    # Extract the version from the matched group
    version = match.group(1)
else:
    # Set a default version if not found
    version = "Unknown"

project = "NuclearBoy"
copyright = "2023, Ahnaf Tahmid Chowdhury"
author = "Ahnaf Tahmid Chowdhury"
release = version

# -- General configuration ---------------------------------------------------
# https://www.sphinx-doc.org/en/master/usage/configuration.html#general-configuration

extensions = [
    "myst_parser",  # Enables MyST (Markedly Structured Text) support, which allows for more powerful markup.
    # "numpydoc",                # Helps document NumPy-style docstrings for Python functions and classes.
    # "sphinx.ext.autodoc",      # Automatically generates documentation from Python docstrings.
    # "sphinx.ext.intersphinx",  # Provides cross-referencing to external documentation and projects.
    "sphinx.ext.viewcode",  # Adds "View Source" links to the documentation to view the source code.
    "sphinx_copybutton",  # Provides a "Copy" button for code blocks to allow users to easily copy code snippets.
    "sphinx_design",  # Enhances the design and appearance of your Sphinx documentation.
    "sphinx_tabs.tabs",  # Enables tabbed content for organizing information in tabs.
    # "sphinx_thebe",            # Allows for interactive code execution within your documentation using Jupyter notebooks.
    "sphinx_togglebutton",  # Provides a toggle button to hide/show content in your documentation.
    # "sphinxcontrib.bibtex",    # Supports BibTeX bibliographies for citing references in your documentation.
    # "sphinxext.opengraph",     # Generates Open Graph metadata for better social media sharing.
]

templates_path = ["_templates"]
exclude_patterns = ["_build", "Thumbs.db", ".DS_Store"]


# -- Options for HTML output -------------------------------------------------
# https://www.sphinx-doc.org/en/master/usage/configuration.html#options-for-html-output

html_theme = "sphinx_book_theme"
html_logo = "../.github/logo/nuclear-boy.svg"
html_title = "NuclearBoy"
html_copy_source = True
html_favicon = "../.github/logo/nuclear-boy.svg"
html_last_updated_fmt = ""
html_static_path = ["_static"]
html_css_files = ["nuclear-boy.css"]
html_sidebars = {
    "**": [
        "navbar-logo",
        "icon-links",
        "sbt-sidebar-nav",
    ]
}
html_theme_options = {
    "path_to_docs": "docs",
    "repository_url": "https://github.com/ahnaf-tahmid-chowdhury/NuclearBoy",
    "repository_branch": "develop",
    "use_edit_page_button": True,
    "use_source_button": True,
    "use_issues_button": True,
    "use_repository_button": True,
    "use_download_button": True,
    "use_fullscreen_button": True,
    "use_sidenotes": True,
    "show_toc_level": 2,
    "logo": {
        "text": html_title,
    },
    "icon_links": [
        {
            "name": "Release",
            "url": "https://github.com/ahnaf-tahmid-chowdhury/NuclearBoy/releases",
            "icon": "https://img.shields.io/github/v/release/ahnaf-tahmid-chowdhury/NuclearBoy?style=flat-square&logo=github&label=Release&include_prereleases",
            "type": "url",
        },
        {
            "name": "Build and Test",
            "url": "https://github.com/ahnaf-tahmid-chowdhury/NuclearBoy/blob/develop/.github/workflows/run_build_and_test.yml",
            "icon": "https://img.shields.io/github/actions/workflow/status/ahnaf-tahmid-chowdhury/NuclearBoy/run_build_and_test.yml?style=flat-square&logo=githubactions&logoColor=white&label=Build%20and%20Test",
            "type": "url",
        },
        {
            "name": "DOI",
            "url": "https://doi.org/10.5281/zenodo.8307492",
            "icon": "https://img.shields.io/badge/DOI-10.5281%2Fzenodo.8307492-blue?style=flat-square",
            "type": "url",
        },
    ],
}
