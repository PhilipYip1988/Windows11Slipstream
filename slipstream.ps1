<# Test for loop 
run code and check output #>
for($idx=1; $idx -le 3; $idx++)
{
echo "loop index is $idx"
}

<# Boot Drivers
Download Dell Command | Deploy WinPE Driver Pack
The WinPE contains Storage and Network Controllers
Copy the .CAB file to C:\ then update the name of your .CAB file and run #>
expand "C:\WinPE10.0-Drivers-A25-F0XPX.CAB" -f:* "C:\BootDriversExpanded"
<# Copy the contents of the x64 to C:\BootDrivers #>

<# Details about the boot.wim indexes #>

dism /Get-WimInfo /WimFile:"C:\boot.wim"

<# For loop to slipstream the drivers #>

for($idx=1; $idx -le 2; $idx++)
{
    dism /Mount-WIM /WimFile:"C:\boot.wim" /index:$idx /MountDir:"C:\BootTemp"
    dism /Image:"C:\BootTemp" /Add-Driver /Driver:"C:\BootDrivers" /Recurse
    dism /Unmount-WIM /MountDir:"C:\BootTemp" /Commit
}

<# install.wim
Should be copied to C:\
Right click select Properties and uncheck read only

Dell Command | Deploy Driver Pack should be extracted and the contents of the x64 subfolder
should be copied as a subfolder in C:\InstallDrivers

If the package is a cab file opposed to a Dell Update Package for example like the case with the older XPS-9365. Copy the .CAB to C:\ and run:

expand "C:\9365-win10-A14-GXYTC.CAB" -f:* "C:\InstallDrivers"


substituting the file name with the name of the .CAB file. #>

<# Details about install.wim indexes. #>

dism /Get-WimInfo /WimFile:"C:\install.wim"

<# For loop to slipstream the drivers to a single index, update $idx to the index for desired edition. #>

$idx = 6
for($dummyvar=1; $dummyvar -le 1; $dummyvar++)
{
    dism /Mount-WIM /WimFile:"C:\install.wim" /index:$idx /MountDir:"C:\InstallTemp"
    dism /Image:"C:\InstallTemp" /Add-Driver /Driver:"C:\InstallDrivers" /Recurse
    dism /Unmount-WIM /MountDir:"C:\InstallTemp" /Commit
}

<#
Download the latest 
Cumulative Update for Windows 11 for x64-based Systems
Cumulative Update for .NET Framework 3.5 and 4.8.1 for Windows 11 for x64-based Systems
https://www.catalog.update.microsoft.com/Search.aspx?q=cumulative%20update%20for%2023h2%20x64 
Copy the latest updates to C:\InstallUpdates 
Modify and add the line below to the for loop before unmounting the install.wim.
#>

dism /Image:"C:\InstallTemp" /Add-Package /PackagePath="C:\InstallUpdates\windows11.0-kb5032190-x64_fdbd38c60e7ef2c6adab4bf5b508e751ccfbd525.msu" /PackagePath="C:\InstallUpdates\windows11.0-kb5032006-x64-ndp481_298da3126424149e3c1f488e964507ed1e7b2505.msu"

<# For loop to slipstream the drivers to all indexes. This may take a long time to run. #>

for($idx=1; $idx -le 11; $idx++)
{
    dism /Mount-WIM /WimFile:"C:\install.wim" /index:$idx /MountDir:"C:\InstallTemp"
    dism /Image:"C:\InstallTemp" /Add-Driver /Driver:"C:\InstallDrivers" /Recurse
    dism /Unmount-WIM /MountDir:"C:\InstallTemp" /Commit
}

<# Partition a USB Flash Drive to create:
A FAT32 BOOT Partition (required for the USB to show as a BOOT Device on the UEFI Boot Menu for some systems)
A NTFS Install Partition #>
diskpart
list disk
# change to disk number of USB Flash Drive
select disk 1
convert GPT
clean
<# create partitions #>
create partition primary size=1024
create partition primary
list partition
select Partition 1
format fs="FAT32" quick label="BOOT"
assign letter="H"
select Partition 2
format fs="NTFS" quick label="INSTALL"
assign letter="I"


<# Creating an ISO File
Copy the ISO to C:\InstallationMedia
Replace C:\InstallationMedia\sources\boot.wim with updated version
Replace C:\InstallationMedia\sources\install.wim with updated version

Run the script:
https://github.com/TheDotSource/New-ISOFile/blob/main/New-ISOFile.ps1 #>

<# Run either, the first uses a more sensible title, the second sues the original #>
New-ISOFile -source "C:\InstallationMedia" -destinationIso "C:\Win11_23H2_EnglishInternational_x64_Drivers.iso" -bootFile "C:\InstallationMedia\efi\microsoft\boot\efisys.bin" -title "Win11_23H2_EnglishUK"
New-ISOFile -source "C:\InstallationMedia" -destinationIso "C:\Win11_23H2_EnglishInternational_x64_Drivers.iso" -bootFile "C:\InstallationMedia\efi\microsoft\boot\efisys.bin" -title "CCCOMA_X64FRE_EN-GB_DV9"
