local slide = {}
local slideMetaTable = { __index = slide }

function slide.new( x, y, width, height, name )

    local slideData = {
        x = nil,
        y = nil,
        width = nil,
        height = nil,
        objectsCount = nil,
        objects = {},
        viewGroup = nil,
        name = nil
    }

    slideData.objectsCount = 0
    slideData.x = x
    slideData.y = y
    slideData.viewGroup = display.newGroup()
    slideData.name = name

    if width>0 then
        slideData.width = width
    else
        print("width == " .. width .. ". It should be greater the 0!")
    end

    if height>0 then
        slideData.height = height
    else
        print("height == " .. height .. ". It should be greater the 0!")
    end

    return setmetatable( slideData, slideMetaTable )
end

function slide:invokeShowingFunctionForObject( objectIdentificator, slideId )

    -- create object if needed
    if self.objects[objectIdentificator].object == nil then
        self.objects[objectIdentificator].object = self.objects[objectIdentificator].createFunction( slideId )
        self.objects[objectIdentificator].object.realX = self.objects[objectIdentificator].object.x
        self.objects[objectIdentificator].object.realY = self.objects[objectIdentificator].object.y
        self.viewGroup:insert(self.objects[objectIdentificator].object) -- add object to viewGroup
    end

    -- calculate object possition
    local objectX = self.objects[objectIdentificator].object.realX
    local objectY = self.objects[objectIdentificator].object.realY
    self.objects[objectIdentificator].object.x = (self.x - self.width * 0.5) + objectX
    self.objects[objectIdentificator].object.y = (self.y - self.height * 0.5) + objectY

    self.objects[objectIdentificator].showFunction( slideId ) -- show object
end

function slide:invokeHidingFunctionForObject( objectIdentificator, slideId )
    print("hidding object: "..objectIdentificator)
    self.objects[objectIdentificator].hideFunction( slideId ) -- hide object
end

function slide:invokeRemovingFunctionForObject( objectIdentificator, slideId )
    self.objects[objectIdentificator].removeFunction( slideId )
    self.objects[objectIdentificator].object = nil
end

function slide:count()
    return self.objectsCount
end

function slide:insertObject( object )

    self.objectsCount = self.objectsCount + 1
    self.objects[self.objectsCount] = object

    return true
end

function slide:showObject( identificator )

    -- show by number
    if type(identificator) == "number" then
        if identificator <= self.objectsCount and identificator>0 then
            self:invokeShowingFunctionForObject(identificator)
            return true
        else
            print("Wrong number of object!")
        end

        -- show by object name
    elseif type(identificator) == "string" then
        local i
        for i = 1, self.objectsCount do
            if self.objects[i].name == identificator then
                self:invokeShowingFunctionForObject(i)
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
            self:invokeHidingFunctionForObject(identificator)
            return true
        else
            print("Wrong number of object!")
        end

        -- hide by object name
    elseif type(identificator) == "string" then
        local i
        for i = 1, self.objectsCount do
            if self.objects[i].name == identificator then
                self:invokeHidingFunctionForObject(i)
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
            self:invokeRemovingFunctionForObject(identificator)
            return true
        else
            print("Wrong object identificator!")
        end

        -- remove by name
    elseif type(identificator) == "string" then
        local i
        for i = 1, self.objectsCount do
            if self.objects[i].name == identificator then
                self:invokeRemovingFunctionForObject(i)
                return true
            end
        end
    else
        print("Wrong object identificator!")
    end

    return false
end

function slide:showAllObjects( slideId )
    local i
    for i = 1, self.objectsCount do
        self:invokeShowingFunctionForObject(i, slideId)
    end
end

function slide:hideAllObjects( slideId )
    local i
    for i = 1, self.objectsCount do
        self:invokeHidingFunctionForObject(i, slideId)
    end
end

function slide:destroy( slideId )
    local i
    for i = 1, self.objectsCount do
        self:invokeRemovingFunctionForObject(i, slideId)
    end
end

return slide