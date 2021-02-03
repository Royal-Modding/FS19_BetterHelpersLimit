---${title}

---@author ${author}
---@version r_version_r
---@date 11/12/2020

InitRoyalUtility(Utils.getFilename("utility/", g_currentModDirectory))
InitRoyalMod(Utils.getFilename("rmod/", g_currentModDirectory))

BetterHelpersLimit = RoyalMod.new(r_debug_r, false)

function BetterHelpersLimit:onUpdate()
    g_currentMission.maxNumHirables = 1
end

function BetterHelpersLimit:onValidateVehicleTypes(vehicleTypeManager, addSpecialization, addSpecializationBySpecialization, addSpecializationByVehicleType, addSpecializationByFunction)
    addSpecializationBySpecialization("aiVehicleExtension", "aiVehicle")
end

AIVehicle.numHirablesHiredByFarm = {}

function AIVehicle.getNumHirablesHiredByFarm(farmId)
    if not AIVehicle.numHirablesHiredByFarm[farmId] then
        AIVehicle.numHirablesHiredByFarm[farmId] = 0
    end
    return AIVehicle.numHirablesHiredByFarm[farmId]
end

function AIVehicle.addNumHirablesHiredByFarm(farmId, add)
    if not AIVehicle.numHirablesHiredByFarm[farmId] then
        AIVehicle.numHirablesHiredByFarm[farmId] = 0
    end
    AIVehicle.numHirablesHiredByFarm[farmId] = math.max(AIVehicle.numHirablesHiredByFarm[farmId] + add, 0)
end

if AIVehicle ~= nil then
    function AIVehicle:getCanStartAIVehicle()
        local spec = self.spec_aiVehicle

        if self:getAIVehicleDirectionNode() == nil then
            return false
        end

        if g_currentMission.disableAIVehicle then
            return false
        end

        if AIVehicle.getNumHirablesHiredByFarm(self:getOwnerFarmId()) >= (g_currentMission.maxNumHirables * 2) then
            return false
        end

        if #spec.aiImplementList == 0 then
            return false
        end

        return true
    end
end

if AIConveyorBelt ~= nil then
    function AIConveyorBelt:getCanStartAIVehicle(superFunc)
        if g_currentMission.disableAIVehicle then
            return false
        end

        if AIVehicle.getNumHirablesHiredByFarm(self:getOwnerFarmId()) >= (g_currentMission.maxNumHirables * 2) then
            return false
        end

        return self.spec_aiConveyorBelt.isAllowed
    end
end
