# initrd-utils
Tools and Utilities for Initial Ramdisk

## Script to decrypt a root partition from the initrd shell

Supports the following OS:
   1. Debian 6.x or higher
   2. Ubuntu 14.04 or higher

### Prerequisites
   1. Recommended: Update packages to the latest

      apt-get update -y
      apt-get upgrade -y

   2. Install dropbear

      apt-get install dropbear

### Installation
   1. Create an ssh-key pair and save the public key into this file:
      ```
      /etc/initramfs-tools/root/.ssh/authorized_keys
      ```
   2. Save the private key to the remote client that will connect to the server.
   3. Copy cryptroot.sh and my_initrd_hook files into these locations:
      ```
      /root/cryptroot.sh
      /etc/initramfs-tools/hooks/my_initrd_hook
      ```
   4. Chmod files
      ```
      chmod +x /root/cryptroot.sh
      chmod +x /etc/initramfs-tools/hooks/my_initrd_hook
      ```

   5. Update initial ramdisk file
      ```
      update-initramfs -u
      ```
   6. Verify files are in the initrd file
      ```
      mkdir /root/initrd
      cd /root/initrd
      gzip -dc /boot/initrd.img-3.13.0-32-generic | cpio -id
      ls -l root/cryptroot.sh
      ```

### Operation
   1. Reboot machine
   2. ssh to machine as root and using the ssh-private key
   3. Run the /root/cryptroot.sh script
