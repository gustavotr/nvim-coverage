local M = {}

local Path = require("plenary.path")
local scan = require("plenary.scandir")
local common = require("coverage.languages.common")
local config = require("coverage.config")
local util = require("coverage.util")

--- Returns a list of signs to be placed.
M.sign_list = common.sign_list

--- Returns a summary report.
M.summary = common.summary

--- Loads a coverage report.
-- @param callback called with results of the coverage report
M.load = function(callback)
	local javascript_config = config.opts.lang.javascript
	local p = Path:new(javascript_config.coverage_file)

	if not p:exists() then
		local files = scan.scan_dir("coverage", { depth = 1, search_pattern = ".lcov$" })
		local count = #files

		if count == 0 then
			vim.notify("No coverage file exists.", vim.log.levels.INFO)
			return
		end

		if count > 1 then
			vim.notify("Found multiple lcov files. Use only one!", vim.log.levels.INFO)
			return
		end

		p = Path:new(files[1])
	end

	vim.notify("Loaded coverage from " .. p:normalize(), vim.log.levels.INFO)

	callback(util.lcov_to_table(p))
end

return M
