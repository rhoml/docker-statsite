FROM ubuntu:17.04

RUN apt-get update && apt-get install -y \
    git \
    make \
    gcc \
    automake \
    autoconf \
    python \
    libtool \
    check \
    build-essential \
    python-setuptools \
    devscripts \
    python-pytest \
    scons \
    wget \
    pkg-config \
    m4 \
    && rm -rf /var/lib/apt/lists/* \
    && easy_install pip \
    && pip install pytest requests

RUN mkdir /app \
    && cd /app \
    && git clone https://github.com/statsite/statsite.git \
    && cd statsite \
    && ./autogen.sh \
    && ./configure \
    && make \
    && make install \
    && mv statsite /bin/ \
    && mv sinks /bin/sinks \
    && chmod +x /bin/sinks/* /bin/statsite \
    && cd /root \
    && rm -rf /app

VOLUME ["/etc/statsite"]

EXPOSE 8125

CMD ["/bin/statsite", "-f", "/etc/statsite/statsite.conf"]
