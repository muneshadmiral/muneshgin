FROM golang:latest as builder

WORKDIR /go/src/github.com/muneshadmiral/muneshgin
ADD . /go/src/github.com/muneshadmiral/muneshgin/

ENV GO111MODULE=on

RUN uname -a; go version; go env ; go build -mod=vendor -o muneshgin .

FROM ubuntu:14.04

RUN apt-get update && apt-get install -y --no-install-recommends \
        g++ \
        gcc \
        libc6-dev \
        make \
        pkg-config \
        wget \
        default-jdk \
        default-jre \
        bash 
      #  libc6-compat
ENV GOLANG_VERSION 1.14.6
#    && rm -rf /var/lib/apt/lists/*


# RUN apt-get update && \
#     apt-get upgrade && \
#     # apt-get install ca-certificates && update-ca-certificates && \
#     # apt-get install --update tzdata && \
#     # cp /usr/share/zoneinfo/US/Eastern /etc/localtime && \
#     # echo "US/Eastern" >  /etc/timezone && \
#     # apt-get del tzdata && \
#     apt-get install 
#     apt-get install libc6-compat

RUN set -eux; \
    \
# this "case" statement is generated via "update.sh"
    dpkgArch="$(dpkg --print-architecture)"; \
    case "${dpkgArch##*-}" in \
        amd64) goRelArch='linux-amd64'; goRelSha256='5c566ddc2e0bcfc25c26a5dc44a440fcc0177f7350c1f01952b34d5989a0d287' ;; \
        armhf) goRelArch='linux-armv6l'; goRelSha256='cab39cc0fdf9731476a339af9d7bcd8fc661bfa323abb1ce9d1633fb31daeb07' ;; \
        arm64) goRelArch='linux-arm64'; goRelSha256='291bccfd7d7f1915599bbcc90e49d9fccfcb0004b7c62a2f5cdf0f96a09d6a3e' ;; \
        i386) goRelArch='linux-386'; goRelSha256='17b2c4e26bd3a82a0a44499ae2d36e3f2155d0fe2f6b9a14ac6b7c5afac3ca6a' ;; \
        ppc64el) goRelArch='linux-ppc64le'; goRelSha256='8eb4c84e7b6aa9edb966c467dd6764d131a57d27afbd87cc8f6d10535df9e898' ;; \
        s390x) goRelArch='linux-s390x'; goRelSha256='cb1f2d001ce15e51f7c4bd43f15045ea23d49268010bb981110242a532138749' ;; \
        *) goRelArch='src'; goRelSha256='73fc9d781815d411928eccb92bf20d5b4264797be69410eac854babe44c94c09'; \
            echo >&2; echo >&2 "warning: current architecture ($dpkgArch) does not have a corresponding Go binary release; will be building from source"; echo >&2 ;; \
    esac; \
    \
    url="https://golang.org/dl/go${GOLANG_VERSION}.${goRelArch}.tar.gz"; \
    wget --no-check-certificate -O go.tgz "$url"; \
    echo "${goRelSha256} *go.tgz" | sha256sum -c -; \
    tar -C /usr/local -xzf go.tgz; \
    rm go.tgz; \
    \
    if [ "$goRelArch" = 'src' ]; then \
        echo >&2; \
        echo >&2 'error: UNIMPLEMENTED'; \
        echo >&2 'TODO install golang-any from jessie-backports for GOROOT_BOOTSTRAP (and uninstall after build)'; \
        echo >&2; \
        exit 1; \
    fi; \
    \
    export PATH="/usr/local/go/bin:$PATH"; \
    go version

ENV GOPATH /go
ENV PATH $GOPATH/bin:/usr/local/go/bin:$PATH


RUN mkdir -p "$GOPATH/src" "$GOPATH/bin" /"opt/muneshgin/src" && chmod -R 777 "$GOPATH"
 ADD golang-sdk-x64-linux-4.5.2.0.tar /opt/muneshgin/src
ENV GOPATH /opt/muneshgin:$GOPATH
ENV LD_LIBRARY_PATH /opt/muneshgin/src/appdynamics/lib


# RUN uname -a; go version; go env ; go build  -o muneshgin .
WORKDIR /root/
COPY --from=builder /go/src/github.com/muneshadmiral/muneshgin/muneshgin .

CMD /root/muneshgin

EXPOSE 4000
