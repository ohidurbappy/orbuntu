# ********** Functions **********

function box_out()
{
  local s=("$@") b w
  for l in "${s[@]}"; do
    ((w<${#l})) && { b="$l"; w="${#l}"; }
  done
  tput setaf 3
  echo " -${b//?/-}-
| ${b//?/ } |"
  for l in "${s[@]}"; do
    printf '| %s%*s%s |\n' "$(tput setaf 4)" "-$w" "$l" "$(tput setaf 3)"
  done
  echo "| ${b//?/ } |
 -${b//?/-}-"
  tput sgr 0
}



function echo_red() {
    echo -e "\033[31m$1\033[0m"
}

# function to change the echo color to green
function echo_green() {
    echo -e "\033[32m$1\033[0m"
}

# function to change the echo color to yellow
function echo_yellow() {
    echo -e "\033[33m$1\033[0m"
}

# function to change the echo color to blue
function echo_blue() {
    echo -e "\033[34m$1\033[0m"
}

# function to change the echo color to purple
function echo_purple() {
    echo -e "\033[35m$1\033[0m"
}

# function to change the echo color to cyan
function echo_cyan() {
    echo -e "\033[36m$1\033[0m"
}

# function to change the echo color to white
function echo_white() {
    echo -e "\033[37m$1\033[0m"
}

# function to change the echo color to gray
function echo_gray() {
    echo -e "\033[38m$1\033[0m"
}

# function to change the echo color to black
function echo_black() {
    echo -e "\033[39m$1\033[0m"
}

# function to change the echo color to bold
function echo_bold() {
    echo -e "\033[1m$1\033[0m"
}

# function to change the echo color to underline
function echo_underline() {
    echo -e "\033[4m$1\033[0m"
}

# function to change the echo color to blink
function echo_blink() {
    echo -e "\033[5m$1\033[0m"
}

# function to change the echo color to reverse
function echo_reverse() {
    echo -e "\033[7m$1\033[0m"
}

# function to change the echo color to hidden
function echo_hidden() {
    echo -e "\033[8m$1\033[0m"
}

# function to change the echo color to bold and underline
function echo_bold_underline() {
    echo -e "\033[1;4m$1\033[0m"
}

# function to change the echo color to bold and blink
function echo_bold_blink() {
    echo -e "\033[1;5m$1\033[0m"
}

# function to configure git username
function git_config_username() {
    echo_bold "Configuring git username..."
    git config --global user.name "$1"
    echo_green "Done!"
}

# function to configure git email
function git_config_email() {
    echo_bold "Configuring git email..."
    git config --global user.email "$1"
    echo_green "Done!"
}

# function to configure git username and email
function git_config_username_email() {
    echo_bold "Configuring git username and email..."
    git config --global user.name "$1"
    git config --global user.email "$2"
    echo_green "Done!"
}
