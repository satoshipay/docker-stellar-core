ARG TAG
FROM satoshipay/stellar-core:$TAG

LABEL maintainer="hello@satoshipay.io"

ADD install.gcloud.sh /
RUN /install.gcloud.sh

ADD entry.gcloud.sh /
ENTRYPOINT ["/entry.gcloud.sh"]

CMD ["/usr/local/bin/stellar-core", "--conf", "/stellar-core.cfg"]
