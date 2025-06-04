local function on_company_vpn()
    local handle = io.popen('ping -n 1 api.laci.l3harris.com')
    if not handle then
	return false
    end
    local result = handle:read("*a")
    handle:close()
    return result and result:find("TTL=") ~= nil
end

local default_adapter = on_company_vpn() and "laci_pixtral" or "copilot"

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
			url             = "https://api.laci.l3harris.com",
			api_key         = os.getenv("LACI_API_KEY"),
			chat_url        = "/v1/chat/completions",
			models_endpoint = "/v1/models",
		    },
		    schema = {
			model = {
			    default = "mistralai/Pixtral-12B-2409",
			},
		    },
		})
	    end,
	    -- copilot adapter assumed to be configured elsewhere
	},
	strategies = {
	    chat = {
		adapter = default_adapter,
	    },
	    inline = {
		adapter = default_adapter,
	    },
	},
	opts = {
	    log_level = "DEBUG",
	},
    },
}
