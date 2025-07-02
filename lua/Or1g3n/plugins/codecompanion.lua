local function safe_require(module, fallback)
    local ok, result = pcall(require, module)
    return ok and result or fallback
end

local laci_pixtral = safe_require("Or1g3n.plugins.local.codecompanion.laci_pixtral", {})

return {
    "olimorris/codecompanion.nvim",
    dependencies = {
	"nvim-lua/plenary.nvim",
	"nvim-treesitter/nvim-treesitter",
    },
    opts = {
	adapters = {
	    laci_pixtral = function()
		return require("codecompanion.adapters").extend("openai_compatible", {
		    env = {
			url             = laci_pixtral.config.env.url,
			api_key         = laci_pixtral.config.env.api_key,
			chat_url        = laci_pixtral.config.env.chat_url,
			models_endpoint = laci_pixtral.config.env.models_endpoint,
		    },
		    schema = {
			model = {
			    default = laci_pixtral.config.schema.model.default,
			},
		    },
		})
	    end,
	},
	strategies = {
	    chat = {
		adapter = next(laci_pixtral) ~= nil and "laci_pixtral" or "copilot",
	    },
	    inline = {
		adapter = next(laci_pixtral) ~= nil and "laci_pixtral" or "copilot",
	    },
	},
	opts = {
	    log_level = "DEBUG",
	},
    },
}
