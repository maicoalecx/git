#!/bin/bash

run() {
  echo "Running:# $*"
  "$@"
  while [ $? -ne 0 ]; do
    echo "The command '*$**' fail!"
    echo "(s) to access the terminal | (enter) for continue"
    read option
    if [ "$option" = "s" ]; then
      echo "For continue the script type 'exit'."
      $SHELL
    fi
    echo "(s) for repeat the command that failed | (enter) for continue"
    read response
    if [ "$response" = "s" ]; then
      echo "Repeating the command:# $*"
      "$@"
    else
      echo "Continuing the script..."
      return 1
    fi
  done
  echo "## Command finished with success ##"
}

run sudo pacman -S --noconfirm git-lfs openssh
run read -p "Type your github user name: " username
run git config --global user.name "$username"
run read -p "Type your github email: " email
run git config --global user.email "$email"
run git config --global init.defaultBranch main
run git config --global core.editor "vim"
run git config --global trailer.changeid.key "Change-Id"
run git lfs install
run ssh-keygen -t ed25519 -C "$email"
run eval "$(ssh-agent -s)"
run ssh-add ~/.ssh/id_ed25519
run read -p "Type a user and ip for send ssh public key: " usuario ip
run scp -P 8022 ~/.ssh/id_ed25519.pub $usuario@$ip:~/

echo "END"