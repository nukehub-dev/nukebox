
# Important Notes

- This script is designed for systems that use the `apt-get` package manager. If your system doesn't support `apt-get`, the installation process may not work as expected.

- The script is intended for use with Linux-based systems, and its compatibility with other operating systems (e.g., macOS, Windows) may vary.

- Use the script at your own risk. Always review and understand the code before executing any script on your system.

- Before running the script, make sure to read and understand the installation process, as it may involve modifying your system's settings.

## Purpose

This script is created to assist users in configuring their Linux-based systems. It aims to automate common system setup tasks and package installations using the `apt-get` package manager. 

## Instructions

1. **Download the Script**

   You can download the script from a trusted source or create it manually. To create the script manually, open a text editor and copy the script content provided below.

2. **Review the Script**

   Before running the script, review its content to ensure it contains the commands you want to execute on your system. This is essential to understand what changes will be made.

3. **Make the Script Executable**

   Open a terminal and navigate to the directory where the script is located. Use the `chmod` command to make the script executable:

   ```shell
   chmod +x install-nuclearkid.sh
   ```

4. **Run the Script**

   Execute the script using the following command:

   ```shell
   sudo ./install-nuclearkid.sh
   ```

5. **Follow On-Screen Prompts**

   The script may present on-screen prompts or require user input for certain configurations. Follow these prompts to complete the setup.

6. **Script Execution**

   The script will begin executing the commands one by one. You may see installation progress and status messages on your terminal.

7. **Completion**

   Once the script finishes execution, it will display a completion message. Review the output to ensure there are no errors or issues.

8. **Test the Script**
    There is a test script available in the `tests` directory. You may need to install Pytest to test the script.
    
    ```sh
    nuclearkid activate
    pip3 install pytest
    pytest -ra tests
    ```


## Customization

You can customize the script by adding or removing commands to suit your specific system configuration needs. Just be cautious when making changes to avoid unintended consequences.

## Caution

- **Backup Your Data:** Before running any script that modifies your system, it's essential to back up your data to prevent data loss in case of unexpected issues.

- **Review and Understand:** Ensure you understand each command in the script before running it. This will help you troubleshoot any issues that may arise during execution.

- **Use with Care:** Only run scripts from trusted sources, and avoid running scripts with elevated privileges unless you trust the source and understand the script's contents.

- **Test in a Safe Environment:** If possible, test the script on a non-production or virtual machine environment first to ensure it works as intended.

By following these guidelines and exercising caution, you can use this system configuration script to automate common setup tasks on your Linux-based system.