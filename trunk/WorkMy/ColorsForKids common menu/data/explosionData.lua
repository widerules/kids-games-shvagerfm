local SheetInfo = {}

SheetInfo.sheet =
{
    frames = {

        {
            -- Explosion_001
            x=0,
            y=0,
            width=240,
            height=240,

        },
        {
            -- Explosion_002
            x=240,
            y=0,
            width=240,
            height=240,

        },
        {
            -- Explosion_003
            x=480,
            y=0,
            width=240,
            height=240,

        },
        {
            -- Explosion_004
            x=720,
            y=0,
            width=240,
            height=240,

        },
        {
            -- Explosion_005
            x=960,
            y=0,
            width=240,
            height=240,

        },
        {
            -- Explosion_006
            x=0,
            y=240,
            width=240,
            height=240,

        },
        {
            -- Explosion_007
            x=240,
            y=240,
            width=240,
            height=240,

        },
        {
            -- Explosion_008
            x=480,
            y=240,
            width=240,
            height=240,

        },
        {
            -- Explosion_009
            x=720,
            y=240,
            width=240,
            height=240,

        },
        {
            -- Explosion_010
            x=960,
            y=240,
            width=240,
            height=240,

        },
        {
            -- Explosion_011
            x=0,
            y=480,
            width=240,
            height=240,

        },
        {
            -- Explosion_012
            x=240,
            y=480,
            width=240,
            height=240,

        },
        {
            -- Explosion_013
            x=480,
            y=480,
            width=240,
            height=240,

        },
        {
            -- Explosion_014
            x=720,
            y=480,
            width=240,
            height=240,

        },
        {
            -- Explosion_015
            x=960,
            y=480,
            width=240,
            height=240,

        },
        {
            -- Explosion_016
            x=0,
            y=720,
            width=240,
            height=240,

        },
        {
            -- Explosion_017
            x=240,
            y=720,
            width=240,
            height=240,

        },
        {
            -- Explosion_018
            x=480,
            y=720,
            width=240,
            height=240,

        },
        {
            -- Explosion_019
            x=720,
            y=720,
            width=240,
            height=240,

        },
        {
            -- Explosion_020
            x=960,
            y=720,
            width=240,
            height=240,

        },
        {
            -- Explosion_021
            x=0,
            y=960,
            width=240,
            height=240,

        },
        {
            -- Explosion_022
            x=240,
            y=960,
            width=240,
            height=240,

        },
        {
            -- Explosion_023
            x=480,
            y=960,
            width=240,
            height=240,

        },
        {
            -- Explosion_024
            x=720,
            y=960,
            width=240,
            height=240,

        },
        {
            -- Explosion_025
            x=960,
            y=960,
            width=240,
            height=240,

        },
    },

    sheetContentWidth = 2048,
    sheetContentHeight = 2048
}

SheetInfo.frameIndex =
{

    ["Explosion_001"] = 1,
    ["Explosion_002"] = 2,
    ["Explosion_003"] = 3,
    ["Explosion_004"] = 4,
    ["Explosion_005"] = 5,
    ["Explosion_006"] = 6,
    ["Explosion_007"] = 7,
    ["Explosion_008"] = 8,
    ["Explosion_009"] = 9,
    ["Explosion_010"] = 10,
    ["Explosion_011"] = 11,
    ["Explosion_012"] = 12,
    ["Explosion_013"] = 13,
    ["Explosion_014"] = 14,
    ["Explosion_015"] = 15,
    ["Explosion_016"] = 16,
    ["Explosion_017"] = 17,
    ["Explosion_018"] = 18,
    ["Explosion_019"] = 19,
    ["Explosion_020"] = 20,
    ["Explosion_021"] = 21,
    ["Explosion_022"] = 22,
    ["Explosion_023"] = 23,
    ["Explosion_024"] = 24,
    ["Explosion_025"] = 25,
}

function SheetInfo:getSheet()
    return self.sheet;
end

function SheetInfo:getFrameIndex(name)
    return self.frameIndex[name];
end

return SheetInfo