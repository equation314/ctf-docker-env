FROM ubuntu:20.04

ENV DEBIAN_FRONTEND=noninteractive

RUN sed -i "s/http:\/\/archive.ubuntu.com/http:\/\/mirrors.tuna.tsinghua.edu.cn/g" /etc/apt/sources.list
RUN apt-get update && apt-get -y dist-upgrade

# CTF only
RUN apt-get install -y xinetd

# More tools
RUN apt-get install -y gcc gdb build-essential \
    vim git netcat htop tmux python3-pip

RUN pip3 install -i https://pypi.tuna.tsinghua.edu.cn/simple pip -U
RUN pip3 config set global.index-url https://pypi.tuna.tsinghua.edu.cn/simple

RUN pip3 install pwntools

RUN git clone https://github.com/pwndbg/pwndbg.git .pwndbg
RUN cd .pwndbg && ./setup.sh

RUN useradd -m ctf

WORKDIR /home/ctf

RUN mkdir /home/ctf/root

RUN cp -R /usr/lib* /home/ctf/root

RUN mkdir /home/ctf/root/dev && \
    mknod /home/ctf/root/dev/null c 1 3 && \
    mknod /home/ctf/root/dev/zero c 1 5 && \
    mknod /home/ctf/root/dev/random c 1 8 && \
    mknod /home/ctf/root/dev/urandom c 1 9 && \
    chmod 666 /home/ctf/root/dev/*

RUN mkdir /home/ctf/root/bin && \
    cp /bin/sh /home/ctf/root/bin && \
    cp /bin/ls /home/ctf/root/bin && \
    cp /bin/cat /home/ctf/root/bin

COPY ./files/ctf.xinetd /etc/xinetd.d/ctf
COPY ./files/start.sh /start.sh
COPY ./files/flag.txt /home/ctf/root
RUN chmod +x /start.sh

RUN chown -R root:ctf /home/ctf/root && \
    chmod -R 750 /home/ctf/root && \
    chmod 740 /home/ctf/root/flag.txt

EXPOSE 2333
EXPOSE 6666

# CTF only
# CMD ["/start.sh"]
