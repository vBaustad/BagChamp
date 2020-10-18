--[[

    This is the beginning of the main file for this Bag addon. 
    Here i will put usefull and relevant information for anyone wanting to take a look
    

--------------------------------------------------------------------------------------

	


    TODO: Change name of addon. Bagger is taken
    TODO: Add addon information at start of file





--------------------------------------------------------------------------------------
]]



--Localization
local L = BaggerLocalization

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


