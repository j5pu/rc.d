# syntax=docker/dockerfile:1-labs
ARG image=${image:-alpine:latest}

FROM ${image} AS base
ARG image
COPY profile.d /etc/profile.d
RUN echo "export IMAGE=${image}" > /etc/profile.d/image.sh
ONBUILD COPY --from=base /etc/profile.d /etc/profile.d
# TODO: habria que montar el directorio en lugar de copiar para test y poner target de test
#   o usar el instalador en ambas y copiar?
# o el respositorio deberia ser rc y llamarlas rc:python3.9-alpine
FROM base AS build
SHELL ["/bin/sh", "-l", "-c"]
