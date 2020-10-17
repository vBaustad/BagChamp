-- This is the beginning of the main file for this Bagger addon. 
-- Here i will put usefull and relevant information for anyone wanting to take a look
-- this is on my TODO list. 
--------------------------------------------------------------------------------------


function factorial3 (num) 
    local total = 1
    for i=1, num do
        total = total * i
    end
    return total
end

print(factorial3(9))