FROM cloudron/base:4.0.0@sha256:31b195ed0662bdb06a6e8a5ddbedb6f191ce92e8bee04c03fb02dd4e9d0286df

ARG VERSION=0.24.1
ARG DEB=coder_${VERSION}_linux_amd64.deb
ARG URL=https://github.com/coder/coder/releases/download/v${VERSION}/${DEB}

RUN curl -L -O ${URL} && apt install ./${DEB} && rm ${DEB}

COPY start.sh /app/pkg/start.sh

CMD [ "/app/pkg/start.sh" ]
