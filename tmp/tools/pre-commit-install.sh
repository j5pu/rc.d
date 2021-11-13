#!/usr/bin/env bash

[ -x "${0}" ] || chmod +x "${0}"
pre-commit autoupdate
pre-commit install --install-hooks --overwrite --allow-missing-config -t pre-commit -t post-commit -t pre-push
