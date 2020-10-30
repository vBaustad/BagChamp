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
local iconSpaceHeight = 2
local iconSpaceWidth = 2
local buttonsize = 39





--Calculate height of the bag
local function BagChamp_CalculateHeight(bagslots, width, spacing, buttonsize)

    rows = math.ceil(bagslots / width)
    return ( rows * buttonsize) + (rows * spacing) +60

end

-- Calculate width of the bag
local function BagChamp_CalculateWidth(bagslots, width, spacing, buttonsize) 

    return (width * buttonsize) + (width * spacing) + 4

end

local function itemTimeNameSort(a, b)
    -- If the two items were looted at the same time
    local aTime = BagChamp_ItemTimes[a.num]
    local bTime = BagChamp_ItemTimes[b.num]
    if aTime == bTime then 
        return a.name < b.name
    else
        return aTime >= bTime
    end
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

    -- Is minimalist option turned on 

    -- Return used slots, free slots, minimalist option true og false

    return totalSlots, freeSlots

end

function BagChamp_Button_OnEnter(self, motion)
    if self.link then
        GameTooltip:SetOwner(self, "ANCHOR_TOPRIGHT")
        GameTooltip:SetHyperlink(self.link)
        GameTooltip:Show()
    end
end

function BagChamp_Button_OnLeave(self, motion)
    GameTooltip:Hide()
end


--On Load function
function BagChamp_OnLoad(self)

    UIPanelWindows["BagChamp"] = {        
        whileDead = 1,
        }
    
    --Get totalSlots and freeSlots
    local totalSlots, freeSlots = BagChamp_CalculateBagslots()   
    

    --Set frame width and height
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
            item:SetPoint("TOPLEFT", 4, -50)
            itemWidth = itemWidth +1
        elseif itemWidth == ItemSlotsWidth+1 then
            item:SetPoint("TOPLEFT", self.items[idx- ItemSlotsWidth], "BOTTOMLEFT", 0, -2)
            itemWidth = 2
        else 
            item:SetPoint("TOPLEFT", self.items[idx-1], "TOPRIGHT", 2, 0)
            itemWidth = itemWidth +1            
        end
    end 

    --Create the filter buttons
    self.filters = {}
    for idx=0, 6 do 
        local button = CreateFrame("CheckButton", "BagChamp_Filter" .. idx, self, "BagChampFilterTemplate")
        SetItemButtonTexture(button, "Interface\\ICONS\\INV_Misc_Gem_Pearl_02")
        self.filters[idx] = button 
        if idx == 0 then
            button:SetPoint("TOPLEFT", 5, -32)
        else
            button:SetPoint("TOPLEFT", self.filters[idx-1], "TOPRIGHT", 2, 0)
        end
        button.icon:SetVertexColor(GetItemQualityColor(idx))
        button:SetChecked(false)
        button.quality = idx
        button.glow:Hide()
    end

    self.filters[-1] = self.filters[0]

    self.bagCounts = {}
    self:RegisterEvent("ADDON_LOADED")
    
end


function BagChamp_Update()

    local totalSlots, freeSlots = BagChamp_CalculateBagslots() 

    local items = {}
    local nameFilter = BagChamp.input:GetText():lower()

    -- Scan through the bag slots, looking for items
    for bag = 0, NUM_BAG_SLOTS do
        for slot = 0, GetContainerNumSlots(bag) do
            local texture, count, locked, quality, readable, lootable, link = GetContainerItemInfo(bag, slot)
            if texture then
                local shown = true

                if BagChamp.qualityFilter then
                    shown = shown and BagChamp.filters[quality]:GetChecked()
                end

                if #nameFilter > 0 then
                    local lowerName = GetItemInfo(link):lower()
                    shown = shown and string.find(lowerName, nameFilter, 1, true)
                end

                if shown then
                    -- If an item is found, grab the item number and store data
                    local itemNum = tonumber(link:match("|Hitem:(%d+):"))
                    if not items[itemNum] then
                    items[itemNum] = {
                    texture = texture,
                    count = count,
                    quality = quality,
                    name = GetItemInfo(link),
                    link = link,
                    num = itemNum,
                    }
                    else
                    -- The item already exists in table, just update the count
                    items[itemNum].count = items[itemNum].count + count
                    end
                end
            end
        end
    end

    --Sort items in table
    local sortTbl = {}
    for link, entry in pairs(items) do
        table.insert(sortTbl, entry) 
    end
    table.sort(sortTbl, itemTimeNameSort)


    --Display items in bag (In order)
    for i = 1, totalSlots do
        button = BagChamp.items[i]
        entry = sortTbl[i]

        if entry then
            --There is an item in this slot
            
            button.link = entry.link
            button.icon:SetTexture(entry.texture)
            if entry.count > 1 then
                button.count:SetText(entry.count)
                button.count:Show()
            else
                button.count:Hide()
            end

            if entry.quality > -1 then 
                button.glow:SetVertexColor(GetItemQualityColor(entry.quality))
                button.glow:Show()
            else
                button.glow:Hide()
            end
            --shows items from filter / show all items if not filtered
            button:Show()
            button.icon:Show()
        else
            --Hides items outside filter
            SetItemButtonTexture(button, "Interface\\PaperDoll\\UI-Backpack-EmptySlot")
            button.glow:Hide()
            button.link = nil
            button.count:Hide()
            --button.icon:Hide()
            
        end 
    end

end

function BagChamp_Filter_OnEnter(self, motion)
    GameTooltip:SetOwner(self, "ANCHOR_TOPRIGHT")
    GameTooltip:SetText(_G["ITEM_QUALITY" .. self.quality .. "_DESC"])
    GameTooltip:Show()
end

function BagChamp_Filter_OnLeave(self, motion)
    GameTooltip:Hide()
end

function BagChamp_Filter_OnClick(self, button)    
    BagChamp.qualityFilter = false
    for idx = 0, 6 do
        local button = BagChamp.filters[idx]
        if button:GetChecked() then
            BagChamp.qualityFilter = true
        end
    end
    BagChamp_Update()    
end

function BagChamp_OnEvent(self, event, ...)
    if event == "ADDON_LOADED" and ... == "BagChamp" then
        if not BagChamp_ItemTimes then
            BagChamp_ItemTimes = {}
        end

        for bag = 0, NUM_BAG_SLOTS do
            -- Use optional flag to skip updating times
            bagChamp_ScanBag(bag, true)
        end

        self:UnregisterEvent("ADDON_LOADED")
        self:RegisterEvent("BAG_UPDATE")

    elseif event == "BAG_UPDATE" then
        local bag = ...
        if bag >= 0 then
            bagChamp_ScanBag(bag)
            if BagChamp:IsVisible() then
                BagChamp_Update()
            end
        end
    end
end
        

function bagChamp_ScanBag(bag, initial)
    if not BagChamp.bagCounts[bag] then
        BagChamp.bagCounts[bag] = {}
    end

    local itemCounts = {}
    for slot = 0, GetContainerNumSlots(bag) do
        local texture, count, locked, quality, readable, lootable, link = GetContainerItemInfo(bag, slot)

        if texture then
            local itemId = tonumber(link:match("|Hitem:(%d+):"))
            if not itemCounts[itemId] then
                itemCounts[itemId] = count
            else
                itemCounts[itemId] = itemCounts[itemId] + count
            end
        end
    end

    if initial then
        for itemId, count in pairs(itemCounts) do
            BagChamp_ItemTimes[itemId] = BagChamp_ItemTimes[itemId] or time()
        end
    else 
        for itemId, count in pairs(itemCounts) do
            local oldCount = BagChamp.bagCounts[bag][itemId] or 0
            if count > oldCount then
                BagChamp_ItemTimes[itemId] = time()
            end 
        end
    end
    
    BagChamp.bagCounts[bag] = itemCounts
end

--Add slash commands
SLASH_BAGCHAMP1 = "/bc"
SLASH_BAGCHAMP2 = "/bagchamp"
SlashCmdList["BAGCHAMP"] = function(msg, editbox)
    BagChamp.input:SetText(msg)
    ShowUIPanel(BagChamp)
end