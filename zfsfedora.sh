#Start by installing the ZFS package for Fedora
sudo dnf install http://download.zfsonlinux.org/fedora/zfs-release$(rpm -E %dist).noarch.rpm -y

#Install both kernel-devel and zfs packages. Note that it is important to make sure that the matching kernel-devel package is installed for the #running kernel since DKMS requires it to build ZFS.
sudo dnf install kernel-devel zfs -y

#Swap out the default zfs-fuse with ZFS on Linux package and install ZFS
sudo dnf swap zfs-fuse zfs -y

#Remember to run /sbin/modprobe zfs as root!
su
/sbin/modprobe zfs

#Install and start Samba (both smbd and nmbd)
sudo dnf install samba -y
sudo systemctl enable smb nmb
sudo systemctl start smb nmb

#Configure firewall for Samba
sudo firewall-cmd --add-service=samba --permanent
sudo firewall-cmd --reload


#Install Cockpit module for ZFS and light Samba directory creation
cd /
mkdir /gitclone
cd /gitclone
git clone https://github.com/optimans/cockpit-zfs-manager.git
sudo cp -r cockpit-zfs-manager/zfs /usr/share/cockpit


#If using SELinux in enforcing mode, enable the boolean states for Samba.
sudo setsebool -P samba_export_all_ro=1 samba_export_all_rw=1

#<Deep, deep breath> GIANT FUCKING WARNING YOU SHOULD READ!
#ZFS always creates shares in /var/lib/samba/usershares folder when ShareSMB property is enabled. This is also the case even if Cockpit ZFS Manager #is managing the shares. To avoid duplicate shares of the same file system, it is recommended to configure a different usershares folder path if #required or to disable usershares in the Samba configuration file.

#If enabled, Cockpit ZFS Manager manages shares for the file systems only. Samba global configuration will need to be configured externally.


