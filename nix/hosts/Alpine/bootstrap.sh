#!usr/bin/env sh

# dash shell man (ash port to debian): https://linux.die.net/man/1/dash

# before this script:
# wget this as raw from dotfiles repo

# vars from user input
NAME=$REPLY

# vars from nix

is-root() {
  if ![ $EUID -eq 0 ]; then
    echo "This script needs to be run as root user"
    exit 1;
  else
    read -p "Insert the non-root user name for Nix install:" -r
    init()
  fi
}

pre-nix() {

  if ![ -d /home/$NAME ]; then
   adduser -g "${NAME}" $NAME 
   mkdir -p {/home/$NAME/Desktop,/home/$NAME/Documents,/home/$NAME/Downloads,/home/$NAME/Music,/home/$NAME/Templates,/home/$NAME/Pictures,/home/$NAME/Public,/home/$NAME/Videos}
  else
    echo "A folder called ${NAME} already exists under /home, aborting"
    exit 1;
  fi

  
  if ![ grep "https://dl-cdn.alpinelinux.org/alpine/v.*/community/" /etc/apk/repositories ]; then
    cat > /etc/apk/repositories << EOF $(echo)
https://dl-cdn.alpinelinux.org/alpine/v$(cut -d'.' -f1,2 /etc/alpine-release)/community/
EOF
    apk update
  fi

  # the sh doesnt support true arrays. Instead, a var set to a string is used
  # $IFS can be set to an arbitrary delimiter between elements
  # and  $@ can be used to access the n element of the array
  has="$(find /usr/bin -name 'sudo' -o -name 'curl' -o -name 'xz' | cut -d'/' -f4)"
  if ![ echo "$has" | grep -F -w -- 'sudo' ]; then # -- marks end of cli options
    apk add --no-cache sudo;
  fi
  if ![ echo "$has" | grep -F -w -- 'curl' ]; then
    apk add --no-cache curl;
  fi
  if ![ echo "$has" | grep -F -w -- 'xz' ]; then
    apk add --no-cache xz;
  fi

  if ![ -d /etc/sudoers.d/wheel ]; then
    touch /etc/sudoers.d/wheel
    echo '%wheel ALL=(ALL) ALL' > /etc/sudoers.d/wheel

    adduser $NAME wheel
  fi
}

setup-nix() {

  if ![ -f /usr/bin/sudo ] && [ -f /usr/bin/curl ] && [ -f /user/bin/xz ]; then
    echo "Dependencies for Nix install (sudo, curl and xz) not found, \n remove /home/${NAME} and install dependencies"
    exit 1
  fi

  # maybe apk add --no-cache nix (probably causes version mismatch in derivations)
  curl -L https://nixos.org/nix/install | sh --daemon

  if ![ -f /home/$NAME/.profile ]; then
    touch /home/$NAME/.profile
    cat > /home/$NAME/.profile << EOF
if [ -f /etc/profile ]; then
  . /etc/profile
fi
EOF
  fi
  # for sane distros this should be ~/.bashrc 
  # this is also multiuser install. Single user path will be relative to $HOME/nix/etc
  echo ". /etc/profile.d/nix.sh" >> /home/$NAME/.profile

  # need to manually start nix daemon in openrc: https://wiki.archlinux.org/title/OpenRC#Usage
  # write service in openrc: https://unix.stackexchange.com/questions/521404/set-dm-on-openrc
  # https://github.com/OpenRC/openrc/blob/master/service-script-guide.md
  # https://www.cyberciti.biz/faq/how-to-enable-and-start-services-on-alpine-linux/
  # nix daemon info: https://nixos.org/manual/nix/stable/installation/installing-binary.html#uninstalling
  # nix daemon sysV implementation: https://github.com/NixOS/nix/blob/master/misc/systemv/nix-daemon

}

get-dotfiles() {
  wget -d /home/$NAME https://github.com/TheSlothyBR/.dotfiles/tarball/main -o main.tar.gz | tar -xzv
  mkdir .dotfiles
  mv /home/$NAME/main/TheSlothyBR-.dotfiles-*/ /home/$NAME/.dotfiles/
}

vars-nix() {
  # grab user vars from .nix files
}

post-nix() {
  git clone https://github.com/TheSlothyBR/.dotfiles/main.git /home/$NAME/temp
  mv /home/$NAME/temp/.dotfiles/.git /home/$NAME/.dotfiles/.git
  rm -r /home/$NAME/temp
}

secure-nix() {
  if ![ grep -q root:/bin/bash /etc/passwd ]; then
    sed '\%root%s%/bin/ash%/usr/bin/nologin%' /etc/passwd
  fi
}

init() {
  pre-nix()
  setup-nix()
  get-dotfiles()
  vars-nix()
  post-nix()
  #secure-nix()
}

# is-root()
