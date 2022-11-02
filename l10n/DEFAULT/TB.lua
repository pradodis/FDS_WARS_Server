-- FDS Wars Script by Tsunami 

-- tgtObj is the object with all targets
-- tgtObj.blue -> all blue assets
-- tgtObj.red -> all red assets
-- tgtObj.blue[ZONE_NAME] -> assets inside a given zone

-- teamPoints stores data from all team points

if (FDS ~= nil) then
	env.warning('FDS already created. Exiting...')
	return 0 
end
FDS = {}
env.info('FDS started')

FDS.exportVector = {}
FDS.recordDeliveredPoints = nil
FDS.teamPoints = {}
FDS.playersCredits = {}
FDS.cargoList = {} -- Aircrafts with cargo
FDS.valuableList = {}
FDS.deployedUnits = {} -- All deployed units
FDS.isName = false
FDS.isOnline = true
FDS.isDedicatedServer = true
FDS.zoneSts = {}
FDS.standardTransfer = {10,20,50,100,200,500,1000,2000}
FDS.redZones = {'Red Zone 1','Red Zone 2'}
FDS.blueZones = {'Blue Zone 1','Blue Zone 2'}
FDS.randomDropZones = {'randomDrop_1','randomDrop_2','randomDrop_3','randomDrop_4','randomDrop_5','randomDrop_6','randomDrop_7','randomDrop_8','randomDrop_9','randomDrop_10','randomDrop_11','randomDrop_12','randomDrop_13'}
FDS.redZ1DroneZones = {'Red_Zone_1_Drone_1','Red_Zone_1_Drone_2','Red_Zone_1_Drone_3','Red_Zone_1_Drone_4','Red_Zone_1_Drone_5','Red_Zone_1_Drone_6','Red_Zone_1_Drone_7'}
FDS.dropZones = {}
FDS.activeHovers = {}
FDS.retrievedZones = {}
FDS.entityKills = {}
FDS.killedByEntity = {}
FDS.playersKillRecord = nil 
FDS.dropHeliTypes = {'UH-1H','Mi-8MT','SA342Mistral','Mi-24P'}
FDS.blueRelieveZones = {'Sochi-Adler', 'Gudauta', 'Sukhumi-Babushara', 'Shpora-11', 'Shpora-21', 'Blue_Carrier_K', 'Blue_Carrier_F', 'Blue_Carrier_S', 'Blue_Carrier_T', 'Blue_Carrier_SuperCarrier'}
FDS.redRelieveZones = {'Maykop-Khanskaya', 'Krasnodar-Center', 'Krasnodar-Pashkovsky' ,'Moscow-11','Moscow-21', 'Red_Carrier_K', 'Red_Carrier_F', 'Red_Carrier_S', 'Red_Carrier_T', 'Red_Carrier_SuperCarrier'}
FDS.alliedList = {
	['blue'] = {},
	['red'] = {}
}
FDS.resAWACSTime = {
	['blue'] = {'Blue_AWACS_1', 0},
	['red'] = {'Red_AWACS_1', 0}
}
FDS.resTankerTime = {
	['blue'] = {'Blue_Tanker_1_Cesta', 0},
	['red'] = {'Red_Tanker_1_Cesta', 0}
}
FDS.resMPRSTankerTime = {
	['blue'] = {'Blue_Tanker_1_Haste', 0},
	['red'] = {'Red_Tanker_1_Haste', 0}
}
FDS.currentTransport = {
	['blue'] = {2,''},
	['red'] = {1,''}
}
FDS.lastHits = {}
FDS.currentEngagements = {}
FDS.coalitionCode = {
	[1] = 'blue', 
	[2] = 'red'
}

FDS.trueCoalitionCode = {
	[1] = 'red', 
	[2] = 'blue'
}

for i,j in pairs{'blue','red'} do
	FDS.deployedUnits[j] = {}
	FDS.playersCredits[j] = {}
	FDS.teamPoints[j] = {['Base'] = 0,['Players'] = {}}
	FDS.zoneSts[j] = {}
	if j == 'blue' then
		for _,k in pairs(FDS.blueZones) do
			FDS.zoneSts[j][k] = 'Hot'
		end
	else
		for _,k in pairs(FDS.redZones) do
			FDS.zoneSts[j][k] = 'Hot'
		end
	end
end

FDS.redTgt = {'Red_Inf_AK','Red_Inf_RPG','Red_Arm_BMP1','Red_Arm_BMP2','Red_Arm_T55','Red_Arm_T72','Red_Arm_T80','Red_AAA','Red_AA_Igla','Red_AA_Strela1','Red_AA_Strela2','Red_AA_Tung','Red_SAM','Red_STrucks'}

FDS.blueTgt = {'blue_Inf_AK','blue_Inf_RPG','blue_Arm_BMP1','blue_Arm_BMP2','blue_Arm_T55','blue_Arm_T72','blue_Arm_T80','blue_AAA','blue_AA_Igla','blue_AA_Strela1','blue_AA_Strela2','blue_AA_Tung','blue_SAM','blue_STrucks'}

FDS.uCat = {}
FDS.uCat.LongRangeAA = {"SA-11 Buk CC 9S470M1","SA-11 Buk LN 9A310M1","SA-11 Buk SR 9S18M1"}
FDS.uCat.MedRangeAA = {"2S6 Tunguska","SA-18 Igla-S manpad","Strela-1 9P31","Strela-10M3","ZSU-23-4 Shilka"}
FDS.uCat.Armor = {"BMP-1","BMP-2","T-55","T-72B","T-80UD","Ural-375"}
FDS.uCat.Infantry = {"Paratrooper AKS-74","Paratrooper RPG-16"}

-- Config
FDS.wtime = 1
FDS.randomDropLimit = 2
FDS.callCost = 1000.
FDS.distMin = 50.
FDS.numberZones = 45
--FDS.exportPath = lfs.currentdir() .. 'fdsServerData\\'
FDS.exportPath = 'C:\\fdsServerData\\'
FDS.killEventNumber = 0
FDS.killEventVector = {}
FDS.sendDataFreq = 1.0
FDS.exportDataSite = true -- use false for non-multiplayer games
FDS.errorLogMis = true

-- Rewards
FDS.playerReward = 250.0
FDS.enemyReward = 30.0
FDS.fuelReward = 75.0
FDS.shelterReward = 100.0
FDS.commandPostReward = 100.0
FDS.escortReward = 75.0
FDS.cargoReward = 50.0
FDS.infAKReward = 2.0
FDS.infRPGReward = 4.0

FDS.rewardDict = {
	['.Command Center'] = FDS.commandPostReward,
	['Shelter'] = FDS.shelterReward,
	['Fuel tank'] = FDS.fuelReward,
	['FA-18C_hornet'] = FDS.escortReward,
	['C-130'] = FDS.cargoReward,
	['Paratrooper AKS-74'] = FDS.infAKReward,
	['Paratrooper RPG-16'] = FDS.infRPGReward,
	['Infantry AK ver3'] = FDS.infAKReward,
	['Soldier M249'] = FDS.infAKReward,
	['Default'] = FDS.enemyReward
}

-- Transport
FDS.refreshTime = 2400.
FDS.squadSize = 4
FDS.rewardCargo = 50.
FDS.firstGroupTime = 300.0
FDS.lastDropTime = {
	['blue'] = -(FDS.refreshTime - FDS.firstGroupTime),
	['red'] = -(FDS.refreshTime - FDS.firstGroupTime) 
} 

-- Bombers
FDS.bomberQuantity = 10
FDS.bomberMinInterval = 10.0
FDS.bomberTargetsNumber = 16
FDS.bomberQty = {
	['blue'] = 0,
	['red'] = 0
}

-- AWACS Respawn
FDS.respawnAWACSTime = 1200.0
FDS.fuelAWACSRestart = 14400.0

-- Tanker Respawn
FDS.respawnTankerTime = 600.0
FDS.fuelTankerRestart = 14400.0

-- DropZones
FDS.randomDropValue = 100.
FDS.randomDropTime = 300.
FDS.hoveringAltitude = 100.0
FDS.hoveringRadius = 150.0
FDS.velocityLimit = 10.0
FDS.hoveringResolution = 18
FDS.refreshScan = 2.0
FDS.hoveringTotalTime = 10.0
FDS.positionHist = {}

-- Units per Zone
FDS.InfAK = 17
FDS.InfRPG = 17

FDS.ArmTrucks = 5
FDS.ArmBMP1 = 2
FDS.ArmBMP2 = 2
FDS.ArmT55 = 2
FDS.ArmT72 = 2
FDS.ArmT80 = 2

FDS.AAA = 2
FDS.AATung = 1
FDS.AAStrela1 = 0
FDS.AAStrela2 = 1
FDS.AAIgla = 3
FDS.AATor = 1
FDS.SAM = 0

FDS.unitsInZones = {}
FDS.countUCat = {}
FDS.unitsInZone = {}

FDS.blueunitsInZones = {}
FDS.bluecountUCat = {}
FDS.blueunitsInZone = {}

-- FARP Logic
FDS.farpOwner = {}
FDS.farpEverCaptured = false
FDS.refreshFARPScan = 5.0
FDS.dropLimitAlt = 10.0
FDS.dropSpeedLimit = 0.5
FDS.timeProbe = 0.5
FDS.farpCoalition = 0
function checkIfEmpty(arg)
	if #arg > 0 then
		return false
	else
		return true
	end
end
function checkIfNotEmpty(arg)
	if #arg > 0 then
		return true
	else
		return false
	end
end
FDS.actionOption = {
	['loadCargo'] = {'pick', checkIfNotEmpty, "You are not in your helipad/airfield."},
	['dropTroops'] = {'disable', checkIfEmpty, "You cannot deploy troops here (too close from an enemy helipad/airfield)."},
	['loadValuableGoods'] = {'goods', checkIfNotEmpty, "You are not in the advanced FARP to load the goods."},
	['deliverGoods'] = {'deliver', checkIfNotEmpty, "You cannot deliver goods here (too far from an allied helipad/airfield)."}
}
FDS.coalitionAceptZones = {
	['blue'] = {
		['pick'] = {'Blue_PickZone_1', 'Blue_PickZone_2'}, 
		['disable'] = {'blueTroopsNotAllowed_1', 'blueTroopsNotAllowed_2', 'blueTroopsNotAllowed_3', 'blueTroopsNotAllowed_4', 'blueTroopsNotAllowed_5'},
		['goods'] = {'Mid_Helipad_Load'},
		['deliver'] = {'Blue_PickZone_1', 'Blue_PickZone_2'}},
	['red'] = {
		['pick'] = {'Red_PickZone_1', 'Red_PickZone_2'}, 
		['disable'] = {'redTroopsNotAllowed_1', 'redTroopsNotAllowed_2', 'redTroopsNotAllowed_3', 'redTroopsNotAllowed_4'},
		['goods'] = {'Mid_Helipad_Load'},
		['deliver'] = {'Red_PickZone_1', 'Red_PickZone_2'}}
	}
-- Credits Logic
FDS.bypassPlace = false
FDS.bypassSpeed = false
FDS.bypassAlt = false
FDS.bypassCredits = false
-- Position
FDS.dropDistance = 15
FDS.dropTroopDistance = 6
FDS.advanceDistance = 10
--Mass
FDS.soldierWeight = 80 -- kg
FDS.kitWeight = 20 -- kg
FDS.riffleWeight = 5 -- kg
FDS.manpadWeight = 18 -- kg
FDS.rpgWeight = 7.6 -- kg
FDS.mgWeight = 10 -- kg
FDS.ammoWeight = 50 -- kg
FDS.AAAWeigth = 500 -- kg
FDS.ShilkaWeight = 1500 -- kg
FDS.StrelaWeight = 1500 -- kg
FDS.TunguskaWeight = 3000 -- kg
FDS.TORWeight = 3000 -- kg
FDS.ammoWeight = 500 -- kg
FDS.JTACWeight = 250 -- kg
FDS.minAltitude = 11000.0
FDS.maxAltitude = 22000.0
FDS.goldenBars = {
	['weight'] = 150,
	['value'] = 40,
	['slots'] = 1
}
FDS.laserCodes = {
	['default'] = '1688',
	['su25T'] = '1113'
}
FDS.validLaserDigits={
	{'5','6','7'},
	{'1','2','3','4','5','6','7','8'},
	{'1','2','3','4','5','6','7','8'}
}
FDS.airSupportAssets = {
	{name = "Mig-19", cost = 500, groupName = "_AS_LVL1"},
	{name = "Mig-23", cost = 750, groupName = "_AS_LVL2"},
	{name = "Mig-29", cost = 1000, groupName = "_AS_LVL3"}
	--{name = "JTAC UAV", cost = 300, groupName = "_Spy_Drone", deafultCode = '1688', su25TCode = '1113'}
}
FDS.heliSlots = {
	['UH-1H'] = 12,
	['Mi-8MT'] = 22,
	['SA342Mistral'] = 2,
	['Mi-24P'] = 8
}
FDS.troopAssetsNumbered = {
	{name = "AK Soldier", cost = 15, mass = {FDS.soldierWeight, FDS.kitWeight, FDS.riffleWeight}, slots = 1, variability = {{90,120}}},
	{name = "MG Soldier", cost = 30, mass = {FDS.soldierWeight, FDS.kitWeight, FDS.mgWeight}, slots = 1, variability = {{90,120}}},
	{name = "RPG Soldier", cost = 80, mass = {FDS.soldierWeight, FDS.kitWeight, FDS.rpgWeight}, slots = 1, variability = {{90,120}}},
	{name = "Igla", cost = 150, mass = {FDS.soldierWeight, FDS.kitWeight, FDS.manpadWeight}, slots = 1, variability = {{90,120}}},
	--{name = "JTAC Team", cost = 250, mass = {FDS.JTACWeight, FDS.soldierWeight, FDS.soldierWeight}, slots = 2, variability = {nil,{90,120},{90,120}}, deafultCode = '1688', su25TCode = '1113'},
	{name = "Shilka", cost = 200, mass = {FDS.ShilkaWeight}, slots = 5, variability = {}},
	{name = "Strela", cost = 300, mass = {FDS.StrelaWeight}, slots = 5, variability = {}},
	{name = "Tunguska", cost = 600, mass = {FDS.TunguskaWeight}, slots = 10, variability = {}},
	{name = "TOR", cost = 600, mass = {FDS.TORWeight}, slots = 10, variability = {}},
	{name = "Ammo", cost = 80, mass = {FDS.ammoWeight}, slots = 2, variability = {}}
}
FDS.troopAssets = {}
for _, i in pairs(FDS.troopAssetsNumbered) do
	FDS.troopAssets[i.name] = i
end
FDS.airSupportAssetsKeys = {}
for _, i in pairs(FDS.airSupportAssets) do
	FDS.airSupportAssetsKeys[i.name] = i
end

-- Starting event file
if FDS.exportDataSite then
	lfs.mkdir(FDS.exportPath)
	local file = io.open(FDS.exportPath .. "killRecord.json", "w")
	file:write(nil)
	file:close()
end
if FDS.errorLogMis then
	lfs.mkdir(FDS.exportPath)
	local file = io.open(FDS.exportPath .. "missionError.log", "w")
	file:write(nil)
	file:close()
end

-- Switch
function FDS.switch(t,p)
  t.case = function (self,x,p)
    local f=self[x] or self.default
    if f then
      if type(f)=="function" then
		local isOk, message = pcall(f,x, p, self)
        if not isOk then
			local func = " - ? - "
			for i,v in pairs(getfenv(0)) do
				if v == f then
					func = i
				end
			end
			local infile = io.open(FDS.exportPath .. "missionError.log", "a")
			if infile ~= nil then
				local instr = infile:write("Error! At time: Day: " .. os.date("%d") .. "/" .. os.date("%m") .. "/" .. os.date("%y") .. " - Hour: " .. os.date("%H") .. ":" .. os.date("%M") .. ":" .. os.date("%S") .. " - Func: " .. func .. "\n" .. message .. "\n")
				infile:close()
			end
		end
      else
        error("case "..tostring(x).." not a function")
      end
    end
  end
  return t
end

function protectCall(f,arg)
	local isOk, message = pcall(f,arg)
	if not isOk then
        local func = " - ? - "
        for i,v in pairs(getfenv(0)) do
            if v == f then
                func = i
            end
        end
		local infile = io.open(FDS.exportPath .. "missionError.log", "a")
		local instr = infile:write("Error! At time: Day: " .. os.date("%d") .. "/" .. os.date("%m") .. "/" .. os.date("%y") .. " - Hour: " .. os.date("%H") .. ":" .. os.date("%M") .. ":" .. os.date("%S") .. " - Func: " .. func .. "\n" .. message .. "\n")
		infile:close()
	end
end

function FDS.retrieveUcid(arg,name)
	local gpUcid = ""
	local activePlayerList = net.get_player_list()
	for _, i in pairs(activePlayerList) do
		local playerData = net.get_player_info(i)
		if playerData.name == arg then
			gpUcid = playerData.ucid
		end
	end
	if name then
		return arg
	else
		return gpUcid
	end
end

function FDS.checkPlayerOnline(arg,name,online)
	local gpMsg = ""
	local activePlayerList = net.get_player_list()	
	if online then
		for _, i in pairs(activePlayerList) do
			local playerData = net.get_player_info(i)
			if not name and playerData.ucid == arg then
				for i,j in pairs(mist.DBs.humansByName) do
					if Unit.getByName(i) and Unit.getByName(i):getPlayerName() then
						if Unit.getByName(i):getPlayerName() == playerData.name then
							gpMsg = Unit.getByName(i):getGroup()
						end
					end
				end
			else
				for i,j in pairs(mist.DBs.humansByName) do
					if Unit.getByName(i) and Unit.getByName(i):getPlayerName() then
						if Unit.getByName(i):getPlayerName() == arg then
							gpMsg = Unit.getByName(i):getGroup()
						end
					end
				end
			end
		end
	else
		for i,j in pairs(mist.DBs.humansByName) do
			if Unit.getByName(i) and Unit.getByName(i):getPlayerName() then
				if Unit.getByName(i):getPlayerName() == arg then
					gpMsg = Unit.getByName(i):getGroup()
				end
			end
		end		
	end
	return gpMsg
end

function calculateWeight(unit)
	local usedSlots = 0
	local totalInternalMass = 0
	for _, i in pairs(FDS.cargoList[tostring(unit:getName())]) do
		usedSlots = usedSlots + i.slot
		totalInternalMass = totalInternalMass + i.mass
	end
	for _, i in pairs(FDS.valuableList[tostring(unit:getName())]) do
		usedSlots = usedSlots + i.slot
		totalInternalMass = totalInternalMass + i.mass
	end
	return {usedSlots, totalInternalMass}
end

function FDS.loadCargo(gp)
	local cycle = true
	for repetition = 1,gp[3],1 do
		local myUni = gp[1]:getUnits()[1]
		local totalMass = 0
		local totalInternalMass = 0
		for i,j in pairs(FDS.troopAssets[gp[2]].mass) do
			if FDS.troopAssets[gp[2]].variability[i] then
				totalMass = totalMass + j*(math.random(FDS.troopAssets[gp[2]].variability[i][1],FDS.troopAssets[gp[2]].variability[i][2])/100)
			else
				totalMass = totalMass + j
			end		
		end
		if FDS.cargoList[tostring(gp[1]:getName())] == nil then
			FDS.cargoList[tostring(gp[1]:getName())] = {} 
		end
		--local usedSlots = 0
		--totalInternalMass = totalMass
		--for _, i in pairs(FDS.cargoList[tostring(gp[1]:getName())]) do
		--	usedSlots = usedSlots + i.slot
		--	totalInternalMass = totalInternalMass + i.mass
		--end
		usedSlots, totalInternalMass = unpack(calculateWeight(gp[1]:getUnits()[1]))
		totalInternalMass = totalInternalMass + totalMass
		local gpUcid = FDS.retrieveUcid(gp[1]:getUnits()[1]:getPlayerName(),FDS.isName)
		local msg = {}
		msg.displayTime = 5
		if (usedSlots + FDS.troopAssets[gp[2]].slots) <= FDS.heliSlots[myUni:getDesc().typeName] and (FDS.playersCredits[FDS.trueCoalitionCode[gp[1]:getCoalition()]][gpUcid] >= FDS.troopAssets[gp[2]].cost or FDS.bypassCredits) then
			if gp[2] == "JTAC Team" then
				table.insert(FDS.cargoList[tostring(gp[1]:getName())], {name = FDS.troopAssets[gp[2]].name, mass = totalMass, slot = FDS.troopAssets[gp[2]].slots, code = gp[4]})
			else
				table.insert(FDS.cargoList[tostring(gp[1]:getName())], {name = FDS.troopAssets[gp[2]].name, mass = totalMass, slot = FDS.troopAssets[gp[2]].slots})
			end
			trigger.action.setUnitInternalCargo(myUni:getName(),totalInternalMass)
			FDS.playersCredits[FDS.trueCoalitionCode[gp[1]:getCoalition()]][gpUcid] = FDS.playersCredits[FDS.trueCoalitionCode[gp[1]:getCoalition()]][gpUcid] - FDS.troopAssets[gp[2]].cost
			msg.text = FDS.troopAssets[gp[2]].name .. " loaded in the helicopter. It weighs " .. tostring(totalMass) .. " kg.\nTotal internal mass: " .. tostring(totalInternalMass) .. " kg. Slots Available: " .. tostring(FDS.heliSlots[myUni:getDesc().typeName] - usedSlots - 1) .. ". \nRemaining Credits: $" .. tostring(FDS.playersCredits[FDS.trueCoalitionCode[gp[1]:getCoalition()]][gpUcid])
		else
			if (FDS.playersCredits[FDS.trueCoalitionCode[gp[1]:getCoalition()]][gpUcid] <= FDS.troopAssets[gp[2]].cost and not FDS.bypassCredits) then
				msg.text = "Insuficient credits."
			else
				msg.text = "No slots are available in the helicopter."
			end
			cycle = false			
		end
		msg.sound = 'fdsTroops.ogg'
		trigger.action.outTextForGroup(gp[1]:getID(),msg.text,msg.displayTime)
		trigger.action.outSoundForGroup(gp[1]:getID(),msg.sound)
		if not cycle then
			break
		end
	end
end

function FDS.loadValuableGoods(gp)
	local cycle = true
	for repetition = 1,gp[3],1 do
		local myUni = gp[1]:getUnits()[1]
		local totalInternalMass = 0
		--totalInternalMass = totalMass
		--local usedSlots = 0
		--for _, i in pairs(FDS.cargoList[tostring(gp[1]:getName())]) do
		--	usedSlots = usedSlots + i.slot
		--	totalInternalMass = totalInternalMass + i.mass
		--end
		usedSlots, totalInternalMass = unpack(calculateWeight(gp[1]:getUnits()[1]))
		totalInternalMass = totalInternalMass + FDS.goldenBars.weight
		local msg = {}
		msg.displayTime = 5
		if usedSlots <= FDS.heliSlots[myUni:getDesc().typeName] then
			table.insert(FDS.valuableList[tostring(gp[1]:getName())], {name = "Valuable Goods", mass = FDS.goldenBars.weight, slot = FDS.goldenBars.slots})
			trigger.action.setUnitInternalCargo(myUni:getName(),totalInternalMass)
			msg.text = "Goods loaded in the helicopter. They weigh " .. tostring(FDS.goldenBars.weight) .. " kg.\nTotal internal mass: " .. tostring(totalInternalMass) .. " kg. Slots Available: " .. tostring(FDS.heliSlots[myUni:getDesc().typeName] - usedSlots - 1) .. ". \n"
			msg.sound = 'fdsTroops.ogg'
		else
			msg.text = "No slots are available in the helicopter."
			msg.sound = 'fdsTroops.ogg'
			cycle = false			
		end		
		trigger.action.outTextForGroup(gp[1]:getID(),msg.text,msg.displayTime)
		trigger.action.outSoundForGroup(gp[1]:getID(),msg.sound)
		if not cycle then
			break
		end
	end
end

function FDS.cargoStatus(gp)
	local totalMass = 0
	local occupiedSlots = 0
	local freeSlots = 0
	local slotList = ""
	if FDS.cargoList[tostring(gp[1]:getName())] ~= nil then
		slotList = slotList .. "\n-------- Troops --------\n\n"
		for i,j in pairs(FDS.cargoList[tostring(gp[1]:getName())]) do
			totalMass = totalMass + j.mass
			occupiedSlots = occupiedSlots + j.slot
			slotList = slotList .. "Slot " .. tostring(i) .. ": " .. j.name .. " - Mass: " .. j.mass .. " kg.\n"
		end
	end
	if FDS.valuableList[tostring(gp[1]:getName())] ~= nil then	
		slotList = slotList .. "\n-------- Valuable Goods --------\n\n"
		for i,j in pairs(FDS.valuableList[tostring(gp[1]:getName())]) do
			totalMass = totalMass + j.mass
			occupiedSlots = occupiedSlots + j.slot
			slotList = slotList .. "Slot " .. tostring(i) .. ": " .. j.name .. " - Mass: " .. j.mass .. " kg.\n"
		end
	end
	freeSlots = FDS.heliSlots[gp[1]:getUnits()[1]:getDesc().typeName] - occupiedSlots
	local msg = {}
	msg.text = "*** Internal Cargo Status *** \n"
	msg.text = msg.text .. "Total Internal Mass: " .. tostring(totalMass) .. " kg.\n"
	msg.text = msg.text .. "Free Slots: " .. tostring(freeSlots) .. ".\n\nSlot Order: \n"
	if occupiedSlots > 0 then
		msg.text = msg.text .. slotList
	end
	msg.displayTime = 10
	msg.sound = 'Welcome.ogg'
	trigger.action.outTextForGroup(gp[1]:getID(),msg.text,msg.displayTime)
	trigger.action.outSoundForGroup(gp[1]:getID(),msg.sound)
end

function FDS.validateDropBoard(args)
	local heliPos1 = args.rawData[1]:getUnits()[1]:getPosition()
	local probeTime1 = timer.getTime()
	local terrainAlt = land.getHeight({x = heliPos1.p.x, y = heliPos1.p.z})
	if heliPos1.p.y-terrainAlt <= FDS.dropLimitAlt or FDS.bypassAlt then
		mist.scheduleFunction(FDS.validateSpeed,{{['firstObject'] = args, ['firstPos'] = heliPos1}},timer.getTime()+FDS.timeProbe)
		return true
	else
		local msg = {}
		msg.displayTime = 5
		msg.text = "You are in flight. Land the aircraft first."
		msg.sound = 'fdsTroops.ogg'
		trigger.action.outTextForGroup(args.rawData[1]:getID(),msg.text,msg.displayTime)
		trigger.action.outSoundForGroup(args.rawData[1]:getID(),msg.sound)
		return false
	end
end

function FDS.validateSpeed(args)
	local actorCoalition = args.firstObject.rawData[1]:getCoalition()
	local heliPos2 = args.firstObject.rawData[1]:getUnits()[1]:getPosition()
	local probeTime2 = timer.getTime()
	local currentSpeed = math.sqrt((heliPos2.p.x-args.firstPos.p.x)^2 + (heliPos2.p.z-args.firstPos.p.z)^2)
	if currentSpeed < FDS.dropSpeedLimit or FDS.bypassSpeed then
		local disabledZone = mist.getUnitsInZones({args.firstObject.rawData[1]:getUnits()[1]:getName()},FDS.coalitionAceptZones[FDS.trueCoalitionCode[actorCoalition]][FDS.actionOption[args.firstObject.dropCaseString][1]],'cylinder')
		if FDS.actionOption[args.firstObject.dropCaseString][2](disabledZone) or FDS.bypassPlace then
			if args.firstObject.dropCaseString == 'loadValuableGoods' then 
				if FDS.farpCoalition == actorCoalition then
					args.firstObject.dropCase(args.firstObject.rawData)
				else
					local msg = {}
					msg.displayTime = 5
					msg.text = "You must take control of the FARP before loading goods."
					msg.sound = 'fdsTroops.ogg'
					trigger.action.outTextForGroup(args.firstObject.rawData[1]:getID(),msg.text,msg.displayTime)
					trigger.action.outSoundForGroup(args.firstObject.rawData[1]:getID(),msg.sound)
				end
			else
				args.firstObject.dropCase(args.firstObject.rawData)
			end
		else
			local msg = {}
			msg.displayTime = 5
			msg.text = FDS.actionOption[args.firstObject.dropCaseString][3]
			msg.sound = 'fdsTroops.ogg'
			trigger.action.outTextForGroup(args.firstObject.rawData[1]:getID(),msg.text,msg.displayTime)
			trigger.action.outSoundForGroup(args.firstObject.rawData[1]:getID(),msg.sound)
		end
		return true
	else
		local msg = {}
		msg.displayTime = 5
		msg.text = "You are moving. Stop the aircraft."
		msg.sound = 'fdsTroops.ogg'
		trigger.action.outTextForGroup(args.firstObject.rawData[1]:getID(),msg.text,msg.displayTime)
		trigger.action.outSoundForGroup(args.firstObject.rawData[1]:getID(),msg.sound)
		return false
	end
end

function FDS.dropTroops(args)
	local msg = {}
	local elementNumber = 1
	local numberAdjust = 0
	local usedSlots = 0
	local totalInternalMass = 0
	--for _, i in pairs(FDS.cargoList[tostring(args[1]:getName())]) do
	--	usedSlots = usedSlots + i.slot
	--	totalInternalMass = totalInternalMass + i.mass
	--end
	iterationNumber = 0
	if args[2] == -1 then
		iterationNumber = #FDS.cargoList[tostring(args[1]:getName())]
	else
		iterationNumber = args[2]
	end
	if #FDS.cargoList[tostring(args[1]:getName())] > 0 then
		for i = 1, iterationNumber, 1 do
			usedSlots, totalInternalMass = unpack(calculateWeight(args[1]:getUnits()[1]))
			local dropPoint = args[1]:getUnits()[1]:getPosition().p
			local headingDev = args[1]:getUnits()[1]:getPosition().x
			local adjHeading = 0
			local compz = 0
			local compx = 0
			local degreeHeading = math.atan2(headingDev.z, headingDev.x)*57.2958
			if degreeHeading < 0 then
				degreeHeading = 360 + degreeHeading
			end
			varDeg = 90
			if degreeHeading + varDeg > 360 then
				adjHeading = degreeHeading + varDeg - 360
			elseif degreeHeading + varDeg < 0 then
				adjHeading = degreeHeading + varDeg + 360
			else
				adjHeading = degreeHeading + varDeg
			end
			compz = math.sqrt(1/((math.tan(adjHeading*0.0174533)^2) + 1))
			compx = compz*math.tan(adjHeading * 0.0174533)
			if elementNumber == 1 then
				numberAdjust = {x = 0, z = 0}
			elseif (elementNumber % 2 == 0) then
				numberAdjust = {z = FDS.dropTroopDistance*compx*math.floor(elementNumber/2), x = FDS.dropTroopDistance*compz*math.floor(elementNumber/2)}
			else
				numberAdjust = {z = -FDS.dropTroopDistance*compx*math.floor(elementNumber/2), x = -FDS.dropTroopDistance*compz*math.floor(elementNumber/2)}
			end
			elementNumber = elementNumber+1
			dropPoint.x = dropPoint.x + headingDev.x*FDS.dropDistance + numberAdjust.x
			dropPoint.z = dropPoint.z + headingDev.z*FDS.dropDistance + numberAdjust.z
			local height = land.getHeight({x = dropPoint.x, y = dropPoint.z})
			mockUpName = ""
			if args[1]:getCoalition() == 1 then
				local namePart = string.gsub(FDS.cargoList[tostring(args[1]:getName())][1].name, " ", "_")
				mockUpName = mockUpName .. "Red_" .. namePart .. "_Deploy"
			elseif args[1]:getCoalition() == 2 then
				local namePart = string.gsub(FDS.cargoList[tostring(args[1]:getName())][1].name, " ", "_")
				mockUpName = mockUpName .. "Blue_" .. namePart .. "_Deploy"
			end
			gp = Group.getByName(mockUpName)
			gPData = mist.getGroupData(mockUpName,true)
			gpR = mist.getGroupRoute(mockUpName,true)
			new_GPR = mist.utils.deepCopy(gpR)
			new_gPData = mist.utils.deepCopy(gPData)
			new_gPData.units[1].x = dropPoint.x
			new_gPData.units[1].y = dropPoint.z
			new_gPData.units[1].alt = height
			new_gPData.units[1].heading = math.atan2(headingDev.z, headingDev.x)
			new_GPR[1].x = dropPoint.x
			new_GPR[1].y = dropPoint.z
			new_GPR[2].x = dropPoint.x + headingDev.x*FDS.advanceDistance
			new_GPR[2].y = dropPoint.z + headingDev.z*FDS.advanceDistance
			new_gPData.clone = true
			new_gPData.route = new_GPR
			local returnZone = mist.getUnitsInZones({args[1]:getUnits()[1]:getName()},FDS.coalitionAceptZones[FDS.trueCoalitionCode[args[1]:getCoalition()]]['pick'],'cylinder')
			if #returnZone < 1 then
				local newTroop = mist.dynAdd(new_gPData)
				if FDS.cargoList[tostring(args[1]:getName())][1].code ~= nil then
					ctld.JTACAutoLase(newTroop.name, FDS.cargoList[tostring(args[1]:getName())][1].code, false,"all") 
				end
				local massaFinal = totalInternalMass-FDS.cargoList[tostring(args[1]:getName())][1].mass
				trigger.action.setUnitInternalCargo(args[1]:getName(),massaFinal)
				deployerID = FDS.retrieveUcid(args[1]:getUnits()[1]:getPlayerName(),FDS.isName)
				FDS.deployedUnits[FDS.trueCoalitionCode[args[1]:getCoalition()]][Group.getByName(newTroop.name):getUnits()[1]:getName()] = deployerID
				table.remove(FDS.cargoList[args[1]:getName()],1)
				msg.text = "Troops deployed.\n"
			else
				local massaFinal = totalInternalMass-FDS.cargoList[tostring(args[1]:getName())][1].mass
				trigger.action.setUnitInternalCargo(args[1]:getName(),massaFinal)
				local gpUcid = FDS.retrieveUcid(args[1]:getUnits()[1]:getPlayerName(),FDS.isName)
				local cargoName = FDS.cargoList[tostring(args[1]:getName())][1].name
				FDS.playersCredits[FDS.trueCoalitionCode[args[1]:getCoalition()]][gpUcid] = FDS.playersCredits[FDS.trueCoalitionCode[args[1]:getCoalition()]][gpUcid] + FDS.troopAssets[cargoName].cost
				table.remove(FDS.cargoList[args[1]:getName()],1)
				msg.text = "Troops went back to base.\n"
			end
		end
		msg.displayTime = 10
		msg.sound = 'fdsTroops.ogg'
	else
		msg.text = "No troops to drop off.\n"
		msg.displayTime = 10
		msg.sound = 'fdsTroops.ogg'
	end
	trigger.action.outTextForGroup(args[1]:getID(),msg.text,msg.displayTime)
	trigger.action.outSoundForGroup(args[1]:getID(),msg.sound)
end

function FDS.deliverGoods(args)
	local msg = {}
	local elementNumber = 1
	local numberAdjust = 0
	local usedSlots = 0
	local totalInternalMass = 0
	--for _, i in pairs(FDS.cargoList[tostring(args[1]:getName())]) do
	--	usedSlots = usedSlots + i.slot
	--	totalInternalMass = totalInternalMass + i.mass
	--end
	iterationNumber = 0
	if args[2] == -1 then
		iterationNumber = #FDS.valuableList[tostring(args[1]:getName())]
	else
		iterationNumber = args[2]
	end
	if #FDS.valuableList[tostring(args[1]:getName())] > 0 then
		for i = 1, iterationNumber, 1 do
			usedSlots, totalInternalMass = unpack(calculateWeight(args[1]:getUnits()[1]))
			local returnZone = mist.getUnitsInZones({args[1]:getUnits()[1]:getName()},FDS.coalitionAceptZones[FDS.trueCoalitionCode[args[1]:getCoalition()]]['deliver'],'cylinder')
			if #returnZone > 0 or FDS.bypassPlace then
				local massafinal = totalInternalMass-FDS.valuableList[tostring(args[1]:getName())][1].mass
				trigger.action.setUnitInternalCargo(args[1]:getName(),massafinal)
				deployerID = FDS.retrieveUcid(args[1]:getUnits()[1]:getPlayerName(),FDS.isName)
				table.remove(FDS.valuableList[args[1]:getName()],1)
				local gpUcid = FDS.retrieveUcid(args[1]:getUnits()[1]:getPlayerName(),FDS.isName)
				FDS.playersCredits[FDS.trueCoalitionCode[args[1]:getCoalition()]][gpUcid] = FDS.playersCredits[FDS.trueCoalitionCode[args[1]:getCoalition()]][gpUcid] + FDS.goldenBars.value
				msg.text = "Goods delivered.\n"
			else
				msg.text = "You are not at your helipad/airfield.\n"
			end
		end
		msg.displayTime = 10
		msg.sound = 'fdsTroops.ogg'
	else
		msg.text = "No goods to deliver.\n"
		msg.displayTime = 10
		msg.sound = 'fdsTroops.ogg'
	end
	trigger.action.outTextForGroup(args[1]:getID(),msg.text,msg.displayTime)
	trigger.action.outSoundForGroup(args[1]:getID(),msg.sound)
end

function FDS.refreshOnLinePlayers()
	local jog = net.get_player_list()
	local alliedListRed = {}
    local alliedListBlue = {}
	for i, j in pairs(jog) do
		if net.get_player_info(j).side == 1 then
			alliedListRed[net.get_player_info(j).name] = net.get_player_info(j).ucid
		elseif net.get_player_info(j).side == 2 then
			alliedListBlue[net.get_player_info(j).name] = net.get_player_info(j).ucid
		end
	end
    FDS.alliedList['red'] = alliedListRed
    FDS.alliedList['blue'] = alliedListBlue
end

function FDS.transferNow(args)
    local trueCoa = FDS.trueCoalitionCode[args.gpCoa]
    FDS.refreshOnLinePlayers()
    if FDS.alliedList[trueCoa][args.sender] ~= nil then 
        if FDS.alliedList[trueCoa][args.receiver] ~= nil then 
            if FDS.playersCredits[trueCoa][FDS.alliedList[trueCoa][args.sender]] - args.amount >= 0 then
        		FDS.playersCredits[trueCoa][FDS.alliedList[trueCoa][args.sender]] = FDS.playersCredits[trueCoa][FDS.alliedList[trueCoa][args.sender]] - args.amount
        		FDS.playersCredits[trueCoa][FDS.alliedList[trueCoa][args.receiver]] = FDS.playersCredits[trueCoa][FDS.alliedList[trueCoa][args.receiver]] + args.amount
                local msg = {}
                msg.displayTime = 5
                msg.sound = 'fdsTroops.ogg'
                msg.text = "You transfered $" .. tostring(args.amount) .. " to " .. args.receiver .. ".\nYou have $" .. tostring(FDS.playersCredits[trueCoa][FDS.alliedList[trueCoa][args.sender]]) .. " remaining."
                trigger.action.outTextForGroup(args.gp:getID(),msg.text,msg.displayTime)
                trigger.action.outSoundForGroup(args.gp:getID(),msg.sound)
                local playerCrafts = mist.DBs.humansByName
                local receiverGp = nil
                for i,j in pairs(playerCrafts) do
                    if Group.getByName(i) ~= nil and Group.getByName(i):getUnits()[1]:getPlayerName() == args.receiver then 
                        receiverGp = Group.getByName(i).id_
                    end
                end
                local msg = {}
                msg.displayTime = 5
                msg.sound = 'indirectKill.ogg'
                msg.text = "You received $" .. tostring(args.amount) .. " from " .. args.sender .. ".\nYou have $" .. tostring(FDS.playersCredits[trueCoa][FDS.alliedList[trueCoa][args.receiver]]) .. " now."
                trigger.action.outTextForGroup(receiverGp,msg.text,msg.displayTime)
                trigger.action.outSoundForGroup(receiverGp,msg.sound)
            else
                local msg = {}
                msg.displayTime = 5
                msg.sound = 'fdsTroops.ogg'
                msg.text = "Insuficient credits."
                trigger.action.outTextForGroup(args.gp:getID(),msg.text,msg.displayTime)
                trigger.action.outSoundForGroup(args.gp:getID(),msg.sound)
            end
        else
			local msg = {}
			msg.displayTime = 5
			msg.sound = 'fdsTroops.ogg'
			msg.text = "Invalid receiver, please try again."
			trigger.action.outTextForGroup(args.gp:getID(),msg.text,msg.displayTime)
			trigger.action.outSoundForGroup(args.gp:getID(),msg.sound)
			FDS.refreshRadio(gp)
        end
     else
		local msg = {}
		msg.displayTime = 5
		msg.sound = 'fdsTroops.ogg'
		msg.text = "Invalid sender, please try again."
		trigger.action.outTextForGroup(args.gp:getID(),msg.text,msg.displayTime)
		trigger.action.outSoundForGroup(args.gp:getID(),msg.sound)
		FDS.refreshRadio(gp)
    end
end

function FDS.refreshRadio(gp)
    pcall(missionCommands.removeItemForGroup,mist.DBs.humansByName[gp:getName()]['groupId'],'Current War Status')
    mist.scheduleFunction(missionCommands.addCommandForGroup,{mist.DBs.humansByName[gp:getName()]['groupId'],'Current War Status',nil, FDS.warStatus, {gp.id_, gp:getCoalition(), gp:getUnits()[1]:getPlayerName()}},timer.getTime()+FDS.wtime)
    mist.scheduleFunction(missionCommands.addCommandForGroup,{mist.DBs.humansByName[gp:getName()]['groupId'],'Where to Attack',nil, FDS.whereStrike, {gp.id_, gp:getCoalition(), gp:getName()}},timer.getTime()+FDS.wtime)
    mist.scheduleFunction(missionCommands.addCommandForGroup,{mist.DBs.humansByName[gp:getName()]['groupId'],'Where to Defend',nil, FDS.whereDefend, {gp.id_, gp:getCoalition(), gp:getName()}},timer.getTime()+FDS.wtime)
    mist.scheduleFunction(missionCommands.addCommandForGroup,{mist.DBs.humansByName[gp:getName()]['groupId'],'Drop Zones',nil, FDS.whereDropZones, {gp.id_, gp:getCoalition(), gp:getName()}},timer.getTime()+FDS.wtime)
    FDS.addCreditsOptions(gp)
end

function FDS.addCreditsOptions(gp)
	local rootCredits = missionCommands.addSubMenuForGroup(gp:getID(), "Use Credits")
	-- Transfer Cretids
	local rootCreditTransfer = missionCommands.addSubMenuForGroup(gp:getID(), "Transfer Credits", rootCredits)
    local gpCoa = gp:getCoalition()
    local gpPlayerName = gp:getUnits()[1]:getPlayerName()
    missionCommands.addCommandForGroup(gp:getID(), "Refresh Player List", rootCreditTransfer, FDS.refreshRadio, gp)
    FDS.refreshOnLinePlayers()
    local contactsNumber = 1
    for playerName, playerUcid in pairs(FDS.alliedList[FDS.trueCoalitionCode[gp:getCoalition()]]) do
		if playerName ~= gpPlayerName then 
			if contactsNumber%8 == 0 then
				rootCreditTransfer = missionCommands.addSubMenuForGroup(gp:getID(), "More", rootCreditTransfer)
				contactsNumber = contactsNumber + 1
			else
				sendTo = missionCommands.addSubMenuForGroup(gp:getID(), playerName, rootCreditTransfer)
				for _, transferValue in pairs(FDS.standardTransfer) do
					missionCommands.addCommandForGroup(gp:getID(), '$'..tostring(transferValue) , sendTo, FDS.transferNow, {['gp'] = gp, ['gpCoa'] = gpCoa, ['sender'] = gpPlayerName, ['amount'] = transferValue, ['receiver'] = playerName})
				end
				contactsNumber = contactsNumber + 1
			end
		end
    end
	-- Air Support
	local rootAirSupport = missionCommands.addSubMenuForGroup(gp:getID(), "Air Support", rootCredits)
	local jtacAS = ''
	for _, i in pairs(FDS.airSupportAssets) do
		if i.name == "JTAC UAV" then
			jtacAS = missionCommands.addSubMenuForGroup(gp:getID(), i.name .. " - ($" .. tostring(i.cost) .. ")", rootAirSupport)
			for label, code in pairs(FDS.laserCodes) do
				missionCommands.addCommandForGroup(gp:getID(), "Laser code: " .. code .. " (" .. label .. ")", jtacAS, FDS.createJTACDrone, {gp, i.name, code})
			end
			jtacASCustom = missionCommands.addSubMenuForGroup(gp:getID(), "Custom laser code: 1", jtacAS)
			jtacASCustomDigit = {}
			for _, digit in pairs(FDS.validLaserDigits[1]) do
				jtacASCustomDigit1 = missionCommands.addSubMenuForGroup(gp:getID(), digit, jtacASCustom)
				for _, digit2 in pairs(FDS.validLaserDigits[2]) do
					jtacASCustomDigit2 = missionCommands.addSubMenuForGroup(gp:getID(), digit2, jtacASCustomDigit1)
					for _, digit3 in pairs(FDS.validLaserDigits[3]) do
						missionCommands.addCommandForGroup(gp:getID(), digit3, jtacASCustomDigit2, FDS.createJTACDrone, {gp, i.name, '1' .. digit .. digit2 .. digit3})
					end
				end
			end
		else
			missionCommands.addCommandForGroup(gp:getID(), i.name .. " - ($" .. tostring(i.cost) .. ")", rootAirSupport, FDS.createASupport, {gp, i.name})
		end
	end
	-- Troop transport
	local hasTransport = false
	for key,_ in pairs(FDS.heliSlots) do
		if gp:getUnits()[1]:getDesc().typeName == key then
			hasTransport = true
		end
	end
	if hasTransport then
		local rootTroops = missionCommands.addSubMenuForGroup(gp:getID(), "Troop Transport", rootCredits)
		local jtacTT = ''
		for _, i in pairs(FDS.troopAssetsNumbered) do
			if i.name == "JTAC Team" then
				jtacTT = missionCommands.addSubMenuForGroup(gp:getID(), i.name .. " - ($" .. tostring(i.cost) .. ")", rootTroops)
				for label, code in pairs(FDS.laserCodes) do
					missionCommands.addCommandForGroup(gp:getID(), "Laser code: " .. code .. " (" .. label .. ")", jtacTT, FDS.validateDropBoard, {['rawData'] = {gp, i.name,1, code}, ['dropCase'] = FDS.loadCargo, ['dropCaseString'] = 'loadCargo'})
				end
				jtacTTCustom = missionCommands.addSubMenuForGroup(gp:getID(), "Custom laser code: 1", jtacTT)
				for _, digit in pairs(FDS.validLaserDigits[1]) do
					jtacTTCustomDigit1 = missionCommands.addSubMenuForGroup(gp:getID(), digit, jtacTTCustom)
					for _, digit2 in pairs(FDS.validLaserDigits[2]) do
						jtacTTCustomDigit2 = missionCommands.addSubMenuForGroup(gp:getID(), digit2, jtacTTCustomDigit1)
						for _, digit3 in pairs(FDS.validLaserDigits[3]) do
							missionCommands.addCommandForGroup(gp:getID(), digit3, jtacTTCustomDigit2, FDS.validateDropBoard, {['rawData'] = {gp, i.name, 1, '1' .. digit .. digit2 .. digit3}, ['dropCase'] = FDS.loadCargo, ['dropCaseString'] = 'loadCargo'})
						end
					end
				end
			else
				local troopType = missionCommands.addSubMenuForGroup(gp:getID(), i.name .. " - ($".. i.cost ..")", rootTroops)
				for j=1,10,1 do  
					missionCommands.addCommandForGroup(gp:getID(), "Quantity: " .. tostring(j), troopType, FDS.validateDropBoard, {['rawData'] = {gp, i.name, j}, ['dropCase'] = FDS.loadCargo, ['dropCaseString'] = 'loadCargo'})
				end
			end
		end
		local cargoRoot = missionCommands.addSubMenuForGroup(gp:getID(), "Cargo")
		missionCommands.addCommandForGroup(gp:getID(), "Status", cargoRoot, FDS.cargoStatus, {gp})
		missionCommands.addCommandForGroup(gp:getID(), "Drop All", cargoRoot, FDS.validateDropBoard, {['rawData'] = {gp,-1}, ['dropCase'] = FDS.dropTroops, ['dropCaseString'] = 'dropTroops'})
		local cargoDropRoot = missionCommands.addSubMenuForGroup(gp:getID(), "Drop", cargoRoot)
		for j=1,10,1 do  
			missionCommands.addCommandForGroup(gp:getID(), "Quantity: " .. tostring(j), cargoDropRoot, FDS.validateDropBoard, {['rawData'] = {gp, j}, ['dropCase'] = FDS.dropTroops, ['dropCaseString'] = 'dropTroops'})
		end
		local variousGoods = missionCommands.addSubMenuForGroup(gp:getID(), "Valuable goods",cargoRoot)
		local goodsLoadRoot = missionCommands.addSubMenuForGroup(gp:getID(), "Load", variousGoods)
		for j=1,10,1 do  
			missionCommands.addCommandForGroup(gp:getID(), "Quantity: " .. tostring(j), goodsLoadRoot, FDS.validateDropBoard, {['rawData'] = {gp,'', j}, ['dropCase'] = FDS.loadValuableGoods, ['dropCaseString'] = 'loadValuableGoods'})
		end
		missionCommands.addCommandForGroup(gp:getID(), "Deliver", variousGoods, FDS.validateDropBoard,{['rawData'] = {gp,-1}, ['dropCase'] = FDS.deliverGoods, ['dropCaseString'] = 'deliverGoods'})
	end
end


function FDS.checkFarpDefences()
	if FDS.farpEverCaptured and StaticObject.getByName("Mid_Helipad"):getCoalition() == 3 then
		defenceForces = {}
		for i,j in pairs(FDS.farpOwner) do
			for k,_ in pairs(FDS.deployedUnits[i]) do
				if defGp and k then
					table.insert(defenceForces,k)
				end
			end
			aliveForces = mist.getUnitsInZones(defenceForces,{"Capture_Farp"},'cylinder')
			if #aliveForces == 0 then
				if Group.getByName(j) ~= nil then
					Group.getByName(j):destroy()
				else
					local UOI = {}
					local aliveForces = {}
					for i, j in pairs(mist.makeUnitTable({'[' .. i .. '][vehicle]'})) do
						table.insert(UOI,j)
					end
					emergengyAliveForces = mist.getUnitsInZones(UOI,{"Capture_Farp"},'cylinder')
					emergengyAliveForces[1]:getGroup():destroy()
				end
			end 
		end
	end
end

-- Starting
function creatingBases()
	-- Init Static
	deviation0 = 150.0
	angle0 = 6.6

	deviationHangarr = 120.0
	angleHangarr = -3.1415/180*40

	deviationHangarc = 120.0
	angleHangarc = -3.1415/180*130

	deviationFuelr = 70.0
	angleFuelr = 3.1415/180*70

	deviationFuelc = 70.0
	angleFuelc = 3.1415/180*160
    
    haeding4All = 45.0

	-------

	nCP = 1
	nHangarr = 2
	nHangarc = 2
	nFuelr = 2
	nFuelc = 3

	tgtObj = {}
    tgtObj.blue = {}
    tgtObj.red = {}
	FDS.initTgtObj = {}

    FDS.tgtQty = {
        ['Paratrooper AKS-74'] = FDS.InfAK, 
        ['Paratrooper RPG-16'] = FDS.InfRPG,
        ['Ural-4320T'] = FDS.ArmTrucks, 
        ['BMP-1'] = FDS.ArmBMP1, 
        ['BMP-2'] = FDS.ArmBMP2, 
        ['T-55'] = FDS.ArmT55 , 
        ['T-72B'] = FDS.ArmT72, 
        ['T-80UD'] = FDS.ArmT80 , 
        ['ZSU-23-4 Shilka'] = FDS.AAA, 
        ['2S6 Tunguska'] = FDS.AATung, 
        ['Strela-1 9P31'] = FDS.AAStrela1, 
        ['Strela-10M3'] = FDS.AAStrela2, 
        ['SA-18 Igla-S manpad'] = FDS.AAIgla,
    	['Tor 9A331'] = FDS.AATor}
    
	FDS.joinedZones = {}
	zones = mist.DBs.zonesByName

	for i=1, #FDS.blueZones,1 do
		FDS.joinedZones[FDS.blueZones[i]]= 1
        tgtObj.blue[FDS.blueZones[i]] = {}
	end

	for i= 1, #FDS.redZones, 1 do
		FDS.joinedZones[FDS.redZones[i]]= 0
        tgtObj.red[FDS.redZones[i]] = {}
	end

	for i = 1,2,1 do
		activePl = coalition.getPlayers(i)
		if #activePl ~= 0 then
			for j,k in pairs(activePl) do
				if i == 1 then 
					gp = k:getGroup()
					gpId = gp:getID()
					gpCoa = k:getCoalition()
					gpPN = k:getPlayerName()
					gpName = k:getName()
					gpUcid = FDS.retrieveUcid(gpPN,FDS.isName)
					local cleanCargo = false
					if k:getCategory() == 1 then
						for i,j in pairs(FDS.heliSlots) do
							if k:getDesc().typeName == i then
								cleanCargo = true
							end
						end
						if cleanCargo then
							FDS.cargoList[tostring(k:getName())] = {} 
							FDS.valuableList[tostring(k:getName())] = {} 
						end
					end
					local msg = {}
					msg.text = gpPN .. ', you can help your team by:\n\n - Attacking ground targets in enemy zones (AG mission)(See map or [radio]>[F10]>[Where to attack]).\n\n - Attacking the enemy air transports in enemy supply route (AA mission) (See map).\n - Rescuing point around the map with helicopters (Helo rescue mission).\n - Killing enemy players in the process is always a good idea!\n\n - Visit our website: "https://dcs.comicorama.com/" for server and players stats.\n - Join our Discord community at FDS Server (Link available in the briefing). \nAn explanation about this server is available on our youtube channel: "FDS Server - DCS".'
					msg.displayTime = 60
					msg.sound = 'Welcome.ogg'
					mist.scheduleFunction(missionCommands.addCommandForGroup,{gpId,'Current War Status',nil, FDS.warStatus, {gpId, gpCoa, gpPN}},timer.getTime()+FDS.wtime)
					mist.scheduleFunction(missionCommands.addCommandForGroup,{gpId,'Where to Attack',nil, FDS.whereStrike, {gpId, gpCoa, gpName}},timer.getTime()+FDS.wtime)
					mist.scheduleFunction(missionCommands.addCommandForGroup,{gpId,'Where to Defend',nil, FDS.whereDefend, {gpId, gpCoa, gpName}},timer.getTime()+FDS.wtime)
					mist.scheduleFunction(missionCommands.addCommandForGroup,{gpId,'Drop Zones',nil, FDS.whereDropZones, {gpId, gpCoa, gpName}},timer.getTime()+FDS.wtime)
					FDS.addCreditsOptions(gp)
					mist.scheduleFunction(trigger.action.outTextForGroup,{gpId,msg.text,msg.displayTime},timer.getTime()+FDS.wtime)
					mist.scheduleFunction(trigger.action.outSoundForGroup,{gpId,msg.sound},timer.getTime()+FDS.wtime)
					if i == 1 then 
						FDS.teamPoints['red']['Players'][gpPN] = 0
					elseif i == 2 then
						FDS.teamPoints['blue']['Players'][gpPN] = 0
					end
					if FDS.playersCredits[FDS.trueCoalitionCode[gpCoa]][gpUcid] == nil then
						FDS.playersCredits[FDS.trueCoalitionCode[gpCoa]][gpUcid] = 0
					end
				elseif i == 2 then
					gp = k:getGroup()
					gpId = gp:getID()
					gpCoa = k:getCoalition()
					gpPN = k:getPlayerName()
					gpName = k:getName()
					gpUcid = FDS.retrieveUcid(gpPN,FDS.isName)
					local cleanCargo = false
					if k:getCategory() == 1 then
						for i,j in pairs(FDS.heliSlots) do
							if k:getDesc().typeName == i then
								cleanCargo = true
							end
						end
						if cleanCargo then
							FDS.cargoList[tostring(k:getName())] = {} 
							FDS.valuableList[tostring(k:getName())] = {} 
						end
					end
					local msg = {}
					msg.text = gpPN .. ', you can help your team by:\n\n - Attacking ground targets in enemy zones (AG mission)(See map or [radio]>[F10]>[Where to attack]).\n\n - Attacking the enemy air transports in enemy supply route (AA mission) (See map).\n\n - Rescuing point around the map with helicopters (Helo rescue mission).\n - Killing enemy players in the process is always a good idea!\n\n - Visit our website: "https://dcs.comicorama.com/" for server and players stats.\n - Join our Discord community at FDS Server (Link available in the briefing). \nAn explanation about this server is available on our youtube channel: "FDS Server - DCS".'
					msg.displayTime = 60
					msg.sound = 'Welcome.ogg'
					mist.scheduleFunction(missionCommands.addCommandForGroup,{gpId,'Current War Status',nil, FDS.warStatus, {gpId, gpCoa, gpPN}},timer.getTime()+FDS.wtime)
					mist.scheduleFunction(missionCommands.addCommandForGroup,{gpId,'Where to Attack',nil, FDS.whereStrike, {gpId, gpCoa, gpName}},timer.getTime()+FDS.wtime)
					mist.scheduleFunction(missionCommands.addCommandForGroup,{gpId,'Where to Defend',nil, FDS.whereDefend, {gpId, gpCoa, gpName}},timer.getTime()+FDS.wtime)
					mist.scheduleFunction(missionCommands.addCommandForGroup,{gpId,'Drop Zones',nil, FDS.whereDropZones, {gpId, gpCoa, gpName}},timer.getTime()+FDS.wtime)
					FDS.addCreditsOptions(gp)
					mist.scheduleFunction(trigger.action.outTextForGroup,{gpId,msg.text,msg.displayTime},timer.getTime()+FDS.wtime)
					mist.scheduleFunction(trigger.action.outSoundForGroup,{gpId,msg.sound},timer.getTime()+FDS.wtime)
					if i == 1 then 
						FDS.teamPoints['red']['Players'][gpPN] = 0
					elseif i == 2 then
						FDS.teamPoints['blue']['Players'][gpPN] = 0
					end
					if FDS.playersCredits[FDS.trueCoalitionCode[gpCoa]][gpUcid] == nil then
						FDS.playersCredits[FDS.trueCoalitionCode[gpCoa]][gpUcid] = 0
					end
				end
			end
		end
	end
	

	staticTypes = {}
	staticTypes.types = {'.Command Center','Shelter','Fuel tank'}
	staticTypes.number = {['.Command Center']= {nCP}, ['Shelter']={nHangarr,nHangarc}, ['Fuel tank'] = {nFuelr,nFuelc}}
	staticTypes.cat = {['.Command Center']= {4}, ['Shelter']={4}, ['Fuel tank'] = {4}}
	staticTypes.dist = {['.Command Center']= {deviation0, angle0}, ['Shelter']={{deviationHangarr, angleHangarr},{deviationHangarc, angleHangarc}}, ['Fuel tank'] = {{deviationFuelr, angleFuelr},{deviationFuelc, angleFuelc}}}
	staticTypes.collum = {['.Command Center']= {nCP}, ['Shelter']={nHangarr, nHangarc}, ['Fuel tank'] = {nFuelr, nFuelc}}

	for tz,cc in pairs(FDS.joinedZones) do
		zonePoint = zones[tz]["point"]
		addPoint = {x = zonePoint["x"],y = land.getHeight({x = zonePoint["x"], y = zonePoint["z"]}), z = zonePoint["z"]}

        -- Static Objects
		for j,i in pairs(staticTypes.types) do
			if i == '.Command Center' then
				addPoint = {x = addPoint["x"]+staticTypes.dist[i][1]*math.cos(staticTypes.dist[i][2]),y = land.getHeight({x = addPoint["x"]+staticTypes.dist[i][1]*math.cos(staticTypes.dist[i][2]), y = addPoint["z"]+staticTypes.dist[i][1]*math.sin(staticTypes.dist[i][2])}), z = addPoint["z"]+staticTypes.dist[i][1]*math.sin(staticTypes.dist[i][2])}
				height = land.getHeight({x = zonePoint["x"],y = zonePoint["z"]})

				addO = {}
				addO.country = cc
				addO.category = staticTypes.cat[i][1]
				addO.x = addPoint["x"]
				addO.y = addPoint["z"]
				addO.type = i
				addO.heading = haeding4All

				addCP = mist.dynAddStatic(addO)
				boxPos = {}
				for vert = 0,3,1 do 
					table.insert(boxPos,{x=addCP.x+40.0*math.cos(mist.utils.toRadian(addCP.heading+45.0+90.0*vert)), y=addCP.y+40.0*math.sin(addCP.heading+45.0+90.0*vert)})
				end
                if cc == 1 then
                    table.insert(tgtObj.blue[tz],{addCP.name,{x = addCP.x, y = addCP.y},boxPos,StaticObject.getByName(addCP.name):getCategory()})
                else
                    table.insert(tgtObj.red[tz],{addCP.name,{x = addCP.x, y = addCP.y},boxPos,StaticObject.getByName(addCP.name):getCategory()})
                end

			else
				for r = 0, staticTypes.collum[i][1]-1,1 do
					for c = 0, staticTypes.collum[i][2]-1,1 do 
						addingX = (r+1)*(staticTypes.dist[i][1][1]*math.cos(staticTypes.dist[i][1][2]))+c*(staticTypes.dist[i][2][1]*math.cos(staticTypes.dist[i][2][2]))
						addingY = (r+1)*(staticTypes.dist[i][1][1]*math.sin(staticTypes.dist[i][1][2]))+c*(staticTypes.dist[i][2][1]*math.sin(staticTypes.dist[i][2][2]))
						addPoint2 = {x = addPoint["x"]+addingX,y = land.getHeight({x = addPoint["x"]+addingX, y = addPoint["z"]+addingY}), z = addPoint["z"]+addingY}

						height = land.getHeight({x = zonePoint["x"],y = zonePoint["z"]})

						addO = {}
						addO.country = cc
						addO.category = staticTypes.cat[i][1]
						addO.x = addPoint2["x"]
						addO.y = addPoint2["z"]
						addO.type = i
						addO.heading = haeding4All

						addCP = mist.dynAddStatic(addO)
                        boxPos = {}
                        for vert = 0,3,1 do 
                            table.insert(boxPos,{x=addCP.x+80.0*math.cos(mist.utils.toRadian(addCP.heading+45.0+90.0*vert)), y=addCP.y+80.0*math.sin(addCP.heading+45.0+90.0*vert)})
                        end
                        if cc == 1 then
							table.insert(tgtObj.blue[tz],{addCP.name,{x = addCP.x, y = addCP.y},boxPos,StaticObject.getByName(addCP.name):getCategory()})
                        else
                            table.insert(tgtObj.red[tz],{addCP.name,{x = addCP.x, y = addCP.y},boxPos,StaticObject.getByName(addCP.name):getCategory()})
                        end
					end
				end
			end
		end
        -- Ground Units
        for unc, qt in pairs(FDS.tgtQty) do
            for unitNumber = 0,qt,1 do
				if unitNumber ~= 0 then
					checkP = true
					it = 0
					while checkP==true do
						bornPoint = mist.getRandomPointInZone(tz)
						if cc == 1 then
							for nObj, cObj in ipairs(tgtObj.blue[tz]) do
								checkP = mist.pointInPolygon(bornPoint,cObj[3])
							end
						else
							for nObj, cObj in ipairs(tgtObj.red[tz]) do
								checkP = mist.pointInPolygon(bornPoint,cObj[3])
							end
						end
						it = it + 1
						if it > 10 then
							checkP = false
						end
					end

					addUnit = {}
					addUnit.x = bornPoint.x
					addUnit.y = bornPoint.y
					addUnit.type = unc
					addUnit.skill = 'Ace'
					addUnit.heading = math.random(0.0,359.0)

					allUnits = {}
					table.insert(allUnits,addUnit)

					addO = {}
					addO.units = allUnits
					addO.country = cc
					addO.category = 2
					addO.visible = true
					addUni = mist.dynAdd(addO)

					boxPos = {}
					for vert = 0,3,1 do 
						table.insert(boxPos,{x=addUni.units[1].x+40.0*math.cos(mist.utils.toRadian(addUni.units[1].heading+45.0+90.0*vert)), y=addUni.units[1].y+40.0*math.sin(addUni.units[1].heading+45.0+90.0*vert)})
					end
					FDS.entityKills[addUni.name] = nil
					FDS.killedByEntity[addUni.name] = nil
					if cc == 1 then
						table.insert(tgtObj.blue[tz],{addUni.name,{x = addUni.units[1].x, y = addUni.units[1].y},boxPos,Group.getByName(addUni.name):getCategory()})
					else
						table.insert(tgtObj.red[tz],{addUni.name,{x = addUni.units[1].x, y = addUni.units[1].y},boxPos,Group.getByName(addUni.name):getCategory()})
					end
				end
            end
        end
		-- Data export Vector for all units in zone
		FDS.initTgtObj = mist.utils.deepCopy(tgtObj)
		for _,i in pairs(FDS.initTgtObj) do
			for _, j in pairs(i) do
				for _, k in pairs(j) do
					if StaticObject.getByName(k[1]) then
					   k[5] = StaticObject.getByName(k[1]):getDesc().typeName
					else
					   k[5] = Group.getByName(k[1]):getUnit(1):getDesc().typeName
					end
				end  
			end
		end
	end
end

function killDCSProcess()
	os.execute("C:\\automationScript\\dcsKill.bat")
end

-- Player data
function getPlayersStats()
	local jogList = {}
	local jog = net.get_player_list()
	local enumSide = {[1] = 'red', [2] = 'blue'}
    for _,i in pairs(jog) do
        jogInfo = net.get_player_info(i)
        jogStats = net.get_stat(i)
        if jogInfo['side'] ~= 0 then 
            jogStats['points'] = FDS.teamPoints[enumSide[jogInfo['side']]]['Players'][jogInfo['name']]
			jogStats['credits'] = FDS.playersCredits[enumSide[jogInfo['side']]][jogInfo['ucid']]
            listaViva = mist.DBs.humansByName
            local playerUnits = {}
            for k,z in pairs(listaViva) do
                table.insert(playerUnits, Unit.getByName(k))
            end
            for _, k in pairs(playerUnits) do
                if jogInfo['name'] == k:getPlayerName() then
                    jogInfo['unit'] = k:getDesc().typeName
                end     
            end
        end
        table.insert(jogList, {['information'] = jogInfo, ['stats'] = jogStats})
    end
	return jogList
end

function createJSONEntities()
	local entStart = {}
	for i,j in pairs(FDS.initTgtObj) do
		entStart[i] = {}
		for k,z in pairs(j) do
			local auxListName = {}
			local auxListType = {}
			for _, y in pairs(z) do
				local isAlive = false
				for _, obj in pairs(tgtObj[i][k]) do
					if obj[1] == y[1] then
						isAlive = true
					end
				end
				table.insert(auxListName, {['name'] = y[1], ['type'] = y[4], ['unitName'] = y[5], ['isAlive'] = isAlive, ['kills'] = FDS.entityKills[y[1]], ['killedBy'] = FDS.killedByEntity[y[1]]})
			end
			table.insert(entStart[i], {
					['name'] = k,
					['units'] = auxListName
				})
		end
	end
	return entStart
end

-- Creating export vector
function exportMisData()
    FDS.exportVector = {}
	FDS.exportVector['entities'] = createJSONEntities()
	local transportSquad = {}
	for _, coa in pairs({'blue', 'red'}) do
		if Group.getByName(FDS.currentTransport[coa][2]) and Group.getByName(FDS.currentTransport[coa][2]):isExist() then
			local transportGp = Group.getByName(FDS.currentTransport[coa][2])
			local squadNumber = transportGp:getSize()
			transportSquad[coa] = squadNumber
		else
			transportSquad[coa] = 0
		end
	end
	FDS.exportVector['coalition'] = {
		['blue'] = {
			['dropTime'] = math.floor((FDS.refreshTime - timer.getTime() + FDS.lastDropTime['blue'])/60.0),
			['bombers'] = FDS.bomberQty['blue'],
			['transportSquad'] = transportSquad['blue'],
			['basePoints'] = FDS.teamPoints['blue']['Base']
		},
		['red'] = {
			['dropTime'] = math.floor((FDS.refreshTime - timer.getTime() + FDS.lastDropTime['red'])/60.0),
			['bombers'] = FDS.bomberQty['red'],
			['transportSquad'] = transportSquad['red'],
			['basePoints'] = FDS.teamPoints['red']['Base']
		}	
	}
	FDS.exportVector['playerStats'] = getPlayersStats()
	FDS.exportVector['deliveredPoints'] = FDS.recordDeliveredPoints
	FDS.exportVector['playersKillRecord'] = FDS.playersKillRecord
	FDS.exportVector['missionTime'] = {
		['elapsed'] = math.floor(timer.getTime()), 
		['current'] = math.floor(timer.getAbsTime()), 
		['initial'] = math.floor(timer.getTime0())
	}
	if FDS.exportDataSite then
		jsonExport = net.lua2json(FDS.exportVector)
		local file = io.open(FDS.exportPath .. "currentStats.json", "w")
		file:write(jsonExport)
		file:close()
	end
end

jogList = {}
jog = net.get_player_list()
for _,i in pairs(jog) do
    jogInfo = net.get_player_info(i)
    jogStats = net.get_stat(i)
    table.insert(jogList,{jogInfo,jogStats})
end


function createAG(name, coa)
	number = 0
	wpTasks = {}
	staticObj = {}
	taskNumber = 1
	if coa == 2 then
		gp = Group.getByName('Molde_blue_AG')
	else
		gp = Group.getByName('Molde_red_AG')
	end
	gpR = mist.getGroupRoute(gp:getName(),true)
	new_GPR = mist.utils.deepCopy(gpR)
	prioList = {'Paratrooper AKS-74', 'Paratrooper RPG-16', 'Ural-4320T', 'BMP-1', 'BMP-2', 'T-55', 'T-72B', 'T-80UD', 'ZSU-23-4 Shilka', 'SA-18 Igla-S manpad',  'Strela-1 9P31', 'Strela-10M3', '2S6 Tunguska', 'Tor 9A331'}
	
	for _,zone in pairs(FDS.redZones) do
		wpTasks = {}
		staticObj = {}
		taskNumber = 1
		number = 0
		for i = #prioList, 1, -1 do
			for _,j in pairs(tgtObj.red[zone]) do
				local alvo
				local alvoUni
				alvo = Group.getByName(j[1])
				if alvo then
					alvoUni = alvo:getUnits()
				else	
					local static = StaticObject.getByName(j[1])
					if not has_value(staticObj, static) then
						table.insert(staticObj,static)
					end
				end
				if alvoUni then
					if alvoUni[1]:getDesc().typeName == prioList[i] then
						setTarget = alvo:getID()
						local task = {}
						task.auto = false
						task.enabled = true
						task.id = 'AttackGroup'
						task.number = taskNumber
						task.params = {}
						task.params.altitude = 6000.0
						task.params.altitudeEnabled = false
						task.params.attackQty = 1
						task.params.attackQtyLimit = true
						task.params.direction = 3.385938748869
						task.params.directionEnabled = true
						task.params.expend = 'One'
						task.params.groupAttack = false
						task.params.groupId = setTarget
						if i < 9 then
							task.params.weaponType = 2032
						else
							task.params.weaponType = 131072
						end
						table.insert(wpTasks,task)
						taskNumber = taskNumber + 1
					end
				end
			end
			number = number + 1
		end
		for _,k in pairs(staticObj) do
			setTarget = k:getID()
			local task = {}
			task.auto = false
			task.enabled = true
			task.id = 'AttackUnit'
			task.number = taskNumber
			task.params = {}
			task.params.altitude = 6000.0
			task.params.altitudeEnabled = false
			task.params.attackQty = 1
			task.params.attackQtyLimit = true
			task.params.direction = 3.385938748869
			task.params.directionEnabled = true
			task.params.expend = 'One'
			task.params.groupAttack = false
			task.params.unitId = tonumber(setTarget)
			task.params.weaponType = 14
			table.insert(wpTasks,task)
			taskNumber = taskNumber + 1            
		end
	
		if zone == FDS.redZones[1] then
			new_GPR[3].task.params.tasks = wpTasks
		elseif zone == FDS.redZones[2] then
			new_GPR[5].task.params.tasks = wpTasks
		end
	end
	
	mist.goRoute(name,new_GPR)
end

function FDS.createJTACDrone(args)
	local point3 = args[1]:getUnits()[1]:getPosition().p
	local heightD = ''
	if point3.y/0.3048 > FDS.minAltitude then
		heightD = point3.y/0.3048
	else
		heightD = mist.random(100)
		local variation = (FDS.maxAltitude - FDS.minAltitude)/100
		heightD = (11000 + 100*heightD)*0.3048
	end
	local mockUpName = ''
	if args[1]:getCoalition() == 1 then
		mockUpName = "Red_Spy_Drone"
	elseif args[1]:getCoalition() == 2 then
		mockUpName = "Blue_Spy_Drone"
	end
	gp = Group.getByName(mockUpName)
	gPData = mist.getGroupData(mockUpName,true)
	gpR = mist.getGroupRoute(gp:getName(),true)
	new_GPR = mist.utils.deepCopy(gpR)
	new_gPData = mist.utils.deepCopy(gPData)
	new_gPData.units[1].x = point3.x
	new_gPData.units[1].y = point3.z
	new_gPData.units[1].alt = heightD
	new_GPR[1].task.params.tasks[7].params.altitude = heightD
	new_GPR[1].x = point3.x
	new_GPR[1].y = point3.z
	new_gPData.clone = true
	new_gPData.route = new_GPR
	local newDrone = mist.dynAdd(new_gPData)
	ctld.JTACAutoLase(newDrone.name, args[3], false,"all") 
end

function FDS.createASupport(args)
	local cloneName = ''
	if args[1]:getCoalition() == 1 then
		cloneName = 'Red'.. FDS.airSupportAssetsKeys[args[2]].groupName
	else
		cloneName = 'Blue'..FDS.airSupportAssetsKeys[args[2]].groupName
	end
	gp = Group.getByName(cloneName)
	gPData = mist.getGroupData(cloneName,true)
	gpR = mist.getGroupRoute(gp:getName(),true)
	new_GPR = mist.utils.deepCopy(gpR)
	new_gPData = mist.utils.deepCopy(gPData)
	new_gPData.clone = true
	new_gPData.route = new_GPR
	local deployerID = FDS.retrieveUcid(args[1]:getUnits()[1]:getPlayerName(),FDS.isName)
	local msg = {}
	msg.displayTime = 10
	if FDS.playersCredits[FDS.trueCoalitionCode[args[1]:getCoalition()]][deployerID] >= FDS.airSupportAssetsKeys[args[2]].cost or FDS.bypassCredits then
		FDS.playersCredits[FDS.trueCoalitionCode[args[1]:getCoalition()]][deployerID] = FDS.playersCredits[FDS.trueCoalitionCode[args[1]:getCoalition()]][deployerID] - FDS.airSupportAssetsKeys[args[2]].cost
		local newAS = mist.dynAdd(new_gPData)
		FDS.deployedUnits[FDS.trueCoalitionCode[args[1]:getCoalition()]][Group.getByName(newAS.name):getUnits()[1]:getName()] = deployerID
		msg.text = "Air support is on the way.\nRemaining Credits: $" .. tostring(FDS.playersCredits[FDS.trueCoalitionCode[args[1]:getCoalition()]][deployerID])
		msg.sound = 'fdsTroops.ogg'	
	else
		msg.text = "Insuficient credits.\n"
		msg.sound = 'fdsTroops.ogg'
	end
	trigger.action.outTextForGroup(args[1]:getID(),msg.text,msg.displayTime)
	trigger.action.outSoundForGroup(args[1]:getID(),msg.sound)
end

function bombingRun(coa)
	validateAliveUnits()
    local zone = ''
	local qty = 0
	if coa == 'blue' then
		local z1,z2 = unpack(FDS.redZones)
		if #tgtObj['red'][z1] == #tgtObj['red'][z2] then 
			candidates = {z1, z2}
			zone = candidates[math.random(1,#candidates)]
		elseif #tgtObj['red'][z1] > #tgtObj['red'][z2] then
			zone = z1
		else
			zone = z2
		end
	else
		local z1,z2 = unpack(FDS.blueZones)
		if #tgtObj['blue'][z1] == #tgtObj['blue'][z2] then 
			candidates = {z1, z2}
			zone = candidates[math.random(1,#candidates)]
		elseif #tgtObj['blue'][z1] > #tgtObj['blue'][z2] then
			zone = z1
		else
			zone = z2
		end
	end

	bombingRunTable = {
		["Blue Zone 1"] = {"Red_Bomber_A1_Spaw","Red_Bomber_Zone1","blue","Blue Zone 1",1,2},
		["Blue Zone 2"] = {"Red_Bomber_A2_Spaw","Red_Bomber_Zone2","blue","Blue Zone 2",1,2},
		["Red Zone 1"] = {"Blue_Bomber_A1_Spaw","Blue_Bomber_Zone1","red","Red Zone 1",2,1},
		["Red Zone 2"] = {"Blue_Bomber_A2_Spaw","Blue_Bomber_Zone2","red","Red Zone 2",2,1}
	}
	
    for bomber = 1, FDS.bomberQuantity do
        gp = Group.getByName(bombingRunTable[zone][2])
        gPData = mist.getGroupData(bombingRunTable[zone][2],true)
        gpR = mist.getGroupRoute(gp:getName(),true)
        new_GPR = mist.utils.deepCopy(gpR)
        new_gPData = mist.utils.deepCopy(gPData)
        randomTgt = math.random(1, #tgtObj[bombingRunTable[zone][3]][bombingRunTable[zone][4]])
        
        new_GPR[2].task.params.tasks[1].params.x = tgtObj[bombingRunTable[zone][3]][bombingRunTable[zone][4]][randomTgt][2].x
        new_GPR[2].task.params.tasks[1].params.y = tgtObj[bombingRunTable[zone][3]][bombingRunTable[zone][4]][randomTgt][2].y

        pontinho = mist.getRandomPointInZone(bombingRunTable[zone][1])

        new_gPData.route = new_GPR 
        new_gPData.groupId = nil
        new_gPData.groupName = nil
        new_gPData.name = nil
        new_gPData.units[1].x = pontinho.x
        new_gPData.units[1].y = pontinho.y
        new_gPData.units[1].alt = new_gPData.units[1].alt + (math.random(1,200)-100.0)
        new_gPData.clone = true

        mist.dynAdd(new_gPData)
    end

	local msgBombingAlert = {}  
	msgBombingAlert.text = 'Warning! A large bomber formation is headed for ' .. bombingRunTable[zone][4]
	msgBombingAlert.displayTime = 20  
	msgBombingAlert.sound = 'Siren.ogg'
	trigger.action.outTextForCoalition(bombingRunTable[zone][6], msgBombingAlert.text, msgBombingAlert.displayTime)
	trigger.action.outSoundForCoalition(bombingRunTable[zone][6],msgBombingAlert.sound)

	local msgBombingInfo = {}  
	msgBombingInfo.text = 'An allied bomber formation is headed for ' .. bombingRunTable[zone][4] .. '. Support their effort!'
	msgBombingInfo.displayTime = 20  
	msgBombingInfo.sound = 'bombingRun.ogg'
	trigger.action.outTextForCoalition(bombingRunTable[zone][5], msgBombingInfo.text, msgBombingInfo.displayTime)
	trigger.action.outSoundForCoalition(bombingRunTable[zone][5],msgBombingInfo.sound)
    return zone
end

function updateTgtPositions()
	for coal, zonas in pairs(tgtObj) do
		for zona, unids in pairs(zonas) do
			for unid, data in pairs(unids) do
				local objecto = Group.getByName(data[1]) or StaticObject.getByName(data[1])
				local novaPos = {}
				if objecto:getCategory() == 3 then
					novaPos = objecto:getPosition()
				elseif objecto:getCategory() == 2 and objecto:getUnits()[1] ~= nil then
					novaPos = objecto:getUnits()[1]:getPosition()
				end
				novaPos.p.y = novaPos.p.z
				novaPos.p.z = nil
				tgtObj[coal][zona][unid][2] = novaPos.p
			end
		end
	end
end

function validateAliveUnits()
	local codeCoalitions = {
		['blue'] = {2,1},
		['red'] = {1,2}
	}
	local teamCode = {
		['blue'] = 'Red Team',
		['red'] = 'Blue Team'
	}
	for numero1,coa in pairs(tgtObj) do
		for numero2, zona in pairs(coa) do
			for numero3, unidade in pairs(zona) do
				tkGp = StaticObject.getByName(unidade[1]) or Group.getByName(unidade[1])
				if tkGp == nil or (tkGp ~= nil and not tkGp:isExist()) or (tkGp ~= nil and tkGp:getCategory() == 2 and #tkGp:getUnits() < 1) then
					table.remove(tgtObj[numero1][numero2],numero3)
					local lenTab = #tgtObj[numero1][numero2]
					local playWarning = true
					if  lenTab == 0 then
						FDS.zoneSts[numero1][numero2] = "Cleared"
						local allClearFlag = true
						for _,zSts in pairs(FDS.zoneSts[numero1]) do
							if zSts ~= 'Cleared' then allClearFlag = false end
						end
						local msgclear = {}  
						if allClearFlag then
							msgclear.text = 'Congratulations! All enemy units are eliminated. Mission Accomplished! ByCorrection'
							msgclear.displayTime = 120
						else
							msgclear.text = numero2 .. ' has been cleared, there are no signs of enemy activities in this zone. Good work.'
							msgclear.displayTime = 25 
							-- Msg for Enemy
							local msgfinalEnemy = {}  
							msgfinalEnemy.text = numero2 .. ' is Lost.'
							msgfinalEnemy.displayTime = 30  
							msgfinalEnemy.sound = 'zone_killed.ogg'
							trigger.action.outTextForCoalition(codeCoalitions[numero1][1], msgfinalEnemy.text, msgfinalEnemy.displayTime)
							trigger.action.outSoundForCoalition(codeCoalitions[numero1][1],msgfinalEnemy.sound)
							playWarning = false
						end
						msgclear.sound = 'Complete.ogg'
						trigger.action.outTextForCoalition(codeCoalitions[numero1][2], msgclear.text, msgclear.displayTime)
						trigger.action.outSoundForCoalition(codeCoalitions[numero1][2],msgclear.sound)
						if allClearFlag then
							local msgfinal = {}
							--trigger.action.setUserFlag(901, true)
							msgfinal.text = teamCode[numero1] .. ' is victorious! Restarting Server in 60 seconds. It is recommended to disconnect to avoid DCS crash.'
							msgfinal.displayTime = 60  
							msgfinal.sound = 'victory_Lane.ogg'
							trigger.action.outText(msgfinal.text, msgfinal.displayTime)
							trigger.action.outSoundForCoalition(codeCoalitions[numero1][2],msgfinal.sound)
							trigger.action.outSoundForCoalition(codeCoalitions[numero1][1],'zone_killed.ogg')
							playWarning = false
							endMission()
						end	
					end
					if playWarning then
						local msgfinal = {}  
						msgfinal.text = 'Warning! ' .. numero2 .. ' is under attack.'
						msgfinal.displayTime = 5  
						msgfinal.sound = 'alert_UA.ogg'
						trigger.action.outTextForCoalition(codeCoalitions[numero1][1], msgfinal.text, msgfinal.displayTime)
						trigger.action.outSoundForCoalition(codeCoalitions[numero1][1],msgfinal.sound)
					else 
						playWarning = true
					end
				end
			end
		end
	end
end

function guidedBombingRun(coa)
	validateAliveUnits()
    local zone = ''
	local qty = 0
	FDS.bomberQty[coa] = FDS.bomberQty[coa] + 1
	updateTgtPositions()
	if coa == 'blue' then
		local z1,z2 = unpack(FDS.redZones)
		if #tgtObj['red'][z1] == #tgtObj['red'][z2] then 
			candidates = {z1, z2}
			zone = candidates[math.random(1,#candidates)]
		elseif #tgtObj['red'][z1] > #tgtObj['red'][z2] then
			zone = z1
		else
			zone = z2
		end
	else
		local z1,z2 = unpack(FDS.blueZones)
		if #tgtObj['blue'][z1] == #tgtObj['blue'][z2] then 
			candidates = {z1, z2}
			zone = candidates[math.random(1,#candidates)]
		elseif #tgtObj['blue'][z1] > #tgtObj['blue'][z2] then
			zone = z1
		else
			zone = z2
		end
	end
	bombingRunTable = {
		["Blue Zone 1"] = {"Red_Bomber_A1_Spaw","Red_Bomber_Zone1_Guiding","blue","Blue Zone 1",1,2},
		["Blue Zone 2"] = {"Red_Bomber_A2_Spaw","Red_Bomber_Zone2_Guiding","blue","Blue Zone 2",1,2},
		["Red Zone 1"] = {"Blue_Bomber_A1_Spaw","Blue_Bomber_Zone1_Guiding","red","Red Zone 1",2,1},
		["Red Zone 2"] = {"Blue_Bomber_A2_Spaw","Blue_Bomber_Zone2_Guiding","red","Red Zone 2",2,1}
	}
    for bomber = 1, 1 do
		local gp = Group.getByName(bombingRunTable[zone][2])
		local gPData = mist.getGroupData(bombingRunTable[zone][2],true)
		local gpR = mist.getGroupRoute(gp:getName(),true)
		local new_GPR = mist.utils.deepCopy(gpR)
		local new_gPData = mist.utils.deepCopy(gPData)
		local randomTgt = {}
		local randomTgtStr = {}
		local numberUnit = 0
		local strutNumber = 0
		for elementos = 1, #tgtObj[bombingRunTable[zone][3]][bombingRunTable[zone][4]] do 
			if tgtObj[bombingRunTable[zone][3]][bombingRunTable[zone][4]][elementos][4] == 3 then
				strutNumber = strutNumber + 1
				randomTgtStr[strutNumber] = elementos
			elseif tgtObj[bombingRunTable[zone][3]][bombingRunTable[zone][4]][elementos][4] == 2 then
				numberUnit = numberUnit + 1
				randomTgt[numberUnit] = elementos
			end
		end
		for multiTgt = 1, FDS.bomberTargetsNumber do
			if #randomTgt + #randomTgtStr == 0 then
				numberUnit = 0
				strutNumber = 0
				for elementos = 1, #tgtObj[bombingRunTable[zone][3]][bombingRunTable[zone][4]] do 
					if tgtObj[bombingRunTable[zone][3]][bombingRunTable[zone][4]][elementos][4] == 3 then
						strutNumber = strutNumber + 1
						randomTgtStr[strutNumber] = elementos
					elseif tgtObj[bombingRunTable[zone][3]][bombingRunTable[zone][4]][elementos][4] == 2 then
						numberUnit = numberUnit + 1
						randomTgt[numberUnit] = elementos
					end
				end
			end
			local selection = ''
			local selTgt = ''
			if #randomTgtStr > 0 then
				selection = math.random(1, #randomTgtStr)
				selTgt = tgtObj[bombingRunTable[zone][3]][bombingRunTable[zone][4]][randomTgtStr[selection]][2]
				table.remove(randomTgtStr,selection)
			else
				selection = math.random(1, #randomTgt)
				selTgt = tgtObj[bombingRunTable[zone][3]][bombingRunTable[zone][4]][randomTgt[selection]][2]
				table.remove(randomTgt,selection)	
			end			
			new_GPR[2].task.params.tasks[multiTgt].params.x = selTgt.x
			new_GPR[2].task.params.tasks[multiTgt].params.y = selTgt.y
		end
		pontinho = mist.getRandomPointInZone(bombingRunTable[zone][1])
		new_gPData.route = new_GPR 
		new_gPData.groupId = nil
		new_gPData.groupName = nil
		new_gPData.name = nil
		new_gPData.units[1].x = pontinho.x
		new_gPData.units[1].y = pontinho.y
		new_gPData.units[1].alt = new_gPData.units[1].alt + (math.random(1,200)-100.0)
		new_gPData.clone = true
		mist.dynAdd(new_gPData)
    end

	local msgBombingAlert = {}  
	msgBombingAlert.text = 'Warning! A large bomber formation is headed for ' .. bombingRunTable[zone][4]
	msgBombingAlert.displayTime = 20  
	msgBombingAlert.sound = 'Siren.ogg'
	trigger.action.outTextForCoalition(bombingRunTable[zone][6], msgBombingAlert.text, msgBombingAlert.displayTime)
	trigger.action.outSoundForCoalition(bombingRunTable[zone][6],msgBombingAlert.sound)

	local msgBombingInfo = {}  
	msgBombingInfo.text = 'An allied bomber formation is headed for ' .. bombingRunTable[zone][4] .. '. Support their effort!'
	msgBombingInfo.displayTime = 20  
	msgBombingInfo.sound = 'bombingRun.ogg'
	trigger.action.outTextForCoalition(bombingRunTable[zone][5], msgBombingInfo.text, msgBombingInfo.displayTime)
	trigger.action.outSoundForCoalition(bombingRunTable[zone][5],msgBombingInfo.sound)
    return zone
end

-- Transport AA mission
function checkTransport(coa)
	FDS.lastDropTime[coa] = timer.getTime()
	if Group.getByName(FDS.currentTransport[coa][2]) and Group.getByName(FDS.currentTransport[coa][2]):isExist() then
		local transportGp = Group.getByName(FDS.currentTransport[coa][2])
		local squadNumber = transportGp:getSize()
		if squadNumber > 0 then
			FDS.teamPoints[coa].Base = FDS.teamPoints[coa].Base + squadNumber*FDS.rewardCargo
			local msgTransp = {}  
			msgTransp.text = 'The air transport delivers our team ' .. squadNumber*FDS.rewardCargo .. ' points. More planes are on their way.'
			msgTransp.displayTime = 30  
			msgTransp.sound = 'AirDropDelivered2.ogg'
			trigger.action.outTextForCoalition(FDS.currentTransport[coa][1], msgTransp.text, msgTransp.displayTime)
			trigger.action.outSoundForCoalition(FDS.currentTransport[coa][1],msgTransp.sound)
			if FDS.teamPoints[coa].Base >= FDS.callCost then 
				local bombTimes = math.floor(FDS.teamPoints[coa].Base/FDS.callCost)
				for callIt = 1, bombTimes do
					--mist.scheduleFunction(bombingRun, {'blue'},timer.getTime()+FDS.bomberMinInterval*(callIt-1))
					mist.scheduleFunction(guidedBombingRun, {coa},timer.getTime()+FDS.bomberMinInterval*(callIt-1))
					FDS.teamPoints[coa].Base = FDS.teamPoints[coa].Base - FDS.callCost
				end
			end
			respawnTransport(coa)
		else
			respawnTransport(coa)
		end
	else
		respawnTransport(coa)
	end
end

function respawnTransport(coa)
	local callEscort = {
		['blue'] = 'Blue_Escort',
		['red'] = 'Red_Escort'
	}
	local callTransport = {
		['blue'] = 'Blue_Transport_Goods',
		['red'] = 'Red_Transport_Goods'
	}
	local desGroup1 = mist.getGroupData(callEscort[coa])
	local desRoute1 = mist.getGroupRoute(callEscort[coa],true)
	local copyGroup1 = mist.utils.deepCopy(desGroup1)
	local copyRoute1 = mist.utils.deepCopy(desRoute1)

	local desGroup2 = mist.getGroupData(callTransport[coa])
	local desRoute2 = mist.getGroupRoute(callTransport[coa],true)
	local copyGroup2 = mist.utils.deepCopy(desGroup2)
	local copyRoute2 = mist.utils.deepCopy(desRoute2)

	copyGroup2.route = copyRoute2 
	copyGroup2.groupId = nil
	copyGroup2.groupName = nil
	copyGroup2.name = nil
	local newGp = mist.dynAdd(copyGroup2)
	FDS.currentTransport[coa][2] = newGp['name']

	copyRoute1[1].task.params.tasks[1].params.groupId = newGp['groupId']
	copyGroup1.route = copyRoute1 
	copyGroup1.groupId = nil
	copyGroup1.groupName = nil
	copyGroup1.name = nil
	newGp = mist.dynAdd(copyGroup1)
end

function callReinforcements(coa)
	if coa == 2 then
		local gp = nil
		mist.cloneGroup('Molde_blue_AA',true)
		gp = mist.cloneGroup('Molde_blue_AG',true)
		for i, j in pairs(gp) do
			if i == 'name' then
				gpName = j
			end
		end
		createAG(j,2)

	elseif coa == 1 then
		local gp = nil	
		mist.cloneGroup('Molde_red_AA',true)
		gp = mist.cloneGroup('Molde_red_AG',true)
		for i, j in pairs(gp) do
			if i == 'name' then
				gpName = j
			end
		end
		createAG(j,1)	
	end
	return 'Ready'
end

function respawnAWACSFuel(coa)
	mist.respawnGroup(FDS.resAWACSTime[coa][1],true)
	FDS.resAWACSTime[coa][2] = mist.scheduleFunction(respawnAWACSFuel, {coa},timer.getTime()+FDS.fuelAWACSRestart)
end

function respawnTankerFuel(coa)
	mist.respawnGroup(FDS.resTankerTime[coa][1],true)
	FDS.resTankerTime[coa][2] = mist.scheduleFunction(respawnTankerFuel, {coa},timer.getTime()+FDS.fuelTankerRestart)
end

function respawnMPRSTankerFuel(coa)
	mist.respawnGroup(FDS.resMPRSTankerTime[coa][1],true)
	FDS.resTankerTime[coa][2] = mist.scheduleFunction(respawnMPRSTankerFuel, {coa},timer.getTime()+FDS.fuelTankerRestart)
end

function respawnAWACS(coa)
	sideAWACS = {{'Red_AWACS_1', 1, 2,'red'}, {'Blue_AWACS_1', 2, 1,'blue'}}
	mist.respawnGroup(sideAWACS[coa][1], true)
	FDS.resAWACSTime[sideAWACS[coa][4]][2] = mist.scheduleFunction(respawnAWACSFuel, {sideAWACS[coa][4]},timer.getTime()+FDS.fuelAWACSRestart)
	local msgAWACSBack = {}  
	msgAWACSBack.text = 'Enemy AWACS is back to action.'
	msgAWACSBack.displayTime = 10  
	msgAWACSBack.sound = 'Msg.ogg'
	trigger.action.outTextForCoalition(sideAWACS[coa][3], msgAWACSBack.text, msgAWACSBack.displayTime)
	trigger.action.outSoundForCoalition(sideAWACS[coa][3],msgAWACSBack.sound) 
	local msgAWACSBack = {}  
	msgAWACSBack.text = 'Our AWACS is back to action.'
	msgAWACSBack.displayTime = 10  
	msgAWACSBack.sound = 'Msg.ogg'
	trigger.action.outTextForCoalition(sideAWACS[coa][2], msgAWACSBack.text, msgAWACSBack.displayTime)
	trigger.action.outSoundForCoalition(sideAWACS[coa][2],msgAWACSBack.sound) 
end

function respawnTanker(coa)
	sideTanker = {{'Red_Tanker_1_Cesta', 1, 2,'red'}, {'Blue_Tanker_1_Cesta', 2, 1,'blue'}}
	mist.respawnGroup(sideTanker[coa][1], true)
	FDS.resTankerTime[sideTanker[coa][4]][2] = mist.scheduleFunction(respawnTankerFuel, {sideTanker[coa][4]},timer.getTime()+FDS.fuelTankerRestart)
	local msgTankerBack = {}  
	msgTankerBack.text = 'Enemy Basket Tanker is back to action.'
	msgTankerBack.displayTime = 10  
	msgTankerBack.sound = 'Msg.ogg'
	trigger.action.outTextForCoalition(sideTanker[coa][3], msgTankerBack.text, msgTankerBack.displayTime)
	trigger.action.outSoundForCoalition(sideTanker[coa][3],msgTankerBack.sound) 
	local msgTankerBack = {}  
	msgTankerBack.text = 'Our Basket Tanker is back to action.'
	msgTankerBack.displayTime = 10  
	msgTankerBack.sound = 'Msg.ogg'
	trigger.action.outTextForCoalition(sideTanker[coa][2], msgTankerBack.text, msgTankerBack.displayTime)
	trigger.action.outSoundForCoalition(sideTanker[coa][2],msgTankerBack.sound) 
end

function respawnTankerMPRS(coa)
	sideTanker = {{'Red_Tanker_1_Haste', 1, 2,'red'}, {'Blue_Tanker_1_Haste', 2, 1,'blue'}}
	mist.respawnGroup(sideTanker[coa][1], true)
	FDS.resMPRSTankerTime[sideTanker[coa][4]][2] = mist.scheduleFunction(respawnMPRSTankerFuel, {sideTanker[coa][4]},timer.getTime()+FDS.fuelTankerRestart)
	local msgTankerBack = {}  
	msgTankerBack.text = 'Enemy MPRS Tanker is back to action.'
	msgTankerBack.displayTime = 10  
	msgTankerBack.sound = 'Msg.ogg'
	trigger.action.outTextForCoalition(sideTanker[coa][3], msgTankerBack.text, msgTankerBack.displayTime)
	trigger.action.outSoundForCoalition(sideTanker[coa][3],msgTankerBack.sound) 
	local msgTankerBack = {}  
	msgTankerBack.text = 'Our MPRS Tanker is back to action.'
	msgTankerBack.displayTime = 10  
	msgTankerBack.sound = 'Msg.ogg'
	trigger.action.outTextForCoalition(sideTanker[coa][2], msgTankerBack.text, msgTankerBack.displayTime)
	trigger.action.outSoundForCoalition(sideTanker[coa][2],msgTankerBack.sound) 
end

function checkPlayersOn()
    local mistPlayerList = mist.DBs.humansByName
    local uList = {}
    
    local checkList = {}
    for i,j in  pairs{'blue','red'} do
        if j == 'blue' then 
            checkList[j] = {}
            for k in pairs(FDS.teamPoints.blue['Players']) do
                checkList[j][k] = true
            end
        else
            checkList[j] = {}
            for k in pairs(FDS.teamPoints.red['Players']) do
                checkList[j][k] = true
            end
        end
    end
    
    local uList = {}
    for i,v in pairs(mistPlayerList) do
        local unidade = Unit.getByName(v.unitName)
        table.insert(uList,unidade)
    end
    
    flagT = 0
    for i,j in pairs(uList) do
        if j:getCoalition() == 1 then
            for k,w in pairs(checkList.red) do 
                if j:getPlayerName() == k then
                    checkList.red[k] = false
                end
            end
        else
            for k,w in pairs(checkList.blue) do 
                flagT = w
                if j:getPlayerName() == k then
                    checkList.blue[k] = false
                end
            end    
        end
    end
    
    for i,j in pairs(FDS.teamPoints) do
        for k,w in pairs(FDS.teamPoints[i]['Players']) do
            if checkList[i][k] == true then
                FDS.teamPoints[i]['Players'][k] = nil
            end
        end
    end
end

function mysplit (inputstr, sep)
	if sep == nil then
			sep = "%s"
	end
	local t={}
	for str in string.gmatch(inputstr, "([^"..sep.."]+)") do
			table.insert(t, str)
	end
	return t
end

--Pairs
function pairsByKeys (t, f)
  local a = {}
  for n in pairs(t) do table.insert(a, n) end
  table.sort(a, f)
  local i = 0      -- iterator variable
  local iter = function ()   -- iterator function
    i = i + 1
    if a[i] == nil then return nil
    else return a[i], t[a[i]]
    end
  end
  return iter
end

--Increment
table.inc = function(t, item, inc)
	if inc == nil then
    	return
    else
    	titem = t[item]
    	if titem == nil then
        	t[item] = inc
        else
        	t[item] = titem + inc
        end
    end
end

--Battle Status
function FDS.warStatus(g_id)
	local msg = {}
	msg.text = 'Mission Status:\n \n'
   	msg.displayTime = 30
   	msg.sound = 'Msg.ogg'
	gpUcid = FDS.retrieveUcid(g_id[3],FDS.isName)
	for _, i in pairs({'blue','red'}) do
		if i == 'blue' then
			for _,j in pairs(FDS.blueZones) do
				local unitQtyBlue = 0
				local structureQtyBlue = 0
				local infantryQtyBlue = 0
				if FDS.zoneSts.blue[j] == 'Hot' then 
					stsMsg = tostring(#tgtObj[i][j]) 
					for _,k in pairs(tgtObj.blue[j]) do
						if Group.getByName(k[1]) then
							-- If it is unit
							if Group.getByName(k[1]):getUnits()[1]:hasAttribute('Infantry') then
								infantryQtyBlue = infantryQtyBlue + 1
							elseif Group.getByName(k[1]):getUnits()[1]:hasAttribute('Ground vehicles') then
								unitQtyBlue = unitQtyBlue + 1
							end
						else
							-- If it is structure
							structureQtyBlue = structureQtyBlue + 1
						end
					end
				else 
					stsMsg = 'Cleared.' 
				end
				msg.text = msg.text .. j .. ': ' .. stsMsg .. ' -- Vehicles: '.. unitQtyBlue .. '  Infantry: '.. infantryQtyBlue .. '  Structures: ' .. structureQtyBlue .. '\n'
			end
		else
			for _,j in pairs(FDS.redZones) do
				local unitQtyRed = 0
				local structureQtyRed = 0
				local infantryQtyRed = 0
				if FDS.zoneSts.red[j] == 'Hot' then 
					stsMsg = tostring(#tgtObj[i][j]) 
					for _,k in pairs(tgtObj.red[j]) do
						if Group.getByName(k[1]) ~= nil and Group.getByName(k[1]):getUnits()[1] ~= nil then
							-- If it is unit
							if Group.getByName(k[1]):getUnits()[1]:hasAttribute('Infantry') then
								infantryQtyRed = infantryQtyRed + 1
							elseif Group.getByName(k[1]):getUnits()[1]:hasAttribute('Ground vehicles') then
								unitQtyRed = unitQtyRed + 1
							end
						else
							-- If it is structure
							structureQtyRed = structureQtyRed + 1
						end
					end
				else 
					stsMsg = 'Cleared.' 
				end
				msg.text = msg.text .. j .. ': ' .. stsMsg .. ' -- Vehicles: '.. unitQtyRed .. '  Infantry: '.. infantryQtyRed .. '  Structures: ' .. structureQtyRed .. '\n'
			end
		end
		msg.text = msg.text .. '\n -------------------- \n \n'
	end

	if g_id[2] == 2 then
		local blueAWACS = 'Inactive'
		if Unit.getByName('Blue_AWACS_1') then
			blueAWACS = 'Active'
		end
		msg.text = msg.text .. 'Blue AWACS: '.. blueAWACS
		local redAWACS = 'Inactive'
		if Unit.getByName('Red_AWACS_1') then
			redAWACS = 'Active'
		end
		msg.text = msg.text .. '\nRed AWACS: '.. redAWACS .. '\n'
		msg.text = msg.text .. '\n -------------------- \n \n'
		msg.text = msg.text .. 'Base points: ' .. tostring(FDS.teamPoints.blue.Base) .. '\nYour plane is carrying ' .. tostring(FDS.teamPoints.blue['Players'][g_id[3]]) .. ' points. \n'
		msg.text = msg.text .. '\n -------------------- \n \n'
		msg.text = msg.text .. 'Your Credits: ' .. tostring(FDS.playersCredits.blue[gpUcid])
	else
		local redAWACS = 'Inactive'
		if Unit.getByName('Red_AWACS_1') then
			redAWACS = 'Active'
		end
		msg.text = msg.text .. 'Red AWACS: '.. redAWACS
		local blueAWACS = 'Inactive'
		if Unit.getByName('Blue_AWACS_1') then
			blueAWACS = 'Active'
		end
		msg.text = msg.text .. '\nBlue AWACS: '.. blueAWACS .. '\n'
		msg.text = msg.text .. '\n -------------------- \n \n'
		msg.text = msg.text .. 'Base Points: ' .. tostring(FDS.teamPoints.red.Base) .. '\nYour plane has ' .. tostring(FDS.teamPoints.red['Players'][g_id[3]]) .. ' points. \n'
		msg.text = msg.text .. '\n -------------------- \n \n'
		msg.text = msg.text .. 'Your Credits: ' .. tostring(FDS.playersCredits.red[gpUcid])
	end

	trigger.action.outTextForGroup(g_id[1], msg.text, msg.displayTime)
	trigger.action.outSoundForGroup(g_id[1],msg.sound)
end

function checkDropZones()
	for _,i in pairs(FDS.dropZones) do
		trigger.action.smoke(i[1],3)
	end
end

-- Where to Attack
function FDS.whereStrike(g_id)
	local msg = {}
   	msg.displayTime = 30
   	msg.sound = 'Msg.ogg'
	
	local zones = mist.DBs.zonesByName

	if g_id[2] == 2 then
		msg.text = 'Attack Red Zones:\n \n'
		for _,j in pairs(FDS.redZones) do
			local structureQty = 0
			local unitQty = 0
			local infantryQty = 0
			if FDS.zoneSts.red[j] == 'Hot' then 
				stsMsg = tostring(#tgtObj.red[j]) 
				for _,k in pairs(tgtObj.red[j]) do
					if Group.getByName(k[1]) then
						-- If it is unit
						if Group.getByName(k[1]):getUnits()[1]:hasAttribute('Infantry') then
							infantryQty = infantryQty + 1
						elseif Group.getByName(k[1]):getUnits()[1]:hasAttribute('Ground vehicles') then
							unitQty = unitQty + 1
						end
					else
						-- If it is structure
						structureQty = structureQty + 1
					end
				end
			else 
				stsMsg = 'Cleared.' 
			end
			msg.text = msg.text .. j .. ': ' .. stsMsg .. ' remaining targets -- '.. unitQty .. ' vehicles ' .. infantryQty .. ' soldiers ' .. structureQty .. ' structures.' .. '\n'
			
			local var = {}
			local varMGRS = {}
			local varLL = {}
			local LO = ''
			local LL = ''
			local DIS = ''
			var.units = {g_id[3]} -- Name Unit
			varMGRS.acc = 4
			varLL.acc = 4
			var.ref = zones[j].point
			var.alt = 0
			bra =  mist.getBRString(var)
			bra2 = mysplit(bra,' ')
			bra3 = bra2[1] + 180.0 - mist.utils.toDegree(mist.getNorthCorrection(zones[j].point))

			LL, LO, DIS = coord.LOtoLL(var.ref)
			mgrs1 = coord.LLtoMGRS(LL, LO)
			ll1 = mist.tostringLL(LL, LO, varLL.acc)
			ll1 = mysplit(ll1, '\t')
			mgrs1 = mist.tostringMGRS(mgrs1,varMGRS.acc)
			
			if bra3 > 360.0 then
				bra3 = bra3 - 360.0
			end
			-- Bearing and Range
			msg.text = msg.text .. 'Bearing and range (from you): ' .. tostring(math.floor(bra3+0.7)) ..' '.. bra2[2] ..' '.. bra2[3] .. '\n'
			-- LL
			msg.text = msg.text .. 'Zone coordinates: ' .. ll1[1] .. ' ' .. ll1[2] .. '\n'
			-- MGRS
			msg.text = msg.text .. 'MGRS coordinates: ' .. mgrs1 .. '\n\n'
		end
	else
		msg.text = 'Attack Blue Zones:\n \n'
		for _,j in pairs(FDS.blueZones) do
			local structureQty = 0
			local unitQty = 0
			local infantryQty = 0
			if FDS.zoneSts.blue[j] == 'Hot' then 
				stsMsg = tostring(#tgtObj.blue[j]) 
				for _,k in pairs(tgtObj.blue[j]) do
					if Group.getByName(k[1]) then
						-- If it is unit
						if Group.getByName(k[1]):getUnits()[1]:hasAttribute('Infantry') then
							infantryQty = infantryQty + 1
						elseif Group.getByName(k[1]):getUnits()[1]:hasAttribute('Ground vehicles') then
							unitQty = unitQty + 1
						end
					else
						-- If it is structure
						structureQty = structureQty + 1
					end
				end
			else 
				stsMsg = 'Cleared.' 
			end
			msg.text = msg.text .. j .. ': ' .. stsMsg .. ' remaining targets -- '.. unitQty .. ' vehicles ' .. infantryQty .. ' soldiers ' .. structureQty .. ' structures.' .. '\n'
			
			local var = {}
			local varMGRS = {}
			local varLL = {}
			local LO = ''
			local LL = ''
			local DIS = ''
			var.units = {g_id[3]} -- Name Unit
			varMGRS.acc = 4
			varLL.acc = 4
			var.ref = zones[j].point
			var.alt = 0
			bra =  mist.getBRString(var)
			bra2 = mysplit(bra,' ')
			bra3 = bra2[1] + 180.0 - mist.utils.toDegree(mist.getNorthCorrection(zones[j].point))

			LL, LO, DIS = coord.LOtoLL(var.ref)
			mgrs1 = coord.LLtoMGRS(LL, LO)
			ll1 = mist.tostringLL(LL, LO, varLL.acc)
			ll1 = mysplit(ll1, '\t')
			mgrs1 = mist.tostringMGRS(mgrs1,varMGRS.acc)

			if bra3 > 360.0 then
				bra3 = bra3 - 360.0
			end
			-- Bearing and Range
			msg.text = msg.text .. 'Bearing and range (from you): ' .. tostring(math.floor(bra3+0.7)) ..' '.. bra2[2] ..' '.. bra2[3] .. '\n'
			-- LL
			msg.text = msg.text .. 'Zone coordinates: ' .. ll1[1] .. ' ' .. ll1[2] .. '\n'
			-- MGRS
			msg.text = msg.text .. "MGRS coordinates: " .. mgrs1 .. "\n\n"
		end
	end
	trigger.action.outTextForGroup(g_id[1], msg.text, msg.displayTime)
	trigger.action.outSoundForGroup(g_id[1],msg.sound)
end

-- Where to Defend
function FDS.whereDefend(g_id)
	local msg = {}
   	msg.displayTime = 30
   	msg.sound = 'Msg.ogg'
	
	local zones = mist.DBs.zonesByName

	if g_id[2] == 2 then
		msg.text = 'Defend Blue Zones:\n \n'
		for _,j in pairs(FDS.blueZones) do
			local structureQty = 0
			local unitQty = 0
			if FDS.zoneSts.blue[j] == 'Hot' then 
				stsMsg = tostring(#tgtObj.blue[j]) 
				for _,k in pairs(tgtObj.blue[j]) do
					if Group.getByName(k[1]) then
						-- If it is unit
						unitQty = unitQty + 1
					else
						-- If it is structure
						structureQty = structureQty + 1
					end
				end
			else  
				stsMsg = 'Cleared.' 
			end
			msg.text = msg.text .. j .. ': ' .. stsMsg .. ' remaining objects -- '.. unitQty .. ' units and ' .. structureQty .. ' structures.' .. '\n'
			
			local var = {}
			local varMGRS = {}
			local varLL = {}
			local LO = ''
			local LL = ''
			local DIS = ''
			var.units = {g_id[3]} -- Name Unit
			varMGRS.acc = 4
			varLL.acc = 4
			var.ref = zones[j].point
			var.alt = 0
			bra =  mist.getBRString(var)
			bra2 = mysplit(bra,' ')
			bra3 = bra2[1] + 180.0 - mist.utils.toDegree(mist.getNorthCorrection(zones[j].point))

			LL, LO, DIS = coord.LOtoLL(var.ref)
			mgrs1 = coord.LLtoMGRS(LL, LO)
			ll1 = mist.tostringLL(LL, LO, varLL.acc)
			ll1 = mysplit(ll1, '\t')
			mgrs1 = mist.tostringMGRS(mgrs1,varMGRS.acc)
			
			if bra3 > 360.0 then
				bra3 = bra3 - 360.0
			end
			-- Bearing and Range
			msg.text = msg.text .. 'Bearing and range (from you): ' .. tostring(math.floor(bra3+0.7)) ..' '.. bra2[2] ..' '.. bra2[3] .. '\n'
			-- LL
			msg.text = msg.text .. 'Zone coordinates: ' .. ll1[1] .. ' ' .. ll1[2] .. '\n'
			-- MGRS
			msg.text = msg.text .. "MGRS coordinates: " .. mgrs1 .. "\n\n"
		end
	else
		msg.text = 'Defend Red Zones:\n \n'
		for _,j in pairs(FDS.redZones) do
			local structureQty = 0
			local unitQty = 0
			if FDS.zoneSts.red[j] == 'Hot' then 
				stsMsg = tostring(#tgtObj.red[j]) 
				for _,k in pairs(tgtObj.red[j]) do
					if Group.getByName(k[1]) then
						-- If it is unit
						unitQty = unitQty + 1
					else
						-- If it is structure
						structureQty = structureQty + 1
					end
				end
			else 
				stsMsg = 'Cleared.' 
			end
			msg.text = msg.text .. j .. ': ' .. stsMsg .. ' remaining objects -- '.. unitQty .. ' units and ' .. structureQty .. ' structures.' .. '\n'
			
			local var = {}
			local varMGRS = {}
			local varLL = {}
			local LO = ''
			local LL = ''
			local DIS = ''
			var.units = {g_id[3]} -- Name Unit
			varMGRS.acc = 4
			varLL.acc = 4
			var.ref = zones[j].point
			var.alt = 0
			bra =  mist.getBRString(var)
			bra2 = mysplit(bra,' ')
			bra3 = bra2[1] + 180.0 - mist.utils.toDegree(mist.getNorthCorrection(zones[j].point))

			LL, LO, DIS = coord.LOtoLL(var.ref)
			mgrs1 = coord.LLtoMGRS(LL, LO)
			ll1 = mist.tostringLL(LL, LO, varLL.acc)
			ll1 = mysplit(ll1, '\t')
			mgrs1 = mist.tostringMGRS(mgrs1,varMGRS.acc)
			
			if bra3 > 360.0 then
				bra3 = bra3 - 360.0
			end
			-- Bearing and Range
			msg.text = msg.text .. 'Bearing and range (from you): ' .. tostring(math.floor(bra3+0.7)) ..' '.. bra2[2] ..' '.. bra2[3] .. '\n'
			-- LL
			msg.text = msg.text .. 'Zone coordinates: ' .. ll1[1] .. ' ' .. ll1[2] .. '\n'
			-- MGRS
			msg.text = msg.text .. "MGRS coordinates: " .. mgrs1 .. "\n\n"
		end
	end
	trigger.action.outTextForGroup(g_id[1], msg.text, msg.displayTime)
	trigger.action.outSoundForGroup(g_id[1],msg.sound)
end

-- Remaining Dropzones
function FDS.whereDropZones(g_id)
	local msg = {}
   	msg.displayTime = 30
   	msg.sound = 'Msg.ogg'
	msg.text = 'Current Active drop zones:\n \n'
	for numb, def in pairs(FDS.dropZones) do	
		local var = {}
		local varMGRS = {}
		local varLL = {}
		local LO = ''
		local LL = ''
		local DIS = ''
		var.units = {g_id[3]} -- Name Unit
		varMGRS.acc = 4
		varLL.acc = 4
		var.ref = def[1]
		var.alt = 0
		bra =  mist.getBRString(var)
		bra2 = mysplit(bra,' ')
		bra3 = bra2[1] + 180.0 - mist.utils.toDegree(mist.getNorthCorrection(def[1]))

		LL, LO, DIS = coord.LOtoLL(var.ref)
		mgrs1 = coord.LLtoMGRS(LL, LO)
		ll1 = mist.tostringLL(LL, LO, varLL.acc)
		ll1 = mysplit(ll1, '\t')
		mgrs1 = mist.tostringMGRS(mgrs1,varMGRS.acc)
		
		if bra3 > 360.0 then
			bra3 = bra3 - 360.0
		end
		
		msg.text = msg.text .. 'Zone ' .. numb .. ' with ' .. def[2] .. ' points: BRA -> '.. tostring(math.floor(bra3+0.7)) ..' '.. bra2[2] .. ' '.. bra2[3] .. '\n\n'
	end
	msg.text = msg.text .. 'Recently picked drop zones:\n \n'
	for numb, def in pairs(FDS.retrievedZones) do	
		local var = {}
		local varMGRS = {}
		local varLL = {}
		local LO = ''
		local LL = ''
		local DIS = ''
		var.units = {g_id[3]} -- Name Unit
		varMGRS.acc = 4
		varLL.acc = 4
		var.ref = def[1]
		var.alt = 0
		bra =  mist.getBRString(var)
		bra2 = mysplit(bra,' ')
		bra3 = bra2[1] + 180.0 - mist.utils.toDegree(mist.getNorthCorrection(def[1]))

		LL, LO, DIS = coord.LOtoLL(var.ref)
		mgrs1 = coord.LLtoMGRS(LL, LO)
		ll1 = mist.tostringLL(LL, LO, varLL.acc)
		ll1 = mysplit(ll1, '\t')
		mgrs1 = mist.tostringMGRS(mgrs1,varMGRS.acc)
		
		if bra3 > 360.0 then
			bra3 = bra3 - 360.0
		end

		msg.text = msg.text .. 'Zone ' .. numb .. ' with ' .. def[2] .. ' points: BRA -> '.. tostring(math.floor(bra3+0.7)) ..' '.. bra2[2] .. ' '.. bra2[3] .. '. Retrieved \n\n' --.. tostring(def[4]-timer.getTime()) .. ' minutes ago.' .. '\n\n'
	end
	trigger.action.outTextForGroup(g_id[1], msg.text, msg.displayTime)
	trigger.action.outSoundForGroup(g_id[1],msg.sound)
end

function FDS.nameGroup(_initEnt)
	local _initGroup = _initEnt:getGroup()
	local _initGroupName = _initGroup:getName()
	return _initGroupName
end

function FDS.coalitionCheck(_initator)
	local _initGroup = _initator:getCoalition()
	return _initGroup
end

function FDS.playerCheck(_initiator)
	local checkPl = _initiator:getPlayerName()
	return checkPl
end

function FDS.idCheck(_initEnt)
	local checkID = _initEnt:getID()
	return checkID
end

function isUnitorStructure(_initiator, _target)
	local initCheck = false
	local tgtCheck = false
	if _initiator:getCategory() == 1 or _initiator:getCategory() == 3 then
		initCheck = true
	end
	if _target:getCategory() == 1 or _target:getCategory() == 3 then
		tgtCheck = true
	end
	if initCheck and tgtCheck then
		return true
	else
		return false
	end
end

function has_value (tab, val)
	for index, value in ipairs(tab) do
		if value == val then
			return true
		end
	end
	return false
end

function createRandomDrop()
	local zoneAcc = 0
	for _,i in pairs(FDS.dropZones) do
		if i[3] == nil then
			zoneAcc = zoneAcc + 1
		end
	end
	if zoneAcc < FDS.randomDropLimit then
		local point3 = mist.getRandomPointInZone(FDS.randomDropZones[mist.random(#FDS.randomDropZones)])
		--local point3 = mist.getRandomPointInZone('Random_Test')
		point3.z = point3.y
		point3.y = land.getHeight({x = point3.x,y = point3.z})
		trigger.action.smoke(point3,3)
		table.insert(FDS.dropZones, {point3, FDS.randomDropValue})
		local msgRandom = {}
		msgRandom.text = 'A new random drop zone has been created.'
		msgRandom.displayTime = 30  
		msgRandom.sound = 'Msg.ogg'
		trigger.action.outText(msgRandom.text, msgRandom.displayTime)
		trigger.action.outSound(msgRandom.sound) 
		trigger.action.smoke(point3,3)
	end
end

function recordLandPoints(_initEnt, coa)
	--local activePlayerList = net.get_player_list()
	--local activePlayerListTable = {}
	--for _, i in pairs(activePlayerList) do
	--	table.insert(activePlayerListTable, net.get_player_info(i))
	--end
	--if FDS.recordDeliveredPoints[_initEnt:getPlayerName()] ~= nil then
	--	table.insert(FDS.recordDeliveredPoints[_initEnt:getPlayerName()], FDS.teamPoints[coa]['Players'][_initEnt:getPlayerName()])
	--else
	--	FDS.recordDeliveredPoints[_initEnt:getPlayerName()] = {FDS.teamPoints[coa]['Players'][_initEnt:getPlayerName()],FDS.teamPoints[coa]['Players'][_initEnt:getPlayerName()]}
	--end
	local activePlayerList = net.get_player_list()
	local activePlayerListTable = {}
	for _, i in pairs(activePlayerList) do
		table.insert(activePlayerListTable, net.get_player_info(i))
	end
	local newID = true
	for _, i in pairs(activePlayerListTable) do
		if i.name == _initEnt:getPlayerName() then 
			if FDS.recordDeliveredPoints == nil then
				FDS.recordDeliveredPoints = {}
			end
			for index, data in pairs(FDS.recordDeliveredPoints) do
				if i.ucid == data.ucid then
					newID = false
					if FDS.recordDeliveredPoints[index]['deliveries'] ~= nil then
						table.insert(FDS.recordDeliveredPoints[index]['deliveries'], {['name']= i.name,['value']= FDS.teamPoints[coa]['Players'][_initEnt:getPlayerName()], ['aircraft'] = _initEnt:getDesc().typeName})
					else
						FDS.recordDeliveredPoints[index]['deliveries'] = {}
					end
				end
			end
            if newID then 
                table.insert(FDS.recordDeliveredPoints, {['ucid'] = i.ucid, ['deliveries'] = {{['name']= i.name,['value']= FDS.teamPoints[coa]['Players'][_initEnt:getPlayerName()], ['aircraft'] = _initEnt:getDesc().typeName}}})
            end            
		end
	end
end

function closestZone(point)
	zonas = {}
	zon = mist.DBs.zonesByName
	for i = 1,FDS.numberZones,1 do
		zonas[i] = 'RandomDZ' .. tostring(i)
	end	
	for _,j in pairs(zonas) do
		local pointTrial = mist.getRandomPointInZone(j)
		pointTrial.z = pointTrial.y
		pointTrial.y = land.getHeight({x = pointTrial.x,y = pointTrial.z})
		if not minDist or minDist > mist.utils.get3DDist(point, pointTrial) then
			minDist = mist.utils.get3DDist(point, pointTrial)
			finalPoint = pointTrial
		end
	end
	return finalPoint
end

function detectHover()
	activeHelicopters = {}
    activeHelicopterPositions = {}
	activeHelicopterVelocity = {}
	hoverMessages = {
		[1] = "You start hovering over the rescue point. We are starting to retrieve the goods.",
		[2] = "Continue to hover until the goods are recovered.",
		[3] = "The points have been recovered."
	}
	for _,i in pairs(mist.DBs.aliveUnits) do
		if i.category == 'helicopter' and (i.type == 'UH-1H' or i.type == 'Mi-8MT' or i.type == 'SA342Mistral' or i.type =='Mi-24P') then
			table.insert(activeHelicopters, i)
            table.insert(activeHelicopterPositions, i.pos)
			if FDS.positionHist[i.unit:getPlayerName()] == nil then 
				FDS.positionHist[i.unit:getPlayerName()] = i.pos 
			end
			activeHelicopterVelocity[i.unit:getPlayerName()] = (1.0/FDS.refreshScan) * math.sqrt((i.pos.x - FDS.positionHist[i.unit:getPlayerName()].x)^2+(i.pos.y - FDS.positionHist[i.unit:getPlayerName()].y)^2+(i.pos.z - FDS.positionHist[i.unit:getPlayerName()].z)^2)
			FDS.positionHist[i.unit:getPlayerName()] = i.pos
		end
	end
    for i,j in pairs(FDS.activeHovers) do
        local goner = true
        for _,k in pairs(activeHelicopters) do
            if i == k.unitName then goner = false end
        end
        if goner then FDS.activeHovers[i] = nil end
    end
	for drop,i in pairs(FDS.dropZones) do
		polyZone = {}
		for j = 1, FDS.hoveringResolution do
			table.insert(polyZone, mist.utils.makeVec3GL({x = i[1].x + FDS.hoveringRadius*math.sin(2*math.pi*j/FDS.hoveringResolution), z = i[1].z + FDS.hoveringRadius*math.cos(2*math.pi*j/FDS.hoveringResolution)}))
		end
        for j,k in pairs(activeHelicopterPositions) do
			--,i[1].y + FDS.hoveringAltitude
            if mist.pointInPolygon(k,polyZone) and activeHelicopterVelocity[activeHelicopters[j].unit:getPlayerName()] < FDS.velocityLimit then
                local relDeviation = math.sqrt((k.x-i[1].x)^2 + (k.z-i[1].z)^2)
                if FDS.activeHovers[activeHelicopters[j].unitName] == nil then
                	FDS.activeHovers[activeHelicopters[j].unitName] = {relDeviation, k, 1, i[1], 0}
                else
					local msgHover = {}
					local gp = activeHelicopters[j].groupId
					msgHover.text = hoverMessages[math.floor(1+(FDS.activeHovers[activeHelicopters[j].unitName][3]*FDS.refreshScan/FDS.hoveringTotalTime))]
					msgHover.displayTime = FDS.hoveringTotalTime/3.0
					msgHover.sound = 'Msg.ogg'
					if FDS.activeHovers[activeHelicopters[j].unitName][5] ~= math.floor(1+(FDS.activeHovers[activeHelicopters[j].unitName][3]*FDS.refreshScan/FDS.hoveringTotalTime)) then
						trigger.action.outTextForGroup(gp, msgHover.text, msgHover.displayTime)
						trigger.action.outSoundForGroup(gp,msgHover.sound)
						FDS.activeHovers[activeHelicopters[j].unitName][5] = math.floor(1+(FDS.activeHovers[activeHelicopters[j].unitName][3]*FDS.refreshScan/FDS.hoveringTotalTime))
					end
					if 1+(FDS.activeHovers[activeHelicopters[j].unitName][3]*FDS.refreshScan/FDS.hoveringTotalTime) >= 3.0 then
						local gpCoa = activeHelicopters[j].unit:getCoalition()
						local gpId = activeHelicopters[j].unit:getGroup()
						local msgAll = {}
						if gpCoa == 2 then
							msgAll.text = 'A blue helicopter has retrieved points from a drop zone.'
						else
							msgAll.text = 'A red helicopter has retrieved points from a drop zone.'
						end
						msgAll.displayTime = 20  
						msgAll.sound = 'dropCaptured.ogg'
						trigger.action.outText(msgAll.text, msgAll.displayTime)
						trigger.action.outSound(msgAll.sound)

						local msgLand = {}
						msgLand.text = 'You retrieve  ' .. tostring(FDS.dropZones[drop][2]) .. '.'
						msgLand.displayTime = 20  
						msgLand.sound = 'Msg.ogg'
						trigger.action.outTextForGroup(gpId:getID(), msgLand.text, msgLand.displayTime)
						trigger.action.smoke(FDS.dropZones[drop][1], 2)
						if gpCoa == 2 then
							FDS.teamPoints.blue.Players[activeHelicopters[j].unit:getPlayerName()] = FDS.teamPoints.blue.Players[activeHelicopters[j].unit:getPlayerName()] + FDS.dropZones[drop][2]
						else
							FDS.teamPoints.red.Players[activeHelicopters[j].unit:getPlayerName()] = FDS.teamPoints.red.Players[activeHelicopters[j].unit:getPlayerName()] + FDS.dropZones[drop][2]
						end
						FDS.activeHovers[activeHelicopters[j].unitName] = nil
						local retId = #FDS.retrievedZones
						table.insert(FDS.retrievedZones, {FDS.dropZones[drop][1], FDS.dropZones[drop][2], timer.getTime(),retId})
						mist.scheduleFunction(clearRetrieved, {retId}, timer.getTime()+300.)
						table.remove(FDS.dropZones,drop)
					end
                    FDS.activeHovers[activeHelicopters[j].unitName][3] = FDS.activeHovers[activeHelicopters[j].unitName][3] + 1
                end
            else
				if FDS.activeHovers[activeHelicopters[j].unitName] ~= nil and FDS.activeHovers[activeHelicopters[j].unitName][4].x == i[1].x and FDS.activeHovers[activeHelicopters[j].unitName][4].y == i[1].y and FDS.activeHovers[activeHelicopters[j].unitName][4].z == i[1].z then
					local msgHover = {}
					local gp = activeHelicopters[j].groupId
					msgHover.text = 'You have lost the hovering stance. Start over again.'
					msgHover.displayTime = FDS.refreshScan - 1
					msgHover.sound = 'hover_Failure.ogg'
					trigger.action.outTextForGroup(gp, msgHover.text, msgHover.displayTime)
					trigger.action.outSoundForGroup(gp,msgHover.sound)
					FDS.activeHovers[activeHelicopters[j].unitName] = nil
				end
			end
        end
	end
end

function removeEngagement(pName)
	FDS.currentEngagements[pName] = nil
end

function clearRetrieved(id)
	for i,j in pairs(FDS.retrievedZones) do
		if j[4] == id then
			table.remove(FDS.retrievedZones,i)
		end
	end
end

function endMission()
	if FDS.exportDataSite then
		pcall(killDCSProcess,{})
	end
end

function ping(a)
	local msgPing = {}
	msgPing.text = 'Debug -> argument ' .. a
	msgPing.displayTime = 5
	msgPing.sound = 'Msg.ogg'
	trigger.action.outText(msgPing.text, msgPing.displayTime)
	trigger.action.outSound(msgPing.sound)
end

function find(tbl, val)
    for k, v in pairs(tbl) do
        if v == val then return k end
    end
    return nil
end

function checkExistentialCrisis(rewardDict, _targetEntLocal)
	if _targetEntLocal and _targetEntLocal:getDesc() and _targetEntLocal:getDesc().typeName and rewardDict[_targetEntLocal:getDesc().typeName] then
		return true
	end
end

function targetInServer()
	validateAliveUnits()
    for unidade, killData in pairs(FDS.lastHits) do
    	if killData ~= nil and killData[4] ~= nil and killData[4].target ~= nil and not killData[4].target:isExist() then
			local _initEntLocal = killData[3]
			local _targetEntLocal = killData[4].target
			if pcall(checkExistentialCrisis,FDS.rewardDict, _targetEntLocal) then
				local initCheck = pcall(FDS.playerCheck,_initEntLocal)
				local initCoaCheck = pcall(FDS.coalitionCheck,_initEntLocal)
				local targetCoaCheck = pcall(FDS.coalitionCheck,_targetEntLocal)
				local initCoa = 0
				local targetCoa = 0
				local rewardType = ''
				if _targetEntLocal and _targetEntLocal:getDesc() and _targetEntLocal:getDesc().typeName and FDS.rewardDict[_targetEntLocal:getDesc().typeName] then
					rewardType = _targetEntLocal:getDesc().typeName
				else
					rewardType = 'Default'
				end
				if initCoaCheck and targetCoaCheck then
					initCoa = _initEntLocal:getCoalition()
					targetCoa = _targetEntLocal:getCoalition()
				end
				awardPoints(initCheck, initCoaCheck, targetCoaCheck, initCoa, targetCoa, _initEntLocal, _targetEntLocal, rewardType, false)
				awardIndirectCredit(initCoaCheck, targetCoaCheck, initCoa, targetCoa, _initEntLocal, _targetEntLocal, rewardType, false)
				killData[2] = true
			else
				local infile = io.open(FDS.exportPath .. "missionError.log", "a")
				local instr = infile:write("Warning! At time: Day: " .. os.date("%d") .. "/" .. os.date("%m") .. "/" .. os.date("%y") .. " - Hour: " .. os.date("%H") .. ":" .. os.date("%M") .. ":" .. os.date("%S") .. " - Func: " .. func .. "\n" .. message .. "\n" .. "FDS.lastHits is losing the entry: with target name " .. killData[5].uName .. ", which has Player Name: " .. killData[5].pName .. " \n")
				infile:close()
				FDS.lastHits[killData[5].uID] = nil
			end
        end        
    end
end

function assembleKillObject(initCheck, targetCheck, _event, _eventComplementar, editFDS, bypassEvent)
	FDS.killEventNumber = FDS.killEventNumber + 1
	eventExport = {}
	eventExport['time'] = _event.time
	eventExport['eventID'] = _event.id 
	if _eventComplementar ~= nil then
		eventExport['initiatorUcid'] = _eventComplementar["initiatorUcid"] or nil
		eventExport['initiatorPlayerName'] = _eventComplementar["initiatorPlayerName"] or nil
		eventExport['initiatorName'] = _eventComplementar["initiatorName"] or nil
		eventExport['initiatorCoalition'] = _eventComplementar["initiatorCoalition"] or nil
		eventExport['targetUcid'] = _eventComplementar["targetUcid"] or nil
		eventExport['targetPlayerName'] = _eventComplementar["targetPlayerName"] or nil
		eventExport['targetName'] = _eventComplementar["targetName"] or nil
		eventExport['targetCoalition'] = _eventComplementar["targetCoalition"] or nil
		eventExport['weaponCategory'] = _eventComplementar["weaponCategory"] or nil 
		eventExport['weaponDisplayName'] = _eventComplementar["weaponDisplayName"] or nil 
		eventExport['isPvP'] = _eventComplementar["isPvP"] or nil
	else
		eventExport['initiatorUcid'] = nil
		eventExport['initiatorPlayerName'] = nil
		eventExport['initiatorName'] = nil
		eventExport['initiatorCoalition'] = nil
		eventExport['targetUcid'] = nil
		eventExport['targetPlayerName'] = nil
		eventExport['targetName'] = nil
		eventExport['targetCoalition'] = nil
		eventExport['weaponCategory'] =  nil 
		eventExport['weaponDisplayName'] = nil 
		eventExport['isPvP'] = nil
	end

	if not bypassEvent then
		if initCheck and _event['initiator'] ~= nil and _event['initiator']:getPlayerName() and _event['initiator']:getPlayerName() ~= nil then 
			local activePlayerList = net.get_player_list()
			local activePlayerListTable = {}
			for _, i in pairs(activePlayerList) do
				table.insert(activePlayerListTable, net.get_player_info(i))
			end
			for _, i in pairs(activePlayerListTable) do
				if _event['initiator'] ~= nil and _event['initiator']:getPlayerName() and i.name == _event['initiator']:getPlayerName() then 
					eventExport['initiatorUcid'] = i.ucid
					eventExport['initiatorPlayerName'] = _event['initiator']:getPlayerName()
				end
			end
		end
		if _event['initiator'] and _event['initiator'] ~= nil and _event['initiator']:getDesc() and _event['initiator']:getDesc() ~= nil then 
			--eventExport['initiatorDesc'] = eventExport['initiator']:getDesc()
			eventExport['initiatorName'] = _event['initiator']:getName()
			if _event['initiator'] and _event['initiator'] ~= nil and _event['initiator']:getCoalition() and _event['initiator']:getCoalition() ~= nil then
				eventExport['initiatorCoalition'] = _event['initiator']:getCoalition()
			end
			if _event['initiator'] and _event['initiator'] ~= nil and _event['initiator']:getDesc() and _event['initiator']:getDesc() ~= nil and _event['initiator']:getDesc().typeName then
				eventExport['initiatorType'] = _event['initiator']:getDesc().typeName
			end
		end
		if targetCheck and _event['target'] ~= nil and _event['target']:getPlayerName() and _event['target']:getPlayerName() ~= nil then 
			local activePlayerList = net.get_player_list()
			local activePlayerListTable = {}
			for _, i in pairs(activePlayerList) do
				table.insert(activePlayerListTable, net.get_player_info(i))
			end
			for _, i in pairs(activePlayerListTable) do
				if _event['target'] ~= nil and i.name == _event['target']:getPlayerName() then 
					eventExport['targetUcid'] = i.ucid
					eventExport['targetPlayerName'] = _event['target']:getPlayerName()
				end
			end
		end
		if _event['target'] and _event['target'] ~= nil and _event['target']:getDesc() and _event['target']:getDesc() ~= nil then 
			--eventExport['targetDesc'] = eventExport['target']:getDesc()
			eventExport['targetName'] = _event['target']:getName()
			if _event['target'] ~= nil and _event['target']:getCoalition() and _event['target']:getCoalition() ~= nil then
				eventExport['targetCoalition'] = _event['target']:getCoalition()
			end
			if _event['target'] and _event['target'] ~= nil and _event['target']:getDesc() and _event['target']:getDesc() ~= nil and _event['target']:getDesc().typeName then
				eventExport['targetType'] = _event['target']:getDesc().typeName
			end
		end
		if _event['weapon'] and _event['weapon'] ~= nil and _event['weapon']:getDesc() and _event['weapon']:getDesc() ~= nil and _event['weapon']:getDesc().category and _event['weapon']:getDesc().displayName then 
			eventExport['weaponCategory'] = _event['weapon']:getDesc().category
			eventExport['weaponDisplayName'] = _event['weapon']:getDesc().displayName
		end
	end
	-- Integrating with missionStats
	if editFDS and eventExport['initiatorPlayerName'] == nil then
		if _event['initiator'] and _event['initiator'] ~= nil and _event['initiator']:getGroup() ~= nil and _event['initiator']:getGroup():getName() ~= nil then
			if FDS.entityKills[_event['initiator']:getGroup():getName()] == nil then
				FDS.entityKills[_event['initiator']:getGroup():getName()] = {}
			end
			table.insert(FDS.entityKills[_event['initiator']:getGroup():getName()], eventExport)
		end
	end
	if editFDS and eventExport['targetPlayerName'] == nil then
		if _event['target'] and _event['target'] ~= nil and _event['target']:getCategory() ~= nil then
			if _event['target']:getCategory() == 3 then
				FDS.killedByEntity[eventExport['targetName']] = eventExport
			else
				FDS.killedByEntity[_event['target']:getGroup():getName()] = eventExport
			end
		end
	end
	if editFDS and eventExport['initiatorPlayerName'] ~= nil then
		if eventExport['initiatorCoalition'] ~= eventExport['targetCoalition'] then
			if FDS.playersKillRecord == nil then 
				FDS.playersKillRecord = {}
			end
			eventExport['isPvP'] = false
			if eventExport['initiatorUcid'] ~= nil and eventExport['targetUcid'] ~= nil then
				eventExport['isPvP'] = true
			end
			table.insert(FDS.playersKillRecord,eventExport)
		end
	end
	return eventExport
end

function exportKill(eventExport)
	FDS.killEventVector[FDS.killEventNumber] = eventExport
	jsonExport = net.lua2json(FDS.killEventVector)
	local file = io.open(FDS.exportPath .. "killRecord.json", "w")
	file:write(jsonExport)
	file:close()
end

function checkTID(_event)
	if _event ~= nil and _event.target ~= nil and _event.target:getID() ~= nil then
		return true
	end
end
function checkTName(_event)
	if _event ~= nil and _event.target ~= nil and _event.target:getName() ~= nil then
		return true
	end
end
function checkTPName(_event)
	if _event ~= nil and _event.target ~= nil and _event.target:getPlayerName() ~= nil then
		return true
	end
end

function awardPoints(initCheck, initCoaCheck, targetCoaCheck, initCoa, targetCoa, _initEnt, _targetEnt, rewardType, forceAward)
	if initCheck and initCoaCheck and targetCoaCheck and initCoa ~= targetCoa and _initEnt:isExist() then
		local plName = _initEnt:getPlayerName()
		local tgtName = nil
		if _targetEnt:getCategory() == 3 then
			tgtName = nil
		else
			tgtName = _targetEnt:getPlayerName()
		end
		local plGrp = _initEnt:getGroup()
		local plID = plGrp:getID()
		for i,j in pairs(FDS.teamPoints) do
			for k,w in pairs(FDS.teamPoints[i]['Players']) do
				if plName == k then
					local msgKill = {}
					msgKill.displayTime = 20
					msgKill.sound = 'Msg.ogg'
					if FDS.lastHits[_targetEnt:getID()] ~= nil then
						if FDS.lastHits[_targetEnt:getID()] ~= 'DEAD' and not FDS.lastHits[_targetEnt:getID()][2] then
							if tgtName ~= nil then
								FDS.teamPoints[i]['Players'][k] = FDS.teamPoints[i]['Players'][k] + FDS.playerReward
								msgKill.text = 'You receive: ' .. tostring(FDS.playerReward) .. ' points for your kill.'
								trigger.action.outTextForGroup(plID, msgKill.text, msgKill.displayTime)
								trigger.action.outSoundForGroup(plID,msgKill.sound)
							else
								FDS.teamPoints[i]['Players'][k] = FDS.teamPoints[i]['Players'][k] + FDS.rewardDict[rewardType]
								msgKill.text = 'You receive: ' .. tostring(FDS.rewardDict[rewardType]) .. ' points for your kill.'
								trigger.action.outTextForGroup(plID, msgKill.text, msgKill.displayTime)
								trigger.action.outSoundForGroup(plID,msgKill.sound)	
							end
						end
					elseif forceAward then
						if tgtName ~= nil  then
							FDS.teamPoints[i]['Players'][k] = FDS.teamPoints[i]['Players'][k] + FDS.playerReward
							msgKill.text = 'You receive: ' .. tostring(FDS.playerReward) .. ' points for your kill.'
							trigger.action.outTextForGroup(plID, msgKill.text, msgKill.displayTime)
							trigger.action.outSoundForGroup(plID,msgKill.sound)
						else
							FDS.teamPoints[i]['Players'][k] = FDS.teamPoints[i]['Players'][k] + FDS.rewardDict[rewardType]
							msgKill.text = 'You receive: ' .. tostring(FDS.rewardDict[rewardType]) .. ' points for your kill.'
							trigger.action.outTextForGroup(plID, msgKill.text, msgKill.displayTime)
							trigger.action.outSoundForGroup(plID,msgKill.sound)
						end
					end
				end
			end
		end
	end
end

function awardIndirectCredit(initCoaCheck, targetCoaCheck, initCoa, targetCoa, _initEnt, _targetEnt, rewardType, forceAward)
	if FDS.deployedUnits[FDS.trueCoalitionCode[_initEnt:getCoalition()]][_initEnt:getName()] ~= nil then
		local plName = FDS.deployedUnits[FDS.trueCoalitionCode[_initEnt:getCoalition()]][_initEnt:getName()]
		local tgtName = nil
		if _targetEnt:getCategory() == 3 then
			tgtName = nil
		elseif _targetEnt:getPlayerName() ~= nil then
			tgtName = _targetEnt:getPlayerName()
		end
		local plGrp = FDS.checkPlayerOnline(plName,FDS.isName,FDS.isOnline)
		local plID = plGrp:getID()
		local plCOA = plGrp:getCoalition()
		local unitCOA = _initEnt:getCoalition()
		tgtName = FDS.retrieveUcid(tgtName,FDS.isName)
		for k,w in pairs(FDS.playersCredits[FDS.trueCoalitionCode[_initEnt:getCoalition()]]) do
			if plName == k then
				local msgKill = {}
				msgKill.displayTime = 20
				msgKill.sound = 'indirectKill.ogg'
				if FDS.lastHits[_targetEnt:getID()] ~= nil then
					if FDS.lastHits[_targetEnt:getID()] ~= 'DEAD' and not FDS.lastHits[_targetEnt:getID()][2] then
						if tgtName ~= nil and tgtName ~= '' then
							if tgtName ~= plName then
								FDS.playersCredits[FDS.trueCoalitionCode[_initEnt:getCoalition()]][k] = FDS.playersCredits[FDS.trueCoalitionCode[_initEnt:getCoalition()]][k] + FDS.playerReward
								msgKill.text = 'You receive: ' .. tostring(FDS.playerReward) .. ' credits because your troops killed an enemy.'
							end
						else
							FDS.playersCredits[FDS.trueCoalitionCode[_initEnt:getCoalition()]][k] = FDS.playersCredits[FDS.trueCoalitionCode[_initEnt:getCoalition()]][k] + FDS.rewardDict[rewardType]
							msgKill.text = 'You receive: ' .. tostring(FDS.rewardDict[rewardType]) .. ' credits because your troops killed an enemy.'
						end
						if plCOA == unitCOA then
							trigger.action.outTextForGroup(plID, msgKill.text, msgKill.displayTime)
							trigger.action.outSoundForGroup(plID,msgKill.sound)	
						end
					end
				elseif forceAward then
					if tgtName ~= nil and tgtName ~= '' then
						if tgtName ~= plName then
							FDS.playersCredits[FDS.trueCoalitionCode[_initEnt:getCoalition()]][k] = FDS.playersCredits[FDS.trueCoalitionCode[_initEnt:getCoalition()]][k] + FDS.playerReward
							msgKill.text = 'You receive: ' .. tostring(FDS.playerReward) .. ' credits because your troops killed an enemy.'
						end
					else
						FDS.playersCredits[FDS.trueCoalitionCode[_initEnt:getCoalition()]][k] = FDS.playersCredits[FDS.trueCoalitionCode[_initEnt:getCoalition()]][k] + FDS.rewardDict[rewardType]
						msgKill.text = 'You receive: ' .. tostring(FDS.rewardDict[rewardType]) .. ' credits because your troops killed an enemy.'
					end
					if plCOA == unitCOA then
						trigger.action.outTextForGroup(plID, msgKill.text, msgKill.displayTime)
						trigger.action.outSoundForGroup(plID,msgKill.sound)	
					end
				end
			end
		end
	end
end

-- Event Handler
FDS.eventActions = FDS.switch {
	[world.event.S_EVENT_BIRTH] = function(x, param)
		local _event = param.event
		local _initEnt = _event.initiator
		local cleanCargo = false
		if _initEnt:getCategory() == 1 then
			for i,j in pairs(FDS.heliSlots) do
				if _initEnt:getDesc().typeName == i then
					cleanCargo = true
				end
			end
			if cleanCargo then
				FDS.cargoList[tostring(_initEnt:getName())] = {} 
				FDS.valuableList[tostring(_initEnt:getName())] = {} 
			end
		end
		if _initEnt ~= nil and _initEnt:getID() ~= nil and FDS.lastHits[_initEnt:getID()] ~= nil then
			FDS.lastHits[_initEnt:getID()] = nil
		end
		if _initEnt ~= nil and _initEnt:getCategory() == Object.Category.UNIT and _initEnt:getPlayerName() ~= nil then 
			gpUcid = FDS.retrieveUcid(_initEnt:getPlayerName(),FDS.isName)
			local msg = {}
			msg.text = _initEnt:getPlayerName() .. ', you can help your team by:\n\n - Attacking ground targets in enemy zones (AG mission)(See map or [radio]>[F10]>[Where to attack]).\n - Attacking the enemy air transports in enemy supply route (AA mission) (See map).\n - Rescuing point around the map with helicopters (Helo rescue mission).\n - Killing enemy players in the process is always a good idea!\n\n - Visit our website: "https://dcs.comicorama.com/" for server and players stats.\n - Join our Discord community at FDS Server (Link available in the briefing). \nAn explanation about this server is available on our youtube channel: "FDS Server - DCS".'
			msg.displayTime = 60
			msg.sound = 'Welcome.ogg'
			
			pcall(missionCommands.removeItemForGroup,mist.DBs.humansByName[_initEnt:getName()]['groupId'],'Current War Status')
			mist.scheduleFunction(missionCommands.addCommandForGroup,{mist.DBs.humansByName[_initEnt:getName()]['groupId'],'Current War Status',nil, FDS.warStatus, {_initEnt:getGroup().id_, _initEnt:getCoalition(), _initEnt:getPlayerName()}},timer.getTime()+FDS.wtime)
			mist.scheduleFunction(missionCommands.addCommandForGroup,{mist.DBs.humansByName[_initEnt:getName()]['groupId'],'Where to Attack',nil, FDS.whereStrike, {_initEnt:getGroup().id_, _initEnt:getCoalition(), _initEnt:getName()}},timer.getTime()+FDS.wtime)
			mist.scheduleFunction(missionCommands.addCommandForGroup,{mist.DBs.humansByName[_initEnt:getName()]['groupId'],'Where to Defend',nil, FDS.whereDefend, {_initEnt:getGroup().id_, _initEnt:getCoalition(), _initEnt:getName()}},timer.getTime()+FDS.wtime)
			mist.scheduleFunction(missionCommands.addCommandForGroup,{mist.DBs.humansByName[_initEnt:getName()]['groupId'],'Drop Zones',nil, FDS.whereDropZones, {_initEnt:getGroup().id_, _initEnt:getCoalition(), _initEnt:getName()}},timer.getTime()+FDS.wtime)
			FDS.addCreditsOptions(_initEnt:getGroup())
			mist.scheduleFunction(trigger.action.outTextForGroup,{_initEnt:getGroup().id_,msg.text,msg.displayTime},timer.getTime()+FDS.wtime)
			mist.scheduleFunction(trigger.action.outSoundForGroup,{_initEnt:getGroup().id_,msg.sound},timer.getTime()+FDS.wtime)

			if _initEnt:getCoalition() == 1 then 
				FDS.teamPoints['red']['Players'][_initEnt:getPlayerName()] = 0
			elseif _initEnt:getCoalition() == 2 then
				FDS.teamPoints['blue']['Players'][_initEnt:getPlayerName()] = 0
			end
			if FDS.playersCredits[FDS.trueCoalitionCode[_initEnt:getCoalition()]][gpUcid] == nil then
				FDS.playersCredits[FDS.trueCoalitionCode[_initEnt:getCoalition()]][gpUcid] = 0
			end
		end
	end,
	[world.event.S_EVENT_PILOT_DEAD] = function(x, param)
		local _event = param.event
		local _initEnt = _event.initiator
		if _initEnt ~= nil and _initEnt:getID() ~= nil and FDS.lastHits[_initEnt:getID()] ~= nil then
			local _initEntLocal = FDS.lastHits[_initEnt:getID()][3]
			local _targetEntLocal = _initEnt
			local _eventLocal = FDS.lastHits[_initEnt:getID()][4]
			local initCheck = pcall(FDS.playerCheck,_initEntLocal)
			local initCoa = 0
			local initCoaCheck = pcall(FDS.coalitionCheck,_initEntLocal)
			local targetCheck = pcall(FDS.playerCheck,_targetEntLocal)
			local targetCoa = 0
			local targetCoaCheck = pcall(FDS.coalitionCheck,_targetEntLocal)
			local rewardType = ''
			--[[ local currV = 0
			if _initEnt ~= nil and _initEnt:getPlayerName() then
				for _,i in pairs(FDS.teamPoints) do
					for name,value in pairs(i['Players']) do
						if _initEnt:getPlayerName() == name then
							currV = value
						end
					end
				end
				if currV > 0.0 then
					--createPoint = closestZone(_initEnt:getPosition().p)
					createPoint = _initEnt:getPosition().p
					createPoint.y = land.getHeight({x = createPoint.x,y = createPoint.z})
					local newValue = true
					for _,i in pairs(FDS.dropZones) do
						if i[3] == _event.initiator:getPlayerName() and i[1].x == createPoint.x and i[1].y == createPoint.y and i[1].z == createPoint.z then
							newValue = false
						end
					end
					if newValue then 
						table.insert(FDS.dropZones,{createPoint, currV, _event.initiator:getPlayerName()}) 
						local msg = {}
						msg.text = 'A new drop zone has been created with ' .. tostring(currV) .. ' points.'
						msg.displayTime = 60  
						msg.sound = 'Msg.ogg'
						trigger.action.outText(msg.text, msg.displayTime)
						trigger.action.outSound(msg.sound)
						trigger.action.smoke(createPoint,3)
					end
				end
			end ]]
			--Exporting event record
			if _initEntLocal and _targetEntLocal and _initEntLocal:getCategory() and _targetEntLocal:getCategory() and isUnitorStructure(_initEntLocal,_targetEntLocal) then
				if FDS.exportDataSite then
					if FDS.lastHits[_targetEntLocal:getID()] ~= nil and FDS.lastHits[_targetEntLocal:getID()] ~= 'DEAD' then 
						local killObject = assembleKillObject(initCheck, targetCheck, _eventLocal, FDS.lastHits[_targetEntLocal:getID()][1], not FDS.lastHits[_targetEntLocal:getID()][2], true)
						exportKill(killObject)
					else
						local killObject = assembleKillObject(initCheck, targetCheck, _eventLocal, {}, not FDS.lastHits[_targetEntLocal:getID()][2], true)
						exportKill(killObject)		
					end
				end
				if _targetEntLocal and _targetEntLocal:getDesc() and _targetEntLocal:getDesc().typeName and FDS.rewardDict[_targetEntLocal:getDesc().typeName] then
					rewardType = _targetEntLocal:getDesc().typeName
				else
					rewardType = 'Default'
				end
				if initCoaCheck and targetCoaCheck then
					initCoa = _initEntLocal:getCoalition()
					targetCoa = _targetEntLocal:getCoalition()
				end
				awardPoints(initCheck, initCoaCheck, targetCoaCheck, initCoa, targetCoa, _initEntLocal, _targetEntLocal, rewardType, false)
				awardIndirectCredit(initCoaCheck, targetCoaCheck, initCoa, targetCoa, _initEntLocal, _targetEntLocal, rewardType, false)
				FDS.lastHits[_initEnt:getID()][2] = true
			end
		end
	end,
	[world.event.S_EVENT_HIT] = function(x, param)
		local _event = param.event
		local _eventCopy = mist.utils.deepCopy(_event)
		local debugInfo = {}
		local _init = _event.initiator
		local _currentTgt = _event.target
		local playerCheck1 = pcall(FDS.playerCheck,_init)
		local playerCheck2 = pcall(FDS.playerCheck,_currentTgt)
		local initCheck = pcall(FDS.playerCheck,_init)
		local targetCheck = pcall(FDS.playerCheck,_currentTgt)
		if pcall(checkTID, _event) and _event ~= nil and _event.target ~= nil and _event.target:getID() ~= nil then
			debugInfo['uID'] = _event.target:getID()
		end
		if pcall(checkTName, _event) and _event ~= nil and _event.target ~= nil and _event.target:getName() ~= nil then
			debugInfo['uName'] = _event.target:getName()
		end
		if pcall(checkTPName, _event) and _event ~= nil and _event.target ~= nil and playerCheck2 and _event.target:getPlayerName() ~= nil then
			debugInfo['pName'] = _event.target:getPlayerName()
		end
		if _init ~= nil and _currentTgt ~= nil and _init:getCategory() and _currentTgt:getCategory() and  isUnitorStructure(_init,_currentTgt) then 
			local hitObjectInfo = assembleKillObject(initCheck, targetCheck, _event, {}, false, false)
			if _init and _init ~= nil and _init:getID() and _init:getID() ~= nil and _currentTgt ~= nil and _currentTgt:getID() and _currentTgt:getID() ~= nil and FDS.lastHits[_currentTgt:getID()] ~= 'DEAD' then
				-- [Target ID] = {INFO for JSON, Already paid, Author ID, Copy}
				FDS.lastHits[_currentTgt:getID()] = {hitObjectInfo, false, _init, _eventCopy, debugInfo}
			end
		end
	end,
	[world.event.S_EVENT_CRASH] = function(x, param)
		local _event = param.event
		local _initEnt = _event.initiator
		local currV = 0
		local actorDetails = {}
		if _initEnt ~= nil and _initEnt:getPlayerName() then
			--if FDS.lastHits[_initEnt:getID()] ~= nil then
			--	FDS.lastHits[_initEnt:getID()] = nil
			--end
			--for i,j in pairs(FDS.lastHits) do
			--	if _initEnt:getID() == j[1] then
			--		FDS.lastHits[i] = nil
			--	end
			--end
			for j,i in pairs(FDS.teamPoints) do
				for name,value in pairs(i['Players']) do
					if _initEnt:getPlayerName() == name then
						currV = value
						actorDetails = {j, name}
					end
				end
			end
			if currV > 0.0 then
				--createPoint = closestZone(_initEnt:getPosition().p)
				createPoint = _initEnt:getPosition().p
				createPoint.y = land.getHeight({x = createPoint.x,y = createPoint.z})
				local newValue = true
				for _,i in pairs(FDS.dropZones) do
					if i[3] == _event.initiator:getPlayerName() and i[1].x == createPoint.x and i[1].y == createPoint.y and i[1].z == createPoint.z then
						newValue = false
					end
				end
				if newValue then 
					table.insert(FDS.dropZones,{createPoint, currV, _event.initiator:getPlayerName()}) 
					local msg = {}
					msg.text = 'A new drop zone has been created with ' .. tostring(currV) .. ' points.'
					msg.displayTime = 60  
					msg.sound = 'Msg.ogg'
					trigger.action.outText(msg.text, msg.displayTime)
					trigger.action.outSound(msg.sound)
					trigger.action.smoke(createPoint,3)
					FDS.teamPoints[actorDetails[1]]['Players'][actorDetails[2]] = nil
				end
			end
		end
		if _initEnt:getDesc() and _initEnt:getDesc().typeName == 'E-2C' then
			local coalit = _initEnt:getCoalition()
			local sideAWACS = {{'Blue_AWACS_1', 2, 1, 'red'}, {'Red_AWACS_1', 1, 2, 'blue'}}
			mist.removeFunction(FDS.resAWACSTime[sideAWACS[coalit][4]][2])
			mist.respawnGroup(sideAWACS[coalit][1], true)
			local msgAWACSDown = {}  
			msgAWACSDown.text = 'The enemy shot down our AWACS. It will respawn in ' .. tostring(math.floor((FDS.respawnAWACSTime/60)+0.7)) .. ' minutes.'
			msgAWACSDown.displayTime = 10  
			msgAWACSDown.sound = 'AirDropDelivered.ogg'
			trigger.action.outTextForCoalition(sideAWACS[coalit][3], msgAWACSDown.text, msgAWACSDown.displayTime)
			trigger.action.outSoundForCoalition(sideAWACS[coalit][3],msgAWACSDown.sound) 
			local msgAWACSDown = {}  
			msgAWACSDown.text = 'The enemy AWACS is down. It will respawn in ' .. tostring(math.floor((FDS.respawnAWACSTime/60)+0.7)) .. ' minutes.'
			msgAWACSDown.displayTime = 10  
			msgAWACSDown.sound = 'Msg.ogg'
			trigger.action.outTextForCoalition(sideAWACS[coalit][2], msgAWACSDown.text, msgAWACSDown.displayTime)
			trigger.action.outSoundForCoalition(sideAWACS[coalit][2],msgAWACSDown.sound) 
			mist.scheduleFunction(respawnAWACS, {coalit},timer.getTime()+FDS.respawnAWACSTime)
		end
		if _initEnt:getDesc() and _initEnt:getDesc().typeName == 'KC135MPRS' then
			local coalit = _initEnt:getCoalition()
			local sideTanker = {{'Blue_Tanker_1_Haste', 2, 1, 'red'}, {'Red_Tanker_1_Haste', 1, 2, 'blue'}}
			mist.removeFunction(FDS.resMPRSTankerTime[sideTanker[coalit][4]][2])
			mist.respawnGroup(sideTanker[coalit][1], true)
			local msgTankerDown = {}  
			msgTankerDown.text = 'The enemy shot down our MPRS tanker. It will respawn in ' .. tostring(math.floor((FDS.respawnTankerTime/60)+0.7)) .. ' minutes.'
			msgTankerDown.displayTime = 10  
			msgTankerDown.sound = 'AirDropDelivered.ogg'
			trigger.action.outTextForCoalition(sideTanker[coalit][3], msgTankerDown.text, msgTankerDown.displayTime)
			trigger.action.outSoundForCoalition(sideTanker[coalit][3],msgTankerDown.sound) 
			local msgTankerDown = {}  
			msgTankerDown.text = 'The enemy MPRS tanker is down. It will respawn in ' .. tostring(math.floor((FDS.respawnTankerTime/60)+0.7)) .. ' minutes.'
			msgTankerDown.displayTime = 10  
			msgTankerDown.sound = 'Msg.ogg'
			trigger.action.outTextForCoalition(sideTanker[coalit][2], msgTankerDown.text, msgTankerDown.displayTime)
			trigger.action.outSoundForCoalition(sideTanker[coalit][2],msgTankerDown.sound) 
			mist.scheduleFunction(respawnTankerMPRS, {coalit},timer.getTime()+FDS.respawnTankerTime)
		end
		if _initEnt:getDesc() and _initEnt:getDesc().typeName == 'KC-135' then
			local coalit = _initEnt:getCoalition()
			local sideTanker = {{'Blue_Tanker_1_Cesta', 2, 1, 'red'}, {'Red_Tanker_1_Cesta', 1, 2, 'blue'}}
			mist.removeFunction(FDS.resTankerTime[sideTanker[coalit][4]][2])
			mist.respawnGroup(sideTanker[coalit][1], true)
			local msgTankerDown = {}  
			msgTankerDown.text = 'The enemy shot down our basket tanker. It will respawn in ' .. tostring(math.floor((FDS.respawnTankerTime/60)+0.7)) .. ' minutes.'
			msgTankerDown.displayTime = 10  
			msgTankerDown.sound = 'AirDropDelivered.ogg'
			trigger.action.outTextForCoalition(sideTanker[coalit][3], msgTankerDown.text, msgTankerDown.displayTime)
			trigger.action.outSoundForCoalition(sideTanker[coalit][3],msgTankerDown.sound) 
			local msgTankerDown = {}  
			msgTankerDown.text = 'The enemy basket tanker is down. It will respawn in ' .. tostring(math.floor((FDS.respawnTankerTime/60)+0.7)) .. ' minutes.'
			msgTankerDown.displayTime = 10  
			msgTankerDown.sound = 'Msg.ogg'
			trigger.action.outTextForCoalition(sideTanker[coalit][2], msgTankerDown.text, msgTankerDown.displayTime)
			trigger.action.outSoundForCoalition(sideTanker[coalit][2],msgTankerDown.sound) 
			mist.scheduleFunction(respawnTanker, {coalit},timer.getTime()+FDS.respawnTankerTime)
		end
		if FDS.lastHits[_initEnt:getID()] ~= nil then
			local _initEntLocal = FDS.lastHits[_initEnt:getID()][3]
			local _targetEntLocal = _initEnt
			local _eventLocal = FDS.lastHits[_initEnt:getID()][4]
			local initCheck = pcall(FDS.playerCheck,_initEntLocal)
			local initCoa = 0
			local initCoaCheck = pcall(FDS.coalitionCheck,_initEntLocal)
			local targetCheck = pcall(FDS.playerCheck,_targetEntLocal)
			local targetCoa = 0
			local targetCoaCheck = pcall(FDS.coalitionCheck,_targetEntLocal)
			local rewardType = ''
			--Exporting event record
			if _initEntLocal and _targetEntLocal and _initEntLocal:getCategory() and _targetEntLocal:getCategory() and isUnitorStructure(_initEntLocal,_targetEntLocal) then
				if FDS.exportDataSite then
					if FDS.lastHits[_targetEntLocal:getID()] ~= nil and FDS.lastHits[_targetEntLocal:getID()] ~= 'DEAD' then 
						local killObject = assembleKillObject(initCheck, targetCheck, _eventLocal, FDS.lastHits[_targetEntLocal:getID()][1], not FDS.lastHits[_targetEntLocal:getID()][2], true)
						exportKill(killObject)
					else
						local killObject = assembleKillObject(initCheck, targetCheck, _eventLocal, {}, not FDS.lastHits[_targetEntLocal:getID()][2], true)
						exportKill(killObject)
					end
				end
				if _targetEntLocal and _targetEntLocal:getDesc() and _targetEntLocal:getDesc().typeName and FDS.rewardDict[_targetEntLocal:getDesc().typeName] then
					rewardType = _targetEntLocal:getDesc().typeName
				else
					rewardType = 'Default'
				end
				if initCoaCheck and targetCoaCheck then
					initCoa = _initEntLocal:getCoalition()
					targetCoa = _targetEntLocal:getCoalition()
				end
				awardPoints(initCheck, initCoaCheck, targetCoaCheck, initCoa, targetCoa, _initEntLocal, _targetEntLocal, rewardType, false)
				awardIndirectCredit(initCoaCheck, targetCoaCheck, initCoa, targetCoa, _initEntLocal, _targetEntLocal, rewardType, false)
				FDS.lastHits[_initEnt:getID()][2] = true
			end
		end
	end,
	[world.event.S_EVENT_PLAYER_LEAVE_UNIT] = function(x, param)
		local _event = param.event
		local _initEnt = _event.initiator
		local currV = 0
		local initCheck = pcall(FDS.playerCheck,_initEnt)
		local initCoaCheck = pcall(FDS.coalitionCheck,_initEnt)
		local initCoa = 0
		local rewardType = ''
		if _initEnt ~= nil and _initEnt:getPlayerName() then
			for j,i in pairs(FDS.teamPoints) do
				for name,value in pairs(i['Players']) do
					if _initEnt:getPlayerName() == name then
						currV = value
						actorDetails = {j, name}
					end
				end
			end
			if currV > 0.0 then
				--createPoint = closestZone(_initEnt:getPosition().p)
				createPoint = _initEnt:getPosition().p
				createPoint.y = land.getHeight({x = createPoint.x,y = createPoint.z})
				local newValue = true
				for _,i in pairs(FDS.dropZones) do
					if i[3] == _event.initiator:getPlayerName() and i[1].x == createPoint.x and i[1].y == createPoint.y and i[1].z == createPoint.z then 
						newValue = false
					end
				end
				if newValue then
					table.insert(FDS.dropZones,{createPoint, currV, _event.initiator:getPlayerName()})
					local msg = {}
					msg.text = 'A new drop zone has been created with ' .. tostring(currV) .. ' points.'
					msg.displayTime = 60  
					msg.sound = 'Msg.ogg'
					trigger.action.outText(msg.text, msg.displayTime)
					trigger.action.outSound(msg.sound) 
					trigger.action.smoke(createPoint,3)
					FDS.teamPoints[actorDetails[1]]['Players'][actorDetails[2]] = nil
				end
			end
			if FDS.lastHits[_initEnt:getID()] ~= nil then
				local _initEntLocal = FDS.lastHits[_initEnt:getID()][3]
				local _targetEntLocal = _initEnt
				local _eventLocal = FDS.lastHits[_initEnt:getID()][4]
				local initCheck = pcall(FDS.playerCheck,_initEntLocal)
				local initCoa = 0
				local initCoaCheck = pcall(FDS.coalitionCheck,_initEntLocal)
				local targetCheck = pcall(FDS.playerCheck,_targetEntLocal)
				local targetCoa = 0
				local targetCoaCheck = pcall(FDS.coalitionCheck,_targetEntLocal)
				local rewardType = ''
				--Exporting event record
				if _initEntLocal and _targetEntLocal and _initEntLocal:getCategory() and _targetEntLocal:getCategory() and isUnitorStructure(_initEntLocal,_targetEntLocal) then
					if FDS.exportDataSite then
						if FDS.lastHits[_targetEntLocal:getID()] ~= nil and FDS.lastHits[_targetEntLocal:getID()] ~= 'DEAD' then 
							local killObject = assembleKillObject(initCheck, targetCheck, _eventLocal, FDS.lastHits[_targetEntLocal:getID()][1], not FDS.lastHits[_targetEntLocal:getID()][2], true)
							exportKill(killObject)
						else
							local killObject = assembleKillObject(initCheck, targetCheck, _eventLocal, {}, not FDS.lastHits[_targetEntLocal:getID()][2], true)
							exportKill(killObject)			
						end
					end
					if _targetEntLocal and _targetEntLocal:getDesc() and _targetEntLocal:getDesc().typeName and FDS.rewardDict[_targetEntLocal:getDesc().typeName] then
						rewardType = _targetEntLocal:getDesc().typeName
					else
						rewardType = 'Default'
					end
					if initCoaCheck and targetCoaCheck then
						initCoa = _initEntLocal:getCoalition()
						targetCoa = _targetEntLocal:getCoalition()
					end
					awardPoints(initCheck, initCoaCheck, targetCoaCheck, initCoa, targetCoa, _initEntLocal, _targetEntLocal, rewardType, false)
					awardIndirectCredit(initCoaCheck, targetCoaCheck, initCoa, targetCoa, _initEntLocal, _targetEntLocal, rewardType, false)
					FDS.lastHits[_initEnt:getID()][2] = true
				end
			end
		end
	end,
	[world.event.S_EVENT_LAND] = function(x, param)
		local _event = param.event
		local _initEnt = _event.initiator
		local _local = _event.place
		local initCheck = pcall(FDS.playerCheck,_initEnt)
		local initCoa = 0
		local initCoaCheck = pcall(FDS.coalitionCheck,_initEnt)
		local gpUcid = FDS.retrieveUcid(_initEnt:getPlayerName(),FDS.isName)
		if initCoaCheck then
			initCoa = _initEnt:getCoalition()
		end
		if _initEnt ~= nil and _initEnt:getPlayerName() then
			if _local then
				local flagRed = false
				for _,type in pairs(FDS.redRelieveZones) do
					if _local:getName() == type then
						flagRed = true
					end
				end
				local flagBlue = false
				for _,type in pairs(FDS.blueRelieveZones) do
					if _local:getName() == type then
						flagBlue = true
					end
				end
				if FDS.lastHits[_initEnt:getID()] ~= nil and (flagBlue or flagRed) then
					FDS.lastHits[_initEnt:getID()] = nil
				end
				if initCheck and initCoaCheck and initCoa == 2 and flagBlue and _initEnt:getPlayerName() and FDS.teamPoints.blue['Players'][_initEnt:getPlayerName()] > 0 then
					local msgLand = {}
					local gp = _initEnt:getGroup()
					msgLand.text = 'You land at ' .. _local:getName() .. '. You deliver ' .. FDS.teamPoints.blue['Players'][_initEnt:getPlayerName()] .. ' points to your team and receive ' .. FDS.teamPoints.blue['Players'][_initEnt:getPlayerName()] .. ' credits.'
					msgLand.displayTime = 20  
					msgLand.sound = 'Msg.ogg'
					trigger.action.outTextForGroup(gp:getID(), msgLand.text, msgLand.displayTime)
					trigger.action.outSoundForGroup(gp:getID(),msgLand.sound)
					
					-- Record land points
					recordLandPoints(_initEnt, FDS.trueCoalitionCode[initCoa])

					FDS.teamPoints.blue.Base = FDS.teamPoints.blue.Base + FDS.teamPoints.blue['Players'][_initEnt:getPlayerName()]
					FDS.playersCredits.blue[gpUcid] = FDS.playersCredits.blue[gpUcid] + FDS.teamPoints.blue['Players'][_initEnt:getPlayerName()]
					FDS.teamPoints.blue['Players'][_initEnt:getPlayerName()] = 0.0
					if FDS.teamPoints.blue.Base >= FDS.callCost then 
						local bombTimes = math.floor(FDS.teamPoints.blue.Base/FDS.callCost)
						for callIt = 1, bombTimes do
							--mist.scheduleFunction(bombingRun, {'blue'},timer.getTime()+FDS.bomberMinInterval*(callIt-1))
							mist.scheduleFunction(guidedBombingRun, {'blue'},timer.getTime()+FDS.bomberMinInterval*(callIt-1))
							FDS.teamPoints.blue.Base = FDS.teamPoints.blue.Base - FDS.callCost
						end
					end
				elseif initCheck and initCoaCheck and initCoa == 1 and flagRed and _initEnt:getPlayerName() and FDS.teamPoints.red['Players'][_initEnt:getPlayerName()] > 0 then
					local msgLand = {}
					local gp = _initEnt:getGroup()
					msgLand.text = 'You land at ' .. _local:getName() .. '. You deliver ' .. FDS.teamPoints.red['Players'][_initEnt:getPlayerName()] .. ' points to your team.' 
					msgLand.displayTime = 20  
					msgLand.sound = 'Msg.ogg'
					trigger.action.outTextForGroup(gp:getID(), msgLand.text, msgLand.displayTime)
					trigger.action.outSoundForGroup(gp:getID(),msgLand.sound)

					-- Record land points
					recordLandPoints(_initEnt, FDS.trueCoalitionCode[initCoa])

					FDS.teamPoints.red.Base = FDS.teamPoints.red.Base + FDS.teamPoints.red['Players'][_initEnt:getPlayerName()]
					FDS.playersCredits.red[gpUcid] = FDS.playersCredits.red[gpUcid] + FDS.teamPoints.red['Players'][_initEnt:getPlayerName()]
					FDS.teamPoints.red['Players'][_initEnt:getPlayerName()] = 0.0
					if FDS.teamPoints.red.Base >= FDS.callCost then 
						local bombTimes = math.floor(FDS.teamPoints.red.Base/FDS.callCost)
						for callIt = 1, bombTimes do
							--mist.scheduleFunction(bombingRun, {'red'},timer.getTime()+FDS.bomberMinInterval*(callIt-1))
							mist.scheduleFunction(guidedBombingRun, {'red'},timer.getTime()+FDS.bomberMinInterval*(callIt-1))
							FDS.teamPoints.red.Base = FDS.teamPoints.red.Base - FDS.callCost
						end
					end
				end
			elseif initCheck and initCoaCheck and _initEnt:getPlayerName() and #FDS.dropZones ~= 0 then
				for i, j in pairs(FDS.dropZones) do 
					if not distDZ or distDZ > mist.utils.get3DDist(_initEnt:getPosition().p, j[1]) then
						distDZ = mist.utils.get3DDist(_initEnt:getPosition().p, j[1])
						drop = i
					end
				end
				local flagType = false
				for _,type in pairs(FDS.dropHeliTypes) do
					if _initEnt:getTypeName() == type then
						flagType = true
					end
				end
				if flagType then
					if distDZ < FDS.distMin then
						local msgAll = {}
						local gp = _initEnt:getGroup()
						local gpCoa = gp:getCoalition()
						if gpCoa == 2 then
							msgAll.text = 'A blue helicopter has retrieved points from a drop zone.'
						else
							msgAll.text = 'A red helicopter has retrieved points from a drop zone.'
						end
						msgAll.displayTime = 20  
						msgAll.sound = 'dropCaptured.ogg'
						trigger.action.outText(msgAll.text, msgAll.displayTime)
						trigger.action.outSound(msgAll.sound)

						local msgLand = {}
						local gp = _initEnt:getGroup()
						local gpCoa = gp:getCoalition()
						msgLand.text = 'You retrieve  ' .. tostring(FDS.dropZones[drop][2]) .. '.'
						msgLand.displayTime = 20  
						msgLand.sound = 'Msg.ogg'
						trigger.action.outTextForGroup(gp:getID(), msgLand.text, msgLand.displayTime)
						trigger.action.smoke(FDS.dropZones[drop][1], 2)
						if gpCoa == 2 then
							FDS.teamPoints.blue.Players[_initEnt:getPlayerName()] = FDS.teamPoints.blue.Players[_initEnt:getPlayerName()] + FDS.dropZones[drop][2]
						else
							FDS.teamPoints.red.Players[_initEnt:getPlayerName()] = FDS.teamPoints.red.Players[_initEnt:getPlayerName()] + FDS.dropZones[drop][2]
						end
						local retId = #FDS.retrievedZones
						table.insert(FDS.retrievedZones, {FDS.dropZones[drop][1], FDS.dropZones[drop][2], timer.getTime(),retId})
						mist.scheduleFunction(clearRetrieved, {retId}, timer.getTime()+300.)
						table.remove(FDS.dropZones,drop)
					end
				end 
			end
		end
		if _local:getName() == "Mid_Helipad" and _local:getCoalition() == _initEnt:getCoalition() then
			local msgLand = {}
			local gp = _initEnt:getGroup()
			msgLand.text = 'Here can load valuable goods to deliver to your base helipad. \nEach item weighs ' .. tostring(FDS.goldenBars.weight) .. ' kg, and is worth $' .. tostring(FDS.goldenBars.value) .. ' credits. Access the radio via F10 to load.'
			msgLand.displayTime = 20  
			msgLand.sound = 'Msg.ogg'
			trigger.action.outTextForGroup(gp:getID(), msgLand.text, msgLand.displayTime)
			trigger.action.outSoundForGroup(gp:getID(),msgLand.sound)
			--local variousGoods = missionCommands.addSubMenuForGroup(gp:getID(), "Load valuable goods")
			--for j=1,10,1 do  
				--missionCommands.addCommandForGroup(gp:getID(), "Quantity: " .. tostring(j), variousGoods, FDS.validateDropBoard, {['rawData'] = {gp,'', j}, ['dropCase'] = FDS.loadValuableGoods, ['dropCaseString'] = 'loadValuableGoods'})
			--end
		end
	end,
	[world.event.S_EVENT_KILL] = function(x, param)
		local _event = param.event
		local _initEnt = _event.initiator
		local _targetEnt = _event.target
		local initCheck = pcall(FDS.playerCheck,_initEnt)
		local initCoa = 0
		local initCoaCheck = pcall(FDS.coalitionCheck,_initEnt)
		local targetCheck = pcall(FDS.playerCheck,_targetEnt)
		local targetCoa = 0
		local targetCoaCheck = pcall(FDS.coalitionCheck,_targetEnt)
		local rewardType = ''

		--Exporting event record
		if _initEnt ~= nil and _targetEnt ~= nil and _initEnt:getCategory() and _targetEnt:getCategory() and isUnitorStructure(_initEnt,_targetEnt) then
			if FDS.exportDataSite then
				if FDS.lastHits[_targetEnt:getID()] ~= nil and FDS.lastHits[_targetEnt:getID()] ~= nil then 
					local killObject = assembleKillObject(initCheck, targetCheck, _event, FDS.lastHits[_targetEnt:getID()][1], not FDS.lastHits[_targetEnt:getID()][2], false)
					exportKill(killObject)
				else
					local killObject = assembleKillObject(initCheck, targetCheck, _event, {}, not FDS.lastHits[_targetEnt:getID()][2], false)
					exportKill(killObject)	
				end
			end
			if _targetEnt and _targetEnt:getDesc() and _targetEnt:getDesc().typeName and FDS.rewardDict[_targetEnt:getDesc().typeName] then
				rewardType = _targetEnt:getDesc().typeName
			else
				rewardType = 'Default'
			end
			if initCoaCheck and targetCoaCheck then
				initCoa = _initEnt:getCoalition()
				targetCoa = _targetEnt:getCoalition()
			end
			awardPoints(initCheck, initCoaCheck, targetCoaCheck, initCoa, targetCoa, _initEnt, _targetEnt, rewardType, true)
			awardIndirectCredit(initCoaCheck, targetCoaCheck, initCoa, targetCoa, _initEnt, _targetEnt, rewardType, true)
			FDS.lastHits[_targetEnt:getID()][2] = true
			FDS.lastHits[_targetEnt:getID()] = 'DEAD'
		end
	end,
	[world.event.S_EVENT_MISSION_END] = function(x, param)
		if FDS.exportDataSite then
			local infile = io.open(FDS.exportPath .. "killRecord.json", "r")
			local instr = infile:read("*a")
			infile:close()
			
			local outfile = io.open(FDS.exportPath .. "killRecord_" .. os.date("%y") .. os.date("%m") .. os.date("%d") .. os.date("%H") .. os.date("%M") .. ".json", "w")
			outfile:write(instr)
			outfile:close()

			local infile = io.open(FDS.exportPath .. "currentStats.json", "r")
			local instr = infile:read("*a")
			infile:close()
			
			local outfile = io.open(FDS.exportPath .. "currentStats_" .. os.date("%y") .. os.date("%m") .. os.date("%d") .. os.date("%H") .. os.date("%M") .. ".json", "w")
			outfile:write(instr)
			outfile:close()

			local infile = io.open(FDS.exportPath .. "missionError.log", "r")
			local instr = infile:read("*a")
			infile:close()
			
			local outfile = io.open(FDS.exportPath .. "missionError_" .. os.date("%y") .. os.date("%m") .. os.date("%d") .. os.date("%H") .. os.date("%M") .. ".log", "w")
			outfile:write(instr)
			outfile:close()

			--pcall(killDCSProcess,{})
		end
	end,
	[world.event.S_EVENT_BASE_CAPTURED] = function(x, param)
		local _event = param.event
		local guards = ''
		if _event.place:getCoalition() ~= FDS.farpCoalition then
			if not FDS.farpEverCaptured then
				FDS.farpEverCaptured = true
			end
			if _event.place:getCoalition() == 1 then
				FDS.farpCoalition = 1
				guards = mist.cloneGroup("Red_Outpost_Crew", true)
			elseif _event.place:getCoalition() == 2 then
				FDS.farpCoalition = 2
				guards = mist.cloneGroup("Blue_Outpost_Crew", true)
			end
			FDS.farpOwner = {[FDS.trueCoalitionCode[_event.place:getCoalition()]] = guards.name}
			local soundDict = {['blue'] = {"fdsBaseLost.ogg","fdsBaseCaptured.ogg"}, ['red'] = {"fdsBaseCaptured.ogg","fdsBaseLost.ogg"}}
			msgCap = {}
			msgCap.text = FDS.trueCoalitionCode[_event.place:getCoalition()]:gsub("^%l", string.upper) .. ' Team captured the middle FARP.'
			msgCap.displayTime = 15  
			trigger.action.outText(msgCap.text, msgCap.displayTime)
			trigger.action.outSoundForCoalition(1,soundDict[FDS.trueCoalitionCode[_event.place:getCoalition()]][1])
			trigger.action.outSoundForCoalition(2,soundDict[FDS.trueCoalitionCode[_event.place:getCoalition()]][2])
		end
	end,
	[world.event.S_EVENT_DEAD] = function(x, param)
		local _event = param.event
		local _initEnt = _event.initiator
		local _initName = _initEnt:getName()
		local _initGroupCheck = pcall(FDS.nameGroup,_initEnt)
		local _initGroupName = ''
		if _initGroupCheck == true then
			_initGroupName = FDS.nameGroup(_initEnt)
		end

		coaCheck = pcall(FDS.coalitionCheck,_initEnt)
		playerCheck = pcall(FDS.playerCheck,_initEnt)

		if playerCheck == true then
			if _initEnt:getPlayerName() == nil then
				playerCheck = false
			end
		end

		if playerCheck == false and coaCheck == true then
			-- If not player, verify zones
			if _initEnt:getCoalition() == 2 then
				for i,j in pairs(FDS.blueZones) do
					for k,w in pairs(tgtObj.blue[j]) do
						local checkStructure = false
						if _initGroupCheck == false and _initName == w[1] then
							checkStructure = true
						end
						if _initGroupName == w[1] or checkStructure then
							table.remove(tgtObj.blue[j],k)
							--validateAliveUnits()
							local lenTab = #tgtObj.blue[j]
							local playWarning = true
							if  lenTab == 0 then
								FDS.zoneSts['blue'][j] = "Cleared"
								local allClearFlag = true
								for _,zSts in pairs(FDS.zoneSts['blue']) do
									if zSts ~= 'Cleared' then allClearFlag = false end
								end
								local msgclear = {}  
								if allClearFlag then
									msgclear.text = 'Congratulations! All enemy units are eliminated. Mission Accomplished!'
									msgclear.displayTime = 120
								else
									msgclear.text = j .. ' has been cleared, there are no signs of enemy activities in this zone. Good work.'
									msgclear.displayTime = 25 
									-- Msg for Enemy
									local msgfinalEnemy = {}  
									msgfinalEnemy.text = j .. ' is Lost.'
									msgfinalEnemy.displayTime = 30  
									msgfinalEnemy.sound = 'zone_killed.ogg'
									trigger.action.outTextForCoalition(2, msgfinalEnemy.text, msgfinalEnemy.displayTime)
									trigger.action.outSoundForCoalition(2,msgfinalEnemy.sound)
									playWarning = false
								end
								msgclear.sound = 'Complete.ogg'
								trigger.action.outTextForCoalition(1, msgclear.text, msgclear.displayTime)
								trigger.action.outSoundForCoalition(1,msgclear.sound)
								if allClearFlag then
									local msgfinal = {}
									--trigger.action.setUserFlag(901, true)
									msgfinal.text = 'Red Team is victorious! Restarting Server in 60 seconds. It is recommended to disconnect to avoid DCS crash.'
									msgfinal.displayTime = 60  
									msgfinal.sound = 'victory_Lane.ogg'
									trigger.action.outText(msgfinal.text, msgfinal.displayTime)
									trigger.action.outSoundForCoalition(1,msgfinal.sound)
									trigger.action.outSoundForCoalition(2,'zone_killed.ogg')
									playWarning = false
									endMission()
								end	
							end
							if playWarning then
								local msgfinal = {}  
								msgfinal.text = 'Warning! ' .. j .. ' is under attack.'
								msgfinal.displayTime = 5  
								msgfinal.sound = 'alert_UA.ogg'
								trigger.action.outTextForCoalition(2, msgfinal.text, msgfinal.displayTime)
								trigger.action.outSoundForCoalition(2,msgfinal.sound)
							else 
								playWarning = true
							end
						end
					end
				end
			elseif _initEnt:getCoalition() == 1 then
				for i,j in pairs(FDS.redZones) do
					for k,w in pairs(tgtObj.red[j]) do
						local checkStructure = false
						if not _initGroupCheck and _initName == w[1] then
							checkStructure = true
						end
						if _initGroupName == w[1] or checkStructure then
							table.remove(tgtObj.red[j],k)
							--validateAliveUnits()
							local lenTab = #tgtObj.red[j]
							local playWarning = true
							if lenTab == 0 then
								FDS.zoneSts['red'][j] = "Cleared"
								local allClearFlag = true
								for _,zSts in pairs(FDS.zoneSts['red']) do
									if zSts ~= 'Cleared' then allClearFlag = false end
								end
								local msgclear = {}  
								if allClearFlag then
									msgclear.text = 'Congratulations! All enemy units are eliminated. Mission Accomplished!'
									msgclear.displayTime = 120  
								else
									msgclear.text = j .. ' has been cleared, there are no signs of enemy activities in this zone. Good work.'
									msgclear.displayTime = 25  
									-- Msg for Enemy
									local msgfinalEnemy = {}
									msgfinalEnemy.text = j .. ' is Lost.'
									msgfinalEnemy.displayTime = 60  
									msgfinalEnemy.sound = 'zone_killed.ogg'
									trigger.action.outTextForCoalition(1, msgfinalEnemy.text, msgfinalEnemy.displayTime)
									trigger.action.outSoundForCoalition(1,msgfinalEnemy.sound)
									playWarning = false
								end
								msgclear.sound = 'Complete.ogg'
								trigger.action.outTextForCoalition(2, msgclear.text, msgclear.displayTime)
								trigger.action.outSoundForCoalition(2,msgclear.sound)	
								if allClearFlag then
									local msgfinal = {}
									--trigger.action.setUserFlag(900, true)
									msgfinal.text = 'Blue Team is victorious! Restarting Server in 60 seconds. It is recommended to disconnect to avoid DCS crash.'
									msgfinal.displayTime = 60
									msgfinal.sound = 'victory_Lane.ogg'
									trigger.action.outText(msgfinal.text, msgfinal.displayTime)
									trigger.action.outSoundForCoalition(2,msgfinal.sound)
									trigger.action.outSoundForCoalition(1,'zone_killed.ogg')
									playWarning = false
									endMission()
								end
							end
							if playWarning then
								local msgfinal = {}  
								msgfinal.text = 'Warning! ' .. j .. ' is under attack.'
								msgfinal.displayTime = 5  
								msgfinal.sound = 'alert_UA.ogg'
								trigger.action.outTextForCoalition(1, msgfinal.text, msgfinal.displayTime)
								trigger.action.outSoundForCoalition(1,msgfinal.sound)
							else 
								playWarning = true
							end
						end
					end
				end
			end
		elseif playerCheck == true and coaCheck == true then
			--if _initEnt:getPlayerName() then
			--	for i,j in pairs(FDS.lastHits) do
			--		if _initEnt:getPlayerName() == j[1] then
			--			FDS.lastHits[i] = nil
			--		end
			--	end
			--end
			local plName = _initEnt:getPlayerName()
			for i,j in pairs(FDS.teamPoints) do
				for k,w in pairs(FDS.teamPoints[i]['Players']) do
					if plName == k then
						FDS.teamPoints[i]['Players'][k] = 0.0
					end
				end
			end
		end
		-- LASTHITS
		local idCheck = pcall(FDS.checkID,_initEnt)
		if idCheck and _initEnt:getID() ~= nil and FDS.lastHits[_initEnt:getID()] ~= nil then
			local _initEntLocal = FDS.lastHits[_initEnt:getID()][3]
			local _targetEntLocal = _initEnt
			local _eventLocal = FDS.lastHits[_initEnt:getID()][4]
			local initCheck = pcall(FDS.playerCheck,_initEntLocal)
			local initCoa = 0
			local initCoaCheck = pcall(FDS.coalitionCheck,_initEntLocal)
			local targetCheck = pcall(FDS.playerCheck,_targetEntLocal)
			local targetCoa = 0
			local targetCoaCheck = pcall(FDS.coalitionCheck,_targetEntLocal)
			local rewardType = ''
			--Exporting event record
			if _initEntLocal and _targetEntLocal and _initEntLocal:getCategory() and _targetEntLocal:getCategory() and isUnitorStructure(_initEntLocal,_targetEntLocal) then
				if FDS.exportDataSite then
					if FDS.lastHits[_targetEntLocal:getID()] ~= nil and FDS.lastHits[_targetEntLocal:getID()] ~= 'DEAD' then 
						local killObject = assembleKillObject(initCheck, targetCheck, _eventLocal, FDS.lastHits[_targetEntLocal:getID()][1], not FDS.lastHits[_targetEntLocal:getID()][2], true)
						exportKill(killObject)
					else
						local killObject = assembleKillObject(initCheck, targetCheck, _eventLocal, {}, not FDS.lastHits[_targetEntLocal:getID()][2], true)
						exportKill(killObject)		
					end
				end
				if _targetEntLocal and _targetEntLocal:getDesc() and _targetEntLocal:getDesc().typeName and FDS.rewardDict[_targetEntLocal:getDesc().typeName] then
					rewardType = _targetEntLocal:getDesc().typeName
				else
					rewardType = 'Default'
				end
				if initCoaCheck and targetCoaCheck then
					initCoa = _initEntLocal:getCoalition()
					targetCoa = _targetEntLocal:getCoalition()
				end
				awardPoints(initCheck, initCoaCheck, targetCoaCheck, initCoa, targetCoa, _initEntLocal, _targetEntLocal, rewardType, false)
				awardIndirectCredit(initCoaCheck, targetCoaCheck, initCoa, targetCoa, _initEntLocal, _targetEntLocal, rewardType, false)
				FDS.lastHits[_initEnt:getID()][2] = true
			end
		end
		-- Clean Deploy
		if _initName ~= nil and coaCheck then
			local coaDead = _initEnt:getCoalition()
			for i,_ in pairs(FDS.deployedUnits[FDS.trueCoalitionCode[coaDead]]) do
				if _initName == i then
					FDS.deployedUnits[FDS.trueCoalitionCode[coaDead]][i] = nil
				end
			end 
		end
	end,
	default = function(x, param) end,
}

FDS.eventHandler = {}
function FDS.eventHandler:onEvent(_event)
	-- Debug
	--local msgfinal = {}
	--local eventName = find(world.event, _event.id)
	--msgfinal.text = tostring(eventName)
	--msgfinal.displayTime = 5 
	--msgfinal.sound = 'Msg.ogg' 
	--trigger.action.outText(msgfinal.text, msgfinal.displayTime)
	table.insert(FDS.exportVector,'evento')
	FDS.eventActions:case(_event.id, {event = _event})
	--pcall(FDS.eventActions:case(_event.id),{_event.id, {event = _event}})
end

-- Main
-- Creating Bases, Zones and SAMs
--mist.scheduleFunction(creatingBases, {},timer.getTime()+1)
mist.scheduleFunction(protectCall, {creatingBases},timer.getTime()+1)
-- Updating Players
--mist.scheduleFunction(checkPlayersOn, {},timer.getTime()+1.5,5)
--mist.scheduleFunction(protectCall, {checkPlayersOn},timer.getTime()+1.5,5)

-- Starting check drop routine
--mist.scheduleFunction(checkDropZones, {},timer.getTime()+2,300)
mist.scheduleFunction(protectCall, {checkDropZones},timer.getTime()+2,300)
-- Hover checker
--mist.scheduleFunction(detectHover, {},timer.getTime()+2.5,FDS.refreshScan)
mist.scheduleFunction(protectCall, {detectHover},timer.getTime()+2.5,FDS.refreshScan)
-- FARP check
mist.scheduleFunction(protectCall, {FDS.checkFarpDefences},timer.getTime()+2.5,FDS.refreshFARPScan)
-- Random drop manager
--mist.scheduleFunction(createRandomDrop, {}, timer.getTime()+3, FDS.randomDropTime)
mist.scheduleFunction(protectCall, {createRandomDrop}, timer.getTime()+3, FDS.randomDropTime)
-- Transport caller
--mist.scheduleFunction(checkTransport, {'blue'}, timer.getTime()+FDS.firstGroupTime, FDS.refreshTime)
mist.scheduleFunction(protectCall, {checkTransport,'blue'}, timer.getTime()+FDS.firstGroupTime, FDS.refreshTime)
--mist.scheduleFunction(checkTransport, {'red'}, timer.getTime()+FDS.firstGroupTime, FDS.refreshTime)
mist.scheduleFunction(protectCall, {checkTransport,'red'}, timer.getTime()+FDS.firstGroupTime, FDS.refreshTime)
-- Check Connected Players
--mist.scheduleFunction(targetInServer, {}, timer.getTime()+3.5, FDS.sendDataFreq)
mist.scheduleFunction(protectCall, {targetInServer}, timer.getTime()+3.5, FDS.sendDataFreq)
-- Export mission data
if FDS.exportDataSite then
	--mist.scheduleFunction(exportMisData, {}, timer.getTime()+3.5, FDS.sendDataFreq)
	mist.scheduleFunction(protectCall, {exportMisData}, timer.getTime()+3.5, FDS.sendDataFreq)
end

for _,i in pairs(FDS.coalitionCode) do
	--FDS.resAWACSTime[i][2] = mist.scheduleFunction(respawnAWACSFuel, {i},timer.getTime()+FDS.fuelAWACSRestart)
	FDS.resAWACSTime[i][2] = mist.scheduleFunction(protectCall,{respawnAWACSFuel, i},timer.getTime()+FDS.fuelAWACSRestart)
	FDS.resTankerTime[i][2] = mist.scheduleFunction(protectCall,{respawnTankerFuel, i},timer.getTime()+FDS.fuelTankerRestart)
	FDS.resMPRSTankerTime[i][2] = mist.scheduleFunction(protectCall,{respawnMPRSTankerFuel, i},timer.getTime()+FDS.fuelTankerRestart)
end

--Events
world.addEventHandler(FDS.eventHandler)