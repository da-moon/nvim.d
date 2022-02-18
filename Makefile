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
