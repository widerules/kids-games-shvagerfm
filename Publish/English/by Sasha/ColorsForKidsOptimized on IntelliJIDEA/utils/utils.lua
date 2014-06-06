local M = {}

-- find index of element in table by value 
M.indexOf = function(a, value) 
    for i = 1, #a do
        if a[i] == value then
            return i
        end
    end
    return nil
end

return M