local carousel = {}
local carouselMetaTable = { __index = carousel }

function carousel.new( x, y, width, height, name )

    local carouselData = {
        slides = {},
        slideCount = nil,
        currentSlide = nil,
        x = nil,
        y = nil,
        width = nil,
        height = nil,
        name = nil
    }

    carouselData.x = x
    carouselData.u = y
    carouselData.width = width
    carouselData.height = height

    carouselData.slideCount = 0

    carouselData.currentSlide = 0

    carouselData.name = name

    return setmetatable( carouselData, carouselMetaTable )
end

function carousel:count()
    return self.slideCount
end

function carousel:getCurrentSlide()
    if (self.currentSlide ~= nil) then
        return self.slides[self.currentSlide]
    else
        return nil
    end
end

function carousel:insertSlide( slide )
    self.slideCount = self.slideCount + 1
    self.slides[self.slideCount] = slide

    if self.slideCount == 1 then
        self.currentSlide = 1
    end

    return true
end

function carousel:showSlide( identificator )
    local identificatorType = type(identificator)

    -- by index
    if identificatorType == "number" then
        self.slides[identificator]:showAllObjects( identificator )
        self.currentSlide = identificator
        return true

        -- by name
    elseif identificatorType == "string" then
        local i
        for i = 1, self.slideCount do
            if self.slides[i].name == identificator then
                self.slides[i]:showAllObjects(i)
                self.currentSlide = i
                return true
            end
        end
    else
        print("Wrong identificator")
    end
    return false
end

function carousel:hideSlide( identificator )
    local identificatorType = type(identificator)

    -- by index
    if identificatorType == "number" then
        self.slides[identificator]:hideAllObjects(identificator)
        return true

        -- by name
    elseif identificatorType == "string" then
        local i
        for i = 1, self.slidesCount do
            if self.slides[i].name == identificator then
                self.slides[i]:hideAllObjects(i)
                return true
            end
        end
    else
        print("Wrong identificator")
    end
    return false
end

function carousel:removeSlide( identificator )
    local identificatorType = type(identificator)

    -- by index
    if identificatorType == "number" then
        self.slides[identificator]:destroy(identificator)
        self.currentSlide = nil
        return true

        -- by name
    elseif identificatorType == "string" then
        local i
        for i = 1, #self.slides do
            if self.slides[i].name == identificator then
                self.slides[i]:destroy(i)
                self.currentSlide = nil
                return true
            end
        end
    else
        print("Wrong identificator")
    end
    return false
end

function carousel:showNextSlide()
    if self.currentSlide < self.slideCount then
        self:hideSlide(self.currentSlide)

        self:showSlide(self.currentSlide + 1)
    end
end

function carousel:showPreviousSlide()
    if self.currentSlide>1 then
        self:hideSlide(self.currentSlide)

        self:showSlide(self.currentSlide - 1)
    end
end

function carousel:destroy()
    local i
    for i = 1, self.slideCount do
        self.slides[i]:destroy(i)
        self.slides[i] = nil
    end
end

return carousel