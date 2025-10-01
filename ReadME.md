# OpenerTest Project

## Overview

This project provides a portable folder setup to test opening applications, files, and URLs on Windows 10 and 11 through a combination of Java command line and PowerShell scripts. It supports detecting the user's default browser, storing configuration, and opening multiple resources interactively with syntax like `[1] [2 1]` to control new window vs same window behavior.

---

## Folder Structure

/OpenerTest/

Setup.exe # Runs the setup script

Setup.ps1 # Setup script to prepare resources and detect default browser

Opener.ps1 # Main opener script handling resource opening logic

RunJava.exe #Runs the main program

RunJava.ps1 # Simple launcher script to start the Java CLI app

Main.java # Java CLI program to accept user input and invoke opener script

Map.csv # CSV file defining resources to open (URLs, documents, shortcuts)

/resource/ # Folder to store files/documents referenced in Map.csv

config.ini # Configuration file created by Setup.ps1

browser-config.json # Browser info file created by Setup.ps1

README.md # This documentation file


---

## Setup Instructions

1. Run the setup script first to prepare the environment:
    - Run the executable `Setup.exe` if available, or Right-click and run `Setup.ps1` with PowerShell.
    - This creates the `/resource` folder, configuration files, and detects the default browser on your system.
2. Copy any PDFs or other local files you want to test into the `/resource` folder.
3. Edit `Map.csv` as needed to add or update resource entries for your testing.

---

## Usage Instructions

1. Run the Java CLI app to enter commands and test opening resources:
    - Use `RunJava.exe` or `RunJava.ps1` to launch the CLI, or compile/run `Main.java` manually.
2. Enter commands using square bracket syntax, e.g.:
    - `[1]` to open resource 1 in a new window.
    - `[2 1]` to open resources 2 and 1 together (usually same window, multiple tabs).
    - Multiple groups can be separated by spaces, e.g. `[1] [2 1]`.
3. The Java app calls `Opener.ps1` which interprets the commands, opens resources appropriately using the detected browser settings.

---

## Notes and Requirements

- Requires **PowerShell 5.1+** on Windows 10 or 11.
- Requires **Java Runtime Environment (JRE)** installed and added to PATH.
- Browsers supported for new window/tab control: Chrome, Firefox, Edge, Opera, Brave, Vivaldi.
- Opening behavior depends on browser support for params like `--new-window`.
- Use `ps2exe` or similar tools if you want to create executable launchers for the PowerShell scripts.

---

## Extending and Customizing

- Add or modify entries in `Map.csv` to define new resource IDs, types (`url`, `pdf`, `lnk`), names, and paths.
- Adjust PowerShell scripts if needed to support new browser flags or additional resource handling.
- Java CLI may be updated to improve command parsing or add GUI frontends.

---

## Troubleshooting

- If resources don’t open as expected, verify:
    - The paths in `Map.csv` are correct and accessible.
    - Java is properly installed and on the system PATH.
    - PowerShell scripts run with ExecutionPolicy allowing remote scripts (e.g., `Bypass`).
    - Browser executable paths in `browser-config.json` match actual install locations.

---

With this setup, you get a portable and flexible testing environment to automate opening apps, URLs, and documents with nuanced browser control on Windows PCs.
