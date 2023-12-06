
function splitString(str, sep)
	if sep == nil then
		sep = "%s"
	else
		-- Pattern to capture up to the next occurrence of the separator
		sep = "([^" .. sep .. "]*)"
	end
	local out = {}
	local lastPos
	for str, pos in string.gmatch(str, sep .. "()") do
		table.insert(out, str)
		lastPos = pos
	end
	-- Add an empty string if the string ends with the separator
	if lastPos and lastPos <= #str then
		table.insert(out, "")
	end
	return out
end


function mathRound(num, places)
	local mult = 10 ^ (places or 0)
	return math.floor(num * mult + 0.5) / mult
end
