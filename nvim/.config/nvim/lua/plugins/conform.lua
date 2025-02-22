return { -- Autoformat
	"stevearc/conform.nvim",
	enabled = true,
	opts = {

		notify_on_error = false,
		format_on_save = function(bufnr)
			if vim.b.autoformat ~= nil and not vim.b.autoformat then
				print("autoformat is disabled")
				return nil
			end
			-- Disable "format_on_save lsp_fallback" for languages that don't
			-- have a well standardized coding style. You can add additional
			-- languages here or re-enable it for the disabled ones.
			local disable_filetypes = { c = true, cpp = true }
			return {
				timeout_ms = 500,
				lsp_fallback = not disable_filetypes[vim.bo[bufnr].filetype],
			}
		end,
		formatters_by_ft = {
			lua = { "stylua" },
			-- Use a sub-list to run only the first available formatter
			javascript = { "prettier" },
			typescript = { "prettier" },
			typescriptreact = { "prettier" },
			rust = nil,
			sh = { "shfmt" },
			go = { "gofmt" },
			gdscript = { "gdformat" },
		},
		formatters = {
			shfmt = {
				prepend_args = { "-i", "4" },
			},
		},
	},
}
