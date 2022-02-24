FROM archlinux:base
SHELL ["/bin/bash", "-o", "pipefail", "-c"]
USER "root"
ENV USER="vscode"
ENV UID="1000"
ENV HOME="/home/${USER}"
#  ╭──────────────────────────────────────────────────────────╮
#  │                      initial setup                       │
#  ╰──────────────────────────────────────────────────────────╯
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
#  │                 docker from docker setup                 │
#  ╰──────────────────────────────────────────────────────────╯
USER "root"
RUN \
# ─── INSTALL DOCKER FROM OFFICIAL REPO ──────────────────────────────────────────
pacman -Sy --noconfirm --needed \
  "docker" \
  "docker-compose" \
# ─── ENTRYPOINT SCRIPT THAT ALLOWS DOCKER FROM DOCKER ───────────────────────────
&& ( \
  echo '#!/bin/sh' ; \
  echo 'sudoIf() { if [ "$(id -u)" -ne 0 ]; then sudo "$@"; else "$@"; fi }' ; \
  echo 'SOCKET_GID="$(stat -c "%g" "/var/run/docker.sock")" ; ' ; \
  echo 'if [ "${SOCKET_GID}" != 0 ]; then' ; \
  echo '    if [ "$(cat "/etc/group" | grep :${SOCKET_GID}:)" =  ]; then sudoIf groupadd --gid "${SOCKET_GID}" "docker-host"; fi' ; \
  echo '    if [ "$(id "$(whoami)" | grep -E "groups=.*(=|,)${SOCKET_GID}\(")" = "" ]; then sudoIf usermod -aG "${SOCKET_GID}" "$(whoami)"; fi' ; \
  echo 'fi' ; \
  echo 'exec "$@"' ; \
) | tee '/usr/local/share/docker-init.sh' > /dev/null \
&& chmod +x '/usr/local/share/docker-init.sh' \
# ─── CLEANUP PACMAN PACKAGE CACHE ───────────────────────────────────────────────
&& find "/var/cache/pacman/pkg" -type f -delete
#  ────────────────────────────────────────────────────────────
RUN \
# ─── INSTALL COMMON PACKAGES FROM OFFICIAL REPO ─────────────────────────────────
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
  "pacman-contrib" \
  "expac" \
  "bash-completion" \
  "base-devel" \
  "git" \
  "openssh" \
  "wget" \
  "curl" \
  "python" \
  "python-pip" \
  "python-setuptools" \
  "python-pre-commit" \
  "nodejs" \
  "yarn" \
  "make" \
  "fzf" \
  "unzip" \
  "jq" \
  "unrar" \
  "dialog" \
  "psutils" \
# ─── CLEANUP PACMAN PACKAGE CACHE ───────────────────────────────────────────────
&& find "/var/cache/pacman/pkg" -type f -delete ; \
# ─── STARSHIP PROMPT ──────────────────────────────────────────────────────────
starship --version > /dev/null 2>&1 && echo 'eval "$(starship init bash)" ;' > "/etc/profile.d/starship.sh"  || true; \
# ─── JUST TASK RUNNER BASH COMPLETIONS ──────────────────────────────────────────
just --version > /dev/null 2>&1 && echo 'eval "$(just --completions bash)" ;' > "/etc/profile.d/just.sh" || true  \
bat --version > /dev/null 2>&1 && echo 'alias cat="bat -pp" ;' > "/etc/profile.d/bat.sh" || true  ; \
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
) | tee "/etc/profile.d/fzf.sh" > /dev/null || true ; \
#  ╭──────────────────────────────────────────────────────────╮
#  │                    install aur-helper                    │
#  ╰──────────────────────────────────────────────────────────╯
USER "${USER}"
RUN \
  git clone "https://aur.archlinux.org/aura-bin.git" "/tmp/aura-bin"
WORKDIR "/tmp/aura-bin"
RUN \
  # ── TRY UP TO FIVE TIMES IN CASE OF FAILURE TO INSTALL 'AURA' AUR-HELPER ────────
  for i in {1..5}; do makepkg -sicr --noconfirm && break || sleep 15; done \
  # ─── CLEANUP PACMAN PACKAGE CACHE ───────────────────────────────────────────────
  && sudo find "/var/cache/pacman/pkg" -type f -delete \
  # ─── CLEANUP TMPDIR ─────────────────────────────────────────────────────────────
  && [ -d "/tmp" ] \
    && sudo find "/tmp" -mindepth 1 -maxdepth 1 -type d  -exec rm -rf "{}" + ;
#  ╭──────────────────────────────────────────────────────────╮
#  │                       aur packages                       │
#  ╰──────────────────────────────────────────────────────────╯
USER "${USER}"
RUN \
export MAKEFLAGS="-j$(nproc)" ; \
export CMAKE_BUILD_PARALLEL_LEVEL="$(nproc)" ; \
sudo -E aura -Axac --noconfirm \
  "git-completion" \
  "fzf-extras"
#  ╭──────────────────────────────────────────────────────────╮
#  │        project (repo) specific packages and setup        │
#  ╰──────────────────────────────────────────────────────────╯
USER "${USER}"
RUN \
# ─── AUR PACKAGE ────────────────────────────────────────────────────────────────
export MAKEFLAGS="-j$(nproc)" ; \
export CMAKE_BUILD_PARALLEL_LEVEL="$(nproc)" ; \
sudo -E aura -Axac --noconfirm \
  "stylua-bin" \
  "vale-bin" \
  "luacheck" \
  "neovim-git" \
# ─── OFFICIAL REPO PACKAGES ─────────────────────────────────────────────────────
&& sudo aura -Sy --noconfirm \
  "lua" \
  "luajit" \
  "luarocks" \
  "go" \
  "rustup" \
  "noto-fonts" \
  "ttf-ubuntu-font-family" \
  "ttf-font-awesome" \
# ─── CLEANUP PACMAN PACKAGE CACHE ───────────────────────────────────────────────
&& sudo find "/var/cache/pacman/pkg" -type f -delete \
# ─── CLEANUP AURA CACHE ─────────────────────────────────────────────────────────
&& [ -d "/var/cache/aura/vcs/" ] \
  && sudo find "/var/cache/aura/vcs/" -mindepth 1 -maxdepth 1 -type d  -exec rm -rf "{}" + ; \
# ─── SETUP DEFAULT EDITOR ───────────────────────────────────────────────────────
nvim --version > /dev/null 2>&1 && ( \
  echo 'export EDITOR="nvim" ;' ; \
  echo 'export VISUAL="nvim" ;' ; \
) | sudo tee "/etc/profile.d/editor.sh" > /dev/null || true ; \
# ─── RUSTUP AND CARGO BASH COMPLETIONS ──────────────────────────────────────────
rustup --version > /dev/null 2>&1 && ( \
  rustup default stable ; \
  mkdir -p "/etc/bash_completion.d" ; \
  rustup completions bash rustup | sudo tee "/etc/bash_completion.d/rustup-completion" > /dev/null ; \
  rustup completions bash cargo  | sudo tee "/etc/bash_completion.d/cargo-completion" > /dev/null ; \
) || true;
#  ╭──────────────────────────────────────────────────────────╮
#  │                           rust                           │
#  ╰──────────────────────────────────────────────────────────╯
USER "${USER}"
ENV PATH="${PATH}:${HOME}/.cargo/bin"
#  ╭──────────────────────────────────────────────────────────╮
#  │ convco helps with git tagging, commits and               │
#  │  changelog generation                                    │
#  ╰──────────────────────────────────────────────────────────╯
RUN \
export MAKEFLAGS="-j$(nproc)" ; \
export CMAKE_BUILD_PARALLEL_LEVEL="$(nproc)" ; \
# ─── INSTALL BUILD DEPENDENCIES ─────────────────────────────────────────────────
sudo pacman -S --noconfirm --asdeps "cmake" \
# ─── BUILD PACKAGES ─────────────────────────────────────────────────────────────
&& cargo install -j"$(nproc)" --locked "convco"  \
# ─── REMOVE BUILD DEPENDENCIES ──────────────────────────────────────────────────
&& sudo pacman -Rcns --noconfirm "cmake" \
# ─── CLEANUP STABLE TOOLCHAIN ───────────────────────────────────────────────────
&& rustup uninstall stable \
# ─── CLEANUP PACMAN PACKAGE CACHE ───────────────────────────────────────────────
&& sudo find "/var/cache/pacman/pkg" -type f -delete ; \
[ -d "${HOME}/.cargo/registry" ] \
  && sudo find "${HOME}/.cargo/registry" -mindepth 1 -maxdepth 1 -type d  -exec rm -rf "{}" + ; \
[ -d "${HOME}/.cache" ] \
  && sudo find "${HOME}/.cache" -mindepth 1 -maxdepth 1 -type d  -exec rm -rf "{}" + ; \
sudo ln -sf "${HOME}/.cargo/bin/convco" "/usr/local/bin/convco" ;
# selene is a lua linter
RUN \
export MAKEFLAGS="-j$(nproc)" ; \
export CMAKE_BUILD_PARALLEL_LEVEL="$(nproc)" ; \
cargo install -j"$(nproc)" --locked "selene" \
# ─── CLEANUP STABLE TOOLCHAIN ───────────────────────────────────────────────────
&& rustup uninstall stable ; \
[ -d "${HOME}/.cargo/registry" ] \
  && sudo find "${HOME}/.cargo/registry" -mindepth 1 -maxdepth 1 -type d  -exec rm -rf "{}" + ; \
[ -d "${HOME}/.cache" ] \
  && sudo find "${HOME}/.cache" -mindepth 1 -maxdepth 1 -type d  -exec rm -rf "{}" + ; \
sudo ln -sf "${HOME}/.cargo/bin/selene" "/usr/local/bin/selene" ;
#  ╭──────────────────────────────────────────────────────────╮
#  │ ttdl is used for working with 'todo.txt'                 │
#  ╰──────────────────────────────────────────────────────────╯
RUN \
export MAKEFLAGS="-j$(nproc)" ; \
export CMAKE_BUILD_PARALLEL_LEVEL="$(nproc)" ; \
cargo install -j"$(nproc)" --locked "ttdl" \
# ─── CLEANUP STABLE TOOLCHAIN ───────────────────────────────────────────────────
&& rustup uninstall stable ; \
[ -d "${HOME}/.cargo/registry" ] \
  && sudo find "${HOME}/.cargo/registry" -mindepth 1 -maxdepth 1 -type d  -exec rm -rf "{}" + ; \
[ -d "${HOME}/.cache" ] \
  && sudo find "${HOME}/.cache" -mindepth 1 -maxdepth 1 -type d  -exec rm -rf "{}" + ; \
sudo ln -sf "${HOME}/.cargo/bin/ttdl" "/usr/local/bin/ttdl" ;
#  ╭──────────────────────────────────────────────────────────╮
#  │ jujutsu is an experimental , better git client           │
#  ╰──────────────────────────────────────────────────────────╯
RUN \
export MAKEFLAGS="-j$(nproc)" ; \
export CMAKE_BUILD_PARALLEL_LEVEL="$(nproc)" ; \
rustup run nightly --install cargo install -j"$(nproc)" --locked "jujutsu" \
# ─── CLEANUP STABLE TOOLCHAIN ───────────────────────────────────────────────────
&& rustup uninstall nightly ; \
[ -d "${HOME}/.cargo/registry" ] \
  && sudo find "${HOME}/.cargo/registry" -mindepth 1 -maxdepth 1 -type d  -exec rm -rf "{}" + ; \
[ -d "${HOME}/.cache" ] \
  && sudo find "${HOME}/.cache" -mindepth 1 -maxdepth 1 -type d  -exec rm -rf "{}" + ; \
sudo ln -sf "${HOME}/.cargo/bin/jj" "/usr/local/bin/jj" ;
#  ╭──────────────────────────────────────────────────────────╮
#  │                          python                          │
#  ╰──────────────────────────────────────────────────────────╯
USER "${USER}"
ENV PATH="${PATH}:${HOME}/.local/bin"
#  ╭──────────────────────────────────────────────────────────╮
#  │                            go                            │
#  ╰──────────────────────────────────────────────────────────╯
USER "${USER}"
ENV PATH="${PATH}:${HOME}/go/bin"
#  ╭──────────────────────────────────────────────────────────╮
#  │                         luarocks                         │
#  ╰──────────────────────────────────────────────────────────╯
USER "${USER}"
ENV PATH="${PATH}:${HOME}/.luarocks/bin"
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
#  │                         finalize                         │
#  ╰──────────────────────────────────────────────────────────╯
ARG WORKDIR="/workspace"
ENV WORKDIR "${WORKDIR}"
WORKDIR "${WORKDIR}"
USER "root"
RUN \
chown "$(id -u "${USER}"):$(id -g "${USER}")" -R  \
  "${WORKDIR}" "${HOME}" \

# ─── CLEAN UP PACMAN BUILD DEPS ─────────────────────────────────────────────────
&& pacman -Qdtq | pacman -Rs --noconfirm - || true \
# ─── REMOVE TEMPORARY FILES ─────────────────────────────────────────────────────
&& rm -rf \
  /tmp/*
# ────────────────────────────────────────────────────────────────────────────────
USER "${USER}"
VOLUME ["${HOME}","${WORKDIR}}"]
# VOLUME ["${HOME}/.vscode-server/extensions","${HOME}/.vscode-server-insiders/extensions","${HOME}/.bash_history"]
ENV TERM "xterm"
ENV COLORTERM "truecolor"
ENTRYPOINT [ "/usr/local/share/docker-init.sh" ]
CMD [ "sleep", "infinity" ]
