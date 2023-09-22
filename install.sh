#!/bin/sh

echo -n "Move dotfiles to which user? "
read user

echo "[*] Installing necessary software..."
pkg_add feh i3lock scrot ImageMagick vim thunar chromium neofetch arandr ruby ruby-shims fish jdk portslist unzip

echo "[*] Copying dotfiles..."
cp .fvwmrc /home/$user/.fvwmrc
cp .vimrc /home/$user/.vimrc
cp .Xdefaults /home/$user/.Xdefaults
mv .config /home/$user/

echo "exec fvwm" >> /home/$user/.xinitrc

echo "[*] Make Dev folder"
mkdir /home/$user/dev

echo "[*] Chown -R Home Folder"
chown -R $user /home/$user

echo [*] Change Shell to Fish
chsh -s /usr/local/bin/fish $user

echo [*] Fetch and configure Ports
cd /tmp
ftp https://cdn.openbsd.org/pub/OpenBSD/$(uname -r)/{ports.tar.gz,SHA256.sig}
cd /usr
tar xzf /tmp/ports.tar.gz

echo "WRKOBJDIR=/usr/obj/ports" >> /etc/mk.conf
echo "DISTDIR=/usr/distfiles" >> /etc/mk.conf
echo "PACKAGE_REPOSITORY=/usr/packages" >> /etc/mk.conf

echo "[*] Configure doas(1)"
touch /etc/doas.conf
echo "permit persist keepenv $user as root" > /etc/doas.conf

echo "[*] Configure Memory Limits for Programs"
usermod -G staff $user
cp -f ./login.conf /etc/login.conf

echo [*] Configure xenodm
cp -f ./Xsetup_0 /etc/X11/xenodm/Xsetup_0



echo "[*] Run Syspatch"
syspatch

echo "[*] Done."
neofetch
