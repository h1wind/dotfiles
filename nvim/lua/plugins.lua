-- MIT License Copyright (c) 2021, h1zzz

function goimports(timeout_ms)
  local context = { only = { "source.organizeImports" } }
  vim.validate { context = { context, "t", true } }

  local params = vim.lsp.util.make_range_params()
  params.context = context

  -- See the implementation of the textDocument/codeAction callback
  -- (lua/vim/lsp/handler.lua) for how to do this properly.
  local result = vim.lsp.buf_request_sync(0, "textDocument/codeAction", params, timeout_ms)
  if not result or next(result) == nil then return end
  local actions = result[1].result
  if not actions then return end
  local action = actions[1]

  -- textDocument/codeAction can return either Command[] or CodeAction[]. If it
  -- is a CodeAction, it can have either an edit, a command or both. Edits
  -- should be executed first.
  if action.edit or type(action.command) == "table" then
    if action.edit then
      vim.lsp.util.apply_workspace_edit(action.edit)
    end
    if type(action.command) == "table" then
      vim.lsp.buf.execute_command(action.command)
    end
  else
    vim.lsp.buf.execute_command(action)
  end
end

vim.cmd("autocmd BufWritePre *.go lua goimports(1000)")

vim.lsp.handlers["textDocument/publishDiagnostics"] = vim.lsp.with(vim.lsp.diagnostic.on_publish_diagnostics, {
  virtual_text = true,
  signs = false,
  update_in_insert = false,
  underline = true,
})

vim.cmd([[
  augroup packer_user_config
    autocmd!
    autocmd BufWritePost plugins.lua source <afile> | PackerCompile
  augroup end
]])

local install_path = vim.fn.stdpath("data") .. "/site/pack/packer/start/packer.nvim"

if vim.fn.empty(vim.fn.glob(install_path)) > 0 then
  packer_bootstrap = vim.fn.system({
    "git",
    "clone",
    "--depth",
    "1",
    "https://github.com/wbthomason/packer.nvim",
    install_path
  })
end

vim.cmd("packadd packer.nvim")

return require("packer").startup(function(use)

  -- Packer can manage itself
  use("wbthomason/packer.nvim")

  -- theme
  use({
    "sainnhe/gruvbox-material",
    config = function()
      vim.cmd("colorscheme gruvbox-material")
    end
  })

  -- Status line
  use({
    "nvim-lualine/lualine.nvim",
    requires = {
      {"kyazdani42/nvim-web-devicons"}
    },
    config = function()
      require("lualine").setup({
        options = {
          theme = "gruvbox-material",
          component_separators = { left = '', right = ''},
          section_separators = { left = '', right = ''},
        },
      })
    end
  })

  -- File tree
  use({
    "kyazdani42/nvim-tree.lua",
    requires = {
      {"kyazdani42/nvim-web-devicons"}
    },
    config = function()
      require("nvim-tree").setup({
        view = {
          width = 40,
        }
      })

      vim.api.nvim_set_keymap("n", "<F2>", "<cmd>NvimTreeToggle<CR>", {})
    end
  })

  -- commentary
  use({
    "preservim/nerdcommenter",
    config = function()
      vim.g.NERDDefaultAlign = "left"
      vim.g.NERDCommentEmptyLines = 1
      vim.g.NERDTrimTrailingWhitespace = 1
      vim.g.NERDSpaceDelims = 1
      vim.g.NERDAltDelims_python = 1
    end
  })

  -- Bracket completion
  use({
    "windwp/nvim-autopairs",
    config = function()
      require("nvim-autopairs").setup()
    end
  })

  -- Autocomplete
  use({
    "hrsh7th/nvim-cmp",
    requires = {
      {"hrsh7th/cmp-nvim-lsp"},
      {"hrsh7th/cmp-buffer"},
      {"hrsh7th/cmp-path"},
      {"hrsh7th/cmp-cmdline"},
      {"hrsh7th/cmp-vsnip"},
      {"hrsh7th/vim-vsnip"}
    },
    config = function()
      local cmp = require("cmp")
      cmp.setup({
        snippet = {
          expand = function(args)
            vim.fn["vsnip#anonymous"](args.body) -- For `vsnip` users.
          end,
        },
        mapping = {
          ["<TAB>"] = cmp.mapping.select_next_item(),
          ["<S-TAB>"] = cmp.mapping.select_prev_item(),
          ["<CR>"] = cmp.mapping.confirm({select = true})
        },
        sources = cmp.config.sources({
          {name = "nvim_lsp"},
          {name = "vsnip"}, -- For vsnip users.
        }, {
          {name = "buffer"},
        })
      })
    end
  })

  -- Language Server Protocol
  use({
    "neovim/nvim-lspconfig", 
    config = function()
      local capabilities = require('cmp_nvim_lsp').update_capabilities(vim.lsp.protocol.make_client_capabilities())
      local lsp = require("lspconfig")
      local opts = {noremap = true, silent = true}

      lsp.clangd.setup({capabilities = capabilities}) -- brew install clangd
      lsp.gopls.setup({capabilities = capabilities})  -- brew install gopls
      lsp.cmake.setup({capabilities = capabilities})  -- pip3 install cmake-language-server
      lsp.pylsp.setup({capabilities = capabilities})  -- pip3 install python-lsp-server autopep8

      vim.api.nvim_set_keymap("n", "gD", "<cmd>lua vim.lsp.buf.declaration()<CR>", opts)
      vim.api.nvim_set_keymap("n", "gd", "<cmd>lua vim.lsp.buf.definition()<CR>", opts)
      vim.api.nvim_set_keymap("n", "K", "<cmd>lua vim.lsp.buf.hover()<CR>", opts)
      vim.api.nvim_set_keymap("n", "gi", "<cmd>lua vim.lsp.buf.implementation()<CR>", opts)
      vim.api.nvim_set_keymap("n", "gr", "<cmd>lua vim.lsp.buf.references()<CR>", opts)
      vim.api.nvim_set_keymap("n", "<C-k>", "<cmd>lua vim.lsp.buf.signature_help()<CR>", opts)
      vim.api.nvim_set_keymap("n", "<space>wa", "<cmd>lua vim.lsp.buf.add_workspace_folder()<CR>", opts)
      vim.api.nvim_set_keymap("n", "<space>wr", "<cmd>lua vim.lsp.buf.remove_workspace_folder()<CR>", opts)
      vim.api.nvim_set_keymap("n", "<space>wl", "<cmd>lua print(vim.inspect(vim.lsp.buf.list_workspace_folders()))<CR>", opts)
      vim.api.nvim_set_keymap("n", "<space>D", "<cmd>lua vim.lsp.buf.type_definition()<CR>", opts)
      vim.api.nvim_set_keymap("n", "<space>rn", "<cmd>lua vim.lsp.buf.rename()<CR>", opts)
      vim.api.nvim_set_keymap("n", "<space>ca", "<cmd>lua vim.lsp.buf.code_action()<CR>", opts)
      vim.api.nvim_set_keymap("n", "<space>e", "<cmd>lua vim.diagnostic.open_float()<CR>", opts)
      vim.api.nvim_set_keymap("n", "[d", "<cmd>lua vim.diagnostic.goto_prev()<CR>", opts)
      vim.api.nvim_set_keymap("n", "]d", "<cmd>lua vim.diagnostic.goto_next()<CR>", opts)
      vim.api.nvim_set_keymap("n", "<space>q", "<cmd>lua vim.diagnostic.setloclist()<CR>", opts)
      vim.api.nvim_set_keymap("n", "<space>f", "<cmd>lua vim.lsp.buf.formatting()<CR>", opts)
    end
  })

  -- lsp syntax highlighting
  use({
    "nvim-treesitter/nvim-treesitter",
    run = ":TSUpdate",
    config = function()
      require("nvim-treesitter.configs").setup({
        ensure_installed = {
          "c",
          "cpp",
          "go",
          "python",
          "lua",
          "java",
          "ruby",
          "json",
          "cmake",
          "bash",
          "yaml",
          "vim",
          "toml",
          "rust",
          "php",
          "perl",
          "javascript",
          "http",
          "html",
          "dockerfile",
          "css"
        },
        highlight = {
          enable = true,
          use_languagetree = true
        }
      })
    end
  })

  -- Global search
  -- brew install ripgrep
  use({
    "nvim-telescope/telescope.nvim",
    requires = {
      {"nvim-lua/plenary.nvim"}
    },
    config = function()
      vim.api.nvim_set_keymap("n", "<leader>fg", "<cmd>lua require('telescope.builtin').live_grep()<CR>", {})
      vim.api.nvim_set_keymap("n", "<leader>ff", "<cmd>lua require('telescope.builtin').find_files()<CR>", {})
      vim.api.nvim_set_keymap("n", "<leader>fb", "<cmd>lua require('telescope.builtin').buffers()<CR>", {})
      vim.api.nvim_set_keymap("n", "<leader>fh", "<cmd>lua require('telescope.builtin').help_tags()<CR>", {})
    end
  })

  -- Indent line
  use({
    "lukas-reineke/indent-blankline.nvim",
    config = function()
      vim.g.indent_blankline_use_treesitter = true
      vim.g.indent_blankline_show_first_indent_level = false
      vim.g.indent_blankline_show_trailing_blankline_indent = false
    end
  })

  -- Class outline
  use({
    "simrat39/symbols-outline.nvim",
    config = function()
      require("symbols-outline").setup({})
      vim.g.symbols_outline = {
        highlight_hovered_item = false,
        show_guides = false,
        auto_preview = false,
        relative_width = false,
        width = 40,
      }
      vim.api.nvim_set_keymap("n", "<F3>", "<cmd>SymbolsOutline<CR>", {})
    end
  })

  -- Git Status
  use {
    "lewis6991/gitsigns.nvim",
    requires = {
      "nvim-lua/plenary.nvim"
    },
    config = function()
      require("gitsigns").setup({
        signcolumn = false,
      })
    end
  }

  -- Automatically set up your configuration after cloning packer.nvim
  -- Put this at the end after all plugins
  if packer_bootstrap then
    require("packer").sync()
  end
end)
