--
-- Created by IntelliJ IDEA.
-- User: Svyat
-- Date: 20/06/2014
-- Time: 07:49 AM
-- To change this template use File | Settings | File Templates.
--
local class = require "30log"

local Location = class{
    id = 1,
    name = "Location",
    finalText = "Location complete",
    levelCounts = 1,
    image = nil,
    progress = 0,
    status = "closed",
    levelMap = nil
}

Location.__name = "Location"

function Location:__init(tbl)
    self.name = tbl.name
    self.finalText = tbl.txt
    self.image = tbl.image
    self.progress = tbl.progress
    self.status = tbl.status
    self.levelMap = tbl.map
    self.id = tbl.id or 1
    self.levelCounts = tbl.levelCounts or 1
end

return Location