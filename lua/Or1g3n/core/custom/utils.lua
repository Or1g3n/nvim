local M = {}

-- Safely reference modules that may or may not exist
function M.safe_require(module, fallback)
    local ok, result = pcall(require, module)
    return ok and result or fallback
end

return M
