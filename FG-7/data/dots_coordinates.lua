local constants = require("constants")
local koefficient = 0.4*constants.W
local start_coordinates = {
    square = {x = constants.CENTERX - 138/300*koefficient, y = constants.CENTERY - 138/300*koefficient},
    rectangle = {x = constants.CENTERX - 90/300*koefficient, y = constants.CENTERY - 135/300*koefficient},
    circle = {x = constants.CENTERX, y = constants.CENTERY - 135/300*koefficient},
    oval = {x = constants.CENTERX, y = constants.CENTERY - 75/300*koefficient},
    rhombus = {x = constants.CENTERX, y = constants.CENTERY - 157/300*koefficient},
    triangle = {x = constants.CENTERX, y = constants.CENTERY - 138/300*koefficient},
    trapezoid = {x = constants.CENTERX - 85/300*koefficient, y = constants.CENTERY - 91/300*koefficient},
    pentagon = {x = constants.CENTERX, y = constants.CENTERY - 140/300*koefficient},
    hexagon = {x = constants.CENTERX - 70/300*koefficient, y = constants.CENTERY - 123/300*koefficient},
    star = {x = constants.CENTERX + 2/300*koefficient, y = constants.CENTERY - 142/300*koefficient},
    heart = {x = constants.CENTERX + 2/300*koefficient, y = constants.CENTERY - 77/300*koefficient},
    semicircle = {x = constants.CENTERX - 140/300*koefficient, y = constants.CENTERY},
    parallelogram = {x = constants.CENTERX - 115/300*koefficient, y = constants.CENTERY - 67/300*koefficient},
}
local coordinates = {
    --square
    square = {
        {
            x = start_coordinates.square.x,
            y = start_coordinates.square.y,
            xOffset = -30/300*koefficient,                      --offset using for location of dot's name
            yOffset = -30/300*koefficient
        },
        {
            x = start_coordinates.square.x + 276/300*koefficient,
            y = start_coordinates.square.y,
            xOffset = 30/300*koefficient,
            yOffset = -30/300*koefficient
        },
        {
            x = start_coordinates.square.x + 276/300*koefficient,
            y = start_coordinates.square.y + 276/300*koefficient,
            xOffset = 30/300*koefficient,
            yOffset = 30/300*koefficient
        },
        {
            x = start_coordinates.square.x,
            y = start_coordinates.square.y + 276/300*koefficient,
            xOffset = -30/300*koefficient,
            yOffset = 30/300*koefficient
        },
        size = 4
    },
    rectangle = {
        {
            x = start_coordinates.rectangle.x,
            y = start_coordinates.rectangle.y,
            xOffset = -30/300*koefficient,
            yOffset = -30/300*koefficient
        },
        {
            x = start_coordinates.rectangle.x + 170/300*koefficient,
            y = start_coordinates.rectangle.y,
            xOffset = 30/300*koefficient,
            yOffset = -30/300*koefficient
        },
        {
            x = start_coordinates.rectangle.x + 170/300*koefficient,
            y = start_coordinates.rectangle.y + 265/300*koefficient,
            xOffset = 30/300*koefficient,
            yOffset = 30/300*koefficient
        },
        {
            x = start_coordinates.rectangle.x,
            y = start_coordinates.rectangle.y + 265/300*koefficient,
            xOffset = -30/300*koefficient,
            yOffset = 30/300*koefficient
        },
        size = 4
    },
    circle = {
        {
            x = start_coordinates.circle.x,
            y = start_coordinates.circle.y,
            xOffset = 0,
            yOffset = -25/300*koefficient
        },
        {
            x = start_coordinates.circle.x + 75/300*koefficient,
            y = start_coordinates.circle.y + 25/300*koefficient,
            xOffset = 20/300*koefficient,
            yOffset = -25/300*koefficient
        },
        {
            x = start_coordinates.circle.x + 115/300*koefficient,
            y = start_coordinates.circle.y + 65/300*koefficient,
            xOffset = 25/300*koefficient,
            yOffset = -10/300*koefficient
        },
        {
            x = start_coordinates.circle.x + 135/300*koefficient,
            y = start_coordinates.circle.y + 135/300*koefficient,
            xOffset = 25/300*koefficient,
            yOffset = 0
        },
        {
            x = start_coordinates.circle.x + 120/300*koefficient,
            y = start_coordinates.circle.y + 190/300*koefficient,
            xOffset = 25/300*koefficient,
            yOffset = 10
        },
        {
            x = start_coordinates.circle.x + 70/300*koefficient,
            y = start_coordinates.circle.y + 250/300*koefficient,
            xOffset = 20/300*koefficient,
            yOffset = 25/300*koefficient
        },
        {
            x = start_coordinates.circle.x,
            y = start_coordinates.circle.y + 270/300*koefficient,
            xOffset = 5/300*koefficient,
            yOffset = 30/300*koefficient
        },
        {
            x = start_coordinates.circle.x - 70/300*koefficient,
            y = start_coordinates.circle.y + 250/300*koefficient,
            xOffset = -20/300*koefficient,
            yOffset = 25/300*koefficient
        },
        {
            x = start_coordinates.circle.x - 120/300*koefficient,
            y = start_coordinates.circle.y + 190/300*koefficient,
            xOffset = -20/300*koefficient,
            yOffset = 10/300*koefficient
        },
        {
            x = start_coordinates.circle.x - 135/300*koefficient,
            y = start_coordinates.circle.y + 135/300*koefficient,
            xOffset = -25/300*koefficient,
            yOffset = 0
        },
        {
            x = start_coordinates.circle.x - 115/300*koefficient,
            y = start_coordinates.circle.y + 65/300*koefficient,
            xOffset = -25/300*koefficient,
            yOffset = -10/300*koefficient
        },
        {
            x = start_coordinates.circle.x - 75/300*koefficient,
            y = start_coordinates.circle.y + 25/300*koefficient,
            xOffset = -20/300*koefficient,
            yOffset = -25/300*koefficient
        },
        size = 12
    },
    oval = {
        {
            x = start_coordinates.oval.x,
            y = start_coordinates.oval.y,
            xOffset = 0,
            yOffset = -25/300*koefficient
        },
        {
            x = start_coordinates.oval.x + 65/300*koefficient,
            y = start_coordinates.oval.y + 10/300*koefficient,
            xOffset = 20/300*koefficient,
            yOffset = -25/300*koefficient
        },
        {
            x = start_coordinates.oval.x + 105/300*koefficient,
            y = start_coordinates.oval.y + 30/300*koefficient,
            xOffset = 25/300*koefficient,
            yOffset = -10/300*koefficient
        },
        {
            x = start_coordinates.oval.x + 135/300*koefficient,
            y = start_coordinates.oval.y + 83/300*koefficient,
            xOffset = 25/300*koefficient,
            yOffset = 0
        },
        {
            x = start_coordinates.oval.x + 105/300*koefficient,
            y = start_coordinates.oval.y + 136/300*koefficient,
            xOffset = 25/300*koefficient,
            yOffset = 10/300*koefficient
        },
        {
            x = start_coordinates.oval.x + 65/300*koefficient,
            y = start_coordinates.oval.y + 156/300*koefficient,
            xOffset = 20/300*koefficient,
            yOffset = 25/300*koefficient
        },
        {
            x = start_coordinates.oval.x,
            y = start_coordinates.oval.y + 166/300*koefficient,
            xOffset = 5/300*koefficient,
            yOffset = 30/300*koefficient
        },
        {
            x = start_coordinates.oval.x - 65/300*koefficient,
            y = start_coordinates.oval.y + 156/300*koefficient,
            xOffset = -20/300*koefficient,
            yOffset = 25/300*koefficient
        },
        {
            x = start_coordinates.oval.x - 105/300*koefficient,
            y = start_coordinates.oval.y + 136/300*koefficient,
            xOffset = -20/300*koefficient,
            yOffset = 10/300*koefficient
        },
        {
            x = start_coordinates.oval.x - 135/300*koefficient,
            y = start_coordinates.oval.y + 83/300*koefficient,
            xOffset = -25/300*koefficient,
            yOffset = 0
        },
        {
            x = start_coordinates.oval.x - 105/300*koefficient,
            y = start_coordinates.oval.y + 30/300*koefficient,
            xOffset = -25/300*koefficient,
            yOffset = -10/300*koefficient
        },
        {
            x = start_coordinates.oval.x - 65/300*koefficient,
            y = start_coordinates.oval.y + 10/300*koefficient,
            xOffset = -20/300*koefficient,
            yOffset = -25/300*koefficient
        },
        size = 12
    },
    rhombus = {
        {
            x = start_coordinates.rhombus.x,
            y = start_coordinates.rhombus.y,
            xOffset = 0,
            yOffset = -30/300*koefficient
        },
        {
            x = start_coordinates.rhombus.x + 118/300*koefficient,
            y = start_coordinates.rhombus.y + 157/300*koefficient,
            xOffset = 30/300*koefficient,
            yOffset = 0
        },
        {
            x = start_coordinates.rhombus.x,
            y = start_coordinates.rhombus.y + 315/300*koefficient,
            xOffset = 0,
            yOffset = 30/300*koefficient
        },
        {
            x = start_coordinates.rhombus.x - 118/300*koefficient,
            y = start_coordinates.rhombus.y + 157/300*koefficient,
            xOffset = -30/300*koefficient,
            yOffset = 0
        },
        size = 4
    },
    triangle = {
        {
            x = start_coordinates.triangle.x,
            y = start_coordinates.triangle.y,
            xOffset = 0,
            yOffset = -30/300*koefficient
        },
        {
            x = start_coordinates.triangle.x + 147/300*koefficient,
            y = start_coordinates.triangle.y + 260/300*koefficient,
            xOffset = 30/300*koefficient,
            yOffset = 30/300*koefficient
        },
        {
            x = start_coordinates.triangle.x - 147/300*koefficient,
            y = start_coordinates.triangle.y + 260/300*koefficient,
            xOffset = -30/300*koefficient,
            yOffset = 30/300*koefficient
        },
        size = 3
    },
    trapezoid = {
        {
            x = start_coordinates.trapezoid.x,
            y = start_coordinates.trapezoid.y,
            xOffset = -30/300*koefficient,
            yOffset = -30/300*koefficient
        },
        {
            x = start_coordinates.trapezoid.x + 170/300*koefficient,
            y = start_coordinates.trapezoid.y,
            xOffset = 30/300*koefficient,
            yOffset = -30/300*koefficient
        },
        {
            x = start_coordinates.trapezoid.x + 220/300*koefficient,
            y = start_coordinates.trapezoid.y + 182/300*koefficient,
            xOffset = 30/300*koefficient,
            yOffset = 30/300*koefficient
        },
        {
            x = start_coordinates.trapezoid.x - 50/300*koefficient,
            y = start_coordinates.trapezoid.y + 182/300*koefficient,
            xOffset = -30/300*koefficient,
            yOffset = 30/300*koefficient
        },
        size = 4
    },
    pentagon = {
        {
            x = start_coordinates.pentagon.x,
            y = start_coordinates.pentagon.y,
            xOffset = 0,
            yOffset = -30/300*koefficient
        },
        {
            x = start_coordinates.pentagon.x + 135/300*koefficient,
            y = start_coordinates.pentagon.y + 100/300*koefficient,
            xOffset = 30/300*koefficient,
            yOffset = -30/300*koefficient
        },
        {
            x = start_coordinates.pentagon.x + 85/300*koefficient,
            y = start_coordinates.pentagon.y + 258/300*koefficient,
            xOffset = 30/300*koefficient,
            yOffset = 30/300*koefficient
        },
        {
            x = start_coordinates.pentagon.x - 85/300*koefficient,
            y = start_coordinates.pentagon.y + 258/300*koefficient,
            xOffset = -30/300*koefficient,
            yOffset = 30/300*koefficient
        },
        {
            x = start_coordinates.pentagon.x - 135/300*koefficient,
            y = start_coordinates.pentagon.y + 100/300*koefficient,
            xOffset = -30/300*koefficient,
            yOffset = -30/300*koefficient
        },
        size = 5
    },
    hexagon = {
        {
            x = start_coordinates.hexagon.x,
            y = start_coordinates.hexagon.y,
            xOffset = -30/300*koefficient,
            yOffset = -30/300*koefficient
        },
        {
            x = start_coordinates.hexagon.x + 140/300*koefficient,
            y = start_coordinates.hexagon.y,
            xOffset = 30/300*koefficient,
            yOffset = -30/300*koefficient
        },
        {
            x = start_coordinates.hexagon.x + 210/300*koefficient,
            y = start_coordinates.hexagon.y + 125/300*koefficient,
            xOffset = 30/300*koefficient,
            yOffset = -30/300*koefficient
        },
        {
            x = start_coordinates.hexagon.x + 140/300*koefficient,
            y = start_coordinates.hexagon.y + 248/300*koefficient,
            xOffset = 30/300*koefficient,
            yOffset = 30/300*koefficient
        },
        {
            x = start_coordinates.hexagon.x,
            y = start_coordinates.hexagon.y + 248/300*koefficient,
            xOffset = -30/300*koefficient,
            yOffset = 30/300*koefficient
        },
        {
            x = start_coordinates.hexagon.x - 70/300*koefficient,
            y = start_coordinates.hexagon.y + 125/300*koefficient,
            xOffset = -30/300*koefficient,
            yOffset = -30/300*koefficient
        },
        size = 6
    },
    star = {
        {
            x = start_coordinates.star.x,
            y = start_coordinates.star.y,
            xOffset = 0,
            yOffset = -30/300*koefficient
        },
        {
            x = start_coordinates.star.x + 45/300*koefficient,
            y = start_coordinates.star.y + 92/300*koefficient,
            xOffset = 30/300*koefficient,
            yOffset = -30/300*koefficient
        },
        {
            x = start_coordinates.star.x + 145/300*koefficient,
            y = start_coordinates.star.y + 108/300*koefficient,
            xOffset = 30/300*koefficient,
            yOffset = -30/300*koefficient
        },
        {
            x = start_coordinates.star.x + 71/300*koefficient,
            y = start_coordinates.star.y + 176/300*koefficient,
            xOffset = 30/300*koefficient,
            yOffset = 30/300*koefficient
        },
        {
            x = start_coordinates.star.x + 85/300*koefficient,
            y = start_coordinates.star.y + 276/300*koefficient,
            xOffset = 30/300*koefficient,
            yOffset = 30/300*koefficient
        },
        {
            x = start_coordinates.star.x - 5/300*koefficient,
            y = start_coordinates.star.y + 226/300*koefficient,
            xOffset = 0,
            yOffset = 30/300*koefficient
        },
        {
            x = start_coordinates.star.x - 95/300*koefficient,
            y = start_coordinates.star.y + 273/300*koefficient,
            xOffset = -30/300*koefficient,
            yOffset = 30/300*koefficient
        },
        {
            x = start_coordinates.star.x - 73/300*koefficient,
            y = start_coordinates.star.y + 174/300*koefficient,
            xOffset = -30/300*koefficient,
            yOffset = 30/300*koefficient
        },
        {
            x = start_coordinates.star.x - 145/300*koefficient,
            y = start_coordinates.star.y + 102/300*koefficient,
            xOffset = -30/300*koefficient,
            yOffset = -30/300*koefficient
        },
        {
            x = start_coordinates.star.x - 43/300*koefficient,
            y = start_coordinates.star.y + 90/300*koefficient,
            xOffset = -30/300*koefficient,
            yOffset = -30/300*koefficient
        },
        size = 10
    },
    heart = {
        {
            x = start_coordinates.heart.x,
            y = start_coordinates.heart.y,
            xOffset = 0,
            yOffset = -30/300*koefficient
        },
        {
            x = start_coordinates.heart.x + 30/300*koefficient,
            y = start_coordinates.heart.y - 20/300*koefficient,
            xOffset = 0,
            yOffset = -30/300*koefficient
        },
        {
            x = start_coordinates.heart.x + 70/300*koefficient,
            y = start_coordinates.heart.y - 33/300*koefficient,
            xOffset = 0,
            yOffset = -30/300*koefficient
        },
        {
            x = start_coordinates.heart.x + 110/300*koefficient,
            y = start_coordinates.heart.y - 20/300*koefficient,
            xOffset = 0,
            yOffset = -30/300*koefficient
        },
        {
            x = start_coordinates.heart.x + 130/300*koefficient,
            y = start_coordinates.heart.y + 37/300*koefficient,
            xOffset = 30/300*koefficient,
            yOffset = 10/300*koefficient
        },
        {
            x = start_coordinates.heart.x + 110/300*koefficient,
            y = start_coordinates.heart.y + 94/300*koefficient,
            xOffset = 30/300*koefficient,
            yOffset = 20/300*koefficient
        },
        {
            x = start_coordinates.heart.x +60/300*koefficient,
            y = start_coordinates.heart.y + 130/300*koefficient,
            xOffset = 30/300*koefficient,
            yOffset = 20/300*koefficient
        },
        {
            x = start_coordinates.heart.x,
            y = start_coordinates.heart.y + 192/300*koefficient,
            xOffset = 5/300*koefficient,
            yOffset = 30/300*koefficient
        },
        {
            x = start_coordinates.heart.x - 60/300*koefficient,
            y = start_coordinates.heart.y + 130/300*koefficient,
            xOffset = -20/300*koefficient,
            yOffset = 20/300*koefficient
        },
        {
            x = start_coordinates.heart.x - 110/300*koefficient,
            y = start_coordinates.heart.y + 94/300*koefficient,
            xOffset = -30/300*koefficient,
            yOffset = 20/300*koefficient
        },
        {
            x = start_coordinates.heart.x - 130/300*koefficient,
            y = start_coordinates.heart.y + 37/300*koefficient,
            xOffset = -25/300*koefficient,
            yOffset = 0
        },
        {
            x = start_coordinates.heart.x - 110/300*koefficient,
            y = start_coordinates.heart.y - 20/300*koefficient,
            xOffset = -20/300*koefficient,
            yOffset = -20/300*koefficient
        },
        {
            x = start_coordinates.heart.x - 70/300*koefficient,
            y = start_coordinates.heart.y - 33/300*koefficient,
            xOffset = -10/300*koefficient,
            yOffset = -30/300*koefficient
        },
        {
            x = start_coordinates.heart.x - 30/300*koefficient,
            y = start_coordinates.heart.y - 20/300*koefficient,
            xOffset = 0,
            yOffset = -30/300*koefficient
        },
        size = 14
    },
    semicircle = {
        {
            x = start_coordinates.semicircle.x,
            y = start_coordinates.semicircle.y,
            xOffset = -20/300*koefficient,
            yOffset = -20/300*koefficient
        },
        {
            x = start_coordinates.semicircle.x + 280/300*koefficient,
            y = start_coordinates.semicircle.y,
            xOffset = 20/300*koefficient,
            yOffset = -20/300*koefficient
        },
        {
            x = start_coordinates.semicircle.x + 270/300*koefficient,
            y = start_coordinates.semicircle.y + 55/300*koefficient,
            xOffset = 20/300*koefficient,
            yOffset = 20/300*koefficient
        },
        {
            x = start_coordinates.semicircle.x + 230/300*koefficient,
            y = start_coordinates.semicircle.y + 110/300*koefficient,
            xOffset = 20/300*koefficient,
            yOffset = 20/300*koefficient
        },
        {
            x = start_coordinates.semicircle.x + 140/300*koefficient,
            y = start_coordinates.semicircle.y + 140/300*koefficient,
            xOffset = 5/300*koefficient,
            yOffset = 30/300*koefficient
        },
        {
            x = start_coordinates.semicircle.x + 70/300*koefficient,
            y = start_coordinates.semicircle.y + 110/300*koefficient,
            xOffset = -20/300*koefficient,
            yOffset = 20/300*koefficient
        },
        {
            x = start_coordinates.semicircle.x + 30/300*koefficient,
            y = start_coordinates.semicircle.y + 55/300*koefficient,
            xOffset = -20/300*koefficient,
            yOffset = 20/300*koefficient
        },
        size = 7
    },
    parallelogram = {
        {
            x = start_coordinates.parallelogram.x,
            y = start_coordinates.parallelogram.y,
            xOffset = -30/300*koefficient,
            yOffset = -30/300*koefficient
        },
        {
            x = start_coordinates.parallelogram.x + 250/300*koefficient,
            y = start_coordinates.parallelogram.y,
            xOffset = 30/300*koefficient,
            yOffset = -30/300*koefficient
        },
        {
            x = start_coordinates.parallelogram.x + 230/300*koefficient,
            y = start_coordinates.parallelogram.y + 160/300*koefficient,
            xOffset = 30/300*koefficient,
            yOffset = 30/300*koefficient
        },
        {
            x = start_coordinates.parallelogram.x - 20/300*koefficient,
            y = start_coordinates.parallelogram.y + 160/300*koefficient,
            xOffset = -30/300*koefficient,
            yOffset = 30/300*koefficient
        },
        size = 4
    }
}

return coordinates
