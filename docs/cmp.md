# cmp

## Overview

This document serves as a guide for the workflow to add/modify [`cmp`][cmp]
sources

## Usage

- add the source name and symbol to `vim_item.menu` in `format` function of [`nvim-cmp`][nvim-cmp]
  **setup** function. As an example, to add `foo_src` source:

```lua
-- lua/plugins/nvim-cmp.lua
--- ....
vim_item.menu = ({
   buffer = "[Buffer]",
   foo_src = "[Foo]"
})[entry.source.name]
--- ....
```

- add the source repository to `M.sources` map in
  [`plugins/nvim-cmp-sources.lua`][nvim-cmp-sources] and for basic source
  registration, use `M._register` function with the source name

```lua
-- lua/plugins/nvim-cmp-sources.lua
--example
M.sources["foo/bar"] = {
   M._register("foo_src")
}
```

You can add more instructions if needed in the `M.source[<src-name>]` function
if needed.

- Add the repo to `cmp_sources` list of [`plugins.lua`][plugins] file.

## Internals

- functions in `M.sources` map of
  [`plugins/nvim-cmp-sources.lua`][nvim-cmp-sources] are called by Packer's
  `config` function.
- All sources added to `cmp_sources` list of [`plugins.lua`][plugins] file
  share a common package `setup` function. Essentially, the setup function
  ensures packer loads the **logging**  and **cmp** package. If you need
  further customization, you need to add it outside of  `cmp_sources` list;
  refer to how `tzachar/cmp-tabnine` source is added for an example.
- If your source requires fields such as `run` in Packer's `use` function, you
  have to define it out of `cmp_sources` list. refer to how
  `tzachar/cmp-tabnine` source is added for an example.
- calling `M._register(<source-name>)` function :
  - Logs the name of the source gets added
  - Loads current sources
  - adds the source to the current source list
  - updates `cmp` config.


[cmp]: https://github.com/hrsh7th/nvim-cmp
[nvim-cmp-sources]: ../lua/plugins/nvim-cmp-sources.lua
[nvim-cmp]: ../lua/plugins/nvim-cmp.lua
[plugins]: ../lua/plugins.lua
