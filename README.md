# rc

## pre-commit 
After clone 
````bash
pre-commit install --install-hooks -t pre-commit -t post-commit -t pre-push
````

## docker auto build

### Private repos
```bash
ssh-keygen -t rsa -C "rc@docker.com" -f ~/.ssh/rc.docker
ssh-keygen -t ed25519 -C "rc@docker.com"
```
* enter public key in repository.
* enter SSH_PRIVATE in environment docker hub 

### Other tags 
```Dockerfile
FROM alpine:edge  as base
#FROM alpine:latest (3, 3.14) as base
FROM alpine:3.13 as base
FROM alpine:3.12 as base
FROM archlinux:base-devel as base
FROM bash:devel as base
#FROM centos:latest (8) as base
FROM centos:7 as base
FROM debian:bookworm as base
FROM debian:bookworm-backports as base
FROM debian:bookworm-slim as base
#FROM debian:latest (bullseye) as base
FROM debian:buster as base
FROM debian:buster-backports as base
FROM debian:buster-slim as base
FROM fedora:36 as base
#FROM fedora:latest (35) as base
FROM fedora:34 as base
#FROM jrei/systemd-ubuntu:latest (20.04 - focal) as base
FROM jrei/systemd-ubuntu:focal as base
FROM jrei/systemd-ubuntu:bionic as base
#FROM kalilinux/kali-rolling:latest (armhf, arm64, amd64) as base
#FROM apt -y install <package|kali-linux-headless|kali-linux-large> as base
#FROM 22.04, jammy, devel as base
FROM ubuntu:22.04 as base
#FROM 21.10, impish, rolling as base
FROM ubuntu:21.10 as base
#FROM 21.04, hirsute as base
FROM ubuntu:21.04 as base
#FROM ubuntu:latest (20.04, focal) as base
#FROM 16.04, xenial as base
FROM ubuntu:16.04 as base
#FROM 18.04, bionic as base
FROM ubuntu:18.04 as base
```

### 
