ARG VERSION="1.15"

FROM alpine:3.15
ARG VERSION
RUN apk update && apk add --no-cache gcc make libc-dev ncurses-dev zlib-dev xz-dev bzip2-dev curl-dev
RUN wget -q https://github.com/samtools/bcftools/releases/download/${VERSION}/bcftools-${VERSION}.tar.bz2 && \
    tar -xjf bcftools-${VERSION}.tar.bz2 && \
    cd bcftools-${VERSION} && \
    make -j4 && \
    make install

FROM alpine:3.15
RUN apk update && apk add xz-dev bzip2-dev bash R
COPY --from=0 /usr/local/bin/bcftools /usr/local/bin/bcftools
ADD src /src
ADD exampledata /exampledata
RUN chmod -R 777 /src
ENV PATH="/src:${PATH}"

WORKDIR /data
ENTRYPOINT ["nrc.sh"]