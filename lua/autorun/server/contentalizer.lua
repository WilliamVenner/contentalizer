-- By Billy
-- Workshop link here
-- https://github.com/WilliamVenner/contentalizer

local findContent
do
	local exts = {"vtf", "vmt", "mp3", "ogg", "wav", "mdl", "phy", "jpg", "jpeg", "png"}
	function findContent(path, dir, state)
		state = state or { foundContent = false, foundMap = false, foundCurMap = false }
		local f, d = file.Find(path .. "*", dir)
		for _, f in ipairs(f) do
			if string.EndsWith(f, ".bsp") then
				state.foundMap = true
				if f:gsub("%.bsp$", "") == game.GetMap() then
					state.foundCurMap = true
				end
			else
				for _, ext in ipairs(exts) do
					if string.EndsWith(f, "." .. ext) then
						state.foundContent = true
					end
				end
			end
		end
		for _, d in ipairs(d) do
			findContent(path .. d .. "/", dir, state)
		end
		return state
	end
end

local print do
	local COLOR_PINK = Color(255, 0, 255)
	local COLOR_WHITE = Color(255, 255, 255)
	local COLOR_BLUE = Color(0, 255, 255)
	function print(color, prefix, title, wsid, suffix)
		MsgC(COLOR_PINK, "[Contentalizer] ", color, prefix, " ", COLOR_BLUE, ("%s (%s)"):format(title, wsid), " ", COLOR_WHITE, suffix, "\n")
	end
end

do
	local COLOR_RED = Color(255, 0, 0)
	local COLOR_GREEN = Color(0, 255, 0)
	for _, addon in SortedPairsByMemberValue(engine.GetAddons(), "title") do
		if addon.wsid and addon.mounted then
			local found = findContent("", addon.title)
			if found.foundCurMap then
				print(COLOR_GREEN, "Adding", addon.title, addon.wsid, "to client Workshop downloads as we're playing this map...")
				resource.AddWorkshop(tostring(addon.wsid))
			elseif found.foundMap then
				print(COLOR_RED, "Ignoring", addon.title, addon.wsid, "because it contains a map file that we aren't playing")
			elseif found.foundContent then
				print(COLOR_GREEN, "Adding", addon.title, addon.wsid, "to client Workshop downloads...")
				resource.AddWorkshop(tostring(addon.wsid))
			end
		end
	end
end