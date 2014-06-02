local slideObject = require( "slideObject" )

local slide = {}

local slideMetaTable = { __index = slide }

local slideData = {
    objectsNames = {},
    objects = {}, -- links to objects
    showingFunctions = {},
    hidingFunctions = {},
    x = 0, y = 0,
    width = 0,
    height = 0,
    objectsCount = 0,
    viewGroup = nil
}

local function invokeShowingFunction( func, objectIdentificator )
    local object = func()

    if slideData.objects[objectIdentificator] == nil then
        slideData.objects[objectIdentificator] = object
    end
    slideData.viewGroup:insert(object)
end

local function invokeHidingFunction( func )
    func()
end

slide.create = function( x, y, width, height )
    slideData.objectsCount = 0

    slideData.x = x
    slideData.y = y

    slideData.viewGroup = display.newGroup()

    if widthValue>0 then
        slideData.width = width
    else
        print("width == " .. width .. ". It should be greater the 0!")
    end

    if heightValue>0 then
        slideData.height = height
    else
        print("height == " .. height .. ". It should be greater the 0!")
    end

    return setmetatable( slideData, slideMetaTable )
end

function slide:count()
    return self.objectsCount
end

function slide:insertObject( showingFunction, hidingFunction, objectName )
    if showingFunction == nil or hidingFunction == nil then
        print("One of the functions is not exist!")
        return false
    else
        self.showingFunctions[self.objectsCount + 1] = showingFunction
        self.hidingFunctions[self.objectsCount + 1] = hidingFunction

        if objectName ~= nil then
            self.objectsNames[self.objectsCount + 1] = objectName;
        end

        self.objectsCount = self.objectsCount + 1

        return true
    end
end

function slide:showObject( identificator )

    -- show by number
    if type(identificator) == "number" then
        if identificator <= self.objectsCount and identificator>0 then
            invokeShowingFunction(self.showingFunctions[identificator], identificator)
            return true
        else
            print("Wrong number of object!")
        end

        -- show by object name
    elseif type(identificator) == "string" then
        local i
        for i = 1, self.objectsCount do
            if self.objectsNames[i] == identificator then
                invokeShowingFunction(self.showingFunctions[i])
                return true
            end
        end
        return false

    else
        print("Wrong object identificator!")
    end
end

function slide:hideObject( identificator )

    -- hide by number
    if type(identificator) == "number" then
        if identificator <= self.objectsCount and identificator>0 then
            invokeHidingFunction(self.hidingFunctions[identificator])
            return true
        else
            print("Wrong number of object!")
        end

        -- hide by object name
    elseif type(identificator) == "string" then
        local i
        for i = 1, self.objectsCount do
            if self.objectsNames[i] == identificator then
                invokeHidingFunction(self.hidingFunctions[i])
                return true
            end
        end
        return false

    else
        print("Wrong object identificator!")
    end
end

function slide:removeObject( identificator )

    -- remove by number
    if type(identificator) == "number" then
        if identificator <= self.objectsCount and identificator>0 then
            invokeHidingFunction(self.hidingFunctions[identificator])
            display.remove( self.objects[identificator] )
            self.objects[identificator] = nil
            return true
        else
            print("Wrong object identificator!")
        end

        -- remove by name
    elseif type(identificator) == "string" then
        local i
        for i = 1, self.objectsCount do
            if self.objectsNames[i] == identificator then
                invokeHidingFunction(self.hidingFunctions[i])
                display.remove( self.objects[i] )
                self.objects[i] = nil
                return true
            end
        end
    else
        print("Wrong object identificator!")
    end

    return false
end

function slide:showAllObjects()
    local i
    for i = 1, self.objectsCount do
        invokeShowingFunction(self.showingFunctions[i])
    end
end

function slide:hideAllObjects()
    local i
    for i = 1, self.objectsCount do
        invokeHidingFunction(self.hidingFunctions[i])
    end
end

function slide:destroy()
    local i
    for i = 1, self.objectsCount do
        invokeHidingFunction(self.hidingFunctions[i])
        self.hidingFunctions[i] = nil
        self.showingFunctions[i] = nil
        self.objectsNames[i] = nil
    end
end

return slide