local has = function(x)
	return vim.fn.has(x) == 1
end

local is_unix = has "unix" or has "macunix"
local is_win = has "win32"

if is_unix then
	vim.opt.clipboard:append { 'unnamedplus' }
end

if is_win then
	vim.opt.clipboard:prepend { 'unnamed', 'unnamedplus' }
end
