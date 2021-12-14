#!/bin/bash

# ********** Configurations **********
OS_FLAVOR="orbuntu"
# USER="$(whoami)"
GTK_THEME="Mc-OS-CTLina-Gnome-Dark-1.3.2"
SHELL_THEME="Sweet-Dark-v40"
WALLPAPER="macos-wp.jpg"
SCREENSAVER="firewatch-wallpaper.jpg"
ICON_THEME="Papirus"
# *********** END Configurations ***********


homedir=$( getent passwd "$USER" | cut -d: -f6 )
username=$( getent passwd "$USER" | cut -d: -f1 )

RUID=$(who | awk 'FNR == 1 {print $1}')
RUSER_UID=$(id -u ${RUID})

#Check if root
if [[ "$EUID" -ne 0 ]]; then
  isroot="false"
	theme_install_dir="$homedir/.local/share/themes"
	icon_install_dir="$homedir/.local/share/icons"
    wallpaper_install_dir="$homedir/.local/share/backgrounds"
	
	sleep 0.5
else
  isroot="true"
	homedir=$( getent passwd "$SUDO_USER" | cut -d: -f6 )
	theme_install_dir="/usr/share/themes"
	icon_install_dir="/usr/share/icons"
    wallpaper_install_dir="/usr/share/backgrounds"
fi

echo -e "Theme Dir: $theme_install_dir"
echo -e "Icon Dir: $icon_install_dir"
echo -e "Wallpaper Dir: $wallpaper_install_dir"

wallpaper_file="file:///$wallpaper_install_dir/$WALLPAPER"

# create a temp dir
# tmpdir=$(mktemp -d)
tmpdir="$homedir/orbuntu-tmp"

if [ ! -d "$tmpdir" ]; then
  mkdir -p "$tmpdir"
fi


zip_file_path="$tmpdir/orbuntu.zip"

# ********** Download the files **********
echo "Downloading the files..."
wget https://github.com/ohidurbappy/orbuntu/archive/refs/heads/main.zip -O "$zip_file_path" -q --show-progress
ZIP_OUTPUT_DIR="$tmpdir"
unzip $zip_file_path -d "$tmpdir"
rm "$zip_file_path"
# *********** END Download the files ***********

ZIP_OUTPUT_DIR="$tmpdir/orbuntu-main"
# change directory to the folder
cd "$ZIP_OUTPUT_DIR"

# include the helper functions from 'src/helpers.sh'
source ./src/helpers.sh

clear

# show welcome message
cat 'src/welcome.txt'

box_out "Welcome to the installation script for ORBUNTU" "It will install the required packages"


# press Y to continue
echo_cyan "Do you want to continue? (Y/n):";read
if [[ $REPLY =~ ^[Yy]$ ]]; then
    echo_green "Proceeding with installation"
else
    echo_red "Installation aborted!"
    exit 1
fi


# ******** INSTALLING REQUIRED PACKAGES ********
echo "Installing packages..."
sudo apt update && sudo apt upgrade -y
sudo apt install git gnome-shell-extensions chrome-gnome-shell gnome-tweaks -y




# ******** INSTALL THEMES, ICONS, WALLPAPER ********

OUTPUT_DIRS=(
    "$theme_install_dir"
    "$icon_install_dir"
    "$wallpaper_install_dir"
)

# create dirs if not exist
for dir_name in "${OUTPUT_DIRS[@]}"
do
    if [ ! -d "$dir_name" ]; then
        echo -e "$dir_name doesn't exist, creating now"
        mkdir -p "$dir_name"
    fi
done

theme_src_dir="$ZIP_OUTPUT_DIR/themes"
icon_src_dir="$ZIP_OUTPUT_DIR/icons"


echo "Unzipping the files..."

for file in "$theme_src_dir"/*

    do
        tar -xvf "$file" -d "$theme_install_dir"
    done

# tar -xvf "$theme_src_dir"/* -C "$theme_install_dir"
tar xvf "$icon_src_dir"/* -C "$icon_install_dir"
mv "$ZIP_OUTPUT_DIR"/backgrounds/* "$wallpaper_install_dir"

# ********** GNOME TWEAK SETTINGS ************
gsettings set org.gnome.desktop.wm.preferences button-layout ':minimize,maximize,close'
gsettings set org.gnome.desktop.interface gtk-theme "$GTK_THEME"
gsettings set org.gnome.desktop.wm.preferences theme "$SHELL_THEME"
gsettings set org.gnome.desktop.interface icon-theme "$ICON_THEME"
# gsettings set org.gnome.desktop.interface font-name "Ubuntu Mono 11"
# gsettings set org.gnome.mutter center-new-windows 'true'
gsettings set org.gnome.desktop.interface cursor-theme 'Yaru'
gsettings set org.gnome.desktop.interface clock-show-date 'true'
gsettings set org.gnome.desktop.interface clock-show-weekday 'true'
gsettings set org.gnome.desktop.background picture-uri "$wallpaper_file"




# ******** FIREFOX UNINSTALL ********
echo "Removing Firefox..."
sudo apt-get purge firefox -y
rm -rf ~/.mozilla
sudo rm -rf /etc/firefox
sudo rm -rf /usr/lib/firefox
# ******** FIREFOX UNINSTALL ********


# ******** UNINSTALL THUNDERBIRD MAIL ********
sudo apt-get purge thunderbird -y
sudo rm -rf ~/.thunderbird
sudo rm -rf /etc/thunderbird
sudo rm -rf /usr/lib/thunderbird
# ******** UNINSTALL THUNDERBIRD MAIL ********


# ******** INSTALL VSCODE ********
echo "Installing VSCode..."
sudo snap install code --classic
# ******** INSTALL VSCODE ********



# ******** INSTALL BRAVE ********
echo "Installing Brave..."
sudo apt install apt-transport-https curl
sudo curl -fsSLo /usr/share/keyrings/brave-browser-archive-keyring.gpg https://brave-browser-apt-release.s3.brave.com/brave-browser-archive-keyring.gpg
echo "deb [signed-by=/usr/share/keyrings/brave-browser-archive-keyring.gpg arch=amd64] https://brave-browser-apt-release.s3.brave.com/ stable main"|sudo tee /etc/apt/sources.list.d/brave-browser-release.list
sudo apt update
sudo apt install brave-browser
# ******** INSTALL BRAVE ********







# ********** CHANGE SYSTEM SETTINGS ************
# fix dual boot time issue
timedatectl set-local-rtc 1 --adjust-system-clock
# ********** END CHANGE SYSTEM SETTINGS ************



# ********** CONFIGURE GIT ************

read -p "Do you want to configure git? (y/n): "
if [[ $REPLY =~ ^[Yy]$ ]]; then
    # ASK FOR USERNAME AND EMAIL
    echo_gray "Configuring git..."
    read -p "Enter your username: " USERNAME
    read -p "Enter your email: " EMAIL
    git config --global user.name "$USERNAME"
    git config --global user.email "$EMAIL"
else
    echo_red "Git configuration aborted!"
fi

# ********** END CONFIGURE GIT ************



echo_green "Installation complete!"
read -p "Press any key to exit..."

