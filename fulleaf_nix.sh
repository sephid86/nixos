sgdisk -o -n 1:0:+1024M -t 1:EF00 -n 2:0:0 -t 2:8300 /dev/nvme0n1
mkfs.fat -F32 /dev/nvme0n1p1
mkfs.btrfs -f /dev/nvme0n1p2
mkdir -p /mnt
mount -o subvolid=5 /dev/nvme0n1p2 /mnt
btrfs subvolume create /mnt/@
btrfs subvolume create /mnt/@home
umount /mnt
mount -o compress=zstd:1,subvol=@ /dev/nvme0n1p2 /mnt
mkdir -p /mnt/home
mkdir -p /mnt/boot
mount -o compress=zstd:1,subvol=@home /dev/nvme0n1p2 /mnt/home
mount /dev/nvme0n1p1 /mnt/boot
nixos-generate-config --root /mnt
cp nixos/* /mnt/etc/nixos/ -rf
nixos-install
