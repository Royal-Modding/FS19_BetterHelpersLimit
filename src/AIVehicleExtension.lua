---${title}

---@author ${author}
---@version r_version_r
---@date 01/02/2021

AIVehicleExtension = {}
AIVehicleExtension.MOD_NAME = g_currentModName

function AIVehicleExtension.prerequisitesPresent(specializations)
    return SpecializationUtil.hasSpecialization(AIVehicle, specializations)
end

function AIVehicleExtension.registerOverwrittenFunctions(vehicleType)
    SpecializationUtil.registerOverwrittenFunction(vehicleType, "startAIVehicle", AIVehicleExtension.startAIVehicle)
    SpecializationUtil.registerOverwrittenFunction(vehicleType, "stopAIVehicle", AIVehicleExtension.stopAIVehicle)
end

function AIVehicleExtension:startAIVehicle(superFunc, ...)
    if not self:getIsAIActive() then
        AIVehicle.addNumHirablesHiredByFarm(self:getOwnerFarmId(), 1)
    end
    superFunc(self, ...)
end

function AIVehicleExtension:stopAIVehicle(superFunc, ...)
    if self:getIsAIActive() then
        AIVehicle.addNumHirablesHiredByFarm(self:getOwnerFarmId(), -1)
    end
    superFunc(self, ...)
end
