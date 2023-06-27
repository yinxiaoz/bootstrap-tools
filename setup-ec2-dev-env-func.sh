sudo yum update


setup_vim() {
    mkdir -p .vim/backup
    git clone https://github.com/VundleVim/Vundle.vim.git ~/.vim/bundle/Vundle.vim
}


setup_docker() {
    # docker
    sudo yum install docker
    sudo usermod -a -G docker ec2-user
    id ec2-user
    newgrp docker

    # docker-compose
    wget https://github.com/docker/compose/releases/latest/download/docker-compose-$(uname -s)-$(uname -m)
    sudo mv docker-compose-$(uname -s)-$(uname -m) /usr/local/bin/docker-compose
    sudo chmod -v +x /usr/local/bin/docker-compose

    # Enable docker service at AMI boot time
    sudo systemctl enable docker.service
    # Start the Docker service
    sudo systemctl start docker.service
}

setup_git() {
    # git and github cli
    sudo yum install git
    type -p yum-config-manager >/dev/null || sudo yum install yum-utils
    sudo yum-config-manager --add-repo https://cli.github.com/packages/rpm/gh-cli.repo
    sudo yum install gh

    # auth github
    gh auth login
}

setup_zsh() {
    sudo yum install zsh

    sudo yum install util-linux-user

    sudo passwd ec2-user

    chsh -s $(which zsh)

    sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"
}

setup_zsh_plugin() {
    git clone https://github.com/zsh-users/zsh-syntax-highlighting.git ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-syntax-highlighting

    git clone https://github.com/zsh-users/zsh-autosuggestions ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-autosuggestions
}

setup_pyenv() {
    # necessary dependencies
    sudo yum install gcc zlib-devel bzip2 bzip2-devel readline readline-devel sqlite sqlite-devel openssl openssl-devel libffi-devel -y
    
    # resolve pyenv on amazon linux 2 issue - https://stackoverflow.com/questions/71954694/pyenv-on-amazon-linux-fails-to-build-due-to-openssl
    sudo yum remove openssl-devel.x86_64
    sudo yum autoremove
    sudo yum install openssl11-devel

    # pyenv for python
    curl https://pyenv.run | bash

    # The following is already included in dotfiles/.zshrc. we can skip
    # echo 'export PYENV_ROOT="$HOME/.pyenv"' >> ~/.zshrc
    # echo 'command -v pyenv >/dev/null || export PATH="$PYENV_ROOT/bin:$PATH"' >> ~/.zshrc
    # echo 'eval "$(pyenv init -)"' >> ~/.zshrc

    # pyenv virtualenv plugin
    git clone https://github.com/pyenv/pyenv-virtualenv.git ~/.pyenv/plugins/pyenv-virtualenv

    # The following is already included in dotfiles/.zshrc. we can skip
    # echo 'eval "$(pyenv virtualenv-init -)"' >> ~/.zshrc
}

setup_tmux() {
    # tmux
    # install deps
    sudo yum install -y gcc kernel-devel make ncurses-devel
# DOWNLOAD SOURCES FOR LIBEVENT AND MAKE AND INSTALL
    curl -LOk https://github.com/libevent/libevent/releases/download/release-2.1.11-stable/libevent-2.1.11-stable.tar.gz
    tar -xf libevent-2.1.11-stable.tar.gz
    cd libevent-2.1.11-stable
    ./configure --prefix=/usr/local
    make
    sudo make install

    # DOWNLOAD SOURCES FOR TMUX AND MAKE AND INSTALL

    curl -LOk https://github.com/tmux/tmux/releases/download/3.0a/tmux-3.0a.tar.gz
    tar -xf tmux-3.0a.tar.gz
    cd tmux-3.0a
    LDFLAGS="-L/usr/local/lib -Wl,-rpath=/usr/local/lib" ./configure --prefix=/usr/local
    make
    sudo make install

    tmux -V

    git clone https://github.com/gpakosz/.tmux.git
    ln -s -f .tmux/.tmux.conf
    cp .tmux/.tmux.conf.local .
}
