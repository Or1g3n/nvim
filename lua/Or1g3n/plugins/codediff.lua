return {
	"esmuellert/codediff.nvim",
	enabled = true,
	cmd = "CodeDiff",
    keys = {
        { mode = 'n', "<A-c><A-h>", "<cmd>CodeDiff history<cr>", desc = "CodeDiff: show history" },
        { mode = 'n', "<A-c><A-d>", "<cmd>CodeDiff HEAD<cr>", desc = "CodeDiff: show diff against HEAD" },
    }
}
