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
# Globals:
#   ID                ID to build, create, exec or run command (default: all).
#   OUTPUT            show output in plain format even if succesful build.
#   PUSH              Push after build.
#   REPOSITORIES      [Internal]: repositories names.
#   REPOSITORY        [Internal]: repository name (default: rc).
#                     - Format: <repository name>
#                     - Examples: base, rc
#######################################
build::build() {
  local id build container repo tag
  local image output
  for REPOSITORY in "${REPOSITORIES[@]}"; do
    while read -r id build container repo tag; do
      [ "${ID-}" ] && [ "${ID}" != "${id}" ] && continue
      output="/tmp/${id}-build.out"
      # shellcheck disable=SC2086
      if docker build --progress plain ${CACHE} \
        --build-arg repo="${repo}" --build-arg tag="${tag}" --build-arg target="${REPOSITORY}"\
        --file "${DOCKERFILE_PATH}" ${TARGET} --tag "${build}" . &>"${output}"; then
        image="${repo}:${tag}"
        grep -q -E "FROM.*/${image}" "${output}" || die Invalid FROM image in Dockerfile "$(cat "${output}")"
        if $SHOW || [ "${FUNCNAME[1]}" = "build::main" ]; then ok Built: "${build}", from: "${image}" ; fi
        if [ "${FUNCNAME[1]}" = "build::main" ] && $OUTPUT; then cat "${output}"; fi
        if $HUB || $PUSH; then
          output="/tmp/${id}-push.out"
          if docker push "${build}" &>"${output}"; then
            if $SHOW || [ "${FUNCNAME[1]}" = "build::main" ]; then ok Pushed: "${build}" ; fi
          else
            die "$(cat "${output}")"
          fi
        fi
      else
        die "$(cat "${output}")"
      fi
    done < <(build::vars)
  done
}

build::build::test::quiet::die() {
  local containers i
  if $TEST; then
    ID="${1}"
    containers="$(docker ps -a -q  --filter="ancestor=${2}")"  # Gives all containers regardless of the tag.
    for i in ${containers}; do
      if [ "$(docker inspect "${i}" --format "{{.Config.Image}}")" = "${2}" ]; then
        docker rm --force "${i}" &>/dev/null || die docker rm --force "${i}"
      fi
    done
    docker rmi --force "${2}" &>/dev/null || die docker rmi --force "${2}"
    build::build
  elif $SHOW; then
    ok "${2}"
  fi
}

build::clean() {
  local i
  docker container prune --force &>/dev/null
  # shellcheck disable=SC2046
  for i in $(docker ps -q -f status=paused); do
    docker container unpause "${i}" &>/dev/null && docker stop "${i}" &>/dev/null
  done
  for i in $(comm -23 <(docker ps -aq | sort) <(docker ps -q -f status=running | sort)); do \
    docker rm --volumes "${i}"; done
  docker image prune --all --force &>/dev/null
  docker volume prune --force &>/dev/null
  docker network prune --force &>/dev/null
  docker system prune --all --volumes --force &>/dev/null
  docker builder prune --all --force &>/dev/null
  docker system df
}

#######################################
# Create a container with default name if it does not exists.
# Globals:
#   ID                ID to build, create, exec or run command (default: all).
#   REPOSITORY        [Internal]: repository name (default: rc).
#                     - Format: <repository name>
#                     - Examples: base, rc
#######################################
build::create() {
  local image
  local id build container repo tag
  if [ "${ID-}" ]; then
    image="$(build::image "${ID}")"
    container="$(build::vars | grep "^${ID} " | awk '{ print $3 }')"
    build::create::force "${ID}" "${image}" "${container}"
  else
    while read -r id build container repo tag; do
      build::create::force "${id}" "${build}" "${container}"
    done < <(build::vars)
  fi
}

build::create::force() {
  local container create=true
  build::build::test::quiet::die "${1}" "${2}"
  if docker container inspect "${3}" >/dev/null 2>&1; then
    container="$(docker ps -q -f status=running -f name="${3}")"
    if [ "${container-}" ] && ! $TEST && ! $FORCE; then create=false; fi
  fi
  if $create; then
    docker rm --force "${3}" &>/dev/null || true
    docker create -it --name "${3}" "${2}" &>/dev/null
    ok "${3}"
  fi
}

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
# Shows ids.
#######################################
build::id() { build::vars | awk '{ print $1 }'; }

#######################################
# Shows image for id.
#######################################
build::image() { build::vars | grep "^${1:-alpine} " | awk '{ print $2 }'; }

build::out() { echo "/tmp/build-${1}-${2}.out"; }

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


#######################################
# Shows images and containers variables in fields
# Globals:
#   GIT           GitHub and Docker Hub repository owner.
#   IMAGES        <repo owner>|<repo name>|<tag>
#   REPOSITORY    [Internal]: repository name (default: rc).
#                 - Format: <repository name>
#                 - Examples: base, rc
# Locals:
#   enable       '1' if enable, enable field of 'IMAGES'.
#   name          [Base]: image repository name, <repo name> field of 'IMAGES' (default: <repo owner>).
#                 - Format: <repo name>
#                 - Examples: alpine, systemd-ubuntu.
#   owner         [Base]: image repository owner, <repo owner> field of 'IMAGES'.
#                 - Format: <repo name>
#                 - Examples: alpine, systemd-ubuntu.
#   short         [Base]: image shortened tag.
#                 - Format: <tag> (-alpine removed)
#                 - Examples: 3.9
#   stripname     strip from <repo name>, stripname field of 'IMAGES'.
#   striptag      strip from <tag>, striptag field of 'IMAGES'.
# Outputs:
#   id            [Internal] tag (default: alpine)
#                 - Format: 1) <name>-<short>
#                           2) <name> (if tag is latest)
#                           3) <name><short> (for images with 'short' starting with numbers)
#                 - Examples: alpine, systemd-ubuntu, python3.9, bash5.1
#   build         [Internal]: image, default triggers auto build in Docker Hub (default: GIT/rc:alpine).
#                 - Format: <GIT>/<repository>:<id>
#                 - Examples: <GIT>/base:alpine, <GIT>/base:systemd-ubuntu, <GIT>/rc:python3.9
#   container     [Internal]: container name.
#                 - Format: <repository>@<id>
#                 - Examples: base@alpine, rc@systemd-ubuntu, base@python3.9, rc@bash5.1
#   repo          [Base]: image repository, similar to 'DOCKER_REPO' global, $1 of 'images' variable.
#                 - Format: index.docker.io/<repo owner>/<repo name>.
#                 - Examples: alpine, jrei/systemd-ubuntu.
#   tag           [Base]: image tag, similar to 'DOCKER_TAG', <tag> field of 'IMAGES'(default: latest).
#                 - Format: <tag>
#                 - Examples: latest, 3.9-alpine.
#######################################
build::vars() {
  local enable owner name tag stripname striptag
  local id build container repo tag
  local git line sep short suffix

  echo "${IMAGES}" | while read -r line; do
    [ "$(echo "${line}" | awk -F ';' '{ print NF-1 }')" -eq "$(( IMAGES_FIELDS-1 ))" ] \
      || die Incorrect number of fields for: "${line}"
  done

  while IFS=";" read -r enable owner name tag stripname striptag; do
    [ "${enable}" -ne "1" ] && continue
    sep="-"
    suffix=""
    : "${tag:=latest}"
    repo="${owner}${name:+/${name}}"
    short="${tag/${striptag}/}"
    [ "${short-}" ] && [ "${short:0:1}" -eq "${short:0:1}" ] 2>/dev/null && sep=""
    [ "${short}" = "latest" ] || suffix="${sep}${short}"
    name="${name/${stripname}/}"
    id="${name:-${owner}}${suffix}"
    $TEST || git="${GIT}/"
    build="${git}${REPOSITORY}:${id}"
    container="${REPOSITORY}.${id}"
    echo "${id} ${build} ${container} ${repo} ${tag}"
  done <<< "${IMAGES}"
}

build::usage() {
    echo -e "
${Yellow}Usage${Reset}:
  ${Green}./hooks/build${Reset} [build|clean|create|exec|id|image|run|vars] [base|rc] [push] [id, ...] \
[--output] [--show] [--test] ...

${Yellow}Description${Reset}:
  ${Green}Run${Reset} for all, excludes images with ENTRYPOINT/CMD not shell/bash, i.e: bats, python.

  ${Green}Exec${Reset} is executed for all images.

  ${Green}Create${Reset} does not remove existing container unless ${Magenta}--force${Reset} or \
${Magenta}--test${Reset}.

  ${Green}Push${Reset} ${Magenta}--test${Reset} images are never pushed.

  ${Green}Build${Reset} ${Magenta}--output${Reset} to show the output of container after built.

  ${Blue}Output${Reset} is ${Red}not shown${Reset} for ${Green}create${Reset}, ${Green}exec${Reset} and \
${Green}run${Reset} commands unless:
    ${Magenta}--show${Reset}, will prepend a line with the image name or for --test when succesful build.
    ${Magenta}--test${Reset}, if build fails will show the build output from file and die.

  ${Blue}Development tests${Reset} (a new build/no push is run each time the script is called) can be run with:
    ${Magenta}--test${Reset}, and check the output or error code.

  ${Blue}Portability tests${Reset} can be run for all images using:
    ${Magenta}--show${Reset}, to see what image is producing which output.

${Yellow}Invalid${Reset}:
  $(ok ./hooks/build --target= --dry-run)
  $(ok ./hooks/build --target="foo" --dry-run)
  $(ok ./hooks/build "${Green}build${Reset}" -python3.99)
  $(ok ./hooks/build "${Green}build${Reset}" python3.99)
  $(ok ./hooks/build "${Green}build${Reset}" --id=python3.99)
  $(ok ./hooks/build "${Green}build${Reset}" --repo=foo)
  $(ok ./hooks/build "${Green}build${Reset}" "${Green}run${Reset}")
  $(ok ./hooks/build "${Green}exec${Reset}" --id=python3.10 ls)
  $(ok ./hooks/build "${Green}exec${Reset}")
  $(ok ./hooks/build "${Green}exec${Reset}" --)
  $(ok ./hooks/build "${Green}run${Reset}" --dry-run)
  $(ok ./hooks/build "${Green}run${Reset}" --dry-run --)
  $(ok ./hooks/build "${Green}run${Reset}" --dry-run -- ls)

${Yellow}Examples${Reset}:
  $(inf [Docker Hub]: build and push)
  $(inf [Local]: help)
  $(ok ./hooks/build)

  $(inf Build \(default: rc\))
  $(ok ./hooks/build "${Green}build${Reset}")
  $(inf Build python3.9 with new test build and show build output \(default: rc\))
  $(ok ./hooks/build "${Green}build${Reset}" --id=python3.10 --no-cache --output --test)
  $(inf Build with new test build \(default: rc\))
  $(ok ./hooks/build "${Green}build${Reset}" --test)
  $(inf Build ID \(default: rc\))
  $(ok ./hooks/build "${Green}build${Reset}" --id=alpine)
  $(inf Build ID and push \(default: rc\))
  $(ok ./hooks/build "${Green}build${Reset}" --id=alpine --push)
  $(inf Build ID with test suffix \(default: rc\))
  $(ok ./hooks/build "${Green}build${Reset}" --id=alpine --test)
  $(inf Build for 'base' repository)
  $(ok ./hooks/build "${Green}build${Reset}" --repo=base)
  $(inf Build and push \(default: rc\))
  $(ok ./hooks/build "${Green}build${Reset}" --push)
  $(inf Build and push for 'base' repository)
  $(ok ./hooks/build "${Green}build${Reset}" --push --repo=base)

  $(inf Clean removes all but running containers)
  $(ok ./hooks/build "${Green}clean${Reset}")

  $(inf Create \(default: rc\))
  $(ok ./hooks/build "${Green}create${Reset}")
  $(inf Create and force removing running containers \(default: rc\))
  $(ok ./hooks/build "${Green}create${Reset}" --force)
  $(inf Create with new test build \(default: rc\))
  $(ok ./hooks/build "${Green}create${Reset}" --test)
  $(inf Create alpine container \(default: rc\))
  $(ok ./hooks/build "${Green}create${Reset}" --id=alpine)
  $(inf Create alpine container and force removing running existing container \(default: rc\))
  $(ok ./hooks/build "${Green}create${Reset}" --id=alpine --force)
  $(inf Create alpine container with new test build \(default: rc\))
  $(ok ./hooks/build "${Green}create${Reset}" --id=alpine --test)
  $(inf Create for 'base' repository)
  $(ok ./hooks/build "${Green}create${Reset}" --repo=base)
  $(inf Create and force removing running containers for 'base' repository)
  $(ok ./hooks/build "${Green}create${Reset}" --repo=base --force)
  $(inf Create with new test build for 'base' repository)
  $(ok ./hooks/build "${Green}create${Reset}" --repo=base --test)
  $(inf Create alpine container for 'base' repository)
  $(ok ./hooks/build "${Green}create${Reset}" --repo=base --id=alpine)
  $(inf Create alpine container and force removing running existing container for 'base' repository)
  $(ok ./hooks/build "${Green}create${Reset}" --repo=base --id=alpine --force)
  $(inf Create alpine container with new test build for 'base' repository)
  $(ok ./hooks/build "${Green}create${Reset}" --repo=base --id=alpine --test)

  $(inf Exec command \(all\) for 'rc' repository)
  $(ok ./hooks/build "${Green}exec${Reset}" -- whoami)
  $(inf Exec command with new test build \(all\) for 'rc' repository)
  $(ok ./hooks/build "${Green}exec${Reset}" --test -- whoami)
  $(inf Exec command \(all\) and add image name to output for 'rc' repository)
  $(ok ./hooks/build "${Green}exec${Reset}" --show -- whoami)
  $(inf Exec command with new test build \(all\) and add image name to output for 'rc' repository)
  $(ok ./hooks/build "${Green}exec${Reset}" --show --test -- whoami)
  $(inf Exec command \(id\) for 'rc' repository)
  $(ok ./hooks/build "${Green}exec${Reset}" --id=alpine -- whoami)
  $(inf Exec command with new test build \(id\) and add image name to output  for 'rc' repository)
  $(ok ./hooks/build "${Green}exec${Reset}" --test --id=alpine -- whoami)
  $(inf Exec command \(id\) and add image name to output  for 'rc' repository)
  $(ok ./hooks/build "${Green}exec${Reset}" --show --id=alpine -- whoami)
  $(inf Exec command with new test build \(id\) and add image name to output  for 'rc' repository)
  $(ok ./hooks/build "${Green}exec${Reset}" --show --test --id=alpine -- whoami)
  $(inf Exec command \(all\) for 'base' repository)
  $(ok ./hooks/build "${Green}exec${Reset}" --repo=base -- whoami)
  $(inf Exec command \(all\) and add image name to output for 'base' repository)
  $(ok ./hooks/build "${Green}exec${Reset}" --repo=base --show -- whoami)
  $(inf Exec command \(id\) for 'base' repository)
  $(ok ./hooks/build "${Green}exec${Reset}" --repo=base --id=alpine -- whoami)
  $(inf Exec command \(id\) and add image name to output  for 'base' repository)
  $(ok ./hooks/build "${Green}exec${Reset}" --repo=base --show --id=alpine -- whoami)

  $(inf IDs)
  $(ok ./hooks/build "${Green}id${Reset}")

  $(inf Image for 'alpine' \(default: rc\))
  $(ok ./hooks/build "${Green}image${Reset}")
  $(inf Image for id \(default: rc\))
  $(ok ./hooks/build "${Green}image${Reset}" --id=python3.9)
  $(inf Image for id for 'base' repository)
  $(ok ./hooks/build "${Green}image${Reset}" --repo=base --id=python3.9)

  $(inf Run command \(all\) for 'rc' repository)
  $(ok ./hooks/build "${Green}run${Reset}" -- whoami)
  $(inf Run command --dry-run \(all\) for 'rc' repository and all IDs)
  $(ok ./hooks/build "${Green}run${Reset}" --dry-run -- ls)
  $(inf Run command with new test build \(all\) for 'rc' repository)
  $(ok ./hooks/build "${Green}run${Reset}" --test -- whoami)
  $(inf Run command \(all\) and add image name to output for 'rc' repository)
  $(ok ./hooks/build "${Green}run${Reset}" --show -- whoami)
  $(inf Run command with new test build \(all\) and add image name to output for 'rc' repository)
  $(ok ./hooks/build "${Green}run${Reset}" --show --test -- whoami)
  $(inf Run command \(id\) for 'rc' repository)
  $(ok ./hooks/build "${Green}run${Reset}" --id=alpine -- whoami)
  $(inf Run command with new test build \(id\) for 'rc' repository)
  $(ok ./hooks/build "${Green}run${Reset}" --test --id=alpine -- whoami)
  $(inf Run command \(id\) and add image name to output  for 'rc' repository)
  $(ok ./hooks/build "${Green}run${Reset}" --show --id=alpine -- whoami)
  $(inf Run command with new test build  \(id\) and add image name to output  for 'rc' repository)
  $(ok ./hooks/build "${Green}run${Reset}" --show --test --id=alpine -- whoami)
  $(inf Run command \(all\) for 'base' repository)
  $(ok ./hooks/build "${Green}run${Reset}" --repo=base -- whoami)
  $(inf Run command \(all\) and add image name to output for 'base' repository)
  $(ok ./hooks/build "${Green}run${Reset}" --repo=base --show -- whoami)
  $(inf Run command \(id\) for 'base' repository)
  $(ok ./hooks/build "${Green}run${Reset}" --repo=base --id=alpine -- whoami)
  $(inf Run command \(id\) and add image name to output  for 'base' repository)
  $(ok ./hooks/build "${Green}run${Reset}" --repo=base --show --id=alpine -- whoami)

  $(inf Variables \(default: rc\))
  $(ok ./hooks/build "${Green}vars${Reset}")
  $(inf Variables for testing \(default: rc\))
  $(ok ./hooks/build "${Green}vars${Reset}" --test)
  $(inf Variables for 'base' repository)
  $(ok ./hooks/build "${Green}vars${Reset}" --repo=base)
"
}

#######################################
# Main function
# Globals:
#   EXCLUDE           Excluded IDs when doing 'docker run' for all (not shell CMD/ENTRYPOINT).
#   FORCE             Force creation of container, default true for --test.
#   OUTPUT            show output in plain format even if succesful build.
#   PUSH              Push after build.
#   REPOSITORIES      [Internal]: repositories names.
#   SHOW              Show image id for exec and run.
#   TARGET            Build target.
#   TARGETS           targets.
#   TEST_ADD          Prefix or suffix to add for test images.
#######################################
# shellcheck disable=SC2086
build::main() {
  local dry=false func  msg="argument"
  export REPOSITORIES=("base")
  export EXCLUDE="^bats|^python"  ID PUSH=false
  export FORCE=false CACHE OUTPUT=false SHOW=false TARGET TARGETS
  if [ "${DOCKERFILE_PATH-}" ]; then
    :
  else
    TARGETS="$(awk '! /^#/ && / AS / || / as / { print $4 }' "${DOCKERFILE_PATH}")"
    [ ! "${1-}" ] && build::usage && exit
    for arg; do
      if $finish; then
        args+=("${arg}")
        continue
      fi
      case "${arg}" in
        --dry-run) dry=true ;;
        --force) FORCE=true ;;
        --id=*)
          ID="${arg/--id=/}"
          echo "${ids}" | grep -q "${ID}" || die Invalid ID: "${ID}"
          ;;
        --no-cache) CACHE="${arg}" ;;
        --output) OUTPUT=true ;;
        --push) PUSH=true ;;
        --show) SHOW=true ;;
        --target=*)
          TARGET="${arg/--target=/}"
          [ "${TARGET-}" ] || die Empty target provided
          [ "${TARGETS-}" ] || die No targets in Dockerfile and target provided: "${TARGET}"
          echo "${TARGETS}" | grep -q "${TARGET}" || die Invalid target: "${TARGET}"
          TARGET="--target ${TARGET}"
          ;;
        --) finish=true ;;
        base|build|clean|create|exec|id|image|run|vars)
          if ! $finish; then
            [ ! "${func-}" ] || die Two commands provided: "${arg}" and "${1}"
            [ "${arg}" != "base" ] || BASE=true
            func="build::${arg}"
          fi
          ;;
        *)
          [ "${arg:0:1}" = "-" ] || msg="command"
          false || die Invalid "${msg}": "${arg}"
          ;;
      esac
    done

    if [[ "${func/build::/}" =~ ^exec$|^run$ ]]; then
      if ! $finish; then
        false || die Arguments passed to "${func/build::/}" must be separated with: --, i.e.: build run -- ls
      else
        [ "${args-}" ] || die Not arguments provided to "${func/build::/}"
      fi
    fi

    if $BASE; then
      PUSH=false
      if [ "${REPOSITORY}" = "base" ]; then
        TEST=false
      else
        REPOSITORY="${REPOSITORY}-test"
      fi
     :
    fi
    : "${REPOSITORY:=${REPOSITORIES[0]}}"

    if $TEST; then
      PUSH=false
      if [ "${REPOSITORY}" = "base" ]; then
        TEST=false
      else
        REPOSITORY="${REPOSITORY}-test"
      fi
    fi

    REPOSITORIES=("${REPOSITORY}")

    if [ "${func-}" ]; then
      if $dry; then
        inf CACHE: "${CACHE}"
        inf DOCKERFILE_PATH: "${DOCKERFILE_PATH}"
        inf ID: "${ID}"
        inf EXCLUDE: "${EXCLUDE}"
        inf FORCE: "${FORCE}"
        inf HUB: "${HUB}"
        inf PROGRESS: "${PROGRESS}"
        inf PUSH: "${PUSH}"
        inf REPOSITORIES: "${REPOSITORIES[@]}"
        inf REPOSITORY: "${REPOSITORY}"
        inf SHOW: "${SHOW}"
        inf TARGET: "${TARGET}"
        inf TARGETS: ${TARGETS}
        inf TEST: "${TEST}"
        die "${func/build::/}" "${args[@]}"
      fi
      ${func} "${args[@]}"
    fi
  fi
}

build::main "${@}"
