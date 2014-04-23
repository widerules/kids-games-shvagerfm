-- Settings for Module Game Manager gmanager
local settings = {}

-- list of all games. Just fill names of the scenes with games in right order
settings.gamesOrder = {
    "scenes.game1",
    "scenes.game2",
    "scenes.game3",
    "scenes.game4",
    "scenes.game5",
    "scenes.game6"
}

-- animation type of transition between games
settings.animationOptions = {
    effect = "slideLeft",
    time = 800
}

return settings