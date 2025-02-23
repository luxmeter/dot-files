return {
	"folke/trouble.nvim",
	enabled = true,
	dependencies = { "nvim-tree/nvim-web-devicons", "folke/which-key.nvim" },
      -- stylua: ignore start
        keys = {
            {'<leader>x', group="trouble", desc = 'Trouble'},
            {'<leader>xx', function() require('trouble').toggle 'diagnostics' end, desc = 'Workspace diagnostics' },
            { "<leader>xd", "<cmd>Trouble diagnostics toggle filter.buf=0<cr>", desc = "Document diagnostics", },
            {'<leader>xq', function() require('trouble').toggle 'quickfix' end, desc = 'Show Diagnostics in Quickfix' },
            {'<leader>xl', function() require('trouble').toggle 'loclist' end, desc = 'Show Diagnostics in Loclist' },
        },
	-- stylua: ignore end
	opts = function(opts)
		vim.tbl_extend("force", opts, {
			-- icons / text used for a diagnostic
			error = " ",
			warn = " ",
			hint = " ",
			information = " ",
			other = " ",
		})

		-- vim.keymap.set("n", "]d", function()
		--   require("trouble").next({ skip_groups = true, jump = true })
		-- end, { desc = "Go to previous diagnostic message" })
		-- vim.keymap.set("n", "[d", function()
		--   require("trouble").previous({ skip_groups = true, jump = true })
		-- end, { desc = "Go to next diagnostic message" })

		-- Diagnostic keymaps
		local function troubles_visible()
			local ok, trouble = pcall(require, "trouble")
			return ok and trouble.is_open()
		end

		local function next_trouble()
			if troubles_visible() then
				require("trouble").next({ skip_groups = true, jump = true })
			else
				vim.diagnostic.goto_next()
			end
		end

		local function prev_trouble()
			if troubles_visible() then
				require("trouble").prev({ skip_groups = true, jump = true })
			else
				vim.diagnostic.goto_prev()
			end
		end
		vim.keymap.set("n", "]d", next_trouble, { desc = "Previous diagnostic" })
		vim.keymap.set("n", "[d", prev_trouble, { desc = "Next diagnostic" })
	end,
}
