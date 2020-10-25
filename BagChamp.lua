--[[

    This is the beginning of the main file for this Bag addon. 
    Here i will put usefull and relevant information for anyone wanting to take a look
    

--------------------------------------------------------------------------------------

	


        TODO LIST: 
        
        * Add addon information at start of file - 1
        * Count bagspace to use when creating item slots - 2





--------------------------------------------------------------------------------------
]]


--Localization
local L = BagChampLocalization
local bagslots = 112
local numberOfItemSlotsWidth = 12
local numberOfItemSlotsHeight = bagslots / numberOfItemSlotsWidth



--On Load function
function BagChamp_OnLoad(self)
    

    --Set frame size  
    self:SetSize((numberOfItemSlotsWidth * 38) + 20 + (12 * numberOfItemSlotsWidth), (numberOfItemSlotsHeight * 38)+ 70 +(numberOfItemSlotsHeight * 7))

    --Create the item slots
    itemWidth = 1
    self.items = {}
    for idx = 1, bagslots do 
        local item = CreateFrame("Button", "BagChamp_Item" .. idx, self, "BagChampItemTemplate")
        

        self.items[idx] = item
        if idx == 1 then
            item:SetPoint("TOPLEFT", 20, -50)
            itemWidth = itemWidth +1
        elseif itemWidth == numberOfItemSlotsWidth+1 then
            item:SetPoint("TOPLEFT", self.items[idx- numberOfItemSlotsWidth], "BOTTOMLEFT", 0, -7)
            itemWidth = 2
        else 
            item:SetPoint("TOPLEFT", self.items[idx-1], "TOPRIGHT", 12, 0)
            itemWidth = itemWidth +1
        end
    end 

end













