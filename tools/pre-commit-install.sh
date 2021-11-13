#!/usr/bin/env bash

pre-commit autoupdate
pre-commit install --install-hooks --overwrite --allow-missing-config -t pre-commit -t post-commit -t pre-push
