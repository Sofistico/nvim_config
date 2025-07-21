-- LSP Plugins
local lsp_configs = require 'util.self_lsp'
local icons = require 'local-icons'
local plugins = require 'util.self_init'
return {
  {
    -- `lazydev` configures Lua LSP for your Neovim config, runtime and plugins
    -- used for completion, annotations and signatures of Neovim apis
    'folke/lazydev.nvim',
    ft = 'lua',
    opts = {
      library = {
        -- Load luvit types when the `vim.uv` word is found
        { path = '${3rd}/luv/library', words = { 'vim%.uv' } },
      },
    },
  },
  {
    -- Main LSP Configuration
    'neovim/nvim-lspconfig',
    lazy = true,
    event = 'BufAdd',
    dependencies = {
      -- Mason must be loaded before its dependents so we need to set it up here.
      'mason-org/mason.nvim',
      'mason-org/mason-lspconfig.nvim',
      'WhoIsSethDaniel/mason-tool-installer.nvim',
      -- 'hinell/lsp-timeout.nvim',
      -- Useful status updates for LSP.
      -- NOTE: `opts = {}` is the same as calling `require('fidget').setup({})`
      { 'j-hui/fidget.nvim', opts = {} },

      -- 'Issafalcon/lsp-overloads.nvim',
      'ray-x/lsp_signature.nvim',
      'folke/snacks.nvim',
    },
    keys = {
      { '<leader>cl', '<cmd>LspInfo<cr>', desc = 'Show Lsp Info' },
      { '<leader>cI', '<cmd>LspInstall<cr>', desc = 'Install LSP by FileType' },
      { '<leader>tl', '<cmd>LspRestart<cr>', desc = 'Restart Lsp' },
    },
    config = function()
      -- Brief aside: **What is LSP?**
      --
      -- LSP is an initialism you've probably heard, but might not understand what it is.
      --
      -- LSP stands for Language Server Protocol. It's a protocol that helps editors
      -- and language tooling communicate in a standardized fashion.
      --
      -- In general, you have a "server" which is some tool built to understand a particular
      -- language (such as `gopls`, `lua_ls`, `rust_analyzer`, etc.). These Language Servers
      -- (sometimes called LSP servers, but that's kind of like ATM Machine) are standalone
      -- processes that communicate with some "client" - in this case, Neovim!
      --
      -- LSP provides Neovim with features like:
      --  - Go to definition
      --  - Find references
      --  - Autocompletion
      --  - Symbol Search
      --  - and more!
      --
      -- Thus, Language Servers are external tools that must be installed separately from
      -- Neovim. This is where `mason` and related plugins come into play.
      --
      -- If you're wondering about lsp vs treesitter, you can check out the wonderfully
      -- and elegantly composed help section, `:help lsp-vs-treesitter`

      --  This function gets run when an LSP attaches to a particular buffer.
      --    That is to say, every time a new file is opened that is associated with
      --    an lsp (for example, opening `main.rs` is associated with `rust_analyzer`) this
      --    function will be executed to configure the current buffer

      local _hover = vim.lsp.buf.hover
      local _signatureHelp = vim.lsp.buf.signature_help

      ---@diagnostic disable-next-line: duplicate-set-field
      vim.lsp.buf.hover = function(opts)
        opts = opts or {}
        opts.border = opts.border or 'rounded'
        opts.title = opts.title or 'Hover'
        return _hover(opts)
      end

      ---@diagnostic disable-next-line: duplicate-set-field
      vim.lsp.buf.signature_help = function(opts)
        opts = opts or {}
        opts.border = opts.border or 'rounded'
        opts.title = opts.title or 'Signature Helper'
        return _signatureHelp(opts)
      end

      vim.api.nvim_create_autocmd('LspAttach', {
        group = vim.api.nvim_create_augroup('kickstart-lsp-attach', { clear = true }),
        callback = function(event)
          -- NOTE: Remember that Lua is a real programming language, and as such it is possible
          -- to define small helper and utility functions so you don't have to repeat yourself.
          --
          -- In this case, we create a function that lets us more easily define mappings specific
          -- for LSP related items. It sets the mode, buffer and description for us each time.
          local map = function(keys, func, desc, mode, noremap)
            mode = mode or 'n'
            vim.keymap.set(mode, keys, func, { buffer = event.buf, desc = 'LSP: ' .. desc, noremap = noremap })
          end

          -- all general lsp commands go here:

          -- Execute a code action, usually your cursor needs to be on top of an error
          -- or a suggestion from your LSP for this to activate.
          map('<leader>ca', vim.lsp.buf.code_action, '[C]ode [A]ction', { 'n', 'x' })
          map('gra', vim.lsp.buf.code_action, '[C]ode [A]ction', { 'n', 'x' })
          -- Rename the variable under your cursor.
          --  Most Language Servers support renaming across files, etc.
          -- map('<leader>cr', vim.lsp.buf.rename, '[r]ename')
          map('grn', vim.lsp.buf.rename, '[r]ename')
          map('grt', vim.lsp.buf.type_definition, '[t]ype definition')

          -- TODO: Make this take an input like vim.lsp.buf.rename for the rename of the file, see https://github.com/neovim/neovim/blob/f72dc2b4c805f309f23aff62b3e7ba7b71a554d2/runtime/lua/vim/lsp/buf.lua#L319C1-L320C1
          map('<leader>cR', function()
            require('snacks').rename.rename_file()
          end, '[R]ename File')

          -- The following two autocommands are used to highlight references of the
          -- word under your cursor when your cursor rests there for a little while.
          --    See `:help CursorHold` for information about when this is executed
          --
          -- When you move your cursor, the highlights will be cleared (the second autocommand).
          local client = vim.lsp.get_client_by_id(event.data.client_id)
          if client then
            if client:supports_method(vim.lsp.protocol.Methods.textDocument_documentHighlight) then
              local highlight_augroup = vim.api.nvim_create_augroup('kickstart-lsp-highlight', { clear = false })
              vim.api.nvim_create_autocmd({ 'CursorHold', 'CursorHoldI' }, {
                buffer = event.buf,
                group = highlight_augroup,
                callback = vim.lsp.buf.document_highlight,
              })

              vim.api.nvim_create_autocmd({ 'CursorMoved', 'CursorMovedI' }, {
                buffer = event.buf,
                group = highlight_augroup,
                callback = vim.lsp.buf.clear_references,
              })

              vim.api.nvim_create_autocmd('LspDetach', {
                group = vim.api.nvim_create_augroup('kickstart-lsp-detach', { clear = true }),
                callback = function(event2)
                  vim.lsp.buf.clear_references()
                  vim.api.nvim_clear_autocmds { group = 'kickstart-lsp-highlight', buffer = event2.buf }
                end,
              })
            end

            lsp_configs.make_capabilities(client)

            -- client:request(vim.lsp.buf.hover, params?, handler?, bufnr?)
            -- The following code creates a keymap to toggle inlay hints in your
            -- code, if the language server you are using supports them
            --
            -- This may be unwanted, since they displace some of your code
            if client:supports_method(vim.lsp.protocol.Methods.textDocument_inlayHint) then
              require('snacks').toggle.inlay_hints():map '<leader>th'
            end

            --- Guard against servers without the signatureHelper capability
            if client.server_capabilities.signatureHelpProvider then
              ------@diagnostic disable-next-line: missing-fields
              ---require('lsp-overloads').setup(client, {
              ---  ---@diagnostic disable-next-line: missing-fields
              ---  keymaps = {
              ---    close_signature = '<A-i>',
              ---  },
              ---})
              ---map('<leader>tO', '<cmd>LspOverloadsSignatureAutoToggle<CR>', 'Toggle Lsp Signature Auto')
              ---map('<A-i>', '<cmd>LspOverloadsSignature<CR>', 'Show Signature Overloads', { 'i', 'n' }, true)
              local signature = require 'lsp_signature'
              signature.on_attach({
                bind = true,
                handler_opts = {
                  border = 'rounded',
                },
                toggle_key = '<a-i>',
                select_signature_key = '<M-n>', -- cycle to next signature, e.g. '<M-n>' function overloading
                close_timeout = 10000,
                hint_prefix = icons.fun .. ' ',
              }, event.buf)
              -- map('<A-i>', signature.toggle_float_win, 'Toggle Signature')
            end

            if client.server_capabilities.declarationProvider then
              -- WARN: This is not Goto Definition, this is Goto Declaration.
              --  For example, in C this would take you to the header.
              map('grD', vim.lsp.buf.declaration, '[G]oto [D]eclaration')
            end

            if client.server_capabilities.referencesProvider then
              -- Find references for the word under your cursor.
              map('grr', function()
                require('telescope.builtin').lsp_references { layout_strategy = 'vertical', show_line = false, include_declaration = false }
              end, '[G]oto [R]eferences')
            end

            if client.server_capabilities.definitionProvider then
              -- Jump to the definition of the word under your cursor.
              --  This is where a variable was first declared, or where a function is defined, etc.
              --  To jump back, press <C-t>.
              map('grd', require('telescope.builtin').lsp_definitions, '[G]oto [D]efinition')
              map('<F12>', require('telescope.builtin').lsp_definitions, '[G]oto [D]efinition')
            end

            if client.server_capabilities.implementationProvider then
              -- Jump to the implementation of the word under your cursor.
              --  Useful when your language has ways of declaring types without an actual implementation.
              map('gri', require('telescope.builtin').lsp_implementations, '[G]oto [I]mplementation')
              map('<C-F12>', require('telescope.builtin').lsp_implementations, '[G]oto [I]mplementation')
            end

            if client.server_capabilities.typeDefinitionProvider then
              -- Jump to the type of the word under your cursor.
              --  Useful when you're not sure what type a variable is and you want to see
              --  the definition of its *type*, not where it was *defined*.
              map('<leader>D', require('telescope.builtin').lsp_type_definitions, 'Type [D]efinition')
            end

            if client.server_capabilities.codeLensProvider then
              map('<leader>cc', vim.lsp.codelens.refresh, 'Refresh e Display [c]odelens')
              map('<leader>cC', vim.lsp.codelens.run, 'Run [C]odelens', { 'n', 'v' })
            end

            if client.server_capabilities.documentSymbolProvider then
              -- Fuzzy find all the symbols in your current document.
              --  Symbols are things like variables, functions, types, etc.
              map('<leader>ss', require('telescope.builtin').lsp_document_symbols, 'Document [s]ymbols')
            end

            if client.server_capabilities.workspaceSymbolProvider then
              -- Fuzzy find all the symbols in your current workspace.
              --  Similar to document symbols, except searches over your entire project.
              map('<leader>sS', require('telescope.builtin').lsp_dynamic_workspace_symbols, 'Workspace [S]ymbols')
            end

            -- Change diagnostic symbols in the sign column (gutter)
            lsp_configs.config_lsp_diagnostic(vim.g.have_nerd_font, icons, plugins)

            if lsp_configs[client.name] ~= nil and lsp_configs[client.name].keys ~= nil then
              local keys = lsp_configs[client.name].keys
              for _, k in ipairs(keys) do
                if type(k.key) == 'table' then
                  ---@diagnostic disable-next-line: param-type-mismatch
                  for _, kl in ipairs(k.key) do
                    map(kl, k.func, k.desc, k.mode)
                  end
                else
                  map(k.key, k.func, k.desc, k.mode)
                end
              end
            end
          end
        end,
      })

      -- Enable the following language servers
      --  Feel free to add/remove any LSPs that you want here. They will automatically be installed.
      --
      --  Add any additional override configuration in the following tables. Available keys are:
      --  - cmd (table): Override the default command used to start the server
      --  - filetypes (table): Override the default list of associated filetypes for the server
      --  - capabilities (table): Override fields in capabilities. Can be used to disable certain LSP features.
      --  - settings (table): Override the default settings passed when initializing the server.
      --        For example, to see the options for `lua_ls`, you could go to: https://luals.github.io/wiki/settings/
      local servers = {
        -- clangd = {},
        -- gopls = {},
        -- pyright = {},
        -- rust_analyzer = {},
        -- ... etc. See `:help lspconfig-all` for a list of all the pre-configured LSPs
        --
        -- Some languages (like typescript) have entire language plugins that can be useful:
        --    https://github.com/pmizio/typescript-tools.nvim
        --
        -- But for many setups, the LSP (`tsserver`) will work just fine
        -- tsserver = {},
        --
        lua_ls = {
          -- cmd = {...},
          -- filetypes = { ...},
          -- capabilities = {},
          settings = {
            Lua = {
              completion = {
                callSnippet = 'Replace',
              },
              -- You can toggle below to ignore Lua_LS's noisy `missing-fields` warnings
              -- diagnostics = { disable = { 'missing-fields' } },
              hint = { enable = true },
            },
          },
        },
        omnisharp = {
          autostart = not vim.g.use_roslyn,
          handlers = plugins.is_loaded 'omnisharp_extended' and {
            ['textDocument/definition'] = require('omnisharp_extended').definition_handler,
            ['textDocument/typeDefinition'] = not vim.g.use_roslyn and require('omnisharp_extended').type_definition_handler,
            ['textDocument/references'] = not vim.g.use_roslyn and require('omnisharp_extended').references_handler,
            ['textDocument/implementation'] = not vim.g.use_roslyn and require('omnisharp_extended').implementation_handler,
          },
          settings = {
            FormattingOptions = {
              OrganizeImports = true,
              -- Enables support for reading code style, naming convention and analyzer
              -- settings from .editorconfig.
              EnableEditorConfigSupport = true,
            },
            RoslynExtensionsOptions = {
              EnableImportCompletion = true,
              -- Enables support for roslyn analyzers, code fixes and rulesets.
              EnableAnalyzersSupport = true,
              EnableDecompilationSupport = true,
            },
          },
          enable_roslyn_analyzers = true,
          organize_imports_on_format = true,
          enable_import_completion = true,
          enable_decompilation_support = true,
        },
        clangd = {
          root_dir = function(fname)
            return require('lspconfig.util').root_pattern(
              'Makefile',
              'configure.ac',
              'configure.in',
              'config.h.in',
              'meson.build',
              'meson_options.txt',
              'build.ninja'
            )(fname) or require('lspconfig.util').root_pattern('compile_commands.json', 'compile_flags.txt')(fname) or vim.fs.dirname(
              vim.fs.find('.git', { path = fname, upward = true })[1]
            )
          end,
          capabilities = {
            offsetEncoding = { 'utf-16' },
          },
          cmd = {
            'clangd',
            '--background-index',
            '--clang-tidy',
            '--header-insertion=iwyu',
            '--completion-style=detailed',
            '--function-arg-placeholders',
            '--fallback-style=llvm',
          },
          init_options = {
            usePlaceholders = true,
            completeUnimported = true,
            clangdFileStatus = true,
          },
        },
        html = {
          filetypes = { 'html', 'templ', 'razor' },
        },
      }

      require('mason-tool-installer').setup { ensure_installed = lsp_configs.ensure_installed_all, automatic_installation = true }

      require('mason-lspconfig').setup {
        automatic_enable = {
          exclude = {
            'omnisharp',
          },
        },
        handlers = {
          function(server_name)
            local server = servers[server_name] or {}
            -- This handles overriding only values explicitly passed
            -- by the server configuration above. Useful when disabling
            -- certain features of an LSP (for example, turning off formatting for tsserver)
            require('lspconfig')[server_name].setup(server)
          end,
        },
        automatic_installation = true,
        ensure_installed = lsp_configs.ensure_installed_lsp,
      }
    end,
  },
}
-- vim: ts=2 sts=2 sw=2 et
