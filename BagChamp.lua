--[[

    This is the beginning of the main file for this Bag addon. 
    Here i will put usefull and relevant information for anyone wanting to take a look
    

--------------------------------------------------------------------------------------

	


        TODO LIST: 
        
        * addon information at start of file
        * searchbar
        * border
        * bag row
        * items to bagslots
        * fetch bagslots
        * fetch items in bags
        * title with character name
        * currency "bar" - Allow more than 3
        * sort function to bags - From top / From bot 
        * Localization
        * settingspage
        * coloring around items for rarity
        * Itemlevel on equippable items
        * close button 
        * move window
        * open window with keybind
        * hide blizzard bags
        * Option to show only used space (with one bagslot showing slots left)
        

        NEXT LEVEL DEV:
        * functionality to make their own sorting and spacing, like arkinventory
        * Switch between character inventories
        * bank and guildbank
        * themes








--------------------------------------------------------------------------------------
]]


-- Set variables
local L = BagChampLocalization
local ItemSlotsWidth = 12
local iconSpaceHeight = 7
local iconSpaceWidth = 7
local buttonsize = 35










--Calculate height of the bag
local function BagChamp_CalculateHeight(bagslots, width, spacing, buttonsize)

    rows = math.ceil(bagslots / width)
    return ( rows * buttonsize) + (rows * spacing) +60

end

-- Calculate width of the bag
local function BagChamp_CalculateWidth(bagslots, width, spacing, buttonsize) 

    return (width * buttonsize) + (width * spacing) + 14

end

local function itemNameSort(a, b)
    return a.name < b.name
end

--Calculate bagslots
function BagChamp_CalculateBagslots()
    
    local freeSlots = 0
    local totalSlots = 0

    for bag = 0, NUM_BAG_SLOTS do
        totalSlots = totalSlots + GetContainerNumSlots(bag)
        for slot = 1, GetContainerNumSlots(bag) do
            local texture = GetContainerItemInfo(bag, slot)            
            if not texture then
                freeSlots = freeSlots +1
            end
        end
    end

    
    print("You have", totalSlots, "slots total in your bags, and", freeSlots, " free slots in your inventory")

    --get number of bagslots from window

    -- Is minimalist option turned on 

    -- get number of used bagslots

    -- substract used slots from # slots

    -- Return used slots, free slots, minimalist option true og false

    return totalSlots, freeSlots

end

--On Load function
function BagChamp_OnLoad(self)
        
    --testing assigning multiple variables from one call
    local totalSlots, freeSlots = BagChamp_CalculateBagslots()   
    
    local width = BagChamp_CalculateWidth(totalSlots, ItemSlotsWidth, iconSpaceWidth, buttonsize)
    local height = BagChamp_CalculateHeight(totalSlots, ItemSlotsWidth, iconSpaceHeight, buttonsize)

    --Set frame size  
    self:SetSize(width, height)

    --Create the item slots
    itemWidth = 1
    self.items = {}
    for idx = 1, totalSlots do 
        local item = CreateFrame("Button", "BagChamp_Item" .. idx, self, "BagChampItemTemplate")       

        self.items[idx] = item
        if idx == 1 then
            item:SetPoint("TOPLEFT", 10, -50)
            itemWidth = itemWidth +1
        elseif itemWidth == ItemSlotsWidth+1 then
            item:SetPoint("TOPLEFT", self.items[idx- ItemSlotsWidth], "BOTTOMLEFT", 0, -7)
            itemWidth = 2
        else 
            item:SetPoint("TOPLEFT", self.items[idx-1], "TOPRIGHT", 7, 0)
            itemWidth = itemWidth +1            
        end
    end 
end


function BagChamp_Update()

    local totalSlots, freeSlots = BagChamp_CalculateBagslots() 

    local items = {}
    -- Scan through the bag slots, looking for items
    for bag = 0, NUM_BAG_SLOTS do
        for slot = 0, GetContainerNumSlots(bag) do
            local texture, count, locked, quality, readable, lootable, link = GetContainerItemInfo(bag, slot)
            if texture then
                -- If found, grab the item number and store other data
                local itemNum = tonumber(link:match("|Hitem:(%d+):"))
                if not items[itemNum] then
                    items[itemNum] = {
                    texture = texture,
                    count = count,
                    quality = quality,
                    name = GetItemInfo(link),
                    link = link,
                    }
                else
                    -- The item already exists in our table, just update the count
                    items[itemNum].count = items[itemNum].count + count
                end
            end
        end
    end

    --Sort items in table
    local sortTbl = {}
    for link, entry in pairs(items) do
        table.insert(sortTbl, entry) 
    end
    table.sort(sortTbl, itemNameSort)


    --Display items in bag (In order)
    for i = 1, totalSlots do
        local button = BagChamp.items[i]
        local entry = sortTbl[i]

        if entry then
            --There is an item in this slot

            button.icon:SetTexture(entry.texture)
            if entry.count > 1 then
                button.count:SetText(entry.count)
                button.count:Show()
            else
                button.count:Hide()
            end

            if entry.quality > -1 then 
                button.glow:SetVertexColor(GetItemQualityColor(4))
                --button.glow:SetVertexColor(GetItemQualityColor(entry.quality))
                button.glow:Show()
            else
                button.glow:Hide()
            end
            button:Show()
        else
            --button:Hide()
        end 
    end

end




