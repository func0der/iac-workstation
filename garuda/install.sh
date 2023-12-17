if test -d /etc/garuda
    garuda-update
else
    sudo pacman -Syyu
end

sudo pacman -S --refresh --needed yakuake gimp gparted keepassxc onlyoffice-bin spotify sublime-text-4 teamspeak3 teamviewer vim

## ProtonVPN

echo 'Installing ProtonVPN'

curl https://repo.protonvpn.com/debian/public_key.asc | sudo pacman-key --add -
sudo pacman-key --finger 6A5571928D2222D83BC7456E4EDE055B645F044F
sudo pacman-key --lsign-key 6A5571928D2222D83BC7456E4EDE055B645F044F

sudo pamac update --force-refresh

sudo pamac build protonvpn


## IntelliJ IDEA Ultimate Edition

sudo pamac install intellij-idea-ultimate-edition
