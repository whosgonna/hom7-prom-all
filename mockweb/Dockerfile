### Package deps, for build and devel phases
FROM whosgonna/perl-build:5.36.0 AS builder

## Install all of the perl modules:
USER perl
COPY cpanfile* /home/perl/
RUN cpm install --workers 16 --without-develop --without-configure --with-suggests \
    && carton install --without 'develop,configure'


### Final phase: the runtime version - notice that we start from the base perl image.
FROM whosgonna/perl-runtime:latest
USER root
RUN apk add --no-cache sqlite
WORKDIR /home/perl
USER perl

## Set any environmental variables here.
ENV PLACK_ENV=docker_production


## Copy the actual application files:
COPY --chown=perl ./ ./


## Copy the local directory with the perl libraries and the cpan files from the
## ephemeral build image.
COPY --from=builder --chown=perl /home/perl/local/ /home/perl/local/
COPY --from=builder --chown=perl /home/perl/cpanfile* /home/perl/


ENTRYPOINT  carton exec plackup -p  5000 --server Gazelle /home/perl/bin/app.psgi
