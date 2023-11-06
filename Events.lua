local addonName, ns = ...

local eventFrame = CreateFrame("frame", "EventFrame")
eventFrame:RegisterEvent("PLAYER_ENTERING_WORLD")
eventFrame:RegisterEvent("ENCOUNTER_START")
eventFrame:RegisterEvent("UNIT_TARGET")
eventFrame:RegisterEvent("UPDATE_INSTANCE_INFO")

eventFrame:SetScript("OnEvent", function(self, event, ...)
    if event == "PLAYER_ENTERING_WORLD" then
        ns:PLAYER_ENTERING_WORLD(...)
    elseif event == "ENCOUNTER_START" then
        print('ENCOUNTER START')
    elseif event == "UNIT_TARGET" then
        ns:UNIT_TARGET(...)
    elseif event == "UPDATE_INSTANCE_INFO" then        
    end
end)

function ns:PLAYER_ENTERING_WORLD(isInitialLogin, isReloadingUi)
    print("E:PLAYER_ENTERING_WORLD", isInitialLogin, isReloadingUi)
    if IsInInstance() then
        RequestRaidInfo() -- will trigger UPDATE_INSTANCE_INFO event
    else 
        print('Not in instance')
        --TODO REMOVE THIS, need to hide frame, but give user ability to vewi frames from map icon and settings.
        --self:InitializeBossDropdown(643)
        --self:ShowNote(643, nil, nil) -- show first boss
    end
end

function ns:UNIT_TARGET(unitTarget)
    
    if (UnitExists("target")) then
        local name = UnitName("target") 
        local guid = UnitGUID("target")
        local name = UnitName("target") 
        local class = UnitClass("unit")
        local isEnemy = UnitIsEnemy("player","target")

        if guid then
            --local link = unitLink:format(guid, name) -- clickable link
            local unit_type = strsplit("-", guid)
            if unit_type == "Creature" or unit_type == "Vehicle" then
                local _, _, server_id, instance_id, zone_uid, npc_id, spawn_uid = strsplit("-", guid)
                print(format("[%s] is a creature with NPC ID %d", name, npc_id))
                if isEnemy and self:IsInstanceBoss(instance_id, npc_id) then
                    self:ShowNote(instanceID, npc_id, nil)
                end
            elseif unit_type == "Player" then
                local _, server_id, player_id = strsplit("-", guid)
                print(format("[%s] is a player with ID %s", name, player_id))
            end
	    end
        
    end
end