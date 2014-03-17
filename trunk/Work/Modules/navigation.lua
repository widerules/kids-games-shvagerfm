local M = {}

M.scenes = {
	scene1 = 2,
	scene2 = 3
}

M.currentScene = nil;

M.next = function()
end

M.prev = function()
end

M.gotoScene = function(sceneName, effect, duration)
end

M.start = function(sceneName)
	if (sceneName) then
		M.currentScene = sceneName;
	end
end


return M