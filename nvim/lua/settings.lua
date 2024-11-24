-- MIT License Copyright (c) 2021, h1wind

vim.opt.guicursor = ""
vim.opt.fileformat = "unix"
vim.opt.syntax = "on"
vim.opt.laststatus = 2
vim.opt.mouse = ""
vim.opt.encoding = "utf-8"
vim.opt.hidden = true
vim.opt.cursorline = true
vim.opt.relativenumber = true
vim.opt.number = true
vim.opt.autoread = true
vim.opt.swapfile = false
vim.opt.backup = false
vim.opt.writebackup = false
vim.opt.completeopt = {"menu", "menuone", "noselect"}
vim.opt.ruler = true
vim.opt.cino = ":0l1g0t0(0"
vim.opt.hlsearch = true
vim.opt.incsearch = true
vim.opt.showmatch = true
vim.opt.matchtime = 1
vim.opt.pumheight = 20
vim.opt.pumwidth = 20
vim.opt.ignorecase = true
vim.opt.endofline = true
vim.opt.background = "dark"
vim.opt.showmode = true
-- vim.opt.sw=4
-- vim.opt.ts=4

vim.g.mapleader = ","

local function init_indent()
  local indents = {
    {
      et = true,
      n = 4,
      fts = {"java", "python", "markdown"},
    }, {
      et = true,
      n = 2,
      fts = {"sh", "c", "cpp", "vim", "json", "cmake", "yaml", "lua", "html", "javascript", "css"},
    }, {
      et = false,
      n = 4,
      fts = {"go", "make"},
    },
  }

  for _, item in pairs(indents) do
    for _, ft in pairs(item["fts"]) do
      local cmd = "autocmd FileType " .. ft .. " setlocal" .. " ts=" .. item["n"] .. " sw=" .. item["n"]
      if item["et"] then
        cmd = cmd .. " et"
      end
      vim.cmd(cmd)
    end
  end
end

init_indent()

vim.cmd("nohlsearch")
vim.cmd("filetype on")
vim.cmd("filetype plugin on")
vim.cmd("filetype indent on")
vim.cmd("autocmd BufNewFile,BufRead *.h set filetype=c")

vim.cmd([[
augroup neovim_terminal
    autocmd!
    autocmd TermOpen * startinsert
    autocmd TermOpen * :set nonumber norelativenumber
augroup END
]])

vim.api.nvim_set_keymap("n", ";", ":", {})
vim.api.nvim_set_keymap("n", "<F1>", "<ESC>", {})
vim.api.nvim_set_keymap("i", "<F1>", "<ESC>", {})
