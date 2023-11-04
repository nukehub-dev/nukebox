# Contributing to NukeBox

Thank you for your interest in contributing to **NukeBox**! We appreciate your efforts to improve the project and make it more useful for the nuclear physics community.

## Code of Conduct

Please review and adhere to our [Code of Conduct][code-of-conduct] to ensure a respectful and inclusive environment for all contributors.

## How Can I Contribute?

### Reporting Bugs

If you encounter a bug while using **NukeBox**, we want to know! Please follow these steps:

1. Check the [existing issues](https://github.com/nukehub-dev/NukeBox/issues) to see if the bug has already been reported.
2. If the bug is new, [open a new issue](https://github.com/nukehub-dev/NukeBox/issues/new) with a detailed bug report using the provided [bug report template][bug-report-template].
3. Provide a clear description of the bug, steps to reproduce it, and your environment details.

### Suggesting Enhancements

Have an idea for a new feature or improvement? We'd love to hear it! Here's what you can do:

1. Review the [existing issues](https://github.com/nukehub-dev/NukeBox/issues) to avoid duplicate suggestions.
2. If your idea is new, [open a new issue](https://github.com/nukehub-dev/NukeBox/issues/new) with a detailed description using the provided [feature request template][feature-request-template].
3. Explain why you think this enhancement is valuable and how it could benefit the users.

### Submitting Pull Requests

Contributions from the community help us grow and improve **NukeBox**. Follow these steps to submit a pull request:

1. Fork the repository and create a new branch for your changes.
2. Make your modifications, adhering to the coding guidelines.
3. Test your changes thoroughly to ensure they work as intended.
4. [Open a new pull request](https://github.com/nukehub-dev/NukeBox/compare) using the provided [pull request template][pull-request-template].
5. Provide a clear description of the changes, the problem they solve, and the testing steps.

## Development Setup

If you're interested in contributing code, here's how to set up your development environment:

1. Fork the [repository](https://github.com/nukehub-dev/NukeBox/fork).
1. Clone your fork of the repository: 
  ```sh
  git clone https://github.com/<USERNAME>/<REPOSITORY_NAME>.git`
  ```
2. Navigate to the project directory: `cd <REPOSITORY_NAME>`
3. Check out development branch: `git checkout develop`
4. Run the script: `./install-nukebox.sh` and install NukeBox
5. Install dependencies: `pip install -r packages.txt`
6. Run tests: `pytest -ra tests`

## Coding Guidelines

Please adhere to the established coding guidelines to maintain consistency across the project. This includes formatting, variable naming, and commenting practices. If you're not sure about something, feel free to ask for clarification in the relevant issue or pull request.

## License

By contributing to **NukeBox**, you agree that your contributions will be licensed under the project's [license][license]. Your contributions will be acknowledged in the project's list of contributors.

Thank you for contributing to **NukeBox**!


[bug-report-template]: .github/ISSUE_TEMPLATE/bug-report-template.md
[feature-request-template]: .github/ISSUE_TEMPLATE/feature-request-template.md
[pull-request-template]: .github/pull-request-template.md
[code-of-conduct]: CODE_OF_CONDUCT.md
[license]: LICENSE