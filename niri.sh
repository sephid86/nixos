mkdir -p /mnt
mount -o subvolid=5 /dev/nvme0n1p2 /mnt
btrfs subvolume create /mnt/@
umount /mnt
mount -o compress=zstd:1,subvol=@ /dev/nvme0n1p2 /mnt
mkdir -p /mnt/home
mount -o compress=zstd:1,subvol=@home /dev/nvme0n1p2 /mnt/home
mkdir -p /mnt/boot
mount /dev/nvme0n1p1 /mnt/boot
nixos-generate-config --root /mnt
cp ./* /mnt/etc/nixos/ -rf
nixos-install
