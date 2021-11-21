#!/usr/bin/env bash
# shellcheck disable=SC1091
set -eo pipefail
shopt -s inherit_errexit

# IMAGES: enable;<repo owner>;<repo name>;<tag>;stripname;striptag
#
# TODO: poner opción de active o no en el csv
# TODO: lo dejo. mirara el error y lo de los ancestors que coño borra y por que no salen los putos todo .

IMAGES_FIELDS="6"
IMAGES=$(cat <<EOF
1;alpine;;;;
1;archlinux;;;;
1;bash;;;;
0;bash;;5.1;;
0;bash;;5.0;;
0;bash;;4.4;;
1;bats;bats;;;
1;busybox;;;;
1;centos;;;;
1;debian;;;;
1;debian;;bullseye-backports;;bullseye-
1;debian;;bullseye-slim;;bullseye-
1;fedora;;;;
1;jrei;systemd-ubuntu;;;
1;kalilinux;kali-rolling;;-rolling;
1;kalilinux;kali-bleeding-edge;;-bleeding;
1;nixos;nix;;;
0;python;;3.9-alpine;;-alpine
0;python;;3.9-bullseye;;
0;python;;3.9-slim;;
1;python;;3.10-alpine;;-alpine
1;python;;3.10-bullseye;;
1;python;;3.10-slim;;
1;richxsl;rhel7;;;
1;ubuntu;;;;
1;zshusers;zsh;;;
EOF
)

#declare -A targets=( \
#["bash"]="bash debian kalilinux ubuntu" \
#["bin_bash"]="centos fedora richxsl" \
#["sh"]="alpine busybox nix" \
#["usr_bin_bash"]="archlinux" \
#)


#######################################
# Exec command in an ephemeral container.
# Globals:
#   ID                ID to build, create, exec or run command (default: all).
#   SHOW              Show image id for exec and run.
#   TEST              Build local images if repository is not base.
#######################################
build::exec() {
  local i image
  export ARGUMENTS=("${@}")
  if [ "${ID-}" ]; then
    image="$(build::image "${ID}")"
    [ "${SHOW-}" ] && ok "${image}"
    build::exec::rm "${ID}" "${image}"
  else
    for i in $(build::id); do
      image="$(build::image "${i}")"
      [ "${SHOW-}" ] && ok "${image}"
      build::exec::rm "${i}" "${image}"
    done
  fi
}

build::exec::rm() {
  local name="exec-${1}"
  docker rm --force "${name}" &>/dev/null || true
  build::build::test::quiet::die "${1}" "${2}"
  if docker run -dit --name "${name}" "${2}" >/dev/null \
    && docker exec -it "${name}" "${ARGUMENTS[@]}"; then
    docker rm --force "${name}" &>/dev/null || true
  fi
}

#######################################
# Runs command in an ephemeral container.
# Globals:
#   EXCLUDE           Excluded IDs when doing 'docker run' for all (not shell CMD/ENTRYPOINT).
#   ID                ID to build, create, exec or run command (default: all).
#   SHOW              Show image id for exec and run.
#   TEST              Build local images if repository is not base.
#######################################
build::run() {
  local i image
  if [ "${ID-}" ]; then
    image="$(build::image "${ID}")"
    build::build::test::quiet::die "${ID}" "${image}"
    docker run -it --rm "${image}" "${@}"
    if $TEST; then docker rmi "${image}" >/dev/null; fi
  else
    for i in $(build::id); do
      [[ "${i}" =~ ${EXCLUDE} ]] && continue
      image="$(build::image "${i}")"
      build::build::test::quiet::die "${ID}" "${image}"
      docker run -it --rm "${image}" "${@}"
      $TEST && docker rmi "${image}" >/dev/null
    done
  fi
}
