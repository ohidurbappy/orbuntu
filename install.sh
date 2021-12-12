#!/bin/bash

# ********** Configurations **********
OS_FLAVOR="orbuntu"
USER="$(whoami)"

GTK_THEME="Mc-OS-CTLina-Gnome-Dark-1.3.2"
SHELL_THEME="Sweet-Dark-v40"
WALLPAPER="macos-wp.jpg"
SCREENSAVER="firewatch-wallpaper.jpg"
ICON_THEME="Papirus"
# *********** END Configurations ***********


# ********** Download the files **********
echo "Downloading the files..."
wget https://github.com/ohidurbappy/orbuntu/archive/refs/heads/main.zip -O orbuntu.zip
ZIP_OUTPUT_DIR="$HOME/$OS_FLAVOR"
sudo unzip orbuntu.zip -d $ZIP_OUTPUT_DIR
sudo yes | cp -r $ZIP_OUTPUT_DIR/orbuntu-main/* $ZIP_OUTPUT_DIR
rm orbuntu.zip
# *********** END Download the files ***********


# change directory to the folder
cd $ZIP_OUTPUT_DIR

# include the helper functions from 'src/helpers.sh'
source src/helpers.sh


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

# change the color to white
echo -e "\e[0m"


# ******** INSTALLING REQUIRED PACKAGES ********
echo "Installing packages..."
sudo apt update && sudo apt upgrade -y
sudo apt install git gnome-shell-extensions chrome-gnome-shell gnome-tweaks -y


# ******** FIREFOX UNINSTALL ********
echo "Removing Firefox..."
sudo apt-get purge firefox -y
rm -rf ~/.mozilla
sudo rm -rf /etc/firefox
sudo rm -rf /usr/lib/firefox
# ******** FIREFOX UNINSTALL ********


# ******** UNINSTALL THUNDERBIRD MAIL ********
# sudo apt-get purge thunderbird -y
# sudo rm -rf ~/.thunderbird
# sudo rm -rf /etc/thunderbird
# sudo rm -rf /usr/lib/thunderbird
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



# ******** INSTALL THEMES, ICONS, WALLPAPER ********

OUTPUT_DIRS=(
    "$HOME/.themes"
    "$HOME/.icons"
)

# create dirs if not exist
for dir_name in "${OUTPUT_DIRS[@]}"
do
    if [ ! -d "$dir_name" ]; then
        mkdir "$dir_name"
    fi
done


echo "Unzipping the files..."
tar -xvf themes/* -C ~/.themes
tar -xvf icons/* -C ~/.icons

mv "$HOME/$OS_FLAVOR/backgrounds"/* /usr/share/backgrounds/

echo_gray "Installing the themes..."

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
gsettings set org.gnome.desktop.background picture-uri "file:///usr/share/backgrounds/$WALLPAPER"




# ********** CHANGE SYSTEM SETTINGS ************
# fix dual boot time issue
timedatectl set-local-rtc 1 --adjust-system-clock
# ********** END CHANGE SYSTEM SETTINGS ************


# ********** CONFIGURE GIT ************

# ASK FOR USERNAME AND EMAIL
echo_gray "Configuring git..."
read -p "Enter your username: " USERNAME
read -p "Enter your email: " EMAIL
git config --global user.name "$USERNAME"
git config --global user.email "$EMAIL"

# ********** END CONFIGURE GIT ************



echo_green "Installation complete!"
read -p "Press any key to exit..."

