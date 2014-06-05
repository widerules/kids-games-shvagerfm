local slideObject = {}
local slideObjectMetaTable = { __index = slideObject }

function slideObject.new()

    local slideObjectData = {
        createFunction = nil,
        showFunction = nil,
        hideFunction = nil,
        removeFunction = nil,

        object = nil,
        name = "none",

        realX = nil,
        realY = nil
    }

    return setmetatable( slideObjectData, slideObjectMetaTable )
end

return slideObject