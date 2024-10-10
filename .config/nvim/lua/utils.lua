local M = {}

function M.get_os()
	-- ask LuaJIT first
	if jit then
		return jit.os
	end

	-- Unix, Linux variants
	local fh, err = assert(io.popen("uname -o 2>/dev/null", "r"))
	if fh then
		Osname = fh:read()
	end

	return Osname or "Windows"
end

return M
