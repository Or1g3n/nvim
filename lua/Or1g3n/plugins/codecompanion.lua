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
    },
    strategies = {
      chat = {
        adapter = "laci_pixtral",   -- or "laci_pixtral" if you want this model by default
      },
      inline = {
        adapter = "laci_pixtral",
      },
    },
    opts = {
      log_level = "DEBUG",
    },
  },
}
