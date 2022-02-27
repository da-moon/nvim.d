# syntax = docker/dockerfile:labs
# vim: filetype=dockerfile softtabstop=2 tabstop=2 shiftwidth=2 fileencoding=utf-8 expandtab
# ────────────────────────────────────────────────────────────────────────────────

#
# ──────────────────────────────────────────────────────────────────────────────────────────────────────────────────── I ──────────
#   :::::: B A S E   L A Y E R   F O R   B U I L D I N G   G O   A P P L I C A T I O N : :  :   :    :     :        :          :
# ──────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────
#
FROM golang:alpine AS go-builder
SHELL ["/bin/ash", "-o", "pipefail", "-c"]
USER "root"
RUN   ( \
  echo "http://dl-cdn.alpinelinux.org/alpine/edge/main" ; \
  echo "http://dl-cdn.alpinelinux.org/alpine/edge/community" ; \
  echo "http://dl-cdn.alpinelinux.org/alpine/edge/testing" ; \
  echo "http://dl-cdn.alpinelinux.org/alpine/v3.14/main" ; \
  echo "http://dl-cdn.alpinelinux.org/alpine/v3.14/community" ; \
  echo "http://dl-cdn.alpinelinux.org/alpine/v3.13/main" ; \
  echo "http://dl-cdn.alpinelinux.org/alpine/v3.13/community" ; \
  ) | tee "/etc/apk/repositories" > /dev/null  \
  && apk add --no-cache "bash~=5.1" "ca-certificates" \
  || ( \
  sed -i -e 's/dl-cdn/dl-4/g' /etc/apk/repositories \
  && apk add --no-cache "bash~=5.1" "ca-certificates" \
  )
# ────────────────────────────────────────────────────────────────────────────────
SHELL ["/bin/bash", "-o", "pipefail", "-c"]
# ────────────────────────────────────────────────────────────────────────────────
RUN  \
apk add --no-cache \
  "build-base~=0.5" \
  "cmake~=3" \
  "coreutils~=9" \
  "curl~=7" \
  "git~=2" \
  "findutils~=4" \
  "make~=4" \
  "util-linux~=2" \
  "wget~=1"

ENV GO111MODULE="on"
ENV CGO_ENABLED="0"
ENV CGO_LDFLAGS="-s -w -extldflags '-static'"
#
# ────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────── II ──────────
#   :::::: B A S E   L A Y E R   F O R   B U I L D I N G   R U S T   A P P L I C A T I O N S : :  :   :    :     :        :          :
# ────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────
#
FROM alpine:edge AS rust-builder
# ────────────────────────────────────────────────────────────────────────────────
SHELL ["/bin/ash", "-o", "pipefail", "-c"]
# ────────────────────────────────────────────────────────────────────────────────
USER root
RUN   ( \
  echo "http://dl-cdn.alpinelinux.org/alpine/edge/main" ; \
  echo "http://dl-cdn.alpinelinux.org/alpine/edge/community" ; \
  echo "http://dl-cdn.alpinelinux.org/alpine/edge/testing" ; \
  echo "http://dl-cdn.alpinelinux.org/alpine/v3.14/main" ; \
  echo "http://dl-cdn.alpinelinux.org/alpine/v3.14/community" ; \
  echo "http://dl-cdn.alpinelinux.org/alpine/v3.13/main" ; \
  echo "http://dl-cdn.alpinelinux.org/alpine/v3.13/community" ; \
  ) | tee "/etc/apk/repositories" > /dev/null  \
  && apk add --no-cache "bash~=5.1" "ca-certificates" \
  || ( \
  sed -i -e 's/dl-cdn/dl-4/g' /etc/apk/repositories \
  && apk add --no-cache "bash~=5.1" "ca-certificates" \
  )
# ────────────────────────────────────────────────────────────────────────────────
SHELL ["/bin/bash", "-o", "pipefail", "-c"]
# ────────────────────────────────────────────────────────────────────────────────
RUN \
apk add --no-cache \
  "build-base~=0.5" \
  "cmake~=3" \
  "coreutils~=9" \
  "curl~=7" \
  "gcc~=10" \
  "git~=2" \
  "libgit2-static~=1" \
  "make~=4" \
  "musl-dev~=1" \
  "ncurses-static~=6" \
  "openssl-dev~=1" \
  "openssl-libs-static~=1"
# ────────────────────────────────────────────────────────────────────────────────
ARG RUST_VERSION="1.58.0"
ARG RUSTUP_URL="https://sh.rustup.rs"
ENV RUSTUP_HOME="/usr/local/rustup"
ENV CARGO_HOME="/usr/local/cargo"
ENV PATH="${CARGO_HOME}/bin:${PATH}"
ENV RUST_VERSION "${RUST_VERSION}"
RUN \
  --mount=type=cache,id=rust-builder-cargo-registry-index,sharing=shared,mode=0777,target=/usr/local/cargo/registry/index \
	--mount=type=cache,id=rust-builder-cargo-registry-cache,sharing=shared,mode=0777,target=/usr/local/cargo/registry/cache \
	--mount=type=cache,id=rust-builder-cargo-git-db,sharing=shared,mode=0777,target=/usr/local/cargo/git/db \
  case "$(apk --print-arch)" in \
  x86_64 | aarch64) \
  true \
  ;; \
  *) \
  exit 1 \
  ;; \
  esac; \
  curl --proto '=https' --tlsv1.2 -fSsl "${RUSTUP_URL}" | bash -s -- -y \
  --no-modify-path \
  --profile minimal \
  --default-toolchain "${RUST_VERSION}" \
  --default-host "$(apk --print-arch)-unknown-linux-musl" \
  && chmod -R a+w "${RUSTUP_HOME}" "${CARGO_HOME}" \
  && rustup --version \
  && cargo --version \
  && rustc --version \
  && rustup toolchain install "nightly-$(apk --print-arch)-unknown-linux-musl" \
  && cargo search sccache
COPY <<-"EOT" /usr/local/cargo/config
[target.x86_64-unknown-linux-musl]
  rustflags = ["-C", "target-feature=+crt-static"]
[target.aarch64-unknown-linux-musl]
  rustflags = ["-C", "target-feature=+crt-static"]
[target.armv7-unknown-linux-musleabihf]
  linker = "arm-linux-gnueabihf-gcc"
[build]
  incremental = true
EOT
ENV OPENSSL_STATIC=yes
ENV OPENSSL_LIB_DIR="/usr/lib"
ENV OPENSSL_INCLUDE_DIR="/usr/include"
WORKDIR "/workspace"
#
# ──────────────────────────────────────────────────────────────────────────────────────────── I ──────────
#   :::::: B A S E   L A Y E R   F O R   F I N A L   L A Y E R : :  :   :    :     :        :          :
# ──────────────────────────────────────────────────────────────────────────────────────────────────────
#
# This layer is for speeding up builds for packages that get installed from AUR
# as every AUR package is built in parallel in a separate layer drived from this layer
FROM archlinux:base as base
SHELL ["/bin/bash", "-o", "pipefail", "-c"]
USER "root"
ENV USER="vscode"
ENV UID="1000"
ENV HOME="/home/${USER}"
#  ╭──────────────────────────────────────────────────────────╮
#  │                      initial setup                       │
#  ╰──────────────────────────────────────────────────────────╯
# hadolint ignore=SC2016
RUN \
# ─── INITIALIZE PACMAN ──────────────────────────────────────────────────────────
pacman-key --init \
&& pacman-key --populate archlinux \
&& pacman -Syyu --noconfirm \
# ─── DOWNLOAD SIXTEEN PACKAGES CONCURRENTLY ─────────────────────────────────────
&& sed -i \
  -e "/ParallelDownloads/d" \
  -e  '/\[options\]/a ParallelDownloads = 16' \
"/etc/pacman.conf" \
# ─── USE PACMAN AVATAR FOR SHOWING PROGRESS ─────────────────────────────────────
&& sed -i \
  -e "/Color/d" \
  -e "/ILoveCandy/d" \
  -e '/\[options\]/a Color' \
  -e '/\[options\]/a ILoveCandy' \
"/etc/pacman.conf" \
&& pacman -Sy --noconfirm --needed \
  "openssl" \
  "reflector" \
  "sudo" \
  "base-devel" \
  "git" \
# ─── FINDING FASTEST SOURCES ────────────────────────────────────────────────────
&& reflector \
  --verbose \
  -p https \
  --latest 5 \
  --sort rate \
  --save "/etc/pacman.d/mirrorlist" \
# ─── USER CREATION ──────────────────────────────────────────────────────────────
&& ! getent group "${USER}" > /dev/null \
&& groupadd --gid "${UID}" "${USER}" > /dev/null > /dev/null \
&& useradd \
  --no-log-init \
  --create-home \
  --home-dir "${HOME}" \
  --gid "${UID}" \
  --uid "${UID}" \
  --shell "/bin/bash" \
  # ─── USER PASSWORD IS THE SAME AS THE USERNAME ──────────────────────────────────
  --password \
  "$(openssl passwd -1 -salt SaltSalt '${USER}' 2>/dev/null)" \
  "${USER}" \
# ─── CREATE SUDO GROUP ID IT DOES NOT EXIST ─────────────────────────────────────
&& ! getent group sudo > /dev/null && groupadd sudo \
# ─── ALLOW PASSWORDLESS SUDO FOR USERS BELONGING TO WHELL GROUP ─────────────────
&& sed -i \
  -e '/%wheel.*NOPASSWD:\s*ALL/d' \
  -e '/%wheel\s\+ALL=(ALL\(:ALL\)\?)\s\+ALL/d' \
"/etc/sudoers" \
&& ( \
echo "%wheel ALL=(ALL) ALL" ; \
echo "%wheel ALL=(ALL) NOPASSWD: ALL" ; \
) | tee -a "/etc/sudoers" > /dev/null  \
# ─── UPDATE USER GROUP MEMBERSHIP ───────────────────────────────────────────────
&& usermod -aG wheel,root,sudo "${USER}" \
# ─── ENSURE USER HOME HAS THE RIGHT OWNERSHIP ───────────────────────────────────
&& chown "$(id -u "${USER}"):$(id -g "${USER}")" "${HOME}" -R \
# ─── CLEANUP PACMAN PACKAGE CACHE ───────────────────────────────────────────────
&& find "/var/cache/pacman/pkg" -type f -delete
#  ╭──────────────────────────────────────────────────────────╮
#  │                           rust                           │
#  ╰──────────────────────────────────────────────────────────╯
USER "root"
ENV CARGO_HOME="${HOME}/.cargo"
ENV PATH="${CARGO_HOME}/bin:${PATH}"
RUN \
pacman -Sy --noconfirm --needed \
  "rustup" \
# ─── CLEANUP PACMAN PACKAGE CACHE ───────────────────────────────────────────────
&& find "/var/cache/pacman/pkg" -type f -delete ;
#  ╭──────────────────────────────────────────────────────────╮
#  │                     python packages                      │
#  ╰──────────────────────────────────────────────────────────╯
USER "root"
ENV PATH="${PATH}:${HOME}/.local/bin"
RUN \
pacman -Sy --noconfirm --needed \
  "python" \
  "python-pip" \
  "python-setuptools" \
  "python-pre-commit" \
# ─── CLEANUP PACMAN PACKAGE CACHE ───────────────────────────────────────────────
&& find "/var/cache/pacman/pkg" -type f -delete ;
#  ────────────────────────────────────────────────────────────
ENV PATH="${PATH}:${HOME}/.luarocks/bin"
RUN \
pacman -Sy --noconfirm --needed \
  "lua" \
  "luajit" \
  "luarocks" \
# ─── CLEANUP PACMAN PACKAGE CACHE ───────────────────────────────────────────────
&& find "/var/cache/pacman/pkg" -type f -delete ;
#  ────────────────────────────────────────────────────────────
ENV PATH="${PATH}:${HOME}/go/bin"
RUN \
pacman -Sy --noconfirm --needed \
  "go" \
# ─── CLEANUP PACMAN PACKAGE CACHE ───────────────────────────────────────────────
&& find "/var/cache/pacman/pkg" -type f -delete ;

#  ╭──────────────────────────────────────────────────────────╮
#  │                 install nodejs packages                  │
#  ╰──────────────────────────────────────────────────────────╯
USER "root"
RUN \
pacman -Sy --noconfirm --needed \
  "nodejs" \
  "yarn" \
# ─── CLEANUP PACMAN PACKAGE CACHE ───────────────────────────────────────────────
&& find "/var/cache/pacman/pkg" -type f -delete ;

#
# ──────────────────────────────────────────────────────────────────────────────────────────────────────────────────── III ──────────
#   :::::: B U I L D I N G   T O O L S   F R O M   S O U R C E   I N   P A R A L L E L : :  :   :    :     :        :          :
# ──────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────
#

#  ╭──────────────────────────────────────────────────────────╮
#  │           this layer is used for building gosu           │
#  ╰──────────────────────────────────────────────────────────╯
FROM go-builder AS gosu-builder
ARG GOSU_BRANCH="master"
RUN \
  set -xeu ; \
  git clone \
  --depth 1 \
  --branch "${GOSU_BRANCH}" \
  "https://github.com/tianon/gosu.git" \
  "/workspace"
WORKDIR "/workspace"
RUN \
  --mount=type=cache,id=gosu-build,target="/root/.cache/go-build" \
  --mount=type=cache,id=gosu-mod,target="/go/pkg/mod" \
  --mount=type=tmpfs,target="/go/src/" \
  set -xeu ; \
  git fetch --all --tags && \
  git checkout \
  "$(git describe --tags $(git rev-list --tags --max-count=1))"  && \
  go mod tidy && \
  go build -o "/go/bin/gosu" "./"
#  ╭──────────────────────────────────────────────────────────╮
#  │                  this layer builds vale                  │
#  ╰──────────────────────────────────────────────────────────╯
FROM go-builder AS vale-builder
ARG VALE_BRANCH="v2"
RUN \
  set -xeu ; \
  git clone \
  --depth 1 \
  --branch "${VALE_BRANCH}" \
  "https://github.com/errata-ai/vale.git" \
  "/workspace"
WORKDIR "/workspace"
RUN \
  --mount=type=cache,id=vale-build,target="/root/.cache/go-build" \
  --mount=type=cache,id=vale-mod,target="/go/pkg/mod" \
  --mount=type=tmpfs,target="/go/src/" \
  set -xeu ; \
  git fetch --all --tags && \
  git checkout \
  "$(git describe --tags $(git rev-list --tags --max-count=1))"  && \
  go mod tidy && \
  make build && \
  mv "bin/vale" "/go/bin/vale"
#  ╭──────────────────────────────────────────────────────────╮
#  │           this layer builds selene from source           │
#  ╰──────────────────────────────────────────────────────────╯
# selene is a lua lintere
FROM rust-builder AS selene-builder
RUN \
  --mount=type=cache,id=selene-cargo-registry-index,sharing=shared,mode=0777,target=/usr/local/cargo/registry/index \
	--mount=type=cache,id=selene-cargo-registry-cache,sharing=shared,mode=0777,target=/usr/local/cargo/registry/cache \
	--mount=type=cache,id=selene-cargo-git-db,sharing=shared,mode=0777,target=/usr/local/cargo/git/db \
  export apkArch="$(apk --print-arch)" ; \
  case "${apkArch}" in \
  x86_64 | aarch64) \
  true \
  ;; \
  *) \
  exit 1 \
  ;; \
  esac; \
  cargo install \
    --all-features \
    --root "/workspace" \
    --target "${apkArch}-unknown-linux-musl" \
    --branch "main" \
    --git "https://github.com/Kampfkarren/selene" ;
# this layer builds stylua from source
FROM rust-builder AS stylua-builder
RUN \
  --mount=type=cache,id=stylua-cargo-registry-index,sharing=shared,mode=0777,target=/usr/local/cargo/registry/index \
	--mount=type=cache,id=stylua-cargo-registry-cache,sharing=shared,mode=0777,target=/usr/local/cargo/registry/cache \
	--mount=type=cache,id=stylua-cargo-git-db,sharing=shared,mode=0777,target=/usr/local/cargo/git/db \
  export apkArch="$(apk --print-arch)" ; \
  case "${apkArch}" in \
  x86_64 | aarch64) \
  true \
  ;; \
  *) \
  exit 1 \
  ;; \
  esac; \
  cargo install \
    --root "/workspace" \
    --target "${apkArch}-unknown-linux-musl" \
    "stylua"
#  ╭──────────────────────────────────────────────────────────╮
#  │            this layer builds ttdl from source            │
#  ╰──────────────────────────────────────────────────────────╯
# ttdl is used for working with 'todo.txt'
FROM rust-builder AS ttdl-builder
RUN \
  --mount=type=cache,id=ttdl-cargo-registry-index,sharing=shared,mode=0777,target=/usr/local/cargo/registry/index \
	--mount=type=cache,id=ttdl-cargo-registry-cache,sharing=shared,mode=0777,target=/usr/local/cargo/registry/cache \
	--mount=type=cache,id=ttdl-cargo-git-db,sharing=shared,mode=0777,target=/usr/local/cargo/git/db \
  export apkArch="$(apk --print-arch)" ; \
  case "${apkArch}" in \
  x86_64 | aarch64) \
  true \
  ;; \
  *) \
  exit 1 \
  ;; \
  esac; \
  cargo install \
    --all-features \
    --root "/workspace" \
    --target "${apkArch}-unknown-linux-musl" \
    "ttdl" ;
#  ╭──────────────────────────────────────────────────────────╮
#  │          this layer builds jujutsu from source           │
#  ╰──────────────────────────────────────────────────────────╯
# jujutsu is an experimental , better git client
FROM rust-builder AS jujutsu-builder
RUN \
  --mount=type=cache,id=jujutsu-cargo-registry-index,sharing=shared,mode=0777,target=/usr/local/cargo/registry/index \
	--mount=type=cache,id=jujutsu-cargo-registry-cache,sharing=shared,mode=0777,target=/usr/local/cargo/registry/cache \
	--mount=type=cache,id=jujutsu-cargo-git-db,sharing=shared,mode=0777,target=/usr/local/cargo/git/db \
  export apkArch="$(apk --print-arch)" ; \
  case "${apkArch}" in \
  x86_64 | aarch64) \
  true \
  ;; \
  *) \
  exit 1 \
  ;; \
  esac; \
  rustup run --install nightly cargo install \
    --all-features \
    --root "/workspace" \
    --target "${apkArch}-unknown-linux-musl" \
    --git "https://github.com/martinvonz/jj.git"
#  ╭──────────────────────────────────────────────────────────╮
#  │           this layer builds convco from source           │
#  ╰──────────────────────────────────────────────────────────╯
# convco helps with git tagging, commits and
# changelog generation
# Building convco in Alpine fails, thus we are building it in ArchLinux image
FROM base AS convco-builder
USER root
ENV CARGO_HOME="/usr/local/cargo"
RUN \
  --mount=type=cache,id=convco-cargo-registry-index,sharing=shared,mode=0777,target=/usr/local/cargo/registry/index \
	--mount=type=cache,id=convco-cargo-registry-cache,sharing=shared,mode=0777,target=/usr/local/cargo/registry/cache \
	--mount=type=cache,id=convco-cargo-git-db,sharing=shared,mode=0777,target=/usr/local/cargo/git/db \
mkdir "/workspace" \
&& pacman -S --noconfirm --asdeps "cmake" ; \
MAKEFLAGS="-j$(nproc)" ; \
CMAKE_BUILD_PARALLEL_LEVEL="$(nproc)" ; \
rustup run --install stable cargo install -j"$(nproc)" --root "/workspace" --locked "convco"
#
# ────────────────────────────────────────────────────────────────────────────────────────────────────── I ──────────
#   :::::: Y A R N   P A C K A G E S   P A R A L L E L   I N S T A L L S : :  :   :    :     :        :          :
# ────────────────────────────────────────────────────────────────────────────────────────────────────────────────
#
FROM base AS yarn-packages
USER "root"
RUN \
--mount=type=cache,id=yarn-cache,sharing=shared,target=/usr/local/share/.cache/yarn \
yarn --silent global add \
  "remark" \
  "remark-cli" \
  "remark-frontmatter" \
  "remark-stringify" \
  "remark-toc" \
  "remark-preset-lint-recommended" \
  "remark-preset-lint-recommended" \
  "remark-lint-list-item-indent" \
  "standard-readme-spec" \
  "yo" \
  "generator-standard-readme" ;

#
# ────────────────────────────────────────────────────────────────────────────────── I ──────────
#   :::::: A U R   P A R A L L E L   I N S T A L L S : :  :   :    :     :        :          :
# ────────────────────────────────────────────────────────────────────────────────────────────
#

FROM base AS neovim-git-aur-installer
USER "${USER}"
RUN \
AUR_CLONE_URLS=( \
"https://aur.archlinux.org/neovim-git.git" \
) ; \
for url in "${AUR_CLONE_URLS[@]}";do \
git clone "${url}" "/tmp/"$(basename "${url%.git}")"" \
&& pushd "/tmp/"$(basename "${url%.git}")"" > /dev/null 2>&1 ; \
for i in {1..5}; do makepkg -sicr --noconfirm && break || sleep 15; done \
&& popd > /dev/null 2>&1 ; \
done ;
#  ────────────────────────────────────────────────────────────
FROM base AS aura-bin-aur-installer
USER "${USER}"
RUN \
AUR_CLONE_URLS=( \
"https://aur.archlinux.org/aura-bin.git" \
) ; \
for url in "${AUR_CLONE_URLS[@]}";do \
git clone "${url}" "/tmp/"$(basename "${url%.git}")"" \
&& pushd "/tmp/"$(basename "${url%.git}")"" > /dev/null 2>&1 ; \
for i in {1..5}; do makepkg -sicr --noconfirm && break || sleep 15; done \
&& popd > /dev/null 2>&1 ; \
done ;
#  ────────────────────────────────────────────────────────────
FROM base AS git-completion-aur-installer
USER "${USER}"
RUN \
AUR_CLONE_URLS=( \
"https://aur.archlinux.org/git-completion.git" \
) ; \
for url in "${AUR_CLONE_URLS[@]}";do \
git clone "${url}" "/tmp/"$(basename "${url%.git}")"" \
&& pushd "/tmp/"$(basename "${url%.git}")"" > /dev/null 2>&1 ; \
for i in {1..5}; do makepkg -sicr --noconfirm && break || sleep 15; done \
&& popd > /dev/null 2>&1 ; \
done ;
#  ────────────────────────────────────────────────────────────
FROM base AS fzf-extras-aur-installer
USER "${USER}"
RUN \
AUR_CLONE_URLS=( \
"https://aur.archlinux.org/fzf-extras.git" \
) ; \
for url in "${AUR_CLONE_URLS[@]}";do \
git clone "${url}" "/tmp/"$(basename "${url%.git}")"" \
&& pushd "/tmp/"$(basename "${url%.git}")"" > /dev/null 2>&1 ; \
for i in {1..5}; do makepkg -sicr --noconfirm && break || sleep 15; done \
&& popd > /dev/null 2>&1 ; \
done ;
#  ────────────────────────────────────────────────────────────
FROM base AS stylua-bin-aur-installer
USER "${USER}"
RUN \
AUR_CLONE_URLS=( \
"https://aur.archlinux.org/stylua-bin.git" \
) ; \
for url in "${AUR_CLONE_URLS[@]}";do \
git clone "${url}" "/tmp/"$(basename "${url%.git}")"" \
&& pushd "/tmp/"$(basename "${url%.git}")"" > /dev/null 2>&1 ; \
for i in {1..5}; do makepkg -sicr --noconfirm && break || sleep 15; done \
&& popd > /dev/null 2>&1 ; \
done ;
#  ────────────────────────────────────────────────────────────
FROM base AS luacheck-aur-installer
USER "${USER}"
RUN \
AUR_CLONE_URLS=( \
"https://aur.archlinux.org/luacheck.git" \
) ; \
for url in "${AUR_CLONE_URLS[@]}";do \
git clone "${url}" "/tmp/"$(basename "${url%.git}")"" \
&& pushd "/tmp/"$(basename "${url%.git}")"" > /dev/null 2>&1 ; \
for i in {1..5}; do makepkg -sicr --noconfirm && break || sleep 15; done \
&& popd > /dev/null 2>&1 ; \
done ;

#
# ──────────────────────────────────────────────────────────── IV ──────────
#   :::::: M A I N   L A Y E R : :  :   :    :     :        :          :
# ──────────────────────────────────────────────────────────────────────
#
FROM base
#  ╭──────────────────────────────────────────────────────────╮
#  │                    install core tools                    │
#  ╰──────────────────────────────────────────────────────────╯
RUN \
pacman -Sy --noconfirm --needed \
  "docker" \
  "docker-compose" \
  "bash-completion" \
  "openssh" \
  "man-db" \
  "wget" \
  "curl" \
  "make" \
  "unzip" \
  "jq" \
  "unrar" \
  "dialog" \
  "psutils" \
# ─── CLEANUP PACMAN PACKAGE CACHE ───────────────────────────────────────────────
&& find "/var/cache/pacman/pkg" -type f -delete ;
#  ╭──────────────────────────────────────────────────────────╮
#  │             install modern cli applications              │
#  ╰──────────────────────────────────────────────────────────╯
USER "root"
RUN \
pacman -Sy --noconfirm --needed \
  "just" \
  "starship" \
  "ripgrep" \
  "fd" \
  "tokei" \
  "git-delta" \
  "sd" \
  "shfmt" \
  "exa" \
  "fzf" \
  "bat" \
# ─── CLEANUP PACMAN PACKAGE CACHE ───────────────────────────────────────────────
&& find "/var/cache/pacman/pkg" -type f -delete ;
#  ╭──────────────────────────────────────────────────────────╮
#  │                          fonts                           │
#  ╰──────────────────────────────────────────────────────────╯
USER "root"
RUN \
pacman -Sy --noconfirm --needed \
  "noto-fonts" \
  "ttf-ubuntu-font-family" \
  "ttf-font-awesome" \
&& find "/var/cache/pacman/pkg" -type f -delete ;
#  ╭──────────────────────────────────────────────────────────╮
#  │                   user profile config                    │
#  ╰──────────────────────────────────────────────────────────╯
USER "${USER}"
RUN \
# ─── BASE GIT CONFIGS ───────────────────────────────────────────────────────────
git config --global push.recurseSubmodules "on-demand" \
&& git config --global diff.submodule "log" \
&& git config --global status.submoduleSummary "true" \
# ─── USE DELTA FOR GIT DIFFS ────────────────────────────────────────────────────
&& delta --version > /dev/null 2>&1 && ( \
  git config --global pager.diff delta \
  && git config --global pager.log delta \
  && git config --global pager.reflog delta \
  && git config --global pager.show delta \
  && git config --global interactive.difffilter "delta --color-only --features=interactive" \
  && git config --global delta.features "side-by-side line-numbers decorations" \
  && git config --global delta.whitespace-error-style "22 reverse" \
  && git config --global delta.decorations.commit-decoration-style "bold yellow box ul" \
  && git config --global delta.decorations.file-style "bold yellow ul" \
  && git config --global delta.decorations.file-decoration-style "none" \
  && git config --global delta.decorations.commit-style "raw" \
  && git config --global delta.decorations.hunk-header-decoration-style "blue box" \
  && git config --global delta.decorations.hunk-header-file-style "red" \
  && git config --global delta.decorations.hunk-header-line-number-style "#067a00" \
  && git config --global delta.decorations.hunk-header-style "file line-number syntax" \
  && git config --global delta.interactive.keep-plus-minus-markers "false" \
) || true ; \
  # ─── SSH SETUP ──────────────────────────────────────────────────────────────────
  mkdir -p "${HOME}/.ssh" \
  && chmod 700 "${HOME}/.ssh" \
  && ( \
    echo "Host git.sr.ht" ; \
    echo "  User git" ; \
    echo "  StrictHostKeyChecking no" ; \
    echo "  MACs hmac-sha2-512" ; \
    echo "  UserKnownHostsFile=/dev/null" ; \
  ) | tee "${HOME}/.ssh/config" > /dev/null \
  && chmod 644 "${HOME}/.ssh/config" ;
#  ╭──────────────────────────────────────────────────────────╮
#  │                    Entrypoint script                     │
#  ╰──────────────────────────────────────────────────────────╯
USER "root"
RUN \
( \
  echo '#!/bin/sh' ; \
  echo 'sudoIf() { if [ "$(id -u)" -ne 0 ]; then sudo "$@"; else "$@"; fi }' ; \
  # ─── DOCKER FROM DOCKER ─────────────────────────────────────────────────────────
  echo 'if [ -r "/var/run/docker.sock" ];then' ; \
  echo 'SOCKET_GID="$(stat -c "%g" "/var/run/docker.sock")" ; ' ; \
  echo '  if [ "${SOCKET_GID}" != 0 ]; then' ; \
  echo '      if [ "$(cat "/etc/group" | grep :${SOCKET_GID}:)" =  ]; then sudoIf groupadd --gid "${SOCKET_GID}" "docker-host"; fi' ; \
  echo '      if [ "$(id "$(whoami)" | grep -E "groups=.*(=|,)${SOCKET_GID}\(")" = "" ]; then sudoIf usermod -aG "${SOCKET_GID}" "$(whoami)"; fi' ; \
  echo '  fi' ; \
  echo 'fi' ; \
  # ─── FIX KARY-COMMENTS VSCODE EXTENSION ─────────────────────────────────────────
  echo 'path_pattern="*/karyfoundation.comment*/dictionary.js"; ' ; \
  echo 'while read path; do' ; \
  echo '  if test -n "${path}"; then' ; \
  echo '    sed "/shellscript/r"<( \ ' ; \
  echo "    leading_whitespaces=\"\$(grep -Po \"[[:space:]]+(?=case 'shellscript':)\" \"\${path}\")\"; " ; \
  echo "      language='terraform'; ! grep -q \"case '\${language}':\" \"\${path}\" && (echo -n \"\${leading_whitespaces}\";echo \"case '\${language}':\" );" ; \
  echo "      language='dockerfile'; ! grep -q \"case '\${language}':\" \"\${path}\" && (echo -n \"\${leading_whitespaces}\";echo \"case '\${language}':\" );" ; \
  echo "      language='just'; ! grep -q \"case '\${language}':\" \"\${path}\" && (echo -n \"\${leading_whitespaces}\";echo \"case '\${language}':\" );" ; \
  echo "      language='hcl'; ! grep -q \"case '\${language}':\" \"\${path}\" && (echo -n \"\${leading_whitespaces}\";echo \"case '\${language}':\" );" ; \
  echo "      language='packer'; ! grep -q \"case '\${language}':\" \"\${path}\" && (echo -n \"\${leading_whitespaces}\";echo \"case '\${language}':\" );" ; \
  echo '    ) -i -- "${path}" ;' ; \
  echo '  fi ;' ; \
  echo 'done <<< "$(find "${HOME}" -type f -path "${path_pattern}" 2>/dev/null || true )" ;' ; \
  echo 'exec "$@"' ; \
) | tee '/usr/local/share/docker-init.sh' > /dev/null \
&& chmod +x '/usr/local/share/docker-init.sh' ;

#  ────────────────────────────────────────────────────────────
USER "root"
COPY --chmod=0755 --from="aura-bin-aur-installer" "/usr/bin/aura" "/usr/local/bin/aura"
COPY --chmod=0755 --from="aura-bin-aur-installer" "/usr/share/bash-completion/completions/aura" "/usr/share/bash-completion/completions/aura"
COPY --from="aura-bin-aur-installer" "/var/cache/aura/" "/var/cache/aura/"
RUN \
pacman -Sy --noconfirm --needed \
  "gmp" \
  "git" \
&& find "/var/cache/pacman/pkg" -type f -delete \
&& aura --version
#  ────────────────────────────────────────────────────────────
USER "root"
COPY --from="luacheck-aur-installer" "/usr/bin/luacheck" "/usr/local/bin/luacheck"
COPY --from="luacheck-aur-installer" "/usr/share/lua/5.4/luacheck" "/usr/share/lua/5.4/luacheck"
RUN \
pacman -Sy --noconfirm --needed \
  "lua" \
  "lua-filesystem" \
  "lua-argparse" \
&& find "/var/cache/pacman/pkg" -type f -delete \
&& luacheck --version
#  ────────────────────────────────────────────────────────────
USER "root"
COPY --chmod=0755 --from="fzf-extras-aur-installer" "/usr/share/fzf/fzf-extras.bash" "/usr/share/fzf/fzf-extras.bash"
RUN \
pacman -Sy --noconfirm --needed \
  "bash" \
  "fzf" \
  "tmux" \
&& find "/var/cache/pacman/pkg" -type f -delete ;
#  ────────────────────────────────────────────────────────────
USER "root"
COPY --chmod=0755 --from="neovim-git-aur-installer" "/usr/bin/nvim" "/usr/local/bin/nvim"
COPY --from="neovim-git-aur-installer" "/usr/share/nvim" "/usr/share/nvim"
COPY --from="neovim-git-aur-installer" "/usr/lib/nvim" "/usr/lib/nvim"
COPY --from="neovim-git-aur-installer" "/etc/xdg/nvim" "/etc/xdg/nvim"
COPY --from="neovim-git-aur-installer" "/usr/share/locale/" "/usr/share/locale/"
RUN \
pacman -Sy --noconfirm --needed \
  "libluv" \
  "libtermkey" \
  "libutf8proc" \
  "libuv" \
  "libvterm" \
  "luajit" \
  "msgpack-c" \
  "unibilium" \
  "tree-sitter" \
&& find "/var/cache/pacman/pkg" -type f -delete \
&& nvim --version
ENV EDITOR="nvim"
ENV VISUAL="nvim"
#  ╭──────────────────────────────────────────────────────────╮
#  │                 # global profile config                  │
#  ╰──────────────────────────────────────────────────────────╯
USER "root"
RUN \
# ─── STARSHIP PROMPT ──────────────────────────────────────────────────────────
starship --version > /dev/null 2>&1 && echo 'eval "$(starship init bash)" ;' > "/etc/profile.d/starship.sh"  || true; \
just --version > /dev/null 2>&1 && echo 'eval "$(just --completions bash)" ;' > "/etc/profile.d/just.sh" || true ; \
npm  --version >/dev/null 2>&1 && echo 'export PATH="$(npm -g bin):${PATH}" ;' > "/etc/profile.d/npm.sh" || true ; \
yarn --version >/dev/null 2>&1 && echo 'export PATH="$(yarn global bin):${PATH}" ;' > "/etc/profile.d/yarn.sh" || true ; \
rustup --version > /dev/null 2>&1 && ( \
  mkdir -p "/etc/bash_completion.d" ; \
  ( \
    echo '! rustup default > /dev/null 2>&1 && rustup default stable ;' ; \
    echo '[ ! -r "/etc/bash_completion.d/rustup" ] && rustup completions bash rustup | sudo tee "/etc/bash_completion.d/rustup" > /dev/null ;' ; \
    echo '[ ! -r "/etc/bash_completion.d/cargo" ] && rustup completions bash cargo | sudo tee "/etc/bash_completion.d/cargo" > /dev/null ;' ; \
  ) | tee "/etc/profile.d/rustup.sh" > /dev/null ; \
) || true \
bat --version > /dev/null 2>&1 && ( \
  echo 'alias cat="bat -pp" ;' ; \
  echo "export MANPAGER='sh -c \"col -bx | bat --language man --style plain\"' ;" ; \
) | tee "/etc/profile.d/bat.sh" > /dev/null || true  ; \
exa --version > /dev/null 2>&1 && ( \
  echo 'alias la="exa -alhF" ;' ; \
  echo 'alias ll="exa -lhF" ;' ; \
  echo 'alias llfu="exa -bghHliS --git" ;' ; \
  echo 'alias llt="exa -T" ;' ; \
  echo 'alias ls="exa" ;' ; \
) | tee "/etc/profile.d/exa.sh" > /dev/null || true ; \
fzf --version > /dev/null 2>&1 && ( \
  echo '_fzf_complete_make() {' ; \
  echo '  FZF_COMPLETION_TRIGGER="" _fzf_complete "-1" "${@}" < <(make -pqr 2>/dev/null \' ; \
  echo '  | awk -F":" "/^[a-zA-Z0-9][^\$#\/\t=]*:([^=]|\$)/ {split(\$1,A,/ /);for(i in A)print A[i]}" \' ; \
  echo '  | grep -v Makefile \' ; \
  echo '  | sort -u)' ; \
  echo '}' ; \
  echo '[[ -n ${BASH} ]] && complete -F _fzf_complete_make -o default -o bashdefault make' ; \
  echo '[ -r "/usr/share/fzf/key-bindings.bash" ] && source "/usr/share/fzf/key-bindings.bash"' ; \
  echo '[ -r "/usr/share/fzf/completion.bash" ] && source "/usr/share/fzf/completion.bash"' ; \
) | tee "/etc/profile.d/fzf.sh" > /dev/null || true ;

#  ╭──────────────────────────────────────────────────────────╮
#  │                         finalize                         │
#  ╰──────────────────────────────────────────────────────────╯
ARG WORKDIR="/workspace"
ENV WORKDIR "${WORKDIR}"
WORKDIR "${WORKDIR}"
USER "root"
COPY --chmod=0755 --from="gosu-builder" "/go/bin" "/usr/local/bin"
COPY --chmod=0755 --from="vale-builder" "/go/bin" "/usr/local/bin"
#  ────────────────────────────────────────────────────────────
COPY --chmod=0755 --from="git-completion-aur-installer" "/usr/local/share/bash-completion/completions/git" "/usr/local/share/bash-completion/completions/git"
COPY --chmod=0755 --from="git-completion-aur-installer" "/usr/share/git-completion/prompt.sh" "/usr/share/git-completion/prompt.sh"
#  ────────────────────────────────────────────────────────────
COPY --chmod=0755 --from="selene-builder" "/workspace/bin" "/usr/local/bin"
COPY --chmod=0755 --from="stylua-builder" "/workspace/bin" "/usr/local/bin"
COPY --chmod=0755 --from="ttdl-builder" "/workspace/bin" "/usr/local/bin"
COPY --chmod=0755 --from="jujutsu-builder" "/workspace/bin" "/usr/local/bin"
COPY --chmod=0755 --from="convco-builder" "/workspace/bin" "/usr/local/bin"
#  ────────────────────────────────────────────────────────────
COPY --from="yarn-packages" "/usr/local/share/.config/yarn/global/node_modules" "/usr/local/share/.config/yarn/global/node_modules"
#  ────────────────────────────────────────────────────────────
RUN \
chown "$(id -u "${USER}"):$(id -g "${USER}")" -R  \
  "${WORKDIR}" "${HOME}" \
# ─── YARN SYMLINKS ──────────────────────────────────────────────────────────────
&& find "/usr/local/share/.config/yarn/global/node_modules/.bin/" \
  -type l -exec basename {} \; \
| xargs -r -I {} \
ln -sf "/usr/local/share/.config/yarn/global/node_modules/.bin/{}" "/usr/local/bin/{}" \
&& remark --version \
&& yo --version \
#  ────────────────────────────────────────────────────────────
&& gosu --version \
&& vale --version \
#  ────────────────────────────────────────────────────────────
&& selene --version \
&& stylua --version \
&& ttdl --version \
&& jj --version \
&& convco --version \
# ─── CLEAN UP PACMAN BUILD DEPS ─────────────────────────────────────────────────
&& pacman -Qdtq | pacman -Rs --noconfirm - || true \
# ─── REMOVE TEMPORARY FILES ─────────────────────────────────────────────────────
&& rm -rf \
  /tmp/*
# ────────────────────────────────────────────────────────────────────────────────
USER "${USER}"
VOLUME ["${HOME}","${WORKDIR}}"]
ENV TERM "xterm"
ENV COLORTERM "truecolor"
ENV DOCKER_BUILDKIT "1"
ENTRYPOINT [ "/usr/local/share/docker-init.sh" ]
CMD [ "sleep", "infinity" ]
