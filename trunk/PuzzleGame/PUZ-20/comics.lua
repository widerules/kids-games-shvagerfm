--
-- Created by IntelliJ IDEA.
-- User: Svyat
-- Date: 12/06/2014
-- Time: 11:26 AM
-- To change this template use File | Settings | File Templates.
--


--Таблица для хранения комиксов.
--Комикс - одна картинка, состоящая из 2, 3 или 4 картинок, расположенных квадратом.
--Инициализация комикса производится с помощью вызова ф-ии comics.init(),
--которая принимает в качестве единственного аргумента таблицу с такими полями:
--              imageSrc         - путь к картинке-комиксу
--              nFrames          - количество кадров (2, 3 или 4)
--              listener         - callback, который вызывается по завершению комикса
--              timeShow         - время в миллисекундах, в течение которого кадр будет находиться на экране
--              timeTransition   - время в миллисекундах, в течение которого будет проигрываться
--                                 анимация перехода от одного кадра к другому

--Запуск комикса выполняется с помощью ф-ии comics.start() без аргументов

--          ВНИМАНИЕ!
--  Комиксы должны иметь строго адаптированные размеры для корректного отображения (соотношение 16:9)



local constants = require ("constants")

local comics = {}

--инициализация комикса
function comics.init(_in)
    comics.source = _in.imageSrc
    comics.frames = _in.nFrames
    comics.listener = _in.listener
    comics.timeShow = _in.timeShow
    comics.timeTransition = _in.timeTransition
    return comics
end

--функция завершения комикса
function comics.release()
    if(comics.image ~= nil) then
        display.remove(comics.image)
        comics.image = nil
    end
    if (comics.listener ~= nil) then
        comics.listener()               --вызов callback
    end
end

--функция запуска комикса
function comics.start()
    comics.image = display.newImage(comics.source)
    if (comics.frames == 2) then        --поведение варьируется в зависимости от кол-ва кадров.
                                        -- Возможные варианты: 2, 3 или 4 кадра.
                                        --При кол-ве кадров больше 4 поведение будет таким же, как и у 4.

        local del = comics.timeShow     --задержка для кадров

        comics.image.x = constants.W
        comics.image.y = constants.CENTERY
        comics.image.width = constants.W*2
        comics.image.height = comics.image.width*9/16/2

        transition.to(comics.image, {time = comics.timeTransition, delay = del, x = 0})
        del = del + comics.timeTransition + comics.timeShow

        timer.performWithDelay(del, comics.release)

    elseif(comics.frames == 3) then

        local del = comics.timeShow

        comics.image.x = constants.W
        comics.image.y = constants.H
        comics.image.width = constants.W*2
        comics.image.height = comics.image.width*9/16

        transition.to(comics.image, {time = comics.timeTransition, delay = del, x = 0})
        del = del + comics.timeTransition + comics.timeShow

        transition.to(comics.image, {time = comics.timeTransition, delay = del, x = constants.CENTERX, y = 0})
        del = del + comics.timeTransition + comics.timeShow

        timer.performWithDelay(del, comics.release)

    else

        local del = comics.timeShow

        comics.image.x = constants.W
        comics.image.y = constants.H
        comics.image.width = constants.W*2
        comics.image.height = comics.image.width*9/16

        transition.to(comics.image, {time = comics.timeTransition, delay = del, x = 0})
        del = del + comics.timeTransition + comics.timeShow

        transition.to(comics.image, {time = comics.timeTransition, delay = del, x = constants.W, y = 0})
        del = del + comics.timeTransition + comics.timeShow

        transition.to(comics.image, {time = comics.timeTransition, delay = del, x = 0})
        del = del + comics.timeTransition + comics.timeShow

        timer.performWithDelay(del, comics.release)

    end
end

return comics