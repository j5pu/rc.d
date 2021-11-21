# shellcheck shell=sh

has "$(basename "${0}" .lib)" || exit

if $MACOS; then
  Host="unix://${HOME}/.run/docker.sock"
  Name="desktop-linux"
  scan="/Applications/Docker.app/Contents/Resources/snyk/docker/snyk-mac.sh"
else
# TODO: ver como se instala en LINUX y ver si hay mas paths que se usan en docker para poner variable.
#  poner --force y la opción de cuantas hay
  scan=""
fi

if $MACOS; then
  name="mini"
  host="ssh://${name}.com"
  config=$(cat<<EOF
{
  "Name": "${name}",
  "Metadata": {},
  "Endpoints": {
    "docker": {
      "Host": "${host}",
      "SkipTLSVerify": false
    }
  }
}
EOF
  )
  id="43385991f0be5fed6db7fb640c5f510d41bcaac6ecca6c842a0c2a2d2d2bf510"
  tofile "${config}" "${DOCKER_CONFIG}/context/meta/${id}/meta.json"
fi

config=$(cat<<EOF
{
  "Name": "${Name}",
  "Metadata": {},
  "Endpoints": {
    "docker": {
      "Host": "${Host}",
      "SkipTLSVerify": false
    }
  }
}
EOF
)
id="fe9c6bd7a66301f49ca9b6a70b217107cd1284598bfc254700c989b916da791e"
tofile "${config}" "${DOCKER_CONFIG}/context/meta/${id}/meta.json"

config=$(cat<<EOF
[
]
EOF
)
tofile "${config}" "${DOCKER_CONFIG}/devenvironments/data.json"

config=$(cat<<EOF
{
  "path": "${scan}",
  "optin": true
}
EOF
)
tofile "${config}" "${DOCKER_CONFIG}/scan/config.json"

config=$(cat<<EOF
{
  "${GIT}": "${DOCKER_SYNC_TOKEN}"
}
EOF
)
tofile "${config}" "${DOCKER_CONFIG}/scan/tokens.json"

config=$(cat<<EOF
{
  "compose-versions": {
    "v2.0.0-rc.1": {
      "active-percentage": 0.5,
      "include-pro-users": false,
      "default": 0.00
    }
  }
}

EOF
)
tofile "${config}" "${DOCKER_CONFIG}/canary.json"

config=$(cat<<EOF
{
  "auths": {
    "ghcr.io": {
      "auth": "${GHCR_IO_TOKEN}"
    },
    "https://index.docker.io/v1/": {
      "auth": "${DOCKER_HUB_TOKEN}"
    }
  },
  "credHelpers": {
    "asia.gcr.io": "gcloud",
    "eu.gcr.io": "gcloud",
    "gcr.io": "gcloud",
    "marketplace.gcr.io": "gcloud",
    "staging-k8s.gcr.io": "gcloud",
    "us.gcr.io": "gcloud"
  },
  "currentContext": "$(docker context show)",
  "aliases": {
    "builder": "buildx"
  }
}

EOF
)
tofile "${config}" "${DOCKER_CONFIG}/config.json"

config=$(cat<<EOF
{
  "builder": {
    "gc": {
      "enabled": true,
      "defaultKeepStorage": "20GB"
    }
  },
  "experimental": true,
  "features": {
    "buildkit": true
  }
}
EOF
)
tofile "${config}" "${DOCKER_CONFIG}/daemon.json"

config=$(cat<<EOF
{
  "composeV2": "enabled"
}
EOF
)
tofile "${config}" "${DOCKER_CONFIG}/features.json"

unset config darwin Host host id Name name scan

