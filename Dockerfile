# LICENSE

# Copyright (c) 2017 Rhommel Lamas

# MIT License

# Permission is hereby granted, free of charge, to any person obtaining
# a copy of this software and associated documentation files (the
# "Software"), to deal in the Software without restriction, including
# without limitation the rights to use, copy, modify, merge, publish,
# distribute, sublicense, and/or sell copies of the Software, and to
# permit persons to whom the Software is furnished to do so, subject to
# the following conditions:

# The above copyright notice and this permission notice shall be
# included in all copies or substantial portions of the Software.

# THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND,
# EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF
# MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND
# NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE
# LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION
# OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION
# WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
FROM ubuntu:17.04

MAINTAINER Rhommel Lamas <roml@rhommell.com>

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

FROM ubuntu:17.04

RUN cd /bin

COPY --from=0 /bin/statsite statsite
COPY --from=0 /bin/sinks sinks

VOLUME ["/etc/statsite"]

EXPOSE 8125

CMD ["/bin/statsite", "-f", "/etc/statsite/statsite.conf"]
