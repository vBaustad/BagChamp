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
local bagslots = 24
local ItemSlotsWidth = 12
local iconSpaceHeight = 7
local iconSpaceWidth = 12
local buttonsize = 35


--Calculate bagslots
function BagChamp_CalculateBagslots()

    --get number of bagslots from window

    -- Is minimalist option turned on 

    -- get number of used bagslots

    -- substract used slots from # slots

    -- Return used slots, free slots, minimalist option true og false

    var1 = 1
    var2 = 2
    var3 = true

    return var1, var2, var3

end

--Calculate height of the bag
function BagChamp_CalculateHeight(bagslots, width, spacing, buttonsize)

    rows = math.ceil(bagslots / width)
    return ( rows * buttonsize) + (rows * spacing) +70

end

-- Calculate width of the bag
function BagChamp_CalculateWidth(bagslots, width, spacing, buttonsize) 

    return (width * buttonsize) + (width * spacing) + 40

end

--On Load function
function BagChamp_OnLoad(self)


    --testing assigning multiple variables from one call
    var1, var2, var3 = BagChamp_CalculateBagslots()

    print(var1 .. " + " .. var2 .. " ")
    
    local width = BagChamp_CalculateWidth(bagslots, ItemSlotsWidth, iconSpaceWidth, buttonsize)
    local height = BagChamp_CalculateHeight(bagslots, ItemSlotsWidth, iconSpaceHeight, buttonsize)
    
   
    --Set frame size  
    self:SetSize(width, height)

    --Create the item slots
    itemWidth = 1
    self.items = {}
    for idx = 1, bagslots do 
        local item = CreateFrame("Button", "BagChamp_Item" .. idx, self, "BagChampItemTemplate")       

        self.items[idx] = item
        if idx == 1 then
            item:SetPoint("TOPLEFT", 30, -50)
            itemWidth = itemWidth +1
        elseif itemWidth == ItemSlotsWidth+1 then
            item:SetPoint("TOPLEFT", self.items[idx- ItemSlotsWidth], "BOTTOMLEFT", 0, -7)
            itemWidth = 2
        else 
            item:SetPoint("TOPLEFT", self.items[idx-1], "TOPRIGHT", 12, 0)
            itemWidth = itemWidth +1            
        end
    end 

end













