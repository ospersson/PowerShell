$VMName = 'LinuxMint18.1'
$VirtualSwitchName = 'Switch1'
$VHDName = '{0}.vhdx' -f $VMName
$VMStoragePath = 'C:\ProgramData\Microsoft\Windows\Hyper-V'
$VHDStorageSubPath = Join-Path -Path 'G:\VHD' -ChildPath $VMName
$VHDStoragePath = Join-Path -Path $VHDStorageSubPath -ChildPath $VHDName
#$UbuntuISOPath = 'G:\ISO\ubuntu-16.10-server-amd64.iso'
$UbuntuISOPath = 'G:\ISO\linuxmint-18.1-xfce-64bit-beta.iso'

# Start the VM with this amount of ram.
[long]$MemoryStartup = 512 * 1048576    	# 512 MB

# Declare max and min amount of ram.
[long]$MinMemory = 256 * 1048576    		# 256 MB
[long]$MaxMemory = 4 * 1073741824 		# 4 GB

# Declare disksize for system disk.
[long]$DiskSize = 100 * 1073741824  		# 100 GB

# Declare number of cores for the VM.
[int]$Cores = 2

# --------------- This part creates the VM on a Hyper-V host.

# Create a new VM.
New-VM -Name $VMName -MemoryStartupBytes $MemoryStartup -SwitchName $VirtualSwitchName -BootDevice CD -Path $VMStoragePath -Generation 1 -NoVHD

# Set max and min amount of memory.
Set-VMMemory -VMName $VMName -DynamicMemoryEnabled $true -MinimumBytes $MinMemory -MaximumBytes $MaxMemory 

# Set number of processor cores
Set-VMProcessor -VMName $VMName -Count $Cores 

# Set max size and other info about the hard disk. 
New-VHD -Path $VHDStoragePath -SizeBytes $DiskSize -Dynamic -BlockSizeBytes 1MB

# Add the created hard disk(a .vhdx file) to the VM. 
Add-VMHardDiskDrive -VMName $VMName -ControllerType IDE -ControllerNumber 0 -ControllerLocation 0 -Path $VHDStoragePath

# Set the path to the ISO installation file.
Set-VMDvdDrive -VMName $VMName -ControllerNumber 1 -ControllerLocation 0 -Path $UbuntuISOPath
