local class = require("30log-master.30log")

local FieldOptions = {
    getFieldValue = function(self) return self.field end,
    setFieldValue = function(self, newValue) self.value = newValue  end
}

local ExampleClass = class {field = "in ES" }
ExampleClass:include(FieldOptions)

-- PROGRESS_BAR class difinition BEGIN
local ProgressBar = class { min = 0, max = 100, progress = 0, field = "in PB" }

ProgressBar:include(FieldOptions)

function ProgressBar:__init(min, max)
    self.min, self.max = min, max
    self.progress = 0
end

function ProgressBar:addProgress(value)
    if (self.progress + value <= self.max) then
        self.progress = self.progress + value
    else
        self.progress = self.max
    end
end

function ProgressBar:removeProgress(value)
    if (self.progress - value >= self.min) then
        self.progress = self.progress - value
    else
        self.progress = self.min
    end
end

ProgressBar.__add = function(pb, value)
    pb:addProgress(value)
    return pb
end

ProgressBar.__sub = function(pb, value)
    pb:removeProgress(value)
    return pb
end

function ProgressBar:tostring()
    return ("Min: "..self.min.."; Max: "..self.max.."; Progress: "..self.progress)
end
-- PROGRESS_BAR class difinition END



-- RESIABLE_PROGRESS_BAR extends PROGRESS_BAR class difinition BEGIN
local ResizeableProgressBar = ProgressBar:extends{ width = 50, height = 20 }

function ResizeableProgressBar:__init(min, max, width, height)
    ResizeableProgressBar.super.__init(self, min, max)
    self.width = width
    self.height = height
    self.field = "in rpb"
end

function ResizeableProgressBar:resize(newWidth, newHeight)
    self.width = newWidth
    self.height = newHeight
end

function ResizeableProgressBar:tostring()
    return (self.super:tostring() .. "; width: ".. self.width.."; height: "..self.height)
end
-- RESIABLE_PROGRESS_BAR END



local myPb = ProgressBar:new(0, 200)
print("new pb: "..myPb:tostring())
myPb:addProgress(1)
print("add 1 using method: "..myPb:tostring())
myPb = myPb - 1
print("remove 1 using operator '-': "..myPb:tostring())
print("field in pb: ", myPb:getFieldValue())


local myRPb = ResizeableProgressBar:new(0, 100, 90, 10)
print("new rpb: "..myRPb:tostring())
myRPb:resize(200, 20)
print("new rpb after resizing: "..myRPb:tostring())
print("field in rpb: ", myRPb:getFieldValue())


local ex = ExampleClass:new()
print("field in ex: ", ex:getFieldValue())
