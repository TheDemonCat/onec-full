FROM alpine:latest as downloader
LABEL maintainer="Ruslan Zhdanov <nl.ruslan@yandex.ru> (@TheDemonCat)"

ARG ONEC_USERNAME
ARG ONEC_PASSWORD
ARG VERSION
ENV installer_type=client

RUN apk --no-cache add bash curl grep \
  && cd /tmp \
  && curl -O "https://raw.githubusercontent.com/TheDemonCat/onec_downloader/master/download.sh" \
  && chmod +x download.sh \
  && sync; ./download.sh \
  && for file in *.tar.gz; do tar -zxf "$file"; done \
  && rm -rf *.tar.gz

FROM demoncat/onec-base:latest as base
LABEL maintainer="Ruslan Zhdanov <nl.ruslan@yandex.ru> (@TheDemonCat)"

COPY --from=downloader /tmp/*.deb /tmp/

RUN cd /tmp \ 
    && dpkg -i 1c-enterprise83-common_*.deb \
      1c-enterprise83-server_*.deb \
      1c-enterprise83-ws_*.deb \
      1c-enterprise83-client_*.deb \
  && cd .. \
  && rm -rf dist

RUN mkdir -p /root/.1cv8/1C/1cv8/conf/
