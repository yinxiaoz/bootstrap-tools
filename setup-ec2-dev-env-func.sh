
update_yum() {
    sudo yum update
}


setup_vim() {
    mkdir -p .vim/backup
    git clone https://github.com/VundleVim/Vundle.vim.git ~/.vim/bundle/Vundle.vim
}

setup_nvm() {
    curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.39.3/install.sh | bash
    . ~/.nvm/nvm.sh
    nvm install 16

    npm install -g aws-cdk
}

setup_kube() {
    # https://minikube.sigs.k8s.io/docs/start/
    curl -LO https://storage.googleapis.com/minikube/releases/latest/minikube-linux-amd64
    sudo install minikube-linux-amd64 /usr/local/bin/minikube
    
    # https://kubernetes.io/docs/tasks/tools/install-kubectl-linux/
    curl -LO "https://dl.k8s.io/release/$(curl -L -s https://dl.k8s.io/release/stable.txt)/bin/linux/amd64/kubectl"
    sudo install -o root -g root -m 0755 kubectl /usr/local/bin/kubectl

    # https://eksctl.io/introduction/#installation
    ARCH=amd64
    PLATFORM=$(uname -s)_$ARCH
    curl -sLO "https://github.com/weaveworks/eksctl/releases/latest/download/eksctl_$PLATFORM.tar.gz"
    curl -sL "https://github.com/weaveworks/eksctl/releases/latest/download/eksctl_checksums.txt" | grep $PLATFORM | sha256sum --check
    tar -xzf eksctl_$PLATFORM.tar.gz -C /tmp && rm eksctl_$PLATFORM.tar.gz
    sudo mv /tmp/eksctl /usr/local/bin

    # https://kompose.io/installation/
    curl -L https://github.com/kubernetes/kompose/releases/download/v1.28.0/kompose-linux-amd64 -o kompose
    sudo mv ./kompose /usr/local/bin/kompose
}

setup_docker() {
    # docker
    sudo yum install docker
    sudo usermod -a -G docker ec2-user
    id ec2-user
    newgrp docker

    # docker-compose
    sudo curl -L https://github.com/docker/compose/releases/download/v2.19.1/docker-compose-linux-x86_64 -o /usr/local/bin/docker-compose
    sudo chmod -v +x /usr/local/bin/docker-compose

    sudo chgrp docker /usr/local/bin/docker-compose
    sudo chmod 750 /usr/local/bin/docker-compose

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
    
    # resolve pyenv on amazon linux 2 issue - https://stackoverflow.com/questions/71954694/pyenv-on-amazon-linux-fails-to-build-due-to-openssl
    sudo yum remove openssl-devel.x86_64
    sudo yum autoremove
    sudo yum install openssl11-devel

    # pyenv for python
    curl https://pyenv.run | bash

    # The following is already included in dotfiles/.zshrc. we can skip
    echo 'export PYENV_ROOT="$HOME/.pyenv"' >> ~/.zshrc
    echo 'command -v pyenv >/dev/null || export PATH="$PYENV_ROOT/bin:$PATH"' >> ~/.zshrc
    echo 'eval "$(pyenv init -)"' >> ~/.zshrc

    # pyenv virtualenv plugin
    git clone https://github.com/pyenv/pyenv-virtualenv.git ~/.pyenv/plugins/pyenv-virtualenv

    # The following is already included in dotfiles/.zshrc. we can skip
    echo 'eval "$(pyenv virtualenv-init -)"' >> ~/.zshrc

    # necessary dependencies
    sudo yum install gcc zlib-devel bzip2 bzip2-devel readline readline-devel sqlite sqlite-devel openssl openssl-devel libffi-devel -y
}

setup_poetry() {
    curl -sSL https://install.python-poetry.org | python3 -
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

