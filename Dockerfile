FROM phusion/baseimage:focal-1.2.0

ENV DEBIAN_FRONTEND noninteractive

ENV TZ Asia/Ho_Chi_Minh

RUN dpkg --add-architecture i386 && \
    apt-get -y update && \
    apt install -y \
    libc6:i386 \
    libc6-dbg:i386 \
    libc6-dbg \
    lib32stdc++6 \
    g++-multilib \
    cmake \
    ipython3 \
    vim \
    net-tools \
    iputils-ping \
    libffi-dev \
    libssl-dev \
    python3-dev \
    python3-pip \
    build-essential \
    ruby \
    ruby-dev \
    tmux \
    strace \
    ltrace \
    nasm \
    wget \
    gdb \
    gdb-multiarch \
    netcat \
    socat \
    git \
    patchelf \
    gawk \
    file \
    python3-distutils \
    bison \
    rpm2cpio cpio \
    zstd \
    zsh \
    tzdata --fix-missing && \
    rm -rf /var/lib/apt/list/*

RUN ln -fs /usr/share/zoneinfo/$TZ /etc/localtime && \
    dpkg-reconfigure -f noninteractive tzdata

RUN sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"

RUN version=$(curl -s https://api.github.com/repos/radareorg/radare2/releases/latest | grep -P '"tag_name": "(.*)"' -o| awk '{print $2}' | awk -F"\"" '{print $2}') && \
    wget https://github.com/radareorg/radare2/releases/download/${version}/radare2_${version}_amd64.deb && \
    dpkg -i radare2_${version}_amd64.deb && rm radare2_${version}_amd64.deb

RUN python3 -m pip install -U pip && \
    python3 -m pip install --no-cache-dir \
    ropgadget \
    z3-solver \
    smmap2 \
    apscheduler \
    ropper \
    unicorn \
    keystone-engine \
    capstone \
    angr \
    pebble \
    r2pipe

RUN gem install one_gadget seccomp-tools && rm -rf /var/lib/gems/2.*/cache/*

RUN git clone --depth 1 https://github.com/pwndbg/pwndbg && \
    cd pwndbg && chmod +x setup.sh && ./setup.sh

RUN git clone --depth 1 https://github.com/scwuaptx/Pwngdb.git ~/Pwngdb && \
    cd ~/Pwngdb && mv .gdbinit .gdbinit-pwngdb && \
    sed -i "s?source ~/peda/peda.py?# source ~/peda/peda.py?g" .gdbinit-pwngdb && \
    echo "source ~/Pwngdb/.gdbinit-pwngdb" >> ~/.gdbinit

RUN wget -O ~/.gdbinit-gef.py -q http://gef.blah.cat/py

RUN git clone --depth 1 https://github.com/niklasb/libc-database.git libc-database && \
    echo "/libc-database/" > ~/.libcdb_path && \
    rm -rf /tmp/*

COPY ./tmux.conf /root/.tmux.conf

WORKDIR /pwn/work/

# COPY --from=skysider/glibc_builder64:2.19 /glibc/2.19/64 /glibc/2.19/64
# COPY --from=skysider/glibc_builder32:2.19 /glibc/2.19/32 /glibc/2.19/32

# COPY --from=skysider/glibc_builder64:2.23 /glibc/2.23/64 /glibc/2.23/64
# COPY --from=skysider/glibc_builder32:2.23 /glibc/2.23/32 /glibc/2.23/32

# COPY --from=skysider/glibc_builder64:2.24 /glibc/2.24/64 /glibc/2.24/64
# COPY --from=skysider/glibc_builder32:2.24 /glibc/2.24/32 /glibc/2.24/32

# COPY --from=skysider/glibc_builder64:2.27 /glibc/2.27/64 /glibc/2.27/64
# COPY --from=skysider/glibc_builder32:2.27 /glibc/2.27/32 /glibc/2.27/32

# COPY --from=skysider/glibc_builder64:2.28 /glibc/2.28/64 /glibc/2.28/64
# COPY --from=skysider/glibc_builder32:2.28 /glibc/2.28/32 /glibc/2.28/32

# COPY --from=skysider/glibc_builder64:2.29 /glibc/2.29/64 /glibc/2.29/64
# COPY --from=skysider/glibc_builder32:2.29 /glibc/2.29/32 /glibc/2.29/32

# COPY --from=skysider/glibc_builder64:2.30 /glibc/2.30/64 /glibc/2.30/64
# COPY --from=skysider/glibc_builder32:2.30 /glibc/2.30/32 /glibc/2.30/32

# COPY --from=skysider/glibc_builder64:2.33 /glibc/2.33/64 /glibc/2.33/64
# COPY --from=skysider/glibc_builder32:2.33 /glibc/2.33/32 /glibc/2.33/32

# COPY --from=skysider/glibc_builder64:2.34 /glibc/2.34/64 /glibc/2.34/64
# COPY --from=skysider/glibc_builder32:2.34 /glibc/2.34/32 /glibc/2.34/32

# COPY --from=skysider/glibc_builder64:2.35 /glibc/2.35/64 /glibc/2.35/64
# COPY --from=skysider/glibc_builder32:2.35 /glibc/2.35/32 /glibc/2.35/32

# COPY --from=skysider/glibc_builder64:2.36 /glibc/2.36/64 /glibc/2.36/64
# COPY --from=skysider/glibc_builder32:2.36 /glibc/2.36/32 /glibc/2.36/32

COPY linux_server linux_server64  /pwn/

RUN chmod a+x /pwn/linux_server /pwn/linux_server64

RUN python3 -m pip install --no-cache-dir pwntools

RUN wget https://github.com/robbyrussell/oh-my-zsh/raw/master/tools/install.sh -O - | zsh || true
RUN mkdir -p "$HOME/.zsh"
RUN git clone https://github.com/sindresorhus/pure.git "$HOME/.zsh/pure"
RUN echo "fpath+=("$HOME/.zsh/pure")\nautoload -U promptinit; promptinit\nprompt pure" >> ~/.zshrc

RUN git clone https://github.com/zsh-users/zsh-syntax-highlighting.git ~/.zsh/zsh-syntax-highlighting
RUN echo "source ~/.zsh/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh" >> ~/.zshrc

RUN git clone https://github.com/zsh-users/zsh-autosuggestions ~/.zsh/zsh-autosuggestions
RUN echo "source ~/.zsh/zsh-autosuggestions/zsh-autosuggestions.zsh" >> ~/.zshrc
RUN echo "ZSH_AUTOSUGGEST_HIGHLIGHT_STYLE='fg=111'" >> ~/.zshrc

RUN wget https://github.com/io12/pwninit/releases/latest/download/pwninit && \
    cp pwninit /usr/local/bin && \
    chmod +x /usr/local/bin/pwninit && \
    rm pwninit

RUN curl -LO https://github.com/neovim/neovim/releases/latest/download/nvim-linux64.tar.gz && \
    rm -rf /opt/nvim && \
    tar -C /opt -xzf nvim-linux64.tar.gz


RUN mkdir -p /pwn/binaries

RUN chsh -s $(which zsh)
RUN echo "export PATH=$PATH:/opt/nvim-linux64/bin" >> ~/.zshrc

RUN git clone https://github.com/LazyVim/starter /root/.config/nvim && \
    rm -rf /root/.config/nvim/.git

ENV LC_ALL=C.UTF-8

CMD ["/sbin/my_init"]
