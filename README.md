# Project Initializer

This neovim plugin is intended to create starter project folders. I would list all of the new commands added here, but
this list can and will expand. To see what all is available. To see what's available take a look at 
[cpp-project-init.lua](lua/cpp-project-init.lua) and check the `setup` function of object `M`.

## Prerequisites

You need to install [luafilesystem](https://github.com/lunarmodules/luafilesystem). This can be obtained using
`luarocks`. This guide will assume that you are using arch Linux or something based off of it. If you would like to use
a different operating system, you'll follow the same steps but the commands where you get the software may be different.

1) install `luarocks`

```bash
sudo pacaman -S luarocks
```

2) install [luafilesystem](https://github.com/lunarmodules/luafilesystem) for lua5.1.

```bash
sudo luarocks --lua-version=5.1 install luafilesystem
```

## Install and setup the plugin

These installation steps will assume that you are using `lazy.nvim` as your package manager. If you are using something
different please check the documentation for your preferred package manager. Information on how to install `lazy.nvim`
can be found [here](https://www.lazyvim.org/).

1) In `~/.config/nvim/lua/plugins/` create a file called `projgect-initalizer.lua`. Be sure to add the following code:

```lua
return {
  "StiltFox/project-initalizer.nvim"
}
```

2) After you're done with that, open `~/.config/nvim/init.lua` and add the following line:

```lua
require("project-initalizer").setup()
```

Congratulations! The plugin is installed.
