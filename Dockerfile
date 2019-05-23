FROM debian:stretch

# git tag from https://github.com/stellar/stellar-core
ARG STELLAR_CORE_VERSION="v11.1.0"
ARG STELLAR_CORE_BUILD_DEPS="git build-essential pkg-config autoconf automake libtool bison flex libpq-dev wget pandoc"
ARG STELLAR_CORE_DEPS="curl jq libpq5"
ARG CONFD_VERSION="0.16.0"

LABEL maintainer="hello@satoshipay.io"

# install stellar core and confd
ADD install.sh /
RUN /install.sh

VOLUME /data

# peer port
EXPOSE 11625

# HTTP port (do NOT expose publicly)
EXPOSE 11626

# configuration options, see here for docs:
# https://github.com/stellar/stellar-core/blob/master/docs/stellar-core_example.cfg
ENV \
  DATABASE="sqlite3:///data/stellar.db" \
  HTTP_MAX_CLIENT="128" \
  NETWORK_PASSPHRASE="Public Global Stellar Network ; September 2015" \
  INITIALIZE_DB=true

ADD ready.sh /
ADD confd /etc/confd

ADD entry.sh /
ENTRYPOINT ["/entry.sh"]

CMD ["/usr/local/bin/stellar-core", "--conf", "/stellar-core.cfg"]
