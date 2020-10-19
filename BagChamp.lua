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


--On Load function

function BagChamp_OnLoad(self)
    SetPortraitToTexture(self.portrait, "Interface\\ICONS\\INV_Misc_Bag_22")

    --Create the item slots
    self.items = {}
    for idx = 1, 24 do -- TODO 2
        local item = CreateFrame("Button", "BagChamp_Item" .. idx, self, "BagChampItemTemplate")
        self.items[idx] = item
        if idx == 1 then
            item:SetPoint("TOPLEFT", 30, -75)
        elseif idx == 7 or idx == 13 or idx == 19 then
            item:SetPoint("TOPLEFT", self.items[idx-6], "BOTTOMLEFT", 0, -7)
        else 
            item:SetPoint("TOPLEFT", self.items[idx-1], "TOPRIGHT", 12, 0)
        end
    end 
end








-- Test printing straight from locale file
print(L.FRAMES_LOCKED)



--Print to chat when entering/leaving combat
if not MyCombatFrame then
    CreateFrame("Frame", "MyCombatFrame", UIParent)
end

MyCombatFrame:RegisterEvent("PLAYER_REGEN_ENABLED")
MyCombatFrame:RegisterEvent("PLAYER_REGEN_DISABLED")

function MyCombatFrame_OnEvent(self, event, ...)
    if event == "PLAYER_REGEN_ENABLED" then
        print("Leaving Combat...")
    elseif event == "PLAYER_REGEN_DISABLED" then
        print("Entering Combat!")
    end
end

MyCombatFrame:SetScript("OnEvent", MyCombatFrame_OnEvent)


