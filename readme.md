# Windows 11 Installation Media Slipstream Script

The purpose of this repository is to slipstream the Dell Command PE Driver Pack to the boot.wim and the Dell Command Driver Pack to the install.wim of Windows 11 Installation Media

The direct ISO download must be used for this purpose:

[Windows 11 Software Download Page](https://www.microsoft.com/software-download/windows11)

[Cumultative Updates](https://www.catalog.update.microsoft.com/Search.aspx?q=cumulative%20update%20for%2023h2%20x64)

The Dell Command PE Driver Pack and Dell Command Driver Pack are found under the Systems Management Category of the Business Systems Drivers and Downloads Page:

[Dell Drivers and Downloads](https://www.dell.com/support/home/en-uk?app=drivers)

It is recommended to use VSCode to run sections of slipstream.ps1. VSCode can be installed using:

```
winget install Microsoft.VisualStudioCode
```

 VSCode should be run as an administrator in order to use Dism.
