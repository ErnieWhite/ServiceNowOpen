# ServiceNow Directory Manager

A collection of Windows scripts (PowerShell and Batch) that automatically create and open directories in your ServiceNow OneDrive folder. These scripts streamline the process of managing project directories by handling both directory creation and File Explorer integration.

## 📋 Overview

The ServiceNow Directory Manager provides two script options:
- **PowerShell Script** (`Open-ServiceNowDirectory.ps1`) - Advanced features with better error handling
- **Batch Script** (`open-servicenow-directory.bat`) - Simple, universal compatibility

Both scripts perform the same core functions:
1. Accept a directory name from the command line
2. Check if the directory exists in the ServiceNow base path
3. Create the directory if it doesn't exist
4. Open the directory in File Explorer (new tab if Explorer is already running)
5. Launch File Explorer if it's not currently running

## 🎯 Target Directory

The scripts operate on the following base directory:
```
C:\Users\awhite\OneDrive - Morsco\Documents\ServiceNow
```

## 🚀 Quick Start

### PowerShell Script Usage

```powershell
# Basic usage
.\Open-ServiceNowDirectory.ps1 "ProjectName"

# With parameter name
.\Open-ServiceNowDirectory.ps1 -DirectoryName "My New Project"

# Show help
.\Open-ServiceNowDirectory.ps1 -Help
```

### Batch Script Usage

```batch
# Basic usage
open-servicenow-directory.bat "ProjectName"

# With spaces in name
open-servicenow-directory.bat "My New Project"

# Show help
open-servicenow-directory.bat /?
```

## 📁 File Descriptions

### PowerShell Script (`Open-ServiceNowDirectory.ps1`)

**Features:**
- Comprehensive parameter validation and help system
- Colored console output for better user experience
- Advanced error handling with detailed error messages
- Automatic sanitization of invalid filename characters
- Process checking for File Explorer
- Detailed logging of all operations

**Requirements:**
- PowerShell 5.1 or later
- Windows 11
- Access to the specified OneDrive path

### Batch Script (`open-servicenow-directory.bat`)

**Features:**
- Universal compatibility with all Windows versions
- Simple command-line interface
- Basic error checking and validation
- Help system with detailed usage information
- Automatic directory creation and File Explorer integration

**Requirements:**
- Windows Command Prompt
- Windows 11 (though compatible with earlier versions)
- Access to the specified OneDrive path

## 🔧 Installation

1. **Download the Scripts**
   - Save the PowerShell script as `Open-ServiceNowDirectory.ps1`
   - Save the batch script as `open-servicenow-directory.bat`

2. **Choose Your Location**
   - Place scripts in a directory that's in your PATH for global access
   - Or keep them in a project folder and call them with full paths

3. **Set Execution Policy (PowerShell only)**
   ```powershell
   # Check current policy
   Get-ExecutionPolicy
   
   # Set policy to allow local scripts (if needed)
   Set-ExecutionPolicy -ExecutionPolicy RemoteSigned -Scope CurrentUser
   ```

## 📖 Detailed Functionality

### How It Works

1. **Input Validation**
   - Checks if directory name is provided
   - Validates directory name for invalid characters
   - Sanitizes input to prevent filesystem errors

2. **Base Directory Verification**
   - Confirms the ServiceNow base directory exists
   - Provides clear error messages if OneDrive path is inaccessible

3. **Directory Management**
   - Checks if target directory already exists
   - Creates directory if it doesn't exist
   - Handles permission errors gracefully

4. **File Explorer Integration**
   - Detects if File Explorer is currently running
   - Opens the directory in a new Explorer window/tab
   - Launches File Explorer automatically if not running

### Error Handling

Both scripts include comprehensive error handling for common scenarios:

- **Missing Parameters**: Clear help messages guide proper usage
- **Invalid Directory Names**: Automatic sanitization or clear error messages
- **Path Access Issues**: Verification that OneDrive path is accessible
- **Permission Errors**: Clear messages about directory creation failures
- **File Explorer Issues**: Graceful handling of Explorer launch problems

### Output Examples

**Successful Directory Creation:**
```
ServiceNow Directory Manager
================================
Target directory: C:\Users\awhite\OneDrive - Morsco\Documents\ServiceNow\New Project
Directory does not exist. Creating: New Project
✓ Successfully created directory: New Project
✓ Opened directory in File Explorer: C:\Users\awhite\OneDrive - Morsco\Documents\ServiceNow\New Project
✓ Operation completed successfully!
```

**Existing Directory:**
```
ServiceNow Directory Manager
================================
Target directory: C:\Users\awhite\OneDrive - Morsco\Documents\ServiceNow\Existing Project
✓ Directory already exists: Existing Project
✓ Opened directory in File Explorer: C:\Users\awhite\OneDrive - Morsco\Documents\ServiceNow\Existing Project
✓ Operation completed successfully!
```

## ⚙️ Customization

To modify the scripts for different base directories:

**PowerShell:**
```powershell
# Change this line in the script
$BaseDirectory = "C:\Your\Custom\Path\Here"
```

**Batch:**
```batch
REM Change this line in the script
set "BASE_DIR=C:\Your\Custom\Path\Here"
```

## 🛠️ Troubleshooting

### Common Issues

1. **"Base directory does not exist" Error**
   - Ensure OneDrive is properly synced
   - Verify the path exists and is accessible
   - Check that OneDrive is running

2. **PowerShell Execution Policy Errors**
   ```powershell
   Set-ExecutionPolicy -ExecutionPolicy RemoteSigned -Scope CurrentUser
   ```

3. **Permission Denied Errors**
   - Run scripts as Administrator (if needed)
   - Check OneDrive sync status
   - Verify folder permissions

4. **File Explorer Doesn't Open**
   - Try running `explorer.exe` manually
   - Restart Windows Explorer process
   - Check if Windows is experiencing issues

### Debugging

**PowerShell Script:**
- Enable verbose output by adding `-Verbose` parameter support
- Check `$Error` variable for detailed error information
- Use `Get-ExecutionPolicy -List` to check all scopes

**Batch Script:**
- Remove `@echo off` temporarily to see all commands
- Add `echo` statements before critical operations
- Check `%ERRORLEVEL%` values

## 📝 Version History

### Version 1.0
- Initial release
- Basic directory creation and File Explorer integration
- Comprehensive error handling
- Help system implementation
- Support for directory names with spaces
- Invalid character sanitization

## 🤝 Support

For issues or feature requests:
1. Check the troubleshooting section
2. Verify all requirements are met
3. Test with a simple directory name first
4. Check OneDrive sync status

## 📄 License

These scripts are provided as-is for internal use. Modify as needed for your specific requirements.

---

*Created for ServiceNow directory management workflows*