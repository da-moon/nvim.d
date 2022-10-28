# vim: filetype=make syntax=make textwidth=0 softtabstop=0 tabstop=4 shiftwidth=4 fileencoding=utf-8 smartindent autoindent noexpandtab
# ─── VARIABBLES ─────────────────────────────────────────────────────────────────
CLEAR = clear
LS = ls
TOUCH = touch
CPF = cp -f
RM = rm -rf
RMDIR = sudo rm -rf
MKDIR = mkdir -p
ERRIGNORE = 2>/dev/null
SEP=/
DEVNUL = /dev/null
WHICH = which
SHELL=/bin/bash
# ────────────────────────────────────────────────────────────────────────────────
default:
	@if ! $(WHICH) fzf > $(DEVNUL) 2>&1; then \
		make --no-print-directory help ; \
	else  \
		make --no-print-directory $$(make -rpn \
		    | grep -v '^--' \
			| sed -n -e '/^$$/ { n ; /^[^ .#][^ ]*:/ { s/:.*$$// ; p ; } ; }' \
			| grep -vE '^default$$' \
			| sort -u \
			| fzf) ; \
	fi
# ─── MAKE CONFIG ────────────────────────────────────────────────────────────────
LUA_VERSION = $(shell find '/usr/bin' -type f -name 'luarocks-5*' | sed 's/^.*-//')
PROJECT_NAME := $(notdir $(shell git remote get-url origin))
# where to store binaries in case they are not availabe.
# this path does not require sudo
TMP_BIN_DIR := $(notdir $(CURDIR))/tmp/bin
export PATH := $$HOME/.luarocks/bin:$(PATH)
export PATH := $(TMP_BIN_DIR):$(PATH)
export LUA_PATH=/usr/local/share/lua/$(LUA_VERSION)/?.lua;/usr/local/share/lua/$(LUA_VERSION)/?/init.lua;/usr/local/lib/lua/$(LUA_VERSION)/?.lua;/usr/local/lib/lua/$(LUA_VERSION)/?/init.lua;/usr/share/lua/$(LUA_VERSION)/?.lua;/usr/share/lua/$(LUA_VERSION)/?/init.lua;/usr/lib/lua/$(LUA_VERSION)/?.lua;/usr/lib/lua/$(LUA_VERSION)/?/init.lua;/usr/share/lua/common/?.lua;/usr/share/lua/common/?/init.lua;./?.lua;./?/init.lua
export LUA_CPATH=/usr/local/lib/lua/$(LUA_VERSION)/?.so;/usr/local/lib/lua/$(LUA_VERSION)/loadall.so;/usr/lib/lua/$(LUA_VERSION)/?.so;/usr/lib/lua/$(LUA_VERSION)/loadall.so;./?.so
.PHONY: $(TARGET_LIST)
.SILENT: $(TARGET_LIST)
TARGET_LIST ?= $(shell $(MAKE) -rpn | sed -n -e '/^$$/ { n ; /^[^ .\#][^ ]*:/ { s/:.*$$// ; p ; } ; }' | sort -u)
# ─── HIDDEN TARGETS ─────────────────────────────────────────────────────────────
--fix-home-ownership:
	echo '─── running $@ hidden Make target ────────────────────────────────────────────' ;
	export PATH=$(PATH) ;
	@find "$${HOME}" \
		-not -group "$(shell id -g)" \
		-not -user "$(shell id -u)" \
		-print0 | \
		xargs -0 -r -I {} -P "$(shell nproc)" \
		sudo chown --no-dereference "$(shell id -u):$(shell id -g)" {} ;
--rust:
	echo '─── running $@ hidden Make target ────────────────────────────────────────────' ;
	export PATH=$(PATH) ;
	@if ! $(WHICH) cargo > $(DEVNUL) 2>&1; then \
		if $(WHICH) pacman > $(DEVNUL) 2>&1; then \
			sudo pacman -Syy --noconfirm --needed rust sccache ; \
		elif $(WHICH) apk > $(DEVNUL) 2>&1; then \
			sudo apk info --installed "cargo" > $(DEVNUL) 2>&1 || sudo apk add --no-cache "cargo" ; \
			sudo apk info --installed "sccache" > $(DEVNUL) 2>&1 || sudo apk add --no-cache "sccache" ; \
		fi \
	fi
--stylua:
	echo '─── running $@ hidden Make target ────────────────────────────────────────────' ;
	export PATH=$(PATH) ;
	@if ! $(WHICH) stylua > $(DEVNUL) 2>&1; then \
		if $(WHICH) makepkg > $(DEVNUL) 2>&1; then \
			$(RMDIR) "/tmp/stylua-git" \
			&& git clone "https://aur.archlinux.org/stylua-git.git" "/tmp/stylua-git" \
			&& pushd "/tmp/stylua-git" \
			&& makepkg -sicr --noconfirm \
			&& popd \
			&& $(RMDIR) "/tmp/stylua-git" ; \
		else \
			$(MAKE) --no-print-directory -f $(MAKEFILE_LIST) -- --rust ; \
			cargo install -j$(shell nproc) stylua ; \
		fi \
	fi
--selene:
	echo '─── running $@ hidden Make target ────────────────────────────────────────────' ;
	export PATH=$(PATH) ;
	@if ! $(WHICH) selene > $(DEVNUL) 2>&1; then \
		if $(WHICH) makepkg > $(DEVNUL) 2>&1; then \
			$(RMDIR) "/tmp/selene-linter" \
			&& git clone "https://aur.archlinux.org/selene-linter.git" "/tmp/selene-linter" \
			&& pushd "/tmp/selene-linter" \
			&& makepkg -sicr --noconfirm \
			&& popd \
			&& $(RMDIR) "/tmp/selene-linter" ; \
		else \
			$(MAKE) --no-print-directory -f $(MAKEFILE_LIST) -- --rust ; \
			cargo install -j$(shell nproc) --branch main --git https://github.com/Kampfkarren/selene selene ; \
		fi \
	fi
--vale:
	echo '─── running $@ hidden Make target ────────────────────────────────────────────' ;
	export PATH=$(PATH) ;
	@if ! $(WHICH) selene > $(DEVNUL) 2>&1; then \
		if $(WHICH) makepkg > $(DEVNUL) 2>&1; then \
			$(RMDIR) "/tmp/vale-bin" \
			&& git clone "https://aur.archlinux.org/vale-bin.git" "/tmp/vale-bin" \
			&& pushd "/tmp/vale-bin" \
			&& makepkg -sicr --noconfirm \
			&& popd \
			&& $(RMDIR) "/tmp/vale-bin" ; \
		else \
			curl -sfL https://install.goreleaser.com/github.com/ValeLint/vale.sh | sudo sh -s -- -b "/usr/local/bin" latest ; \
		fi \
	fi
--fd:
	echo '─── running $@ hidden Make target ────────────────────────────────────────────' ;
	export PATH=$(PATH) ;
	@if ! $(WHICH) fd > $(DEVNUL) 2>&1; then \
		if $(WHICH) pacman > $(DEVNUL) 2>&1; then \
			sudo pacman -Syy --noconfirm --needed fd ; \
		elif $(WHICH) apk > $(DEVNUL) 2>&1; then \
			sudo apk add --no-cache fd	; \
		elif $(WHICH) cargo > $(DEVNUL) 2>&1; then \
			cargo install -j$(shell nproc) fd-find ; \
		fi \
	fi
--rg:
	echo '─── running $@ hidden Make target ────────────────────────────────────────────' ;
	export PATH=$(PATH) ;
	@if ! $(WHICH) rg > $(DEVNUL) 2>&1; then \
		if $(WHICH) pacman > $(DEVNUL) 2>&1; then \
			sudo pacman -Syy --noconfirm --needed ripgrep ; \
		elif $(WHICH) apk > $(DEVNUL) 2>&1; then \
			sudo apk add --no-cache ripgrep	; \
		elif $(WHICH) apt-get > $(DEVNUL) 2>&1; then \
			sudo apt-get update && sudo apt-get install -y ripgrep	; \
		elif $(WHICH) cargo > $(DEVNUL) 2>&1; then \
			cargo install -j$(shell nproc) ripgrep ; \
		fi \
	fi
--docker-engine-check:
	echo '─── running $@ hidden Make target ────────────────────────────────────────────' ;
	export PATH=$(PATH) ;
	if ! $(WHICH) docker > $(DEVNUL) 2>&1; then \
		echo "*** Docker not found." ; \
		exit 1 ; \
	fi
--docker-buildx-check:
	echo '─── running $@ hidden Make target ────────────────────────────────────────────' ;
	export PATH=$(PATH) ;
	if ! docker buildx version > $(DEVNUL) 2>&1; then \
		echo "*** docker buildx plugin not found." ; \
		$(MAKE) --no-print-directory -- --docker-buildx-install ; \
	fi
export BUILDX_VERSION := 0.6.3
--docker-buildx-install:
	echo '─── running $@ hidden Make target ────────────────────────────────────────────' ;
	export PATH=$(PATH) ; \
	sudo $(MKDIR) "/usr/lib/docker/cli-plugins" && \
	sudo curl -L \
		--output "/usr/lib/docker/cli-plugins/docker-buildx" \
		"https://github.com/docker/buildx/releases/download/v$(BUILDX_VERSION)/buildx-v$(BUILDX_VERSION).linux-amd64" \
	&& sudo chmod a+x "/usr/lib/docker/cli-plugins/docker-buildx"

--docker:
	echo '─── running $@ hidden Make target ────────────────────────────────────────────' ;
	$(MAKE) --no-print-directory -- --docker-engine-check
	$(MAKE) --no-print-directory -- --docker-buildx-check

--luarocks:
	echo '─── running $@ hidden Make target ────────────────────────────────────────────' ;
	export PATH=$(PATH) ;
	[ ! -d "$${HOME}/.cache/luarocks" ] && $(MKDIR) "$${HOME}/.cache/luarocks" || true;
	if $(WHICH) pacman > $(DEVNUL) 2>&1; then \
		sudo pacman -Syy --noconfirm --needed "luarocks" ; \
		elif $(WHICH) apk > $(DEVNUL) 2>&1; then \
		sudo apk info --installed "lua5.2" > $(DEVNUL) 2>&1 || sudo apk add --no-cache "lua5.2" ; \
		sudo apk info --installed "lua5.2-dev" > $(DEVNUL) 2>&1 || sudo apk add --no-cache "lua5.2-dev" ; \
		sudo apk info --installed "luarocks" > $(DEVNUL) 2>&1 || sudo apk add --no-cache "luarocks" ; \
		sudo apk info --installed "luajit" > $(DEVNUL) 2>&1 || sudo apk add --no-cache  "luajit" ; \
		fi
	$(MAKE) --no-print-directory -f $(MAKEFILE_LIST) -- --luarocks-post-install ;
--luarocks-post-install:
	echo '─── running $@ hidden Make target ────────────────────────────────────────────' ;
	export PATH=$(PATH) ;
	sudo ln -sf \
		"/usr/bin/luarocks-$(LUA_VERSION)" \
		"/usr/local/bin/luarocks" ; \
		if ! $(WHICH) luarocks > $(DEVNUL) 2>&1; then \
		echo >&2 "*** luarocks not found in path" ; \
		exit 1; \
		fi
	$(MAKE) --no-print-directory -f $(MAKEFILE_LIST) -- --fix-home-ownership ;
--luacheck: --luarocks --fix-home-ownership
	echo '─── running $@ hidden Make target ────────────────────────────────────────────' ;
	export PATH=$(PATH) ;
	@if ! $(WHICH) luacheck > $(DEVNUL) 2>&1; then \
		if ! luarocks show "luacheck" > $(DEVNUL) 2>&1; then \
		sudo luarocks install "luacheck" ; \
		fi \
	fi
--remove-shebang: --fd
	echo '─── running $@ hidden Make target ────────────────────────────────────────────' ;
	export PATH=$(PATH) ;
	fd --unrestricted -e 'lua' -E plugin/packer_compiled.lua --full-path $(CURDIR) \
	-x sed -i \
	-e '/-- vim:/d' \
	-e '/-- code/d'
--add-shebang: --fd
	echo '─── running $@ hidden Make target ────────────────────────────────────────────' ;
	export PATH=$(PATH) ;
	fd --unrestricted -e 'lua' -E plugin/packer_compiled.lua --full-path $(CURDIR) \
	-x sed -i \
	-e '1 i\-- vim: filetype=lua syntax=lua softtabstop=3 tabstop=3 shiftwidth=3 fileencoding=utf-8 smartindent autoindent expandtab' \
	-e '1 i\-- code: language=lua insertSpaces=true tabSize=3'
--install-packer:
	echo '─── running $@ hidden Make target ────────────────────────────────────────────' ;
	export PATH=$(PATH) ;
	nvim --headless -c 'autocmd User PackerComplete quitall' -c 'qall' ;
	nvim --headless -c 'autocmd User PackerComplete quitall' -c 'PackerSync';

#  ────────────────────────────────────────────────────────────────────
help:                   ## Show main help menu
	echo '─── main help menu ─────────────────────────────────────────────────────────────'
	if ! $(WHICH) column > $(DEVNUL) 2>&1; then \
		printf "$$(fgrep -h "##" $(MAKEFILE_LIST) | fgrep -v 'fgrep' | sed -e 's/\\$$//' | sed -e 's/\s.*##//')\n" ; \
	else  \
		printf "$$(fgrep -h "##" $(MAKEFILE_LIST) | fgrep -v 'fgrep' | sed -e 's/\\$$//' | sed -e 's/\s.*##//')\n" \
		| column -t  \
		| sed -re 's/: ( +)/\1: /' -e 's/ +/ /2g' ; \
	fi
#  ╭──────────────────────────────────────────────────────────╮
#  │                       git targets                        │
#  ╰──────────────────────────────────────────────────────────╯
PATCHVERSION ?= $(shell git describe --tags --abbrev=0 | sed s/v// | awk -F. '{print $$1"."$$2"."$$3+1}')
patch-release: ## bump up tags for a new Patch release.
	echo '─── running $@ Make target ──────────────────────────────────────────────────' ;
	git checkout '$(shell git rev-parse --abbrev-ref HEAD)' \
	&& git pull \
	&& git fetch -p && git branch -vv | awk '/: gone]/ {print $$1}' | xargs -r -I {} git branch -D '{}' \
	&& git tag -a v$(PATCHVERSION) -m 'release $(PATCHVERSION)' \
	&& git push origin --tags
	echo '────────────────────────────────────────────────────────────────────────────────' ;

MINORVERSION ?= $(shell git describe --tags --abbrev=0 | sed s/v// | awk -F. '{print $$1"."$$2+1".0"}')
minor-release: ## bump up tags for a new Minor release
	echo '─── running $@ Make target ──────────────────────────────────────────────────' ;
	git checkout '$(shell git rev-parse --abbrev-ref HEAD)' \
	&& git pull \
	&& git fetch -p && git branch -vv | awk '/: gone]/ {print $$1}' | xargs -r -I {} git branch -D '{}' \
	&& git tag -a v$(MINORVERSION) -m 'release $(MINORVERSION)' \
	&& git push origin --tags
	echo '────────────────────────────────────────────────────────────────────────────────' ;

MAJORVERSION ?= $(shell git describe --tags --abbrev=0 | sed s/v// |  awk -F. '{print $$1+1".0.0"}')
major-release: ## bump up tags for a new Major release
	echo '─── running $@ Make target ──────────────────────────────────────────────────' ;
	git checkout '$(shell git rev-parse --abbrev-ref HEAD)' \
	&& git pull \
	&& git fetch -p && git branch -vv | awk '/: gone]/ {print $$1}' | xargs -r -I {} git branch -D '{}' \
	&& git tag -a v$(MAJORVERSION) -m 'release $(MAJORVERSION)' \
	&& git push origin --tags ;
	echo '────────────────────────────────────────────────────────────────────────────────' ;
# ────────────────────────────────────────────────────────────────────────────────
snapshot: ## archives the repository and stores it under tmp/snapshots
	echo '─── running $@ Make target ──────────────────────────────────────────────────' ;
	- $(eval tmp=$(shell mktemp -d))
	- $(eval time=$(shell date +'%Y-%m-%d-%H-%M'))
	- $(eval snapshot_dir=$(CURDIR)/tmp/snapshots)
	- $(eval path=$(snapshot_dir)/$(time).tar.gz)
	- sync
	- $(MKDIR) $(snapshot_dir)
	- tar -C $(CURDIR) -cpzf $(tmp)/$(time).tar.gz .
	- mv $(tmp)/$(time).tar.gz $(path)
	- $(RM) $(tmp)
	- echo "*** snapshot created at $(path)"
	echo '────────────────────────────────────────────────────────────────────────────────' ;
# ────────────────────────────────────────────────────────────────────────────────
clean: ## prepares a clean slate for configuring Neovim
	echo '─── running $@ Make target ──────────────────────────────────────────────────' ;
	export PATH=$(PATH) ;
	pkill -SIGKILL npm || true ;
	pkill -SIGKILL nodejs || true ;
	$(RMDIR) \
		"$(CURDIR)/plugin/packer_compiled.lua" \
		"$${HOME}/.cache/"*vim* \
		"$${HOME}/.local/share/nvimlsp_servers" \
		"$${HOME}/.cache/neosnippet" \
		"$${HOME}/.config/coc" \
		"$${HOME}/.vim"* \
		"$${HOME}/.config/"*vim* \
		"$${HOME}/.cache/"*vim* \
		"$${HOME}/.local/share/"*vim* \
		"$${HOME}/.local/state/nvim/view/"* \
		"$${HOME}/.local/state/nvim/lsp.log" \
		"$${HOME}/.local/state/nvim/log" ;
	echo '────────────────────────────────────────────────────────────────────────────────' ;
# ────────────────────────────────────────────────────────────────────────────────
install: clean ## configure nvim
	echo '─── running $@ Make target ──────────────────────────────────────────────────' ;
	export PATH=$(PATH) ;
	$(MKDIR) $${HOME}/.config ;
	ln -sf $(CURDIR) $${HOME}/.config/nvim ;
	$(MAKE) --no-print-directory -f $(MAKEFILE_LIST) -- --install-packer ;
	nvim -c "PackerStatus";
	echo '────────────────────────────────────────────────────────────────────────────────' ;
# ────────────────────────────────────────────────────────────────────────────────
healthcheck: ## runs neovim healthchecks
	echo '─── running $@ Make target ──────────────────────────────────────────────────' ;
	export PATH=$(PATH) ;
	nvim --headless -c 'checkhealth' -c 'silent write >> /dev/stdout' -c 'quitall' 2>&1
	echo '────────────────────────────────────────────────────────────────────────────────' ;
#  ────────────────────────────────────────────────────────────
stylua: --stylua --fd --remove-shebang ## formats lua files with stylua
	echo '─── running $@ Make target ──────────────────────────────────────────────────' ;
	export PATH=$(PATH) ;
	fd --unrestricted -e 'lua' -E plugin/packer_compiled.lua -E archive/ --full-path $(CURDIR) \
	-x stylua --config-path="$(CURDIR)/.stylua.toml"
	$(MAKE) --no-print-directory -f $(MAKEFILE_LIST) -- --add-shebang ;
	echo '────────────────────────────────────────────────────────────────────────────────' ;
# docker
DOCKER_FILES := $(shell rg --hidden --no-ignore --files --type docker --glob '!tmp/' | sed -e ':a' -e 'N' -e ' !ba' -e 's/\n/ /g')
docker-build: hadolint ## Builds container images with Buildkit
	echo '─── running $@ Make target ──────────────────────────────────────────────────' ;
	export PATH=$(PATH) ;
	docker buildx create --use --name "$(PROJECT_NAME)" --driver docker-container \
	&& docker buildx bake --builder "$(PROJECT_NAME)"
	echo '────────────────────────────────────────────────────────────────────────────────' ;
# NOTE>  these hidden targets will lint individual docker files. this meta target enables parallel linting when make is run with '-j<parallel-job-count>' flag
HADOLINT_TARGETS = $(DOCKER_FILES:%=--lint-%)
$(HADOLINT_TARGETS):
	$(eval docker_file_path=$(@:--lint-%=%))
	echo '─── running $@ hidden Make target ────────────────────────────────────────────' ;
	echo 'linting $(docker_file_path)' ;
	docker run --rm -i hadolint/hadolint < $(docker_file_path)
hadolint: --docker ## Lint docker files with Hadolint
	echo '─── running $@ Make target ──────────────────────────────────────────────────' ;
	$(MAKE) --no-print-directory -- $(HADOLINT_TARGETS)
	echo '────────────────────────────────────────────────────────────────────────────────'
#  ╭──────────────────────────────────────────────────────────╮
#  │                         linters                          │
#  ╰──────────────────────────────────────────────────────────╯
luacheck: --luacheck --remove-shebang  ## Lint lua files with luacheck
	echo '─── running $@ Make target ──────────────────────────────────────────────────' ;
	export PATH=$(PATH) ;
	luacheck -q --codes --config "$(CURDIR)/.luacheckrc" $(CURDIR)
	$(MAKE) --no-print-directory -f $(MAKEFILE_LIST) -- --add-shebang ;
	echo '────────────────────────────────────────────────────────────────────────────────' ;

selene: --selene --fd ## Lint lua files with selene
	echo '─── running $@ Make target ──────────────────────────────────────────────────' ;
	export PATH=$(PATH) ;
	files=($$(fd -u -a -c never -e 'lua' -E plugin/packer_compiled.lua -E archive/ --full-path $(CURDIR))) ; \
	selene $${files[*]}
	echo '────────────────────────────────────────────────────────────────────────────────'


#  ╭──────────────────────────────────────────────────────────╮
#  │                       meta targets                       │
#  ╰──────────────────────────────────────────────────────────╯
lint: luacheck selene hadolint ## a 'meta' target that runs all linter targets
fmt: stylua ## a 'meta' target that runs all formatters
dep: --stylua --luacheck --selene --vale --rg --fd --docker ## a 'meta' target that checks for development environment prerequisites applications and installs some applications
