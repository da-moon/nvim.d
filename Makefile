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
# ────────────────────────────────────────────────────────────────────────────────
LUA_VERSION = $(shell find '/usr/bin' -type f -name 'luarocks-5*' | sed 's/^.*-//')
PROJECT_NAME := $(notdir $(CURDIR))
export PATH := $$HOME/.luarocks/bin:$(PATH)
export LUA_PATH=/usr/local/share/lua/$(LUA_VERSION)/?.lua;/usr/local/share/lua/$(LUA_VERSION)/?/init.lua;/usr/local/lib/lua/$(LUA_VERSION)/?.lua;/usr/local/lib/lua/$(LUA_VERSION)/?/init.lua;/usr/share/lua/$(LUA_VERSION)/?.lua;/usr/share/lua/$(LUA_VERSION)/?/init.lua;/usr/lib/lua/$(LUA_VERSION)/?.lua;/usr/lib/lua/$(LUA_VERSION)/?/init.lua;/usr/share/lua/common/?.lua;/usr/share/lua/common/?/init.lua;./?.lua;./?/init.lua
export LUA_CPATH=/usr/local/lib/lua/$(LUA_VERSION)/?.so;/usr/local/lib/lua/$(LUA_VERSION)/loadall.so;/usr/lib/lua/$(LUA_VERSION)/?.so;/usr/lib/lua/$(LUA_VERSION)/loadall.so;./?.so
# ─── MAKE CONFIG ────────────────────────────────────────────────────────────────
SHELL := /bin/bash
.DEFAULT_GOAL := default
.PHONY: $(shell egrep -o '^[a-zA-Z_-]+:' $(MAKEFILE_LIST) | sed 's/://')
.SILENT: $(shell egrep -o '^[a-zA-Z_-]+:' $(MAKEFILE_LIST) | sed 's/://')
# ─── HIDDEN TARGETS ─────────────────────────────────────────────────────────────
--fix-home-ownership:
	export PATH=$(PATH) ;
	@find "$${HOME}" \
		-not -group "$(shell id -g)" \
		-not -user "$(shell id -u)" \
		-print0 | \
		xargs -0 -r -I {} -P "$(shell nproc)" \
		sudo chown --no-dereference "$(shell id -u):$(shell id -g)" {} ;
--rust:
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
--luarocks:
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
	export PATH=$(PATH) ;
	@if ! $(WHICH) luacheck > $(DEVNUL) 2>&1; then \
		if ! luarocks show "luacheck" > $(DEVNUL) 2>&1; then \
		sudo luarocks install "luacheck" ; \
		fi \
	fi
--remove-shebang: --fd
	export PATH=$(PATH) ;
	fd  -e 'lua' -E plugin/packer_compiled.lua --full-path $(CURDIR) \
	-x sed -i \
	-e '/-- vim:/d' \
	-e '/-- code/d'
--add-shebang: --fd
	export PATH=$(PATH) ;
	fd -e 'lua' -E plugin/packer_compiled.lua --full-path $(CURDIR) \
	-x sed -i \
	-e '1 i\-- vim: filetype=lua syntax=lua softtabstop=3 tabstop=3 shiftwidth=3 fileencoding=utf-8 smartindent autoindent expandtab' \
	-e '1 i\-- code: language=lua insertSpaces=true tabSize=3'
--install-packer:
	export PATH=$(PATH) ;
	nvim --headless -c 'autocmd User PackerComplete quitall' -c 'qall' ;
	nvim --headless -c 'autocmd User PackerComplete quitall' -c 'PackerSync';
# ─── TARGETS ────────────────────────────────────────────────────────────────────
default: ## default target which uses fzf to show a menu of make target options
	@make -rpn \
		| sed -n -e '/^$$/ { n ; /^[^ .#][^ ]*:/ { s/:.*$$// ; p ; } ; }' \
		| sort -u \
		| fzf

#  ────────────────────────────────────────────────────────────────────
help:                   ## Show this help
	@printf "$$(fgrep -h "##" $(MAKEFILE_LIST) | fgrep -v 'fgrep' | sed -e 's/\\$$//' | sed -e 's/\s.*##//')\n"

# ────────────────────────────────────────────────────────────────────────────────
snapshot: ## archives the repository and stores it under tmp/snapshots
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
# ────────────────────────────────────────────────────────────────────────────────
clean: ## prepares a clean slate for configuring Neovim
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
		"$${HOME}/.local/share/"*vim* ;
# ────────────────────────────────────────────────────────────────────────────────
healthcheck: ## runs neovim healthchecks
	export PATH=$(PATH) ;
	nvim --headless -c 'checkhealth' -c 'silent write >> /dev/stdout' -c 'quitall' 2>&1
# ────────────────────────────────────────────────────────────────────────────────
fmt: --stylua --fd --remove-shebang ## formats lua files with stylua
	export PATH=$(PATH) ;
	fd  -e 'lua' -E plugin/packer_compiled.lua -E archive/ --full-path $(CURDIR) \
	-x stylua --config-path="$(CURDIR)/.stylua.toml"
	$(MAKE) --no-print-directory -f $(MAKEFILE_LIST) -- --add-shebang ;
# ────────────────────────────────────────────────────────────────────────────────
luacheck: --luacheck --remove-shebang  ## runs luacheck linter
	export PATH=$(PATH) ;
	luacheck -q --codes --config "$(CURDIR)/.luacheckrc" $(CURDIR)
	$(MAKE) --no-print-directory -f $(MAKEFILE_LIST) -- --add-shebang ;
selene: --selene --fd ## runs selene linter
	export PATH=$(PATH) ;
	files=($$(fd -a -c never -e 'lua' -E plugin/packer_compiled.lua -E archive/ --full-path $(CURDIR))) ; \
	selene $${files[*]}
