FROM ubuntu:17.04

RUN apt-get update && apt-get install -y \
    build-essential \
    git \
    make \
    gcc \
    automake \
    autoconf \
    python \
    libtool \
    check \
    devscripts \
    scons \
    wget \
    pkg-config \
    m4

RUN apt-get install -y python-setuptools

RUN easy_install pip \
    && pip install pytest requests

RUN mkdir /app

ARG VERSION

RUN cd /app \
    && git clone -b ${VERSION} https://github.com/statsite/statsite.git \
    && cd statsite \
    && ./autogen.sh \
    && ./configure \
    && make \
    && make install \
    && mv statsite /bin/ \
    && mv sinks /bin/sinks \
    && chmod +x /bin/sinks/* /bin/statsite

RUN apt-get -y autoremove \
    && apt-get clean all \
    && rm -rf /var/lib/apt/lists/*

FROM ubuntu:17.04

RUN cd /bin

COPY --from=0 /bin/statsite statsite
COPY --from=0 /bin/sinks sinks

VOLUME ["/etc/statsite"]

EXPOSE 8125

CMD ["/bin/statsite", "-f", "/etc/statsite/statsite.conf"]
