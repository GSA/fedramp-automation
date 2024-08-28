# 1. About OSCAL CLI
OSCAL CLI is a Java-based tool for validating FedRAMP OSCAL artifacts (SSP, SAP, SAR, and POA\&M).

It ensures that your OSCAL content meets FedRAMP OSCAL requirements.

For more information about OSCAL CLI, visit [https://github.com/metaschema-framework/oscal-cli](https://github.com/metaschema-framework/oscal-cli).

# 2. Who should use OSCAL CLI
This tool is intended for FedRAMP OSCAL implementers, practitioners, and content authors, including cloud service providers (CSPs), OSCAL tool suppliers, assessors, and federal agencies.

# 3. Installing OSCAL CLI
This section provides instructions for setting up your local environment to use OSCAL CLI.

## 3.1. Prerequisites
To use OSCAL CLI, you need the following programs and packages:
1. *Windows only:* A Linux-like shell terminal (Visual Studio Code, WSL, MSYS2, Cygwin)
2. JDK version 11 or newer
3. Git (any Git interface; for example, git bash, GitHub Desktop, Visual Studio Code, Oxygen Editor; for more information about git, visit [https://git-scm.com/](https://git-scm.com/))

## 3.2. Installing OSCAL CLI
To install OSCAL CLI
1. Go to [https://github.com/metaschema-framework/oscal-cli/releases](https://github.com/metaschema-framework/oscal-cli/releases).
2. Under the latest release, click **Download**.
3. Download the ZIP archive.
4. Open the terminal.
5. If the **opt** directory does not exist in your shell structure, run the following commands:
   a. `$ cd /`
   b. `$ mkdir opt`
6. To change to the **opt** directory, run the following command:
   `$ cd opt`
7. To create the **oscal-cli** directory, run the following command:
   `$ mkdir oscal-cli`
8. Extract the downloaded ZIP archive into the created **oscal-cli** directory.

## 3.3. Adding Java and OSCAL CLI to the PATH variable
To add Java and OSCAL CLI to the shell’s **PATH** variable
1. Install JDK.
2. Using your preferred text editor, open the following file:
   `<shell-root>/home/<user>/.bashrc`
3. Scroll to the bottom of the file.
4. To add Java and OSCAL CLI to the PATH variable, insert the following lines, replacing **\<jdk-path\>** with the actual Java installation directory path on your system:
   `export PATH=$PATH:'<jdk-path>/bin'
   export PATH=$PATH:/opt/oscal-cli/bin`
5. Save and close the **.bashrc** file.
6. Open the terminal.
7. To verify that Java is working correctly
   a. Run the following command:
      `$ java --version`
   b. Verify that the command returns the Java version.
8. To verify that OSCAL CLI is working correctly
   a. Run the following command:
      `$ oscal-cli --help`
   b. Verify that the command returns OSCAL CLI help.

For more information about installing OSCAL CLI, visit [https://github.com/metaschema-framework/oscal-cli?tab=readme-ov-file\#installing](https://github.com/metaschema-framework/oscal-cli?tab=readme-ov-file\#installing).

## 3.4. Upgrading OSCAL CLI
To upgrade OSCAL CLI to a newer version
1. Go to [https://github.com/metaschema-framework/oscal-cli/releases](https://github.com/metaschema-framework/oscal-cli/releases).
2. Download the latest ZIP archive.
3. Delete everything in the following directory:
   `<shell-root>/opt/oscl-cli`
4. Extract the downloaded archive into the empty **oscl-cli** directory.
5. Open the terminal.
6. To verify that OSCAL CLI is working correctly
   a. Run the following command:
      `$ oscal-cli --help`
   b. Verify that the command returns OSCAL CLI help.

# 4. Validating FedRAMP OSCAL content
This section describes steps for validating FedRAMP OSCAL artifacts (SSP, SAP, SAR, and POA\&M files).

## 4.1. Cloning the FedRAMP Automation repository
Cloning the FedRAMP Automation GitHub repository gives you access to the latest FedRAMP-specific OSCAL extensions, making your validations more robust.

To clone the FedRAMP Automation repository
1. Open the terminal.
2. Change to the directory where you want to clone the repository.
3. Run the following command:
   `$ git clone --recurse-submodules https://github.com/GSA/fedramp-automation`

## 4.2. Getting the latest repository updates
If you have previously cloned the FedRAMP Automation repository, to get the most recent changes
1. Open the terminal.
2. To change to the cloned repository directory, run the following command, replacing **\<fedramp-automation-repository\>** with the actual path:
   `$ cd <fedramp-automation-repository>`
3. To verify that you are on the correct branch
   a. Run the following command:
      `$ git branch`
   b. To switch to the **feature/external-constraints** branch, run the following command:
       `$ git checkout feature/external-constraints`
4. To get the latest repository updates, run the following command:
   `$ git pull`

## 4.3. Validating FedRAMP OSCAL files
To validate your FedRAMP OSCAL file, using the FedRAMP external constraints
1. Open the terminal.
2. Run the following command:
   `$ oscal-cli validate <oscal-artifact> -c <fedramp-external-constraints> -o <sarif-output> --sarif-include-pass`
   where
	* `<oscal-artifact>`is your SSP, SAR, SAP, or POA\&M file
	* `<fedramp-external-constraints>` is the name of a FedRAMP external constraints file (for example, **fedramp-external-allowed-values.xml**; you may specify more than one file)
	* `<sarif-output>` is the auto-generated validation results file in the SARIF format (for more information about SARIF, visit [https://docs.oasis-open.org/sarif/sarif/v2.1.0/sarif-v2.1.0.html](https://docs.oasis-open.org/sarif/sarif/v2.1.0/sarif-v2.1.0.html))
	* `--sarif-include-pass` is the option to include passed validation results in the SARIF report (by default, the SARIF output includes only failed validations; if you want only the failed results, omit this option)

To view a complete list of
  * OSCAL CLI commands, run the following command:
     `$ oscal-cli --help`
  * Specific command options, run the following command:
     `$ oscal-cli <command> --help`

## 4.4. Fixing validation errors
The tool generates validation reports in the JSON-based SARIF format. For more information about SARIF, visit [https://docs.oasis-open.org/sarif/sarif/v2.1.0/sarif-v2.1.0.html](https://docs.oasis-open.org/sarif/sarif/v2.1.0/sarif-v2.1.0.html).

If you prefer viewing SARIF reports in a GUI application, Visual Studio Code offers the **SARIF Viewer** extension. For more information, visit [https://marketplace.visualstudio.com/items?itemName=WDGIS.MicrosoftSarifViewer](https://marketplace.visualstudio.com/items?itemName=WDGIS.MicrosoftSarifViewer).

After validating your FedRAMP OSCAL file, to fix validation errors
1. Open the generated SARIF validation report file.
2. Search for **fail**.
3. In the **text** field for the failed validation, note the message (for example, "The import-profile element must have a reference").
4. In the **decoratedName** field, note the XPath expression (for example, "/system-security-plan/metadata\[1\]").
5. Open the validated OSCAL file.
6. Find the location referenced in the **decoratedName** field.
7. Fix the error.
8. Re-run the validation.

# 5. Providing feedback
If you encounter a bug or have a feature to request, submit an issue at [https://github.com/GSA/fedramp-automation/issues/new/choose](https://github.com/GSA/fedramp-automation/issues/new/choose).
