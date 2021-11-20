ARG repo=alpine
ARG tag=latest
ARG target
ARG image="${repo}:${tag}"

#ARG BASH_ENV=${BASH_ENV:-/etc/profile}
#ARG ENV=${ENV:-$BASH_ENV}

# TODO no tendria el BASH_ENV hacer alguna intermedia

#FROM ${image} AS base
#ARG imbuildage
#ARG repo
#ARG tag
#ARG target
#ENV image ${image}
#ENV repo ${repo}
#ENV tag ${tag}
#ENV target ${target}
#RUN printf '%s\n' image=${image} nrepo=${repo} ntag=${tag} target=${target} >/.container
#ONBUILD COPY --from=base /.container /
FROM ${image} AS rc
FROM ${image} AS rc-test
#ARG BASH_ENV
#ENV BASH_ENV $BASH_ENV
#ARG ENV
#ENV ENV $ENV

#SHELL ["/bin/sh", "-l", "-c"]

#CMD mkdir -p /base && echo "${base}" > /base/image && touch /base/entrypoint.sh && chmod +x /base/entrypoint.sh

#COPY <<EOF /.base-entrypoint.sh
#COPY profile.d /etc

#ONBUILD COPY --from=base /base /
#ONBUILD COPY --from=base /etc/profile.d /etc
#ONBUILD ENTRYPOINT []
#FROM base AS usr_bin_bash
#CMD ["/usr/bin/bash -l"]
#
#FROM base AS bats
#ENTRYPOINT ["/tini", "--", "bash", "-l", "bats"]
#
#FROM base AS bash
#CMD ["bash -l"]
#
#FROM base AS bin_bash
#CMD ["/bin/bash -l"]
#
#FROM base AS sh
#CMD ["/bin/sh -l"]
#
#FROM base AS other
