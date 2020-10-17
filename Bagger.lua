-- This is the beginning of the main file for this Bagger addon. 
-- Here i will put usefull and relevant information for anyone wanting to take a look
-- this is on my TODO list. 
--------------------------------------------------------------------------------------
-- Dummy table
tbl = {"Alpha", "beta", "gamma"}

-- Dummy array
guild = {}
table.insert(guild, {
    name = "Cladhaire",
    class = "Rogue",
    level = 80,
})
table.insert(guild, {
    name = "Draoi",
    class = "Druid",
    level = 80,
})
table.insert(guild, {
    name = "Deathsquid",
    class = "Deathknight",
    level = 68,
})


--Convert HEX to RBG
function ConvertHexToRGB(hex)
    local red = string.sub(hex, 1, 2)
    local green = string.sub(hex, 3, 4)
    local blue = string.sub(hex, 5, 6)

    red = tonumber(red, 16) / 255
    green = tonumber(green, 16) / 255
    blue = tonumber(blue, 16) / 255

    return red, green, blue
end

--Print out all args sent to function
function printargs(...)
    local num_args = select("#", ...)
    for i=1, num_args do
        local arg= select( i, ...)
        print(i, arg)
    end
end

---Table sorting
function sortNameFunction(a, b)
    return a.name < b.name 
end

function sortLevelNameAsc(a, b)
    if a.level == b.level then
        return a.name < b.name
    end
    return a.level < b.level
end

table.sort(guild, sortLevelNameAsc)


--Table.Concat(table [, sep [, i [, j]]])
print(table.concat(tbl, ":"))

print(table.concat(tbl, "\n"))

print(table.concat(tbl, ",", 1, 2))


--Table.insert(table, [pos,] value)
-- Insert values into table

table.insert(tbl, "delta")
table.insert(tbl, "epsilon")

print(table.concat(tbl, ", "))

table.insert(tbl, 3, "zeta")

print(table.concat(tbl, ", "))

--Table.maxn(table)
-- Returns the largest positive numerical index of he given table, or zero if the table has no positive numerical indices

tblmaxn = {[1] = "a", [2] = "b", [3] = "c", [26] = "z"}
print(#tbl)

print(table.maxn(tbl))

tbl[91.32] = true
print(table.maxn(tbl))


--Table.removee (table [, pos])
--Removes and element from the given Table

print(table.remove(tbl))
print(table.concat(tbl, ", "))

--Table.sort(table [, comp])
--Sorts the array part of a table by reordering the elements within the same table. Can take function args

table.sort(tbl)
print(table.concat(tbl, ", "))
sortFunc = function(a,b)
    return b < a 
end

table.sort(tbl, sortFunc)
print(table.concat(tbl, ", "))


--Pattern matching
--String.gmatchh(s, pattern)

s = "Hello world from Lua"
for word in string.gmatch( s, "%a+") do
    print(word)
end


t = {}
s = "from=world, to=Lua"
for k, v,x in string.gmatch(s, "(%w+)=(%w+)") do    
    t[k] = v
end
for k, v in pairs(t) do
    print(k, v)
end

--String.gsubb(s, pattern, repl [, n])
-- Returns a copy of input in which all (or the first n, if given) occurrences of the pattern have been replaced by a replacement string specified

print(string.gsub("hello world", "(%w+)", "%1 %1"))

print(string.gsub("hello world", "%w+", "%0 %0", 1))

print(string.gsub("hello Lua", "(%w+)%s*(%w+)", "%2 %1"))

lookupTable = {["hello"] = "hola", ["world"] = "mundo"}
function lookupFunc(pattern)
    return lookupTable[pattern]
end

print(string.gsub("hello world", "(%w+)", lookupTable))