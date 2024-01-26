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
FDS.victoriousTeam = 'Missao terminada sem vencedor'
FDS.endTime = {}
FDS.redisStartTime = 5
FDS.exportVector = {}
FDS.recordDeliveredPoints = nil
FDS.teamPoints = {}
FDS.playersCredits = {}
FDS.cargoList = {} -- Aircrafts with cargo
FDS.valuableList = {}
FDS.deployedUnits = {} -- All deployed units
FDS.deployedTroopsMarks = {}
FDS.fuelLevels = {}
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
FDS.dropHeliTypes = {'UH-1H','Mi-8MT','SA342L', 'SA342M', 'SA342Minigun','Mi-24P'}
FDS.blueRelieveZones = {'Sochi-Adler','Batumi', 'Gudauta', 'Sukhumi-Babushara', 'Shpora-11', 'Shpora-21', 'Blue_Carrier_K', 'Blue_Carrier_F', 'Blue_Carrier_S', 'Blue_Carrier_T', 'Blue_Carrier_SuperCarrier'}
FDS.redRelieveZones = {'Anapa-Vityazevo','Kobuleti' ,'Krymsk', 'Gelendzhik', 'Novorossiysk' ,'Moscow-11','Moscow-21', 'Red_Carrier_K', 'Red_Carrier_F', 'Red_Carrier_S', 'Red_Carrier_T', 'Red_Carrier_SuperCarrier'}
FDS.alliedList = {
	['blue'] = {},
	['red'] = {}
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
FDS.recentVictim = {}
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

FDS.discordAdvertisingTime = 1800
FDS.cleanTime = 1800
FDS.discordAdvertisingTrue = true

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
FDS.exportPlayerUnits = true
FDS.exportRegionsData = true
FDS.exportPlayerData = true
FDS.importTax = {0.7}
FDS.taxFreeValue = {100}
FDS.fixedImportValue = 100
FDS.exportDataSite = true -- use false for non-multiplayer games
FDS.errorLogMis = true

-- Rewards
FDS.playerReward = 250.0
FDS.enemyReward = 50.0
FDS.fuelReward = 100.0
FDS.shelterReward = 150.0
FDS.commandPostReward = 200.0
FDS.f18Reward = 100.0
FDS.f4Reward = 100.0
FDS.f5Reward = 100.0
FDS.f1cReward = 100.0
FDS.f14bReward = 100.0
FDS.f15cReward = 100.0
FDS.f16cReward = 100.0
FDS.j11aReward = 100.0
FDS.jf17Reward = 100.0
FDS.m2000cReward = 100.0
FDS.mig23Reward = 100.0
FDS.mig25Reward = 100.0
FDS.mig29Reward = 100.0
FDS.mig31Reward = 100.0
FDS.su27Reward = 100.0
FDS.su33Reward = 100.0
FDS.su30Reward = 100.0
FDS.cargoReward = 100.0
FDS.infAKReward = 10.0
FDS.infRPGReward = 15.0
FDS.predatorJtac = 150.0
FDS.hmmwvJtac = 150.0
FDS.b1b = 100.0

FDS.rewardDict = {
	['.Command Center'] = FDS.commandPostReward,
	['Shelter'] = FDS.shelterReward,
	['Fuel tank'] = FDS.fuelReward,
	['FA-18C_hornet'] = FDS.f18Reward,
	['F-4E'] = FDS.f4Reward,
	['F-5E-3'] = FDS.f5Reward,
	['Mirage-F1C'] = FDS.f1cReward,
	['F-14B'] = FDS.f14bReward,
	['F-15C'] = FDS.f15cReward,
	['F-16C_50'] = FDS.f16cReward,
	['J-11A'] = FDS.j11aReward,
	['JF-17'] = FDS.jf17Reward,
	['M-2000C'] = FDS.m2000cReward,
	['MiG-23MLD'] = FDS.mig23Reward,
	['MiG-25PD'] = FDS.mig25Reward,
	['MiG-29S'] = FDS.mig29Reward,
	['MiG-31'] = FDS.mig31Reward,
	['Su-27'] = FDS.su27Reward,
	['Su-33'] = FDS.su33Reward,
	['Su-30'] = FDS.su30Reward,
	['C-130'] = FDS.cargoReward,
	['Paratrooper AKS-74'] = FDS.infAKReward,
	['Paratrooper RPG-16'] = FDS.infRPGReward,
	['Infantry AK ver3'] = FDS.infAKReward,
	['Soldier M249'] = FDS.infAKReward,
	['RQ-1A Predator'] = FDS.predatorJtac,
	['M1043 HMMWV Armament'] = FDS.hmmwvJtac,
	['B-1B'] = FDS.b1b,
	['Default'] = FDS.enemyReward
}

FDS.doubleGuard = {}
FDS.doubleGuardTime = 1 -- seconds
FDS.doubleGuardOn = true

-- Transport
FDS.deployedTroopsFontSizeText = 15
FDS.deployedTroopsSymbolSize = 200
FDS.updateTroopsRefresh = 120
FDS.refreshTime = 2400.
FDS.squadSize = 4

-- Fixed or progressive for cargo planes
FDS.progressiveReward = true
FDS.conditionalIncrease = true
FDS.initialReward = 25
FDS.rewardIncrease = 5
FDS.rewardCargo = {
	['blue'] = FDS.initialReward-FDS.squadSize*FDS.rewardIncrease,
	['red'] = FDS.initialReward-FDS.squadSize*FDS.rewardIncrease 
}
FDS.firstGroupTime = 300.0
FDS.lastDropTime = {
	['blue'] = -(FDS.refreshTime - FDS.firstGroupTime),
	['red'] = -(FDS.refreshTime - FDS.firstGroupTime) 
} 
FDS.cargoFSTable = {['fighter']={{},{}},['interceptor']={{},{}}}
FDS.cargoFSInterval = 300.0
FDS.cargoChance30min = 0.75
FDS.chanceTrial = 1-(1-FDS.cargoChance30min)^(1/(1800/FDS.cargoFSInterval))
FDS.timeMaxVariance = 0.0

FDS.deleteTime = 3600.0
FDS.retryTime = 600.0
FDS.transportFSSpeed = 200.0

-- Bombers
FDS.bomberQuantity = 10
FDS.bomberMinInterval = 10.0
FDS.bomberTargetsNumber = 16
FDS.bomberQty = {
	['blue'] = 0,
	['red'] = 0
}
FDS.killTime = 1800

-- AWACS Respawn
FDS.awacsMode = 'respawnable' -- 'towers-only', 'buyable', 'respawnable'
FDS.awacsActive = {
	['blue'] = false,
	['red'] = false
}
FDS.awacsRefreshCheck = 5 -- seconds
FDS.respawnAWACSTime = 1800.0
FDS.fuelAWACSRestart = 14400.0
FDS.resAWACSTime = {
	['blue'] = {'Blue_AWACS_1', 0},
	['red'] = {'Red_AWACS_1', 0}
}
-- Tanker Respawn
FDS.respawnTankerTime = 600.0
FDS.fuelTankerRestart = 14400.0
FDS.refuelRefresh = 5 -- seconds
FDS.refuelRepetitions = 1
FDS.refuelThreshold = 0.001

-- Regions to conquer
FDS.ressuplyZones = {['blue'] = {'blueRessuplyTroops', 'blueRessuplyNavy'}, ['red'] = {'redRessuplyTroops', 'redRessuplyNavy'}}
FDS.contestedRegions = {'Shoreline', 'Tuapse', 'Goyth', 'Apsheronsk'}
FDS.minRegionIncome = 10 -- per 10 minutes
FDS.regionStatus = {}
FDS.flagQty = 6
FDS.regionCaptureIncrease = 1
FDS.checkRegionPeriod = 18
FDS.regionPayPeriod = 600
FDS.regionInfoDisplayTime = 3
FDS.regionEventDisplayTime = 10

-- DropZones
-- Minimum dist is 8 nm from enemy field and helipad
FDS.randomDropValue = 250.
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

FDS.AAA = math.random(1,3)
FDS.AATung = math.random(1,3)
FDS.AAStrela1 = math.random(1,3)
FDS.AAStrela2 = math.random(1,3)
FDS.AAIgla = math.random(2,5)
FDS.AATor = math.random(1,3)
FDS.SAM = math.random(0,1)

FDS.unitsInZones = {}
FDS.countUCat = {}
FDS.unitsInZone = {}

FDS.blueunitsInZones = {}
FDS.bluecountUCat = {}
FDS.blueunitsInZone = {}

-- Credit Factory
FDS.activeFactories = {
	['blue'] = {},
	['red'] = {}
}
FDS.typeFactory = {[3] = 'Oil platform', [1] = 'Tech combine'}
FDS.factorySpawnZones = {
	['blue'] = {'blueDeepRig_1', 'blueRigZone_1', 'blueRigZone_2', 'blueRigZone_3', 'blueRigZone_4', 'blueRigZone_5', 'blueFactoryZone_1'},
	['red'] = {'redDeepRig_1', 'redRigZone_1', 'redRigZone_2', 'redRigZone_3', 'redRigZone_4', 'redRigZone_5', 'redFactoryZone_1'}
}
FDS.factoryPeriod = 10 -- time between respawns
FDS.maxFactoryQuantity = 3
FDS.maxFactoryTier = 10
FDS.initialFactoryIncome = 10
FDS.factoryTierIncrease = 5
FDS.factoryCurrierQuantity = 3

-- FARP Logic
FDS.farpReliever = true
FDS.markUpNumber = 0
FDS.farpTextID = 0
FDS.farpOwner = {}
FDS.farpEverCaptured = false
FDS.refreshFARPScan = 5.0
FDS.dropLimitAlt = 20.0
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
	['dropTroops'] = {'disable', checkIfEmpty, "You cannot deploy troops here (too close from an enemy helipad/airfield). Minimum allowed distance: 8mn."},
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
FDS.bypassAllowedZone = false
FDS.allowedZones = {'droppableZone1', 'droppableZone2', 'droppableZone3', 'droppableZone4', 'droppableZone5'}
-- JTAC Parameters
FDS.jtacRefresh = 5.0
FDS.jtacID = 0
FDS.maxJTACRange = 7 -- nm
FDS.allJtacs = {
	['blue'] = {},
	['red'] = {}
}
-- Position
FDS.dropDistance = 45
FDS.dropTroopDistance = 20
FDS.advanceDistance = 10
-- Life span in reboots
FDS.unitLifeSpan = 5
FDS.exportUnitsT = 300
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
FDS.ewrWeight = 100 -- kg
FDS.BMP2Weight = 1500 -- kg
FDS.BMP3Weight = 1500 -- kg
FDS.M2A2Weight = 1500 -- kg
FDS.T72Weight = 2500 -- kg
FDS.T90Weight = 3000 -- kg
FDS.GovWeight = 2000 -- kg
FDS.AkaWeight = 2800 -- kg
FDS.MstWeight = 3500 -- kg
FDS.GradWeight = 2800 -- kg
----
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
	{name = "Mig-19", cost = 500, groupName = "_AS_LVL1", type = 'Air'},
	{name = "Mig-23", cost = 750, groupName = "_AS_LVL2", type = 'Air'},
	{name = "Mig-29", cost = 1000, groupName = "_AS_LVL3", type = 'Air'},
	{name = "JTAC UAV", cost = 500, groupName = "_Spy_Drone", deafultCode = '1688', su25TCode = '1113', type = 'Air'},
	{name = "E-2D AWACS", cost = 2000, type = 'Air'}
}
FDS.heliSlots = {
	['UH-1H'] = 12,
	['Mi-8MT'] = 22,
	['SA342L'] = 2,
	['SA342M'] = 2,
	['SA342Minigun'] = 2,
	['Mi-24P'] = 8
}
-- inf -> 0 -- armor -> 1 -- anti-air -> 2 -- utilities -> 3
FDS.transportTypes = {'Infantry', 'Armor', 'Anti-Air', 'Utilities', 'Artillery'}
FDS.troopAssetsNumbered = {
	--{name = "AK_Soldier", cost = 25, mass = {FDS.soldierWeight, FDS.kitWeight, FDS.riffleWeight}, slots = 1, variability = {{90,120}}, type = 'Infantry'},
	--{name = "MG_Soldier", cost = 50, mass = {FDS.soldierWeight, FDS.kitWeight, FDS.mgWeight}, slots = 1, variability = {{90,120}}, type = 'Infantry'},
	--{name = "RPG_Soldier", cost = 80, mass = {FDS.soldierWeight, FDS.kitWeight, FDS.rpgWeight}, slots = 1, variability = {{90,120}}, type = 'Infantry'},
	{name = "BMP2", cost = 250, mass = {FDS.BMP2Weight}, slots = 4, variability = {}, type = 'Armor'},
	{name = "BMP3", cost = 250, mass = {FDS.BMP3Weight}, slots = 4, variability = {}, type = 'Armor'},
	{name = "M2A2", cost = 250, mass = {FDS.M2A2Weight}, slots = 4, variability = {}, type = 'Armor'},
	{name = "T72", cost = 400, mass = {FDS.T72Weight}, slots = 6, variability = {}, type = 'Armor'},
	{name = "T90", cost = 500, mass = {FDS.T90Weight}, slots = 6, variability = {}, type = 'Armor'},
	{name = "Igla", cost = 200, mass = {FDS.soldierWeight, FDS.kitWeight, FDS.manpadWeight}, slots = 1, variability = {{90,120}}, type = 'Anti-Air'},
	{name = "JTAC Team", cost = 300, mass = {FDS.JTACWeight, FDS.soldierWeight, FDS.soldierWeight}, slots = 2, variability = {nil,{90,120},{90,120}}, deafultCode = '1688', su25TCode = '1113', type = 'Utilities'},
	{name = "Shilka", cost = 250, mass = {FDS.ShilkaWeight}, slots = 5, variability = {}, type = 'Anti-Air'},
	{name = "Strela", cost = 500, mass = {FDS.StrelaWeight}, slots = 5, variability = {}, type = 'Anti-Air'},
	{name = "Tunguska", cost = 800, mass = {FDS.TunguskaWeight}, slots = 10, variability = {}, type = 'Anti-Air'},
	{name = "TOR", cost = 800, mass = {FDS.TORWeight}, slots = 10, variability = {}, type = 'Anti-Air'},
	{name = "Ammo", cost = 100, mass = {FDS.ammoWeight}, slots = 2, variability = {}, type = 'Utilities'},
	{name = "EWR", cost = 200, mass = {FDS.ewrWeight}, slots = 4, variability = {}, type = 'Utilities'},
	{name = "Mortar", cost = 250, mass = {FDS.ewrWeight}, slots = 1, variability = {}, type = 'Artillery'},
	{name = "Gvozdika", cost = 600, mass = {FDS.GovWeight}, slots = 6, variability = {}, type = 'Artillery'},
	{name = "Akatsia", cost = 1200, mass = {FDS.AkaWeight}, slots = 8, variability = {}, type = 'Artillery'},
	{name = "Msta", cost = 1600, mass = {FDS.MstWeight}, slots = 12, variability = {}, type = 'Artillery'},
	{name = "MLRSGrad", cost = 1200, mass = {FDS.GradWeight}, slots = 8, variability = {}, type = 'Artillery'}
}

FDS.costEpsilon = 1
FDS.navalAssetsNumbered = {
	{name = "Molniya", cost = 400, type = 'Naval'},
	{name = "Grisha", cost = 400, type = 'Naval'},
	{name = "Rezky", cost = 900, type = 'Naval'},
	{name = "Neustrashimy", cost = 900, type = 'Naval'},
	{name = "Tilde", cost = 500, type = 'Naval'}
}
FDS.troopAssets = {}
for _, i in pairs(FDS.troopAssetsNumbered) do
	FDS.troopAssets[i.name] = i
end
FDS.navalAssets = {}
for _, i in pairs(FDS.navalAssetsNumbered) do
	FDS.navalAssets[i.name] = i
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

function startRedisMission()
	if DFDS ~= nil then
		DFDS.client:hset({'game', 'started', 'true'})
	end
end

function cleanServer()
	local volS = {id = world.VolumeType.SPHERE,params = {point = {x = -82595.047937808,y = 0,z = 401311.75782212},radius = 200000.0}}
	local cObj = world.removeJunk(volS)
	local cleanFile = io.open(FDS.exportPath .. 'clearFeed.txt', "a")
	if cleanFile == nil then
		lfs.mkdir(FDS.exportPath)
		cleanFile:write(nil)
	end
	cleanFile:write('Objects cleared: ' .. tostring(cObj) .. '\n')
	cleanFile:close()	
end

function discordCall()
	msg = {}
	msg.text = '- Join our discord comunity for enhanced team play.\nAccess the website: "https://dcs.comicorama.com/" for the discord link.\n\n- Junte-se ao nosso canal de discord para melhor jogar em equipe.\nAcesse o site: "https://dcs.comicorama.com/" para o link do discord.\n'
	msg.displayTime = 10
	msg.sound = 'Msg.ogg'
	trigger.action.outText(msg.text, msg.displayTime)
	trigger.action.outSound(msg.sound)
end

function cleanDeployedUnits(coa)
    for i,_ in pairs(FDS.deployedUnits[coa]) do
        if Unit.getByName(i) == nil then
            FDS.deployedUnits[coa][i] = nil
        end
    end   
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

function errorLog(filename, message)
	local errFile = io.open(FDS.exportPath .. filename, "a")
	if errFile == nil then
		lfs.mkdir(FDS.exportPath)
		errFile:write(nil)
	end
	errFile:write(message .. '\n')
	errFile:close()
end

function initializeRegions()
	for _, i in pairs(FDS.contestedRegions) do
		FDS.regionStatus[i] = {}
        FDS.regionStatus[i].owner = 'neutral'
        FDS.regionStatus[i].income = FDS.minRegionIncome
        FDS.regionStatus[i].capture = 0
		importRegionsDataNow()
        args = {}
        args.regionName = i
        args.regionValue = FDS.regionStatus[i].income
        args.ownerTeam = FDS.regionStatus[i].owner
        drawRegionInfo(args)
        -- Flag Placing
        --local centreFlag = trigger.misc.getZone('regionCap'..i)
        --for flagNumber = 1, FDS.flagQty do
        --    addO = {}
        --    addO.country = 64
        --    addO.category = 4
        --    addO.x = centreFlag.point["x"]+math.sin(flagNumber*3.1415*2/FDS.flagQty)*centreFlag.radius
        --    addO.y = centreFlag.point["z"]+math.cos(flagNumber*3.1415*2/FDS.flagQty)*centreFlag.radius
        --    addO.type = 'Black_Tyre_RF'
        --    addO.heading = 0
        --    addCP = mist.dynAddStatic(addO)
        --end
        local ref = trigger.misc.getZone('regionCap'..i)
        FDS.markUpNumber = FDS.markUpNumber + 1
 		trigger.action.circleToAll(-1 , FDS.markUpNumber, ref.point , ref.radius , {0, 0, 0, 1} , {0, 0, 0, 0} , 1 , true)
	end
end

function checkRegions()
	local deployedBlue = {}
	local deployedRed = {}
	local deployed = {['blue'] = deployedBlue, ['red'] = deployedRed}
	for i, j in pairs(mist.DBs.humansByName) do
		if Unit.getByName(i) and Unit.getByName(i):getCoalition() == 1 then
			table.insert(deployed['red'], i)
		elseif Unit.getByName(i) and Unit.getByName(i):getCoalition() == 2 then
			table.insert(deployed['blue'], i)
		end
	end
	for i, j in pairs(FDS.deployedUnits) do
		for k, w in pairs(j) do
			table.insert(deployed[i], k)
		end
	end
	local blueInside = 0
	local redInside = 0
	for _, zoneName in pairs(FDS.contestedRegions) do
		blueInside = mist.getUnitsInZones(deployed['blue'], {'regionCap'..zoneName})
		redInside = mist.getUnitsInZones(deployed['red'], {'regionCap'..zoneName})
		local redBlueCoalition = {
			[2]={
				['frdN'] = blueInside,
				['eneN'] = redInside,
				['limitCapture'] = 100,
				['increase'] = FDS.regionCaptureIncrease,
				['owner'] = 'blue',
				['opositeOwner'] = 'red',
				['ownerTeam'] = 'Blue',
				['opositeTeam'] = 'Red',
				['coaCode'] = 2,
				['enemyCode'] = 1,
				['soundLib'] = {[2] = "fdsBaseCaptured.ogg", [1] = "fdsBaseLost.ogg"}
			}, 
			[1] = {
				['frdN'] = redInside,
				['eneN'] = blueInside,
				['limitCapture'] = -100,
				['increase'] = -FDS.regionCaptureIncrease,
				['owner'] = 'red',
				['opositeOwner'] = 'blue',
				['ownerTeam'] = 'Red',
				['opositeTeam'] = 'Blue',
				['coaCode'] = 1,
				['enemyCode'] = 2,
				['soundLib'] = {[1] = "fdsBaseCaptured.ogg", [2] = "fdsBaseLost.ogg"}
			}}
		for coa = 1, 2 do
			if #redBlueCoalition[coa]['frdN'] > 0 and #redBlueCoalition[coa]['eneN'] == 0 then
				if (coa == 2 and FDS.regionStatus[zoneName].capture < redBlueCoalition[coa]['limitCapture']) or (coa == 1 and FDS.regionStatus[zoneName].capture > redBlueCoalition[coa]['limitCapture']) then
					if (coa == 2 and FDS.regionStatus[zoneName].capture + redBlueCoalition[coa]['increase'] < redBlueCoalition[coa]['limitCapture']) or (coa == 1 and FDS.regionStatus[zoneName].capture + redBlueCoalition[coa]['increase'] > redBlueCoalition[coa]['limitCapture']) then
						FDS.regionStatus[zoneName].capture = FDS.regionStatus[zoneName].capture + redBlueCoalition[coa]['increase'] 
					else
						FDS.regionStatus[zoneName].capture = redBlueCoalition[coa]['limitCapture']
					end
					local msg = {}
					msg.displayTime = 3    
					if (coa ==2 and FDS.regionStatus[zoneName].capture >= 0 and FDS.regionStatus[zoneName].owner == redBlueCoalition[coa]['opositeOwner']) or (coa ==1 and FDS.regionStatus[zoneName].capture <= 0 and FDS.regionStatus[zoneName].owner == redBlueCoalition[coa]['opositeOwner'])  then
						FDS.regionStatus[zoneName].owner = 'neutral'
						args = {}
						args.regionName = zoneName
						args.regionValue = FDS.regionStatus[zoneName].income
						args.ownerTeam = FDS.regionStatus[zoneName].owner
						drawRegionInfo(args)
						msg.text = redBlueCoalition[coa]['opositeTeam'] ..' team does not have the control of ' .. zoneName .. ' region anymore.'
						trigger.action.outText(msg.text, msg.displayTime) 
						trigger.action.outSoundForCoalition(redBlueCoalition[coa]['enemyCode'],"fdsBaseLost.ogg")
						trigger.action.outSoundForCoalition(redBlueCoalition[coa]['coaCode'],"msg.ogg")
						exportRegionsData()
					elseif FDS.regionStatus[zoneName].capture == redBlueCoalition[coa]['limitCapture'] and FDS.regionStatus[zoneName].owner == 'neutral' then
						FDS.regionStatus[zoneName].owner = redBlueCoalition[coa]['owner']
						args = {}
						args.regionName = zoneName
						args.regionValue = FDS.regionStatus[zoneName].income
						args.ownerTeam = FDS.regionStatus[zoneName].owner
						drawRegionInfo(args)
						msg.text = redBlueCoalition[coa]['ownerTeam'] ..' team now holds the ' .. zoneName .. ' region.'
						trigger.action.outText(msg.text, msg.displayTime) 
						trigger.action.outSoundForCoalition(coa,redBlueCoalition[coa]['soundLib'][redBlueCoalition[coa]['enemyCode']])
						trigger.action.outSoundForCoalition(coa,redBlueCoalition[coa]['soundLib'][redBlueCoalition[coa]['coaCode']])
						exportRegionsData()
					else
						if (coa == 2 and FDS.regionStatus[zoneName].capture < 0) or (coa == 1 and FDS.regionStatus[zoneName].capture > 0) then
							msg.text = redBlueCoalition[coa]['ownerTeam']..' team is decapturing the ' .. zoneName .. ' region: ' .. tostring(math.abs(FDS.regionStatus[zoneName].capture)) .. ' %'
						else
							msg.text = redBlueCoalition[coa]['ownerTeam']..' team is capturing the ' .. zoneName .. ' region: ' .. tostring(math.abs(FDS.regionStatus[zoneName].capture)) .. ' %'
						end
						trigger.action.outText(msg.text, msg.displayTime) 
					end        
				end
			end
		end
		-- Deixou de capturar
		local currentTarget = {['red'] = -100, ['blue'] = 100, ['neutral'] = 0}
		if #redInside == 0 and #blueInside == 0 then
			-- Defense regions
			if FDS.regionStatus[zoneName].owner == 'red' or FDS.regionStatus[zoneName].owner == 'blue' then 
				local allZ = mist.DBs.zonesByName
				local coalitionDict = {['red'] = {'Red', 1, 2}, ['blue'] = {'Blue', 2, 1}}
				local defenseZones = {}
				for i,j in pairs(allZ) do
					if string.match(i, 'regionDefense'.. zoneName) then
						table.insert(defenseZones, i)
					end
				end	
				local defenseTroops = mist.getUnitsInZones(deployed[FDS.regionStatus[zoneName].owner], defenseZones)
				if #defenseTroops == 0  then
					local msgStart = coalitionDict[FDS.regionStatus[zoneName].owner][1]
					local sound2PlayLost = coalitionDict[FDS.regionStatus[zoneName].owner][2]
					local sound2PlayMsg = coalitionDict[FDS.regionStatus[zoneName].owner][3]
					FDS.regionStatus[zoneName].owner = 'neutral'
					local args = {}
					args.regionName = zoneName
					args.regionValue = FDS.regionStatus[zoneName].income
					args.ownerTeam = FDS.regionStatus[zoneName].owner
					drawRegionInfo(args)
                    local msg = {}
					msg.displayTime = 3
					msg.text = msgStart..' team does not have the control of ' .. zoneName .. ' region anymore.'
					trigger.action.outText(msg.text, msg.displayTime) 
					trigger.action.outSoundForCoalition(sound2PlayLost,"fdsBaseLost.ogg")
					trigger.action.outSoundForCoalition(sound2PlayMsg,"fdsBaseLost.ogg")
					exportRegionsData()
				end
			end
			-- Not captured
			if FDS.regionStatus[zoneName].capture ~= currentTarget[FDS.regionStatus[zoneName].owner] then
				if math.abs(FDS.regionStatus[zoneName].capture + (math.abs(currentTarget[FDS.regionStatus[zoneName].owner])/(currentTarget[FDS.regionStatus[zoneName].owner]))*FDS.regionCaptureIncrease) < math.abs(currentTarget[FDS.regionStatus[zoneName].owner]) then
					FDS.regionStatus[zoneName].capture = FDS.regionStatus[zoneName].capture + (math.abs(currentTarget[FDS.regionStatus[zoneName].owner])/(currentTarget[FDS.regionStatus[zoneName].owner]))*FDS.regionCaptureIncrease
				elseif FDS.regionStatus[zoneName].owner == 'neutral' and math.abs(FDS.regionStatus[zoneName].capture) - (FDS.regionCaptureIncrease) > currentTarget[FDS.regionStatus[zoneName].owner] then 
					FDS.regionStatus[zoneName].capture = FDS.regionStatus[zoneName].capture - (math.abs(FDS.regionStatus[zoneName].capture)/FDS.regionStatus[zoneName].capture)*FDS.regionCaptureIncrease        
				else
					FDS.regionStatus[zoneName].capture = currentTarget[FDS.regionStatus[zoneName].owner]
				end
			end
		end
	end
end

function regionsPaycheck()
	local paycheck = {['blue'] = 0, ['red'] = 0}
	local allPlayers = mist.DBs.humansByName
	for _, zoneName in pairs(FDS.contestedRegions) do
		if FDS.regionStatus[zoneName].owner ~= 'neutral' then
			paycheck[FDS.regionStatus[zoneName].owner] = paycheck[FDS.regionStatus[zoneName].owner] + FDS.regionStatus[zoneName].income
		end
	end
	for name, data in pairs(allPlayers) do
		if Unit.getByName(name) ~= nil and Unit.getByName(name):getPlayerName() ~= nil and paycheck[FDS.trueCoalitionCode[Unit.getByName(name):getCoalition()]] > 0 then
			local gpUcid = FDS.retrieveUcid(Unit.getByName(name):getPlayerName(),FDS.isName)
			FDS.playersCredits[FDS.trueCoalitionCode[Unit.getByName(name):getCoalition()]][gpUcid] = FDS.playersCredits[FDS.trueCoalitionCode[Unit.getByName(name):getCoalition()]][gpUcid] + paycheck[FDS.trueCoalitionCode[Unit.getByName(name):getCoalition()]]
			local msg = {}
			msg.text = 'You receive $' .. tostring(paycheck[FDS.trueCoalitionCode[Unit.getByName(name):getCoalition()]]) .. ' credits from the regions under you team control.' 
			msg.displayTime = 5
			trigger.action.outTextForGroup(Unit.getByName(name):getGroup():getID(), msg.text, msg.displayTime)
		end
	end
end

function drawRegionInfo(args)
	-- Precisa criar FDS.regionStatus = {['Tuapse'] = {}}
    -- args.regionName ... args.regionValue ... args.ownerTeam
    local allZ = mist.DBs.zonesByName
    local regionName = args.regionName
    local zoneDraw = {}
    local orderedZoneDraw = {}
    local textDraw = {}
    local colorDict = {['blue'] = {0, 0, 1, .1}, ['red'] = {1, 0, 0, .1}, ['neutral'] = {1, 1, 1, .1}}
    local textColorDict = {['blue'] = {0, 0, 1, 1}, ['red'] = {1, 0, 0, 1}, ['neutral'] = {0, 0, 0, 1}}
    for i,j in pairs(allZ) do
        if string.match(i, 'draw'.. regionName) then
            if string.match(i, 'Text') then
                table.insert(textDraw, i)
            else
                table.insert(zoneDraw, i)
            end
        end
    end
    for i = 1, #zoneDraw do
        table.insert(orderedZoneDraw, 'draw'.. regionName..i)
    end
    FDS.markUpNumber = FDS.markUpNumber + 1
	parameters = {}
	for _,i in pairs(orderedZoneDraw) do
		table.insert(parameters, trigger.misc.getZone(i).point)
	end
	argsTest = {7, -1, FDS.markUpNumber}
	for _,i in pairs(parameters) do
		table.insert(argsTest, i)
	end
	table.insert(argsTest, {0, 0, 0, 1})
	table.insert(argsTest, colorDict[args.ownerTeam])
	table.insert(argsTest, 4)
    if FDS.regionStatus[args.regionName]['shapeIds'] ~= nil then
        trigger.action.removeMark(FDS.regionStatus[args.regionName]['shapeIds'][1])
        trigger.action.removeMark(FDS.regionStatus[args.regionName]['shapeIds'][2])
    end
	trigger.action.markupToAll(unpack(argsTest))
    local regionShapeNumber = FDS.markUpNumber
    FDS.markUpNumber = FDS.markUpNumber + 1
    trigger.action.textToAll(-1, FDS.markUpNumber, trigger.misc.getZone(textDraw[1]).point, textColorDict[args.ownerTeam] , {0, 0, 0, 0} , 20, true , args.regionName..'\n+$'..tostring(args.regionValue))
    local regionTextNumber = FDS.markUpNumber
    FDS.regionStatus[args.regionName]['shapeIds'] = {regionShapeNumber, regionTextNumber} 
end

function checkFuelLevels()
	local allPlayers = mist.DBs.humansByName
	for name, data in pairs(allPlayers) do
		if Unit.getByName(name) ~= nil and Unit.getByName(name):getPlayerName() ~= nil then
			if FDS.fuelLevels[name] ~= nil then
				if FDS.fuelLevels[name].fuel + FDS.refuelThreshold < Unit.getByName(name):getFuel() and Unit.getByName(name):getPosition().p.y > 0 then --3048 then
					if FDS.fuelLevels[name].ammount > FDS.refuelRepetitions then
						local _initEnt = Unit.getByName(name)
						local initCheck = pcall(FDS.playerCheck,_initEnt)
						local initCoa = 0
						local initCoaCheck = pcall(FDS.coalitionCheck,_initEnt)
						local gpUcid = FDS.retrieveUcid(_initEnt:getPlayerName(),FDS.isName)
						if initCoaCheck then
							initCoa = _initEnt:getCoalition()
						end
						if _initEnt ~= nil and _initEnt:getPlayerName() ~= nil then
							if initCheck and initCoaCheck and initCoa == 2 and _initEnt:getPlayerName() ~= nil and FDS.teamPoints.blue['Players'][_initEnt:getPlayerName()] ~= nil and FDS.teamPoints.blue['Players'][_initEnt:getPlayerName()] > 0 then
								local msgLand = {}
								local gp = _initEnt:getGroup()
								msgLand.text = 'You deliver ' .. FDS.teamPoints.blue['Players'][_initEnt:getPlayerName()] .. ' points to your team and receive ' .. FDS.teamPoints.blue['Players'][_initEnt:getPlayerName()] .. ' credits via air refuelling.'
								msgLand.displayTime = 20  
								msgLand.sound = 'Msg.ogg'
								trigger.action.outTextForGroup(gp:getID(), msgLand.text, msgLand.displayTime)
								trigger.action.outSoundForGroup(gp:getID(),msgLand.sound)
								
								-- Record land points
								recordLandPoints(_initEnt, FDS.trueCoalitionCode[initCoa])
				
								FDS.teamPoints.blue.Base = FDS.teamPoints.blue.Base + FDS.teamPoints.blue['Players'][_initEnt:getPlayerName()]
								FDS.playersCredits.blue[gpUcid] = FDS.playersCredits.blue[gpUcid] + FDS.teamPoints.blue['Players'][_initEnt:getPlayerName()]
								FDS.teamPoints.blue['Players'][_initEnt:getPlayerName()] = 0.0
								exportPlayerDataNow()
								if FDS.teamPoints.blue.Base >= FDS.callCost then 
									local bombTimes = math.floor(FDS.teamPoints.blue.Base/FDS.callCost)
									for callIt = 1, bombTimes do
										--mist.scheduleFunction(bombingRun, {'blue'},timer.getTime()+FDS.bomberMinInterval*(callIt-1))
										mist.scheduleFunction(guidedBombingRun, {'blue'},timer.getTime()+FDS.bomberMinInterval*(callIt-1))
										FDS.teamPoints.blue.Base = FDS.teamPoints.blue.Base - FDS.callCost
									end
								end
							elseif initCheck and initCoaCheck and initCoa == 1 and _initEnt:getPlayerName() ~= nil and FDS.teamPoints.red['Players'][_initEnt:getPlayerName()] ~= nil and FDS.teamPoints.red['Players'][_initEnt:getPlayerName()] > 0 then
								local msgLand = {}
								local gp = _initEnt:getGroup()
								msgLand.text = 'You deliver ' .. FDS.teamPoints.red['Players'][_initEnt:getPlayerName()] .. ' points to your team and receive ' .. FDS.teamPoints.red['Players'][_initEnt:getPlayerName()] .. ' credits via air refuelling.'
								msgLand.displayTime = 20  
								msgLand.sound = 'Msg.ogg'
								trigger.action.outTextForGroup(gp:getID(), msgLand.text, msgLand.displayTime)
								trigger.action.outSoundForGroup(gp:getID(),msgLand.sound)
				
								-- Record land points
								recordLandPoints(_initEnt, FDS.trueCoalitionCode[initCoa])
				
								FDS.teamPoints.red.Base = FDS.teamPoints.red.Base + FDS.teamPoints.red['Players'][_initEnt:getPlayerName()]
								FDS.playersCredits.red[gpUcid] = FDS.playersCredits.red[gpUcid] + FDS.teamPoints.red['Players'][_initEnt:getPlayerName()]
								FDS.teamPoints.red['Players'][_initEnt:getPlayerName()] = 0.0
								exportPlayerDataNow()
								if FDS.teamPoints.red.Base >= FDS.callCost then 
									local bombTimes = math.floor(FDS.teamPoints.red.Base/FDS.callCost)
									for callIt = 1, bombTimes do
										--mist.scheduleFunction(bombingRun, {'red'},timer.getTime()+FDS.bomberMinInterval*(callIt-1))
										mist.scheduleFunction(guidedBombingRun, {'red'},timer.getTime()+FDS.bomberMinInterval*(callIt-1))
										FDS.teamPoints.red.Base = FDS.teamPoints.red.Base - FDS.callCost
									end
								end
							end
						end
						FDS.fuelLevels[name].fuel = Unit.getByName(name):getFuel()
						local errFile = io.open(FDS.exportPath .. "airRefuelFeed.txt", "a")
						if errFile == nil then
							lfs.mkdir(FDS.exportPath)
							errFile:write(nil)
						end
						errFile:write('\n***************************************\n --- EVENT START ---\nName: ' .. _initEnt:getPlayerName() .. '\nCoalition: ' .. tostring(initCoa) .. '\nLast Fuel: ' .. tostring(FDS.fuelLevels[name].fuel) .. '\nCurrent Fuel: ' .. tostring(Unit.getByName(name):getFuel()) .. '\n')
						errFile:close()	 
					else
						FDS.fuelLevels[name].fuel = Unit.getByName(name):getFuel()
						FDS.fuelLevels[name].ammount = FDS.fuelLevels[name].ammount + 1
					end
				else
					FDS.fuelLevels[name] = {['fuel'] = Unit.getByName(name):getFuel(),['ammount'] = 0}
				end
			else
				FDS.fuelLevels[name] = {['fuel'] = Unit.getByName(name):getFuel(),['ammount'] = 0}
			end
		end
	end
end

function FDS.checkFactories(coa)
	local aFactories = 0
	for _, i in pairs(FDS.activeFactories[coa]) do
		aFactories = aFactories + 1
	end
	if aFactories < FDS.maxFactoryQuantity then
		local coaCountry = {['blue'] = 80, ['red'] = 81}
		local bornPoint = mist.getRandomPointInZone(FDS.factorySpawnZones[coa][math.random(1,#FDS.factorySpawnZones[coa])])
		local factoryType = FDS.typeFactory[land.getSurfaceType(bornPoint)]
		local height = land.getHeight({x = bornPoint["x"],y = bornPoint["z"]})
		local addO = {}
		addO.country = coaCountry[coa]
		addO.category = 3
		addO.x = bornPoint["x"]
		addO.y = bornPoint["y"]
		addO.type = factoryType
		addO.heading = math.random(0,360)
		addCP = mist.dynAddStatic(addO)
		table.insert(FDS.activeFactories[coa],{['name'] = addCP.name, ['tier'] = 1})
	end
end

function FDS.checkPlayerOnline(arg,name,online)
	local gpMsg = ""
	local activePlayerList = net.get_player_list()	
	if online == true then
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

function FDS.resuplyTroops(args)
    local troopsAround = mist.getUnitsInZones(args[2], {'redRessuplyTroops'}, 'cylinder') 
    local qty = 0
	local loadSuccesss = false
    for i,j in pairs(troopsAround) do
        qty = qty + 1
    end
    local msg = {}
    msg.displayTime = 5
    if qty > 0 then
    	msg.text = "Troops are ressuplied."
	else
        msg.text = "No troops around the helipad."
    end
    msg.sound = 'fdsTroops.ogg'
    trigger.action.outTextForGroup(args[1]:getID(),msg.text,msg.displayTime)
    trigger.action.outSoundForGroup(args[1]:getID(),msg.sound)
end

function FDS.loadCargo(gp)
	-- gp[1] = grupo, gp[2] = listname, gp[3] = quantity, gp[4] = code, gp[5] = age, gp[6] -> is recover
	local cycle = true
	local isComplete = false
	local isRecover = gp[6] or false
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
		if FDS.valuableList[tostring(gp[1]:getName())] == nil then
			FDS.valuableList[tostring(gp[1]:getName())] = {} 
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
		local insertAge = gp[5] or nil
		if (usedSlots + FDS.troopAssets[gp[2]].slots) <= FDS.heliSlots[myUni:getDesc().typeName] and (FDS.playersCredits[FDS.trueCoalitionCode[gp[1]:getCoalition()]][gpUcid] >= FDS.troopAssets[gp[2]].cost or FDS.bypassCredits or gp[6]) then
			if gp[2] == "JTAC Team" then
				table.insert(FDS.cargoList[tostring(gp[1]:getName())], {name = FDS.troopAssets[gp[2]].name, mass = totalMass, slot = FDS.troopAssets[gp[2]].slots, code = gp[4], age = insertAge, listName = gp[2]})
			else
				table.insert(FDS.cargoList[tostring(gp[1]:getName())], {name = FDS.troopAssets[gp[2]].name, mass = totalMass, slot = FDS.troopAssets[gp[2]].slots, age = insertAge, listName = gp[2]})
			end
			trigger.action.setUnitInternalCargo(myUni:getName(),totalInternalMass)
			if not gp[6] then
				FDS.playersCredits[FDS.trueCoalitionCode[gp[1]:getCoalition()]][gpUcid] = FDS.playersCredits[FDS.trueCoalitionCode[gp[1]:getCoalition()]][gpUcid] - FDS.troopAssets[gp[2]].cost
			end
			msg.text = FDS.troopAssets[gp[2]].name .. " loaded in the helicopter. It weighs " .. tostring(totalMass) .. " kg.\nTotal internal mass: " .. tostring(totalInternalMass) .. " kg. Slots Available: " .. tostring(FDS.heliSlots[myUni:getDesc().typeName] - usedSlots - 1) .. ". \nRemaining Credits: $" .. tostring(FDS.playersCredits[FDS.trueCoalitionCode[gp[1]:getCoalition()]][gpUcid])
			isComplete = true
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
	return isComplete
end

function FDS.resuplyTroops(args)
    local nameList = {}
    for _,i in pairs(args[2]) do
        table.insert(nameList, i[2])
    end
    local troopsAround = mist.getUnitsInZones(nameList, FDS.ressuplyZones[FDS.trueCoalitionCode[args[1]:getUnits()[1]:getCoalition()]], 'cylinder') 
    local qty = 0
	local loadSuccesss = false
    for i,j in pairs(troopsAround) do
        FDS.deployedUnits[FDS.trueCoalitionCode[args[1]:getUnits()[1]:getCoalition()]][j:getName()].age = 0
        qty = qty + 1
    end
    local msg = {}
    msg.displayTime = 5
    if qty > 0 then
    	msg.text = "Troops are ressuplied."
	else
        msg.text = "No troops around the helipad."
    end
    msg.sound = 'fdsTroops.ogg'
    trigger.action.outTextForGroup(args[1]:getID(),msg.text,msg.displayTime)
    trigger.action.outSoundForGroup(args[1]:getID(),msg.sound)
    return troopsAround
end

function FDS.recoverTroops(actor)
	errorLog("recoverFeed.txt", '\n***************************************\n --- EVENT START ---\n') 
    local coaDeployed = FDS.deployedUnits[FDS.trueCoalitionCode[actor:getUnits()[1]:getCoalition()]]
    local uniList = {}
    local uniListData = {}
    local actorID = FDS.retrieveUcid(actor:getUnits()[1]:getPlayerName(),FDS.isName)
    for i, j in pairs(coaDeployed) do
        if actorID == j.owner then
            table.insert(uniList, i)
            uniListData[i] = {['age'] = j.age, ['listName'] = j.groupData.listName}
        end
    end
	errorLog("recoverFeed.txt", 'Lista montada\n')
    local troopsAround = mist.getUnitsInMovingZones(uniList, {actor:getUnits()[1]:getName()},200, 'cylinder') 
    local qty = 0
	local loadSuccesss = false
    for i,j in pairs(troopsAround) do
        loadSuccesss = FDS.loadCargo({actor, uniListData[j:getName()].listName, 1, nil, uniListData[j:getName()].age,true})
        if loadSuccesss then
			Unit.getByName(j:getName()):getGroup():destroy()
		end
        qty = qty + 1
    end
	errorLog("recoverFeed.txt", 'Montando mensagem\n')
    local msg = {}
    msg.displayTime = 5
    if qty > 0 then
    	msg.text = "Troops are aboard."
	else
        msg.text = "No troops to recover."
    end
    msg.sound = 'fdsTroops.ogg'
    trigger.action.outTextForGroup(actor:getID(),msg.text,msg.displayTime)
    trigger.action.outSoundForGroup(actor:getID(),msg.sound)
	-- Clean Deploy
	mist.scheduleFunction(cleanDeployedUnits,{FDS.trueCoalitionCode[actor:getUnits()[1]:getCoalition()]},timer.getTime()+0.5)
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

function FDS.baseSpawn(args)
	local msg = {}
	local elementNumber = 1
	local numberAdjust = 0
	local usedSlots = 0
	local totalInternalMass = 0
    local allMarks = world.getMarkPanels()
	--Ref Points
	local referenceMarks = {}
    local checkMarkPoints = true
    local senderGroups = {}
	local markRef = {}
	local gpUcid = FDS.retrieveUcid(args.requester:getUnits()[1]:getPlayerName(),FDS.isName) or ''
	local navalGroundAssets = {['false'] = FDS.troopAssets, ['true'] = FDS.navalAssets}
	local listName = args.name
	if (FDS.playersCredits[FDS.trueCoalitionCode[args.requester:getCoalition()]][gpUcid] <= navalGroundAssets[args.isNaval][args.name].cost and not FDS.bypassCredits) then
		local msg = {}
		msg.displayTime = 10
		msg.sound = 'fdsTroops.ogg'		
		msg.text = "Insuficient credits."
		trigger.action.outTextForGroup(args.requester:getID(),msg.text,msg.displayTime)
		trigger.action.outSoundForGroup(args.requester:getID(),msg.sound)
		checkMarkPoints = false
	end
	if checkMarkPoints then
		for _, markData in pairs(allMarks) do
			local markNameSpeed = {}
			if args.requester:getUnits()[1]:getPlayerName() == markData.author and string.sub(markData.text, 1, 3) == 'gwp' and args.requester:getCoalition() == markData.coalition then
				if string.find(string.sub(markData.text,4), "-") ~= nil then
					for markTxt, markSpeed in string.gmatch(string.sub(markData.text, 4), "(%w+)-(%w+)") do
						markNameSpeed = {markTxt, {markSpeed, markData.pos}}
					end
				else
					markNameSpeed = {string.sub(markData.text, 4), {100,markData.pos}}
				end
				if senderGroups[tonumber(markNameSpeed[1])] == nil then
					senderGroups[tonumber(markNameSpeed[1])] = markNameSpeed[2]
				else
					local msg = {}
					msg.displayTime = 10
					msg.sound = 'fdsTroops.ogg'
					msg.text = "Two waypoints with the same number. Check your markpoints. \nThey must be created by you and named as 'gwp1', 'gwp2', 'gwp3'..."
					trigger.action.outTextForGroup(args.requester:getID(),msg.text,msg.displayTime)
					trigger.action.outSoundForGroup(args.requester:getID(),msg.sound)
					checkMarkPoints = false
				end
			end
		end
		if senderGroups[1] == nil then
			if args.requester ~= nil then
				local msg = {}
				msg.displayTime = 10
				msg.sound = 'fdsTroops.ogg'
				msg.text = "No suitable markpoints found. Check your markpoints. \nThey must be created by you and named as 'gwp1', 'gwp2', 'gwp3'..."
				trigger.action.outTextForGroup(args.requester:getID(),msg.text,msg.displayTime)
				trigger.action.outSoundForGroup(args.requester:getID(),msg.sound)
				checkMarkPoints = false
			else
				checkMarkPoints = false
			end
		end
	end
	if checkMarkPoints then
		local mockupNameCoaType = {
			[1] = {['false'] = 'Red_Base_Spawn_Mockup', ['true'] = 'Red_Naval_Spawn_Mockup'},
			[2] = {['false'] = 'Blue_Base_Spawn_Mockup', ['true'] = 'Blue_Naval_Spawn_Mockup'}
		}
		redisString = {}
		for i = 1, args.number, 1 do
			local refDropGroup = {}
			local mockUpName = mockupNameCoaType[args.requester:getCoalition()][args.isNaval]
			refDropGroup = Group.getByName(mockUpName)
			local dropPoint = refDropGroup:getUnits()[1]:getPosition().p
			referenceMarks[1] = dropPoint
			local headingDev = refDropGroup:getUnits()[1]:getPosition().x
			local adjHeading = 0
			local compz = 0
			local compx = 0
			local degreeHeading = math.atan2(headingDev.z, headingDev.x)*57.2958
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
			local mockUpName = ""
			local groupNameMock = ""
			if args.requester:getCoalition() == 1 then
				mockUpName = mockUpName .. "Red_" .. args.name .. "_Deploy"
				groupNameMock = args.name .. "_"
			elseif args.requester:getCoalition() == 2 then
				mockUpName = mockUpName .. "Blue_" .. args.name .. "_Deploy"
				groupNameMock = args.name .. "_" 
			end
			local gp = Group.getByName(mockUpName)
			local gPData = mist.getGroupData(mockUpName,true)
			local gpR = mist.getGroupRoute(mockUpName,true)
			local new_GPR = mist.utils.deepCopy(gpR)
			local new_gPData = mist.utils.deepCopy(gPData)
			new_gPData.units[1].x = dropPoint.x
			new_gPData.units[1].y = dropPoint.z
			new_gPData.units[1].heading = math.atan2(headingDev.z, headingDev.x)
			new_GPR[1].x = dropPoint.x
			new_GPR[1].y = dropPoint.z
			new_GPR[1].speed = senderGroups[1][1]
			new_GPR[1].task.params.tasks[1].params.action.params.value = 0
			local wpNumber = 0
			for _, elemento in pairs(senderGroups) do
				wpNumber = wpNumber + 1
			end
			for wpN = 1, wpNumber, 1 do
				new_GPR[wpN+1] = mist.utils.deepCopy(new_GPR[1])
				if referenceMarks[1] ~= nil and referenceMarks[2] ~= nil then
					local msg = {}
					msg.displayTime = 5
					msg.sound = 'fdsTroops.ogg'
					msg.text = "Two references not yet implemented, use only 'ref1'."
					trigger.action.outTextForGroup(args.requester:getID(),msg.text,msg.displayTime)
					trigger.action.outSoundForGroup(args.requester:getID(),msg.sound)
				elseif referenceMarks[1] ~= nil and referenceMarks[2] == nil then
					new_GPR[wpN+1].x = senderGroups[wpN][2].x - (referenceMarks[1].x - dropPoint.x)
					new_GPR[wpN+1].y = senderGroups[wpN][2].z - (referenceMarks[1].z - dropPoint.z)
				else
					new_GPR[wpN+1].x = senderGroups[wpN][2].x
					new_GPR[wpN+1].y = senderGroups[wpN][2].z					
				end
				new_GPR[wpN+1].speed = senderGroups[wpN][1]
				if wpN == wpNumber then
					new_GPR[wpN+1].task.params.tasks[1].params.action.params.value = 2
				else
					new_GPR[wpN+1].task.params.tasks[1].params.action.params.value = 0
				end
			end
			new_gPData.clone = true
			new_gPData.route = new_GPR
			local newTroop = mist.dynAdd(new_gPData)
			local navalGroundAssets = {['false'] = FDS.troopAssets, ['true'] = FDS.navalAssets}
			FDS.playersCredits[FDS.trueCoalitionCode[args.requester:getCoalition()]][gpUcid] = FDS.playersCredits[FDS.trueCoalitionCode[args.requester:getCoalition()]][gpUcid] - navalGroundAssets[args.isNaval][args.name].cost
			mist.goRoute(Group.getByName(newTroop.name), new_GPR)
			mist.scheduleFunction(mist.goRoute,{Group.getByName(newTroop.name), new_GPR},timer.getTime()+1)
			local groupNameId = 1
			local deployNameCheck = true
			while deployNameCheck do
				deployNameCheck = false
				for coalition, unitSet in pairs(FDS.deployedUnits) do
					for name, data in pairs(unitSet) do
						if data.groupData.showName ~= nil and data.owner .. data.groupData.showName == gpUcid .. groupNameMock .. tostring(groupNameId) then
							groupNameId = groupNameId + 1
							deployNameCheck = true
						end
					end
				end
			end					
			FDS.deployedUnits[FDS.trueCoalitionCode[args.requester:getCoalition()]][Group.getByName(newTroop.name):getUnits()[1]:getName()] = {['owner'] = gpUcid, ['ownerName'] = args.requester:getUnits()[1]:getPlayerName(), ['age'] = 0, ['groupData'] = {['listName'] = listName, ['mockUpName'] = mockUpName,['x'] = dropPoint.x, ['z'] = dropPoint.z, ['hz'] = headingDev.z, ['hx'] = headingDev.x, ['type'] =  navalGroundAssets[args.isNaval][args.name].type, ['coa'] = args.requester:getCoalition(), ['showName'] = groupNameMock .. tostring(groupNameId)}}
			exportCreatedUnits()
			local gpId = Group.getByName(newTroop.name)
			gpId = gpId:getUnits()[1].id_
			redisStringAdd = tostring(FDS.trueCoalitionCode[args.requester:getCoalition()])
			redisStringAdd = redisStringAdd:gsub("%s", "")
			redisStringAdd = {'createdUnitID:' .. redisStringAdd .. ':' .. deployerID .. ':' .. tostring(gpId)}
			table.insert(redisStringAdd, 'unitID')
			table.insert(redisStringAdd, tostring(gpId))
			for key, keyData in pairs(FDS.deployedUnits[FDS.trueCoalitionCode[args.requester:getCoalition()]][Group.getByName(newTroop.name):getUnits()[1]:getName()]) do
				if type(keyData) ~= 'table' then
					table.insert(redisStringAdd, key)
					table.insert(redisStringAdd, tostring(keyData))				
				else
					for key2, keyData2 in pairs(keyData) do
						table.insert(redisStringAdd, key2)
						table.insert(redisStringAdd, tostring(keyData2))							
					end
				end
			end
			table.insert(redisString, redisStringAdd)	
			msg.text = "Troops deployed.\n"
			msg.displayTime = 5
			msg.sound = 'fdsTroops.ogg'
		end
		if DFDS ~= nil then
			local replies = DFDS.client:pipeline(function(p)
				for _, values in pairs(redisString) do
					p:hset(values)
			end
			end)
		end
		trigger.action.outTextForGroup(args.requester:getID(),msg.text,msg.displayTime)
		trigger.action.outSoundForGroup(args.requester:getID(),msg.sound)
		FDS.refreshRadio(args.requester)
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
	local checkZone = true
	if not FDS.bypassAllowedZone then
		local isAllowed = mist.getUnitsInZones({args[1]:getName()},FDS.allowedZones,'cylinder')
		if #isAllowed == 0 then
			checkZone = false
		end
	end
	if checkZone then
		if #FDS.cargoList[tostring(args[1]:getName())] > 0 then
			redisString = {}
			for i = 1, iterationNumber, 1 do
				usedSlots, totalInternalMass = unpack(calculateWeight(args[1]:getUnits()[1]))
				local dropPoint = args[1]:getUnits()[1]:getPosition().p
				local headingDev = args[1]:getUnits()[1]:getPosition().x
				local adjHeading = 0
				local compz = 0
				local compx = 0
				local degreeHeading = math.atan2(headingDev.z, headingDev.x)*57.2958
				local listName = FDS.cargoList[tostring(args[1]:getName())][1].name
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
				groupNameMock = ""
				if args[1]:getCoalition() == 1 then
					local namePart = string.gsub(FDS.cargoList[tostring(args[1]:getName())][1].name, " ", "_")
					mockUpName = mockUpName .. "Red_" .. namePart .. "_Deploy"
					groupNameMock = namePart .. "_"
				elseif args[1]:getCoalition() == 2 then
					local namePart = string.gsub(FDS.cargoList[tostring(args[1]:getName())][1].name, " ", "_")
					mockUpName = mockUpName .. "Blue_" .. namePart .. "_Deploy"
					groupNameMock = namePart .. "_" 
				end
				local gp = Group.getByName(mockUpName)
				local gPData = mist.getGroupData(mockUpName,true)
				if FDS.troopAssets[listName].type == 'Artillery' then
					if args[1]:getCoalition() == 1 then
						gpR = mist.getGroupRoute("Red_Msta_Deploy",true)
					elseif args[1]:getCoalition() == 2 then
						gpR = mist.getGroupRoute("Blue_Msta_Deploy",true)
					end
				else
					gpR = mist.getGroupRoute(mockUpName,true)
				end
				local new_GPR = mist.utils.deepCopy(gpR)
				local new_gPData = mist.utils.deepCopy(gPData)
				new_gPData.units[1].x = dropPoint.x
				new_gPData.units[1].y = dropPoint.z
				new_gPData.units[1].alt = height
				new_gPData.units[1].heading = math.atan2(headingDev.z, headingDev.x)
				new_GPR[1].x = dropPoint.x
				new_GPR[1].y = dropPoint.z
				--new_GPR[2].x = dropPoint.x + headingDev.x*FDS.advanceDistance
				--new_GPR[2].y = dropPoint.z + headingDev.z*FDS.advanceDistance
				--- Artillery TGT
				if FDS.troopAssets[listName].type == 'Artillery' then
					local tgtZN = nil
					local zonasDB = mist.DBs.zonesByName
					if args[1]:getCoalition() == 1 then
						local minDist = nil
						for zoneN,zoneData in pairs(FDS.blueZones) do
							if minDist ~= nil then
								if mist.utils.get2DDist({['x'] = dropPoint.x, ['y'] = dropPoint.z},{['x'] = zonasDB[zoneData].x, ['y'] = zonasDB[zoneData].y}) < minDist then
									minDist = mist.utils.get2DDist({['x'] = dropPoint.x, ['y'] = dropPoint.z},{['x'] = zonasDB[zoneData].x, ['y'] = zonasDB[zoneData].y})
									tgtZN = zoneN
								end
							else
								minDist = mist.utils.get2DDist({['x'] = dropPoint.x, ['y'] = dropPoint.z},{['x'] = zonasDB[zoneData].x, ['y'] = zonasDB[zoneData].y})
								tgtZN = zoneN
							end
						end
					elseif args[1]:getCoalition() == 2 then
						local minDist = nil
						for zoneN,zoneData in pairs(FDS.redZones) do
							if minDist ~= nil then
								if mist.utils.get2DDist({['x'] = dropPoint.x, ['y'] = dropPoint.z},{['x'] = zonasDB[zoneData].x, ['y'] = zonasDB[zoneData].y}) < minDist then
									minDist = mist.utils.get2DDist({['x'] = dropPoint.x, ['y'] = dropPoint.z},{['x'] = zonasDB[zoneData].x, ['y'] = zonasDB[zoneData].y})
									tgtZN = zoneN
								end
							else
								minDist = mist.utils.get2DDist({['x'] = dropPoint.x, ['y'] = dropPoint.z},{['x'] = zonasDB[zoneData].x, ['y'] = zonasDB[zoneData].y})
								tgtZN = zoneN
							end
						end
					end
					for iter = 1, 1, 1 do
						for taskNumber,task in pairs(new_GPR[iter].task.params.tasks) do
							if task.name == 'Z' .. tostring(tgtZN) then
								new_GPR[iter].task.params.tasks[taskNumber].enabled = true
								new_GPR[iter].task.params.tasks[taskNumber].enabled = true
							end
						end
					end
				end
				new_gPData.clone = true
				new_gPData.route = new_GPR
				local returnZone = mist.getUnitsInZones({args[1]:getUnits()[1]:getName()},FDS.coalitionAceptZones[FDS.trueCoalitionCode[args[1]:getCoalition()]]['pick'],'cylinder')
				if #returnZone < 1 then
					local newTroop = mist.dynAdd(new_gPData)
					mist.goRoute(Group.getByName(newTroop.name), new_GPR)
					mist.scheduleFunction(mist.goRoute,{Group.getByName(newTroop.name), new_GPR},timer.getTime()+1)
					if FDS.cargoList[tostring(args[1]:getName())][1].code ~= nil then
						FDS.createJTACJeep({args[1], tostring(FDS.cargoList[tostring(args[1]:getName())][1].code), Group.getByName(newTroop.name)}) 
					end
					local massaFinal = totalInternalMass-FDS.cargoList[tostring(args[1]:getName())][1].mass
					trigger.action.setUnitInternalCargo(args[1]:getName(),massaFinal)
					deployerID = FDS.retrieveUcid(args[1]:getUnits()[1]:getPlayerName(),FDS.isName)
					local groupNameId = 1
					local deployNameCheck = true
					local uniAge = nil
					if FDS.cargoList[tostring(args[1]:getName())][1].age == nil then
						uniAge = 0
					else
						uniAge = FDS.cargoList[tostring(args[1]:getName())][1].age
					end
					local laserCode = FDS.cargoList[tostring(args[1]:getName())][1].code or nil
					FDS.deployedUnits[FDS.trueCoalitionCode[args[1]:getCoalition()]][Group.getByName(newTroop.name):getUnits()[1]:getName()] = {['owner'] = deployerID, ['ownerName'] = args[1]:getUnits()[1]:getPlayerName(), ['age'] = uniAge, ['laserCode'] = laserCode, ['groupData'] = {['mockUpName'] = mockUpName,['x'] = dropPoint.x, ['z'] = dropPoint.z, ['hz'] = headingDev.z, ['hx'] = headingDev.x, ['listName']= listName, ['type'] = FDS.troopAssets[listName].type, ['coa'] = args[1]:getCoalition(), ['showName'] = groupNameMock .. tostring(groupNameId)}}
					table.remove(FDS.cargoList[args[1]:getName()],1)
					exportCreatedUnits()
					while deployNameCheck do
						deployNameCheck = false
						for coalition, unitSet in pairs(FDS.deployedUnits) do
							for name, data in pairs(unitSet) do
								if data.groupData.showName ~= nil and  data.owner .. data.groupData.showName == deployerID .. groupNameMock .. tostring(groupNameId) then
									groupNameId = groupNameId + 1
									deployNameCheck = true
								end
							end
						end
					end	
					local gpId = Group.getByName(newTroop.name)
					gpId = gpId:getUnits()[1].id_
					redisStringAdd = tostring(FDS.trueCoalitionCode[args[1]:getCoalition()])
					redisStringAdd = redisStringAdd:gsub("%s", "")
					redisStringAdd = {'createdUnitID:' .. redisStringAdd .. ':' .. deployerID .. ':' .. tostring(gpId)}
					table.insert(redisStringAdd, 'unitID')
					table.insert(redisStringAdd, tostring(gpId))
					for key, keyData in pairs(FDS.deployedUnits[FDS.trueCoalitionCode[args[1]:getCoalition()]][Group.getByName(newTroop.name):getUnits()[1]:getName()]) do
						if type(keyData) ~= 'table' then
							table.insert(redisStringAdd, key)
							table.insert(redisStringAdd, tostring(keyData))				
						else
							for key2, keyData2 in pairs(keyData) do
								table.insert(redisStringAdd, key2)
								table.insert(redisStringAdd, tostring(keyData2))							
							end
						end
					end 
					table.insert(redisString, redisStringAdd)				
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
			if DFDS ~= nil then
				local replies = DFDS.client:pipeline(function(p)
					for _, values in pairs(redisString) do
						p:hset(values)
					end
				end)
			end
			msg.displayTime = 10
			msg.sound = 'fdsTroops.ogg'
		else
			msg.text = "No troops to drop off.\n"
			msg.displayTime = 10
			msg.sound = 'fdsTroops.ogg'
		end
	else
		msg.text = "You cannot drop troops outside the allowed zone.\n"
		msg.displayTime = 10
		msg.sound = 'fdsTroops.ogg'		
	end
	trigger.action.outTextForGroup(args[1]:getID(),msg.text,msg.displayTime)
	trigger.action.outSoundForGroup(args[1]:getID(),msg.sound)
	FDS.refreshRadio(args[1])
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
	if args.amount > 0 then
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
	else
		local msg = {}
		msg.displayTime = 5
		msg.sound = 'fdsTroops.ogg'
		msg.text = "You have no credits to transfer."
		trigger.action.outTextForGroup(args.gp:getID(),msg.text,msg.displayTime)
		trigger.action.outSoundForGroup(args.gp:getID(),msg.sound)
		FDS.refreshRadio(gp)		
	end
end

function FDS.commandGroup(args)
    local allMarks = world.getMarkPanels()
    local senderGroups = {}
	local referenceMarks = {}
    local foundWP = false
    local checkMarkPoints = true
    for _, markData in pairs(allMarks) do
        local markNameSpeed = {}
        if args.group:getUnits()[1]:getPlayerName() == markData.author and string.sub(markData.text, 1, 3) == 'gwp' and args.group:getCoalition() == markData.coalition then
            if string.find(string.sub(markData.text,4), "-") ~= nil then
                for markTxt, markSpeed in string.gmatch(string.sub(markData.text, 4), "(%w+)-(%w+)") do
                    markNameSpeed = {markTxt, {markSpeed, markData.pos}}
                end
            else
                markNameSpeed = {string.sub(markData.text, 4), {100,markData.pos}}
            end
            if senderGroups[tonumber(markNameSpeed[1])] == nil then
            	senderGroups[tonumber(markNameSpeed[1])] = markNameSpeed[2]
            else
				local msg = {}
                msg.displayTime = 10
                msg.sound = 'fdsTroops.ogg'
                msg.text = "Two waypoints with the same number. Check your markpoints. \nThey must be created by you and named as 'gwp1', 'gwp2', 'gwp3'..."
                trigger.action.outTextForGroup(args.group:getID(),msg.text,msg.displayTime)
                trigger.action.outSoundForGroup(args.group:getID(),msg.sound)
                checkMarkPoints = false
            end
        end
		local markRef = {}
		if args.showName == markData.author and string.sub(markData.text, 1, 3) == 'ref' and args.group:getCoalition() == markData.coalition then
            markRef = {string.sub(markData.text, 4), {markData.pos}}
            if referenceMarks[tonumber(markRef[1])] == nil then
            	referenceMarks[tonumber(markRef[1])] = markRef[2]
            else
				local msg = {}
                msg.displayTime = 10
                msg.sound = 'fdsTroops.ogg'
                msg.text = "Two reference points with the same number. Check your markpoints. \nThey must be created by you and named as 'ref1', and 'ref2'."
                trigger.action.outTextForGroup(args.group:getID(),msg.text,msg.displayTime)
                trigger.action.outSoundForGroup(args.group:getID(),msg.sound)
                checkMarkPoints = false
            end
        end
    end
    if senderGroups[1] == nil then
        if args.group ~= nil then
            local msg = {}
            msg.displayTime = 10
            msg.sound = 'fdsTroops.ogg'
            msg.text = "No suitable markpoints found. Check your markpoints. \nThey must be created by you and named as 'gwp1', 'gwp2', 'gwp3'..."
            trigger.action.outTextForGroup(args.group:getID(),msg.text,msg.displayTime)
            trigger.action.outSoundForGroup(args.group:getID(),msg.sound)
            checkMarkPoints = false
         else
            checkMarkPoints = false
         end
    end
	if checkMarkPoints then
		local allZones = mist.DBs.zonesByName
		local allowedZone = {}
		local forbitenZones = {}
		for zN = 1, #FDS.allowedZones, 1 do
			if allZones['droppableZone' .. tostring(zN)] ~= nil then
				local zoneData = allZones['droppableZone' .. tostring(zN)]
				allowedZone[zN] =  {zoneData.radius, zoneData.x, zoneData.y}
			end
		end
		forbitenZones[1] = {}
		for zN = 1, 4, 1 do
			if allZones['redTroopsNotAllowed_' .. tostring(zN)] ~= nil then
				local zoneData = allZones['redTroopsNotAllowed_' .. tostring(zN)]
				forbitenZones[1][zN] =  {zoneData.radius, zoneData.x, zoneData.y}
			end
		end
		forbitenZones[2] = {}
		for zN = 1, 4, 1 do
			if allZones['blueTroopsNotAllowed_' .. tostring(zN)] ~= nil then
				local zoneData = allZones['blueTroopsNotAllowed_' .. tostring(zN)]
				forbitenZones[2][zN] =  {zoneData.radius, zoneData.x, zoneData.y}
			end
		end
		for _, elementos in pairs(senderGroups) do
			local flagDropZone = {true, true, true}
			if checkMarkPoints then
				for zN = 1, #FDS.allowedZones, 1 do
					local dist = math.sqrt((elementos[2].x - allowedZone[zN][2])^2 + (elementos[2].z - allowedZone[zN][3])^2)
					if dist < allowedZone[zN][1] then
						flagDropZone[zN] = false
					end
				end
				if flagDropZone[1] and flagDropZone[2] and flagDropZone[3] and flagDropZone[4] and flagDropZone[5] then
					local msg = {}
					msg.displayTime = 5
					msg.sound = 'fdsTroops.ogg'
					msg.text = "All markpoints must be inside the deployable zone and at least 8nm away from the enemy helipad and airfield."
					trigger.action.outTextForGroup(args.group:getID(),msg.text,msg.displayTime)
					trigger.action.outSoundForGroup(args.group:getID(),msg.sound) 
					checkMarkPoints = false
				end
			end
		end
		for _, elementos in pairs(senderGroups) do
			local flagDropZone = {false, false, false, false}
			if checkMarkPoints then
				for zN = 1, 4, 1 do
					local dist = math.sqrt((elementos[2].x - forbitenZones[args.group:getCoalition()][zN][2])^2 + (elementos[2].z - forbitenZones[args.group:getCoalition()][zN][3])^2)
					if dist < forbitenZones[args.group:getCoalition()][zN][1] then
						flagDropZone[zN] = true
					end
				end
				if flagDropZone[1] or flagDropZone[2] or flagDropZone[3] or flagDropZone[4] then
					local msg = {}
					msg.displayTime = 5
					msg.sound = 'fdsTroops.ogg'
					msg.text = "All markpoints must be inside the deployable zone and at least 8nm away from the enemy helipad and airfield."
					trigger.action.outTextForGroup(args.group:getID(),msg.text,msg.displayTime)
					trigger.action.outSoundForGroup(args.group:getID(),msg.sound) 
					checkMarkPoints = false
				end
			end
		end		
	end
    if checkMarkPoints then
        if Group.getByName(args.groupName) ~= nil then
        	local gp = Group.getByName(args.groupName)
            local orderedUnit = gp:getUnits()[1]
        	local gpR = mist.getGroupRoute(args.mockName, true)
        	new_GPR = mist.utils.deepCopy(gpR)
        	new_GPR[1].x = orderedUnit:getPosition().p.x
        	new_GPR[1].y = orderedUnit:getPosition().p.z
        	new_GPR[1].speed = senderGroups[1][1]
            new_GPR[1].task.params.tasks[1].params.action.params.value = 0
            local wpNumber = 0
            for _, elemento in pairs(senderGroups) do
                wpNumber = wpNumber + 1
            end
            for wpN = 1, wpNumber, 1 do
                new_GPR[wpN+1] = mist.utils.deepCopy(new_GPR[1])
				if referenceMarks[1] ~= nil and referenceMarks[2] ~= nil then
					local msg = {}
					msg.displayTime = 5
					msg.sound = 'fdsTroops.ogg'
					msg.text = "Two references not yet implemented, use only 'ref1'."
					trigger.action.outTextForGroup(args.group:getID(),msg.text,msg.displayTime)
					trigger.action.outSoundForGroup(args.group:getID(),msg.sound)
				elseif referenceMarks[1] ~= nil and referenceMarks[2] == nil then
					new_GPR[wpN+1].x = senderGroups[wpN][2].x - (referenceMarks[1][1].x - orderedUnit:getPosition().p.x)
					new_GPR[wpN+1].y = senderGroups[wpN][2].z - (referenceMarks[1][1].z - orderedUnit:getPosition().p.z)
				else
					new_GPR[wpN+1].x = senderGroups[wpN][2].x
					new_GPR[wpN+1].y = senderGroups[wpN][2].z					
				end
                new_GPR[wpN+1].speed = senderGroups[wpN][1]
                if wpN == wpNumber then
                	new_GPR[wpN+1].task.params.tasks[1].params.action.params.value = 2
                else
                    new_GPR[wpN+1].task.params.tasks[1].params.action.params.value = 0
                end
            end
            mist.goRoute(gp, new_GPR)
            local msg = {}
            msg.displayTime = 5
            msg.sound = 'Jtac.ogg'
            msg.text = "Orders received."
            trigger.action.outTextForGroup(args.group:getID(),msg.text,msg.displayTime)
            trigger.action.outSoundForGroup(args.group:getID(),msg.sound) 
        else
            local msg = {}
            msg.displayTime = 5
            msg.sound = 'fdsTroops.ogg'
            msg.text = "This troop doesn't exist anymore."
            trigger.action.outTextForGroup(args.group:getID(),msg.text,msg.displayTime)
            trigger.action.outSoundForGroup(args.group:getID(),msg.sound)            
        end
        return new_GPR
    end
end

function FDS.refreshRadio(gp)
    pcall(missionCommands.removeItemForGroup,mist.DBs.humansByName[gp:getName()]['groupId'],'Current War Status')
    mist.scheduleFunction(missionCommands.addCommandForGroup,{mist.DBs.humansByName[gp:getName()]['groupId'],'Current War Status',nil, FDS.warStatus, {gp.id_, gp:getCoalition(), gp:getUnits()[1]:getPlayerName()}},timer.getTime()+FDS.wtime)
    mist.scheduleFunction(missionCommands.addCommandForGroup,{mist.DBs.humansByName[gp:getName()]['groupId'],'Where to Attack',nil, FDS.whereStrike, {gp.id_, gp:getCoalition(), gp:getName()}},timer.getTime()+FDS.wtime)
    mist.scheduleFunction(missionCommands.addCommandForGroup,{mist.DBs.humansByName[gp:getName()]['groupId'],'Where to Defend',nil, FDS.whereDefend, {gp.id_, gp:getCoalition(), gp:getName()}},timer.getTime()+FDS.wtime)
    mist.scheduleFunction(missionCommands.addCommandForGroup,{mist.DBs.humansByName[gp:getName()]['groupId'],'Drop Zones',nil, FDS.whereDropZones, {gp.id_, gp:getCoalition(), gp:getName()}},timer.getTime()+FDS.wtime)
	--mist.scheduleFunction(missionCommands.addCommandForGroup,{mist.DBs.humansByName[gp:getName()]['groupId'],'JTAC Status',nil, FDS.jtacStatus, {gp.id_, gp:getCoalition(), gp:getName()}},timer.getTime()+FDS.wtime)
	FDS.addCreditsOptions(gp)
	FDS.addJtacOption(gp)
	FDS.addTroopManagement(gp)
end

function FDS.addJtacOption(gp)
	local rootJtacs = missionCommands.addSubMenuForGroup(gp:getID(), "Jtac Status")
	-- Transfer Cretids
	missionCommands.addCommandForGroup(gp:getID(), 'Refresh JTAC IDs', rootJtacs, FDS.refreshRadio, gp)
	missionCommands.addCommandForGroup(gp:getID(), 'General Summary', rootJtacs, FDS.jtacSummary, {gp.id_, gp:getCoalition(), gp:getName()})
	local contactsNumber = 2
    for jtacName, jtacData in pairs(FDS.allJtacs[FDS.trueCoalitionCode[gp:getCoalition()]]) do
		if contactsNumber%8 == 0 then
			rootJtacs = missionCommands.addSubMenuForGroup(gp:getID(), "More", rootJtacs)
			contactsNumber = contactsNumber + 1
		else
			missionCommands.addCommandForGroup(gp:getID(), 'JTAC ' .. tostring(FDS.allJtacs[FDS.trueCoalitionCode[gp:getCoalition()]][jtacName].jtacID), rootJtacs, FDS.jtacStatus, {gp.id_, gp:getCoalition(), jtacName, gp})
			contactsNumber = contactsNumber + 1
		end
    end
end

function FDS.troopStatus(gp)
	local gpUcid = FDS.retrieveUcid(gp:getUnits()[1]:getPlayerName(),FDS.isName)
	local unitsUnderMyCommand = {}
	local unitNumber = 0
	local msg = {}
	for name, data in pairs(FDS.deployedUnits[FDS.trueCoalitionCode[gp:getCoalition()]]) do
		table.insert(unitsUnderMyCommand, {data.ownerName .. '_' .. data.groupData.showName, data.age})
		unitNumber = unitNumber + 1
	end
	local unitsUnderMyCommandByType = {}
	for _, gName in pairs(unitsUnderMyCommand) do
		if unitsUnderMyCommandByType[gName[1]] ~= nil then 
			table.insert(unitsUnderMyCommandByType[gName[1]],gName)
		else
			unitsUnderMyCommandByType[gName[1]] = {gName}
		end
	end
	msg.displayTime = 10
	msg.sound = 'fdsTroops.ogg'
	msg.text = "Active troops:\nUnit name ----- Restarts so far / Maximum allowed\n"
    local gpUcid = FDS.retrieveUcid(gp:getUnits()[1]:getPlayerName(),FDS.isName)
	for name, data in pairs(FDS.deployedUnits[FDS.trueCoalitionCode[gp:getCoalition()]]) do
		if data.groupData.type ~= 'Air' and gpUcid == data.owner then 
			msg.text = msg.text .. data.ownerName .. '_' .. data.groupData.showName .. ' : ' .. data.age .. ' / ' .. FDS.unitLifeSpan .. '\n'
		end
	end
	trigger.action.outTextForGroup(gp:getID(),msg.text,msg.displayTime)
	trigger.action.outSoundForGroup(gp:getID(),msg.sound) 	
end

function FDS.ordersToSet(args)
	for _, gName in pairs(args[2]) do
		FDS.commandGroup({['group'] = args[1], ['groupName'] = Unit.getByName(gName[2]):getGroup():getName(), ['showName'] = gName[3], ['mockName'] = gName[4]})
	end
end

function FDS.addTroopManagement(gp)
	local gpUcid = FDS.retrieveUcid(gp:getUnits()[1]:getPlayerName(),FDS.isName)
	local unitsUnderMyCommand = {}
	local unitNumber = 0
	for name, data in pairs(FDS.deployedUnits[FDS.trueCoalitionCode[gp:getCoalition()]]) do
		if data.groupData.type ~= 'Air' and data.owner == gpUcid then 
			table.insert(unitsUnderMyCommand, {data.ownerName .. '_' .. data.groupData.showName, name, data.ownerName, data.groupData.mockUpName, data.groupData.type})
			unitNumber = unitNumber + 1
		end
	end
	local rootTroopMan = missionCommands.addSubMenuForGroup(gp:getID(), "Command my troops")
	missionCommands.addCommandForGroup(gp:getID(), 'Refresh Troops', rootTroopMan, FDS.refreshRadio, gp)
	missionCommands.addCommandForGroup(gp:getID(), 'Troop Status', rootTroopMan, FDS.troopStatus, gp)
	missionCommands.addCommandForGroup(gp:getID(), 'Resuply Troops', rootTroopMan, FDS.resuplyTroops, {gp, unitsUnderMyCommand})
	--missionCommands.addCommandForGroup(gp:getID(), 'Command to all', rootTroopMan, FDS.ordersToSet, {gp, unitsUnderMyCommand})
	local unitsUnderMyCommandByType = {}
	for _, gName in pairs(unitsUnderMyCommand) do
		if unitsUnderMyCommandByType[gName[5]] ~= nil then 
			table.insert(unitsUnderMyCommandByType[gName[5]],gName)
		else
			unitsUnderMyCommandByType[gName[5]] = {gName}
		end
	end
	for gTypeName, gTypeElements in pairs(unitsUnderMyCommandByType) do
		local rootTroopType = missionCommands.addSubMenuForGroup(gp:getID(), gTypeName, rootTroopMan)
		local elementQty = 1
		missionCommands.addCommandForGroup(gp:getID(), 'Command to all ' .. gTypeName, rootTroopType, FDS.ordersToSet, {gp, gTypeElements})
		for _, gName in pairs(gTypeElements) do
			if elementQty%8 == 0 then
				rootTroopType = missionCommands.addSubMenuForGroup(gp:getID(), "More", rootTroopType)
				elementQty = elementQty + 1
			else
				missionCommands.addCommandForGroup(gp:getID(), gName[1], rootTroopType, FDS.commandGroup, {['group'] = gp, ['groupName'] = Unit.getByName(gName[2]):getGroup():getName(), ['showName'] = gName[3], ['mockName'] = gName[4]})
				elementQty = elementQty + 1
			end
		end
	end
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
				missionCommands.addCommandForGroup(gp:getID(), 'All' , sendTo, FDS.transferNow, {['gp'] = gp, ['gpCoa'] = gpCoa, ['sender'] = gpPlayerName, ['amount'] = FDS.playersCredits[FDS.trueCoalitionCode[gpCoa]][FDS.alliedList[FDS.trueCoalitionCode[gpCoa]][gpPlayerName]], ['receiver'] = playerName})
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
		elseif i.name == "E-2D AWACS" then
			if FDS.awacsMode == 'buyable' then
				missionCommands.addCommandForGroup(gp:getID(), i.name .. " - ($" .. tostring(i.cost) .. ")", rootAirSupport, buyAwacs, {gp, i.name})
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
		local rootTroops = missionCommands.addSubMenuForGroup(gp:getID(), "Transport", rootCredits)
		local jtacTT = ''
		for _, aType in pairs(FDS.transportTypes) do
			local rootType = missionCommands.addSubMenuForGroup(gp:getID(), aType, rootTroops) 
			for _, i in pairs(FDS.troopAssetsNumbered) do
				if aType == i.type then
					if i.name == "JTAC Team" then
						jtacTT = missionCommands.addSubMenuForGroup(gp:getID(), i.name .. " - ($" .. tostring(i.cost) .. ")", rootType)
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
						local troopType = missionCommands.addSubMenuForGroup(gp:getID(), i.name .. " - ($".. i.cost ..")", rootType)
						for j=1,10,1 do  
							missionCommands.addCommandForGroup(gp:getID(), "Quantity: " .. tostring(j), troopType, FDS.validateDropBoard, {['rawData'] = {gp, i.name, j}, ['dropCase'] = FDS.loadCargo, ['dropCaseString'] = 'loadCargo'})
						end
					end
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
		missionCommands.addCommandForGroup(gp:getID(), "Recover troops", cargoRoot, FDS.recoverTroops, gp)
	end
	-- Troop Base Spawn
	local rootTroops = missionCommands.addSubMenuForGroup(gp:getID(), "Base Spawn", rootCredits)
	local jtacTT = ''
	for _, aType in pairs(FDS.transportTypes) do
		local rootType = missionCommands.addSubMenuForGroup(gp:getID(), aType, rootTroops) 
		for _, i in pairs(FDS.troopAssetsNumbered) do
			if aType == i.type then
				if i.name == "JTAC Team" or i.name == 'EWR' or i.name == "Mortar" then
					-- jtacTT = missionCommands.addSubMenuForGroup(gp:getID(), i.name .. " - ($" .. tostring(i.cost) .. ")", rootType)
					-- for label, code in pairs(FDS.laserCodes) do
					-- 	missionCommands.addCommandForGroup(gp:getID(), "Laser code: " .. code .. " (" .. label .. ")", jtacTT, FDS.baseSpawn, {['requester'] = gp, ['number'] = 1, ['name'] = i.name, ['code'] = code})
					-- end
					-- jtacTTCustom = missionCommands.addSubMenuForGroup(gp:getID(), "Custom laser code: 1", jtacTT)
					-- for _, digit in pairs(FDS.validLaserDigits[1]) do
					-- 	jtacTTCustomDigit1 = missionCommands.addSubMenuForGroup(gp:getID(), digit, jtacTTCustom)
					-- 	for _, digit2 in pairs(FDS.validLaserDigits[2]) do
					-- 		jtacTTCustomDigit2 = missionCommands.addSubMenuForGroup(gp:getID(), digit2, jtacTTCustomDigit1)
					-- 		for _, digit3 in pairs(FDS.validLaserDigits[3]) do
					-- 			missionCommands.addCommandForGroup(gp:getID(), digit3, jtacTTCustomDigit2, FDS.baseSpawn, {['requester'] = gp, ['number'] = j, ['name'] = i.name, ['code'] = '1' .. digit .. digit2 .. digit3})
					-- 		end
					-- 	end
					-- end
				else
					local troopType = missionCommands.addSubMenuForGroup(gp:getID(), i.name .. " - ($".. i.cost ..")", rootType)
					for j=1,10,1 do  
						missionCommands.addCommandForGroup(gp:getID(), "Quantity: " .. tostring(j), troopType, FDS.baseSpawn, {['requester'] = gp, ['number'] = j, ['name'] = i.name, ['isNaval'] = 'false'})
					end
				end
			end
		end
	end
	-- Naval Spawn
	local rootNaval = missionCommands.addSubMenuForGroup(gp:getID(), "Naval Spawn", rootCredits)
	for _, i in pairs(FDS.navalAssetsNumbered) do
		local troopType = missionCommands.addSubMenuForGroup(gp:getID(), i.name .. " - ($".. i.cost ..")", rootNaval)
		for j=1,10,1 do  
			missionCommands.addCommandForGroup(gp:getID(), "Quantity: " .. tostring(j), troopType, FDS.baseSpawn, {['requester'] = gp, ['number'] = j, ['name'] = i.name, ['isNaval'] = 'true'})
		end
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
        ['Paratrooper AKS-74'] = {FDS.InfAK,'Inf_AK'}, 
        ['Paratrooper RPG-16'] = {FDS.InfRPG,'Inf_RPG'},
        ['Ural-4320T'] = {FDS.ArmTrucks,'STrucks'}, 
        ['BMP-1'] = {FDS.ArmBMP1,'Arm_BMP1'}, 
        ['BMP-2'] = {FDS.ArmBMP2,'Arm_BMP2'}, 
        ['T-55'] = {FDS.ArmT55,'Arm_T55'} , 
        ['T-72B'] = {FDS.ArmT72,'Arm_T72'}, 
        ['T-80UD'] = {FDS.ArmT80,'Arm_T80'} , 
        ['ZSU-23-4 Shilka'] = {FDS.AAA,'AAA'}, 
        ['2S6 Tunguska'] = {FDS.AATung,'AA_Tung'}, 
        ['Strela-1 9P31'] = {FDS.AAStrela1,'AA_Strela1'}, 
        ['Strela-10M3'] = {FDS.AAStrela2,'AA_Strela2'}, 
        ['SA-18 Igla-S manpad'] = {FDS.AAIgla,'AA_Igla'},
    	['Tor 9A331'] = {FDS.AATor,'AA_Tor'}}
    
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

	FDS.markUpNumber = FDS.markUpNumber + 1
	trigger.action.textToAll(-1, FDS.markUpNumber, trigger.misc.getZone('cZone_1').point, {1, 1, 1, 1} , {1, 1, 1, 0.0} , 20, true , 'Capturable FARP: Neutral' )
	FDS.farpTextID = FDS.markUpNumber

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
					FDS.addJtacOption(gp)
					FDS.addTroopManagement(gp)
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
					--mist.scheduleFunction(missionCommands.addCommandForGroup,{gpId,'JTAC Status',nil, FDS.jtacStatus, {gpId, gpCoa, gpName}},timer.getTime()+FDS.wtime)
					FDS.addCreditsOptions(gp)
					FDS.addJtacOption(gp)
					FDS.addTroopManagement(gp)
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
            for unitNumber = 0,qt[1],1 do
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
					local mockName = ''
					if cc == 1 then
						mockName = 'Blue_' .. qt[2]
					else
						mockName = 'Red_' .. qt[2]
					end
					-- Strap
					local gp = Group.getByName(mockName)
					local gPData = mist.getGroupData(mockName,true)
					local gpR = mist.getGroupRoute(gp:getName(),true)
					local addUnit_gp = mist.utils.deepCopy(gpR)
					local addUnit = mist.utils.deepCopy(gPData)
					--
					--addUnit.x = bornPoint.x
					--addUnit.y = bornPoint.y
					--addUnit.type = unc
					--addUnit.skill = 'Ace'
					--addUnit.heading = math.random(0.0,359.0)

					--allUnits = {}
					--table.insert(allUnits,addUnit)

					addO = addUnit
					--addO = {}
					--addO.units = allUnits
					addO.country = cc
					addO.category = 2
					addO.visible = true
					addO.clone = true
					addO.units[1].x = bornPoint.x
					addO.units[1].y = bornPoint.y
					addO.units[1].heading =  math.random(0.0,359.0)
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
	-- Data to sent to redis
	local redisString = {}
	for coalition, zone in pairs(FDS.initTgtObj) do
		for zoneName, unitName in pairs(zone) do
			local iter = 1
			redisStringAdd = tostring(zoneName)
			redisStringAdd = {redisStringAdd:gsub("%s", "")}
			redisStringAdd = {'idTablesZones:'..redisStringAdd[1]}
			for _, set in pairs(unitName) do
				local gpId = StaticObject.getByName(set[1]) or Group.getByName(set[1])
				if gpId:getCategory() ~= 3 then
					gpId = gpId:getUnits()[1].id_
				else
					gpId = gpId.id_
				end
				table.insert(redisStringAdd, tostring(iter))
				table.insert(redisStringAdd, tostring(gpId))
				iter = iter + 1
			end
			table.insert(redisString, redisStringAdd)
		end
	end
	if DFDS ~= nil then
		local replies = DFDS.client:pipeline(function(p)
			for _, values in pairs(redisString) do
				p:hset(values)
			end
		end)
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

function cleanPoints()
    for team, data in pairs(FDS.teamPoints) do
        for name, points in pairs(data["Players"]) do
            local gpUcid = FDS.retrieveUcid(name,FDS.isName)
            if gpUcid ~= nil and points ~= nil then
				if FDS.playersCredits[team][gpUcid] ~= nil then
					FDS.playersCredits[team][gpUcid] = FDS.playersCredits[team][gpUcid] + points
					FDS.teamPoints[team]["Players"][name] = 0
				else
					FDS.playersCredits[team][gpUcid] = points
					FDS.teamPoints[team]["Players"][name] = 0
				end
            end
        end
    end
end

-- Exporting created units
function exportCreatedUnits()
	if FDS.exportPlayerUnits then
		local file = io.open(FDS.exportPath .. "playerUnits.json", "w")
		if file == nil then
			lfs.mkdir(FDS.exportPath)
			file:write(nil)
		end
		local playerUnitsExport = {['blue'] = {}, ['red'] = {}}
		for team,units in pairs(FDS.deployedUnits) do
			for index, unitData in pairs(units) do
				if Unit.getByName(index) ~= nil and Unit.getByName(index):isExist() and unitData.groupData ~= nil and unitData.age < FDS.unitLifeSpan and unitData.groupData.type ~= 'Air' then
					local placedUnit = Unit.getByName(index)
					unitData.groupData.x = placedUnit:getPosition().p.x
					unitData.groupData.z = placedUnit:getPosition().p.z
					playerUnitsExport[team][index] = unitData
				end  
			end
		end
		jsonExport = net.lua2json(playerUnitsExport)
		file:write(jsonExport)
		file:close()
	end
end

-- Export region status
function exportRegionsData()
	if FDS.exportRegionsData then
		local file = io.open(FDS.exportPath .. "regionsData.json", "w")
		if file == nil then
			lfs.mkdir(FDS.exportPath)
			file:write(nil)
		end
		local regionDataExport = FDS.regionStatus
		jsonExport = net.lua2json(regionDataExport)
		file:write(jsonExport)
		file:close()
	end
end

function exportPlayerDataNow()
	if FDS.exportPlayerData then
		local file = io.open(FDS.exportPath .. "playerData.json", "w")
		if file == nil then
			lfs.mkdir(FDS.exportPath)
			file:write(nil)
		end
		local playerDataExport = {['blue'] = {}, ['red'] = {}}
		for team,players in pairs(FDS.playersCredits) do
			for playerName, playerData in pairs(players) do
				playerDataExport[team][playerName] = playerData
			end
		end
		jsonExport = net.lua2json(playerDataExport)
		file:write(jsonExport)
		file:close()
	end
end

function importPlayerDataNow()
	if FDS.exportPlayerData then
		local file = io.open(FDS.exportPath .. "playerData.json", "r")
		if file ~= nil then
			importedUnits = file:read "*a"
			importedUnits = net.json2lua(importedUnits)
			file:close()
            local playerDataExport = {['blue'] = {}, ['red'] = {}}
			for team,players in pairs(importedUnits) do
				for playerName, playerData in pairs(players) do
                	if playerData > FDS.fixedImportValue then
                    	playerData = playerData - FDS.fixedImportValue
                    	if playerData > FDS.taxFreeValue[1] then
                        	playerDataExport[team][playerName] = FDS.taxFreeValue[1]
                        	playerData = playerData - FDS.taxFreeValue[1]
                        	playerDataExport[team][playerName] = playerDataExport[team][playerName] + math.floor(playerData*FDS.importTax[1])
                            --ping(tostring(playerDataExport[team][playerName]))
                    	else
                        	playerDataExport[team][playerName] = playerData
                    	end
                	else
                    	playerDataExport[team][playerName] = 0
                	end
				end
			end
            FDS.playersCredits = playerDataExport
		end
	end
end

function importRegionsDataNow()
	if FDS.exportPlayerData then
		local file = io.open(FDS.exportPath .. "regionsData.json", "r")
		if file ~= nil then
			importedData = file:read "*a"
			importedData = net.json2lua(importedData)
			file:close()
			for _, zoneName in pairs(FDS.contestedRegions) do
				if importedData[zoneName] ~= nil then
            		FDS.regionStatus[zoneName] = importedData[zoneName]
				end
			end
		end
	end
end

function importPlayerUnits()
	if FDS.exportPlayerUnits then
		local file = io.open(FDS.exportPath .. "playerUnits.json", "r")
		if file ~= nil then
			importedUnits = file:read "*a"
			importedUnits = net.json2lua(importedUnits)
			file:close()
			local redisString = {}
			for team, unit in pairs(importedUnits) do
				for name, data in pairs(unit) do
					local updateAge = data.age + 1
					local gp = Group.getByName(data.groupData.mockUpName)
					local gPData = mist.getGroupData(data.groupData.mockUpName,true)
					local gpR = mist.getGroupRoute(data.groupData.mockUpName,true)
					local new_GPR = mist.utils.deepCopy(gpR)
					local new_gPData = mist.utils.deepCopy(gPData)
					new_gPData.units[1].x = data.groupData.x
					new_gPData.units[1].y = data.groupData.z
					new_gPData.units[1].alt = land.getHeight({x = data.groupData.x, y = data.groupData.z})
					new_gPData.units[1].heading = math.atan2(data.groupData.hz, data.groupData.hx)
					new_GPR[1].x = data.groupData.x
					new_GPR[1].y = data.groupData.z
					--new_GPR[2].x = data.groupData.x + data.groupData.hx*FDS.advanceDistance
					--new_GPR[2].y = data.groupData.z + data.groupData.hz*FDS.advanceDistance
					if data.groupData.type == 'Artillery' then
						local tgtZN = nil
						local zonasDB = mist.DBs.zonesByName
						if data.groupData.coa == 1 then
							local minDist = nil
							for zoneN,zoneData in pairs(FDS.blueZones) do
								if minDist ~= nil then
									if mist.utils.get2DDist({['x'] = data.groupData.x, ['y'] = data.groupData.z},{['x'] = zonasDB[zoneData].x, ['y'] = zonasDB[zoneData].y}) < minDist then
										minDist = mist.utils.get2DDist({['x'] = data.groupData.x, ['y'] = data.groupData.z},{['x'] = zonasDB[zoneData].x, ['y'] = zonasDB[zoneData].y})
										tgtZN = zoneN
									end
								else
									minDist = mist.utils.get2DDist({['x'] = data.groupData.x, ['y'] = data.groupData.z},{['x'] = zonasDB[zoneData].x, ['y'] = zonasDB[zoneData].y})
									tgtZN = zoneN
								end
							end
						elseif data.groupData.coa == 2 then
							local minDist = nil
							for zoneN,zoneData in pairs(FDS.redZones) do
								if minDist ~= nil then
									if mist.utils.get2DDist({['x'] = data.groupData.x, ['y'] = data.groupData.z},{['x'] = zonasDB[zoneData].x, ['y'] = zonasDB[zoneData].y}) < minDist then
										minDist = mist.utils.get2DDist({['x'] = data.groupData.x, ['y'] = data.groupData.z},{['x'] = zonasDB[zoneData].x, ['y'] = zonasDB[zoneData].y})
										tgtZN = zoneN
									end
								else
									minDist = mist.utils.get2DDist({['x'] = data.groupData.x, ['y'] = data.groupData.z},{['x'] = zonasDB[zoneData].x, ['y'] = zonasDB[zoneData].y})
									tgtZN = zoneN
								end
							end
						end
						for iter = 1, 1, 1 do
							for taskNumber,task in pairs(new_GPR[iter].task.params.tasks) do
								if task.name == 'Z' .. tostring(tgtZN) then
									new_GPR[iter].task.params.tasks[taskNumber].enabled = true
									new_GPR[iter].task.params.tasks[taskNumber].enabled = true
								end
							end
						end
					end
					new_gPData.clone = true
					new_gPData.route = new_GPR
					local newTroop = mist.dynAdd(new_gPData)
					mist.goRoute(Group.getByName(newTroop.name), new_GPR)
					mist.scheduleFunction(mist.goRoute,{Group.getByName(newTroop.name), new_GPR},timer.getTime()+1)
					FDS.deployedUnits[team][Group.getByName(newTroop.name):getUnits()[1]:getName()] = {['owner'] = data.owner, ['ownerName'] = data.ownerName, ['age'] = updateAge, ['groupData'] = {['mockUpName'] = data.groupData.mockUpName,['x'] = data.groupData.x, ['z'] = data.groupData.z, ['hz'] = data.groupData.hz, ['hx'] = data.groupData.hx, ['type'] = data.groupData.type, ['coa'] = data.groupData.coa, ['showName'] = data.groupData.showName, ['listName'] = data.groupData.listName}}
					local gpId = Group.getByName(newTroop.name)
					gpId = gpId:getUnits()[1].id_
					redisStringAdd = tostring(team)
					redisStringAdd = redisStringAdd:gsub("%s", "")
					redisStringAdd = {'createdUnitID:' .. redisStringAdd .. ':' .. data.owner .. ':' .. tostring(gpId)}
					table.insert(redisStringAdd, 'unitID')
					table.insert(redisStringAdd, tostring(gpId))
					for key, keyData in pairs(FDS.deployedUnits[team][Group.getByName(newTroop.name):getUnits()[1]:getName()]) do
						if type(keyData) ~= 'table' then
							table.insert(redisStringAdd, key)
							table.insert(redisStringAdd, tostring(keyData))				
						else
							for key2, keyData2 in pairs(keyData) do
								table.insert(redisStringAdd, key2)
								table.insert(redisStringAdd, tostring(keyData2))							
							end
						end
					end 
					table.insert(redisString, redisStringAdd)	
				end
			end
			if DFDS ~= nil then
				local replies = DFDS.client:pipeline(function(p)
					for _, values in pairs(redisString) do
						p:hset(values)
					end
				end)
			end
		end
	end
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

function FDS.createJTACJeep(args)
	local msg = {}
	msg.displayTime = 10
	local deployerID = FDS.retrieveUcid(args[1]:getUnits()[1]:getPlayerName(),FDS.isName)
	if FDS.playersCredits[FDS.trueCoalitionCode[args[1]:getCoalition()]][deployerID] >= FDS.troopAssets["JTAC Team"].cost or FDS.bypassCredits then
		FDS.playersCredits[FDS.trueCoalitionCode[args[1]:getCoalition()]][deployerID] = FDS.playersCredits[FDS.trueCoalitionCode[args[1]:getCoalition()]][deployerID] - FDS.troopAssets["JTAC Team"].cost
		local point3 = args[1]:getUnits()[1]:getPosition().p
		local goodDist = true
		for key, jtac in pairs(FDS.allJtacs[FDS.trueCoalitionCode[args[1]:getCoalition()]]) do
			if args[3] == jtac.code and math.sqrt((point3.x - jtac.position[1])^2 + (point3.z - jtac.position[2])^2 + (heightD - jtac.position[3])^2) < FDS.maxJTACRange*1852*2 then
				goodDist = false
			end
		end
		if goodDist then
			local mockUpName = ''
			local circleColor1 = {}
			local circleColor2 = {}
			local textColor1 = {}
			local textColor2 = {}
			if args[1]:getCoalition() == 1 then
				mockUpName = "Red_JTAC_Team_Deploy"
				circleColor1 = {1, 0, 0, 0.75}
				circleColor2 = {0.3, 0, 0.0, 0.25}
				textColor1 = {1, 0, 0, 1}
				textColor2 = {0, 0, 0, 0}
			elseif args[1]:getCoalition() == 2 then
				mockUpName = "Blue_JTAC_Team_Deploy"
				circleColor1 = {0, 0, 1, 0.85}
				circleColor2 = {0, 0, 0.3, 0.15}
				textColor1 = {0, 0, 1, 1}
				textColor2 = {0, 0, 0, 0}
			end
			local deployerID = FDS.retrieveUcid(args[1]:getUnits()[1]:getPlayerName(),FDS.isName)
			FDS.markUpNumber = FDS.markUpNumber + 1
			trigger.action.circleToAll(args[1]:getCoalition() , FDS.markUpNumber, point3, FDS.maxJTACRange*1852 , circleColor1 , circleColor2 , 3 , true)
			local circleNumber = FDS.markUpNumber
			FDS.markUpNumber = FDS.markUpNumber + 1
			FDS.jtacID = FDS.jtacID + 1
			trigger.action.textToAll(args[1]:getCoalition(), FDS.markUpNumber, point3, textColor1 , textColor2 , 20, true , 'Ground JTAC ' .. tostring(FDS.jtacID) ..' laser code: ' .. tostring(args[2]))
			local textNumber = FDS.markUpNumber
			FDS.allJtacs[FDS.trueCoalitionCode[args[1]:getCoalition()]][args[3]:getName()] = {['owner'] = deployerID, ['coalition'] = args[1]:getCoalition(), ['group'] = args[3], ['drawId'] = {circleNumber, textNumber}, ['position'] = {point3.x, point3.z, point3.y}, ['status'] = 'searching', ['sight'] = {}, ['target'] = nil, ['jtacID'] = FDS.jtacID, ['code'] = args[2], ['laserSpot'] = nil}
			msg.text = 'JTAC created.'
			msg.sound = 'fdsTroops.ogg'
		else
			msg.text = 'You are too close from another JTAC with the same laser code.'
			msg.sound = 'fdsTroops.ogg'
		end
	else
		msg.text = 'Insuficient credits.'
		msg.sound = 'fdsTroops.ogg'
	end
	trigger.action.outTextForGroup(args[1]:getID(), msg.text, msg.displayTime)
	trigger.action.outSoundForGroup(args[1]:getID(),msg.sound)
end

function FDS.createJTACDrone(args)
	local msg = {}
	msg.displayTime = 10
	local deployerID = FDS.retrieveUcid(args[1]:getUnits()[1]:getPlayerName(),FDS.isName)
	if FDS.playersCredits[FDS.trueCoalitionCode[args[1]:getCoalition()]][deployerID] >= FDS.airSupportAssetsKeys[args[2]].cost or FDS.bypassCredits then
		FDS.playersCredits[FDS.trueCoalitionCode[args[1]:getCoalition()]][deployerID] = FDS.playersCredits[FDS.trueCoalitionCode[args[1]:getCoalition()]][deployerID] - FDS.airSupportAssetsKeys[args[2]].cost
		local point3 = args[1]:getUnits()[1]:getPosition().p
		local heightD = ''
		if point3.y/0.3048 > FDS.minAltitude then
			heightD = point3.y/0.3048
		else
			heightD = mist.random(100)
			local variation = (FDS.maxAltitude - FDS.minAltitude)/100
			heightD = (11000 + 100*heightD)*0.3048
		end
		local goodDist = true
		for key, jtac in pairs(FDS.allJtacs[FDS.trueCoalitionCode[args[1]:getCoalition()]]) do
			if args[3] == jtac.code and math.sqrt((point3.x - jtac.position[1])^2 + (point3.z - jtac.position[2])^2 + (heightD - jtac.position[3])^2) < FDS.maxJTACRange*1852*2 then
				goodDist = false
			end
		end
		if goodDist then
			local mockUpName = ''
			local circleColor1 = {}
			local circleColor2 = {}
			local textColor1 = {}
			local textColor2 = {}
			if args[1]:getCoalition() == 1 then
				mockUpName = "Red_Spy_Drone"
				circleColor1 = {1, 0, 0, 0.75}
				circleColor2 = {0.3, 0, 0.0, 0.25}
				textColor1 = {1, 0, 0, 1}
				textColor2 = {0, 0, 0, 0}
			elseif args[1]:getCoalition() == 2 then
				mockUpName = "Blue_Spy_Drone"
				circleColor1 = {0, 0, 1, 0.75}
				circleColor2 = {0, 0, 0.3, 0.25}
				textColor1 = {0, 0, 1, 1}
				textColor2 = {0, 0, 0, 0}
			end
			local gp = Group.getByName(mockUpName)
			local gPData = mist.getGroupData(mockUpName,true)
			local gpR = mist.getGroupRoute(gp:getName(),true)
			local new_GPR = mist.utils.deepCopy(gpR)
			local new_gPData = mist.utils.deepCopy(gPData)
			new_gPData.units[1].x = point3.x
			new_gPData.units[1].y = point3.z
			new_gPData.units[1].alt = heightD
			new_GPR[1].task.params.tasks[7].params.altitude = heightD
			new_GPR[1].x = point3.x
			new_GPR[1].y = point3.z
			new_gPData.clone = true
			new_gPData.route = new_GPR
			local newDrone = mist.dynAdd(new_gPData)
			local deployerID = FDS.retrieveUcid(args[1]:getUnits()[1]:getPlayerName(),FDS.isName)
			FDS.markUpNumber = FDS.markUpNumber + 1
			trigger.action.circleToAll(args[1]:getCoalition() , FDS.markUpNumber, point3, FDS.maxJTACRange*1852 , circleColor1 , circleColor2 , 2 , true)
			local circleNumber = FDS.markUpNumber
			FDS.markUpNumber = FDS.markUpNumber + 1
			FDS.jtacID = FDS.jtacID + 1
			trigger.action.textToAll(args[1]:getCoalition(), FDS.markUpNumber, point3, textColor1 , textColor2 , 20, true , 'JTAC ' .. tostring(FDS.jtacID) ..' laser code: ' .. tostring(args[3]))
			local textNumber = FDS.markUpNumber
			FDS.allJtacs[FDS.trueCoalitionCode[args[1]:getCoalition()]][newDrone.name] = {['owner'] = deployerID, ['coalition'] = args[1]:getCoalition(), ['group'] = Group.getByName(newDrone.name), ['drawId'] = {circleNumber, textNumber}, ['position'] = {point3.x, point3.z, heightD}, ['status'] = 'searching', ['sight'] = {}, ['target'] = nil, ['jtacID'] = FDS.jtacID, ['code'] = args[3], ['laserSpot'] = nil}
			msg.text = 'JTAC created.'
			msg.sound = 'fdsTroops.ogg'
		else
			msg.text = 'You are too close from another JTAC with the same laser code.'
			msg.sound = 'fdsTroops.ogg'
		end
	else
		msg.text = 'Insuficient credits.'
		msg.sound = 'fdsTroops.ogg'
	end
	trigger.action.outTextForGroup(args[1]:getID(), msg.text, msg.displayTime)
	trigger.action.outSoundForGroup(args[1]:getID(),msg.sound)
end

function updateDeployedTroops()
    for _, ids in pairs(FDS.deployedTroopsMarks) do
    trigger.action.removeMark(ids[1])
    trigger.action.removeMark(ids[2])
    trigger.action.removeMark(ids[3])
	end
    for coalition, unitSet in pairs(FDS.deployedUnits) do
        for name, data in pairs(unitSet) do
			if data.groupData.type ~= 'Air' then 
				local circleColor1 = {}
				local circleColor2 = {}
				local textColor1 = {}
				local textColor2 = {}
				if data.groupData.coa == 1 then
					circleColor1 = {1, 0.2, 0.5, 1}
					textColor1 = {1, 0.2, 0.5, 1}
					textColor2 = {0, 0, 0, 0}
				elseif data.groupData.coa == 2 then
					circleColor1 = {0, 0.9, 1, 1}
					textColor1 = {0, 0.9, 1, 1}
					textColor2 = {0, 0, 0, 0}
				end
				local uni = Unit.getByName(name)
				point3 = {['x'] = uni:getPosition().p.x, ['y'] = 0, ['z'] = uni:getPosition().p.z}
				--point3 = {['x'] = data.groupData.x, ['y'] = 0, ['z'] = data.groupData.z}
				FDS.markUpNumber = FDS.markUpNumber + 1
				trigger.action.lineToAll(data.groupData.coa , FDS.markUpNumber, {['x'] = point3.x + FDS.deployedTroopsSymbolSize*0.5, ['y'] = point3.y, ['z'] = point3.z + FDS.deployedTroopsSymbolSize*0.5}, {['x'] = point3.x - FDS.deployedTroopsSymbolSize*0.5, ['y'] = point3.y, ['z'] = point3.z - FDS.deployedTroopsSymbolSize*0.5}, circleColor1 , 1 , true)
				local lineNumber1 = FDS.markUpNumber
				FDS.markUpNumber = FDS.markUpNumber + 1
				trigger.action.lineToAll(data.groupData.coa , FDS.markUpNumber, {['x'] = point3.x - FDS.deployedTroopsSymbolSize*0.5, ['y'] = point3.y, ['z'] = point3.z + FDS.deployedTroopsSymbolSize*0.5}, {['x'] = point3.x + FDS.deployedTroopsSymbolSize*0.5, ['y'] = point3.y, ['z'] = point3.z - FDS.deployedTroopsSymbolSize*0.5}, circleColor1 , 1 , true)
				local lineNumber2 = FDS.markUpNumber
				FDS.markUpNumber = FDS.markUpNumber + 1
				trigger.action.textToAll(data.groupData.coa, FDS.markUpNumber, point3, textColor1 , textColor2 , FDS.deployedTroopsFontSizeText, true , data.ownerName .. '_' .. data.groupData.showName)
				local textNumber = FDS.markUpNumber
				table.insert(FDS.deployedTroopsMarks, {lineNumber1, lineNumber2, textNumber})
			end
        end
    end
	local msgCap = {}
	msgCap.text = "UPDATING PLAYER'S UNITS POSITION"
	msgCap.displayTime = 5
	--trigger.action.outText(msgCap.text, msgCap.displayTime)
	--trigger.action.outSound('Msg.ogg')
end

function JTACSearch(args)
	local allUnits = {}
	-- Search for vehicles
	local coaName = nil
	if args.coalition == 1 then
		allUnits = mist.makeUnitTable({'[blue][vehicle]'})
		coaName = 'red'
	elseif args.coalition == 2 then
		coaName = 'blue'
		allUnits = mist.makeUnitTable({'[red][vehicle]'})
	end
	jtacPos = FDS.allJtacs[coaName][args.name].position
	local unitsInSight = {}
	local newVehicles = {}
    local lostUnitsNumber = 0
    local newUnitsNumber = 0
	local quantType = {}
	local tgtLost = true
    if FDS.allJtacs[coaName][args.name].target == nil then
        tgtLost = false
    end
	local tgtDestroyed = false
	local uni = ''
	local lastSight = mist.utils.deepCopy(FDS.allJtacs[coaName][args.name].sight)
    local noOne = true
	for i,j in pairs(allUnits) do
		local isNew = true
		uni = Unit.getByName(j)
		if uni ~= nil and uni:isActive() then
			uniPos = uni:getPosition().p
			dist = math.sqrt((jtacPos[1] - uniPos.x)^2 + (jtacPos[3] - uniPos.y)^2 + (jtacPos[2] - uniPos.z)^2)
			vis = land.isVisible({['x'] = jtacPos[1], ['y'] = jtacPos[3], ['z'] = jtacPos[2]} , uniPos )
			uniLL = {coord.LOtoLL({['x'] = jtacPos[1], ['y'] = jtacPos[3], ['z'] = jtacPos[2]})}
			ll1 = mist.tostringLL(uniLL[1] , uniLL[2], 4)
			ll1 = mysplit(ll1, '\t')
			uniMGRS = coord.LLtoMGRS(uniLL[1] , uniLL[2])
			uniMGRSCorrected = uniMGRS.UTMZone .. ' ' .. uniMGRS.MGRSDigraph .. ' ' .. uniMGRS.Easting .. ' ' .. uniMGRS.Northing
			local var = {}
			local jtacPosVec = {['x'] = jtacPos[1], ['y'] = jtacPos[3], ['z'] = jtacPos[2]}
			var.units = {j} -- Name Unit
			var.ref = jtacPosVec
			var.alt = 0
			bra =  mist.getBRString(var)
			bra2 = mysplit(bra,' ')
			bra3 = bra2[1] - mist.utils.toDegree(mist.getNorthCorrection(jtacPosVec))
			if vis and dist < FDS.maxJTACRange*1852 then
                for index, object in pairs(FDS.allJtacs[coaName][args.name].sight) do
                    if uni ~= nil and uni:isActive() and object.name == j then
                        noOne = false
                        lastSight[index] = nil
						isNew = false
						if FDS.allJtacs[coaName][args.name].target ~= nil and FDS.allJtacs[coaName][args.name].target.name == object.name then
							tgtLost = false
						end
                    end
                end
                if FDS.allJtacs[coaName][args.name].target ~= nil and (Unit.getByName(FDS.allJtacs[coaName][args.name].target.name) == nil or not Unit.getByName(FDS.allJtacs[coaName][args.name].target.name):isExist()) then
                    tgtLost = true
                end
				if isNew then
					newVehicles[i] = j
                    newUnitsNumber = newUnitsNumber + 1
				end
				if tgtLost then
					if FDS.allJtacs[coaName][args.name].target ~= nil and Unit.getByName(FDS.allJtacs[coaName][args.name].target.name) == nil or not Unit.getByName(FDS.allJtacs[coaName][args.name].target.name):isExist() then
						tgtDestroyed = true
						for index, object in pairs(lastSight) do
							if FDS.allJtacs[coaName][args.name].target.name == object.name then
								lastSight[index] = nil
							end
						end
					end
				end
				table.insert(unitsInSight,{['name'] = j, ['uniType'] = uni:getDesc().typeName, ['coordLL'] = {['coord'] = ll1[1] .. ' ' .. ll1[2], ['elev'] = uniPos.y*3.28084}, ['coordMGRS'] = uniMGRSCorrected, ['bra'] = {['bearing'] = math.floor(bra3+0.7), ['range'] = bra2[3], ['altitude'] = uniPos.y*3.28084}})
			end
		end
	end
    if noOne and FDS.allJtacs[coaName][args.name].target ~= nil then
        tgtDestroyed = true
    end

    local aliveEnemies = {}
    local aENumber = 0
    local destroyedEnemies = {}
    local dENumber = 0
    for _, object in pairs(lastSight) do
        lostUnitsNumber = lostUnitsNumber + 1
    end
    if lostUnitsNumber > 0 or newUnitsNumber > 0 or tgtDestroyed then
        if tgtDestroyed then
            dENumber = dENumber + 1
        end
        for index, object in pairs(lastSight) do
            if Unit.getByName(object.name) ~= nil and Unit.getByName(object.name):isExist() then
                aliveEnemies[index] = object
                aENumber = aENumber + 1
            else
                destroyedEnemies[index] = object
                dENumber = dENumber + 1
            end
        end
        local msg = {}
        msg.text = ""
		if newUnitsNumber > 0 then
			msg.text = msg.text .. "Jtac " .. tostring(args.id) .. " has new enemies in sight. " .. tostring(newUnitsNumber) .. " contacts.\nNew units:\n"
            for index, object in pairs(newVehicles) do
                msg.text = msg.text .. Unit.getByName(object):getDesc().typeName .. "\n"
            end 
		end
        if aENumber > 0 then
            if tgtLost and not tgtDestroyed then
                msg.text = msg.text .. "Jtac " .. tostring(args.id) .. " reporting: Target left my sight! Laser off and resuming search.\n\n"
                FDS.allJtacs[coaName][args.name].status = 'searching'
                FDS.allJtacs[coaName][args.name].target = nil
                FDS.allJtacs[coaName][args.name].laserSpot:destroy()
                FDS.allJtacs[coaName][args.name].laserSpot = {}
			end
			msg.text = msg.text .. "Jtac " .. tostring(args.id) .. " lost sight of " .. tostring(aENumber) .. " contacts. \nLost units:\n"
			for index, object in pairs(aliveEnemies) do
				msg.text = msg.text .. object.uniType .. " - Last seen at BRA (from JTAC " .. tostring(args.id) .. "): " .. object.bra["bearing"] .. " for " .. object.bra["range"] .. " at " .. tostring(math.floor(object.bra["altitude"])) .. " ft.\n"
			end 
		end
        if dENumber > 0 then
            if tgtLost and tgtDestroyed then
                msg.text = msg.text .. "Jtac " .. tostring(args.id) .. " reporting: Target destroyed! Laser off and resuming search.\n\n"
                FDS.allJtacs[coaName][args.name].status = 'searching'
                FDS.allJtacs[coaName][args.name].target = nil
                FDS.allJtacs[coaName][args.name].laserSpot:destroy()
                FDS.allJtacs[coaName][args.name].laserSpot = {}
			end
			msg.text =  msg.text .. "Jtac " .. tostring(args.id) .. " reporting: Enemy destroyed! Total:" .. tostring(dENumber) .. " units.\nKilled units:\n"
			for index, object in pairs(destroyedEnemies) do
				msg.text = msg.text .. object.uniType .. ".\n"
			end
        end
        msg.displayTime = 10
        msg.sound = 'Jtac.ogg'	
        trigger.action.outTextForCoalition(args.coalition,msg.text,msg.displayTime)
        trigger.action.outSoundForCoalition(args.coalition,msg.sound)
    end
	FDS.allJtacs[coaName][args.name].sight = unitsInSight
    if FDS.allJtacs[coaName][args.name].status == 'searching' and #FDS.allJtacs[coaName][args.name].sight > 0 then
		local samElements = {}
		local armorElements = {}
		local infantryElements = {}
		local unknownType = {}
		local readyToInsert = true
		for _, dados in pairs(FDS.allJtacs[coaName][args.name].sight) do
			readyToInsert = true
			if Unit.getByName(dados.name):hasAttribute('SAM') or Unit.getByName(dados.name):hasAttribute('SAM elements') then
				for jtacName, jtacData in pairs(FDS.allJtacs[coaName]) do
					if jtacName ~= args.name and jtacData.target ~= nil and jtacData.target.name == dados.name then
						readyToInsert = false
					end
				end
				if readyToInsert then
					table.insert(samElements, dados)
					readyToInsert = true
				end
			elseif Unit.getByName(dados.name):hasAttribute('Tanks') or Unit.getByName(dados.name):hasAttribute('Trucks') or Unit.getByName(dados.name):hasAttribute('IFV') then 
				for jtacName, jtacData in pairs(FDS.allJtacs[coaName]) do
					if jtacName ~= args.name and jtacData.target ~= nil and jtacData.target.name == dados.name then
						readyToInsert = false
					end
				end
				if readyToInsert then
					table.insert(armorElements, dados)
					readyToInsert = true
				end
			elseif Unit.getByName(dados.name):hasAttribute('Infantry') then 
				for jtacName, jtacData in pairs(FDS.allJtacs[coaName]) do
					if jtacName ~= args.name and jtacData.target ~= nil and jtacData.target.name == dados.name then
						readyToInsert = false
					end
				end
				if readyToInsert then
					table.insert(infantryElements, dados)
					readyToInsert = true
				end
			else
				for jtacName, jtacData in pairs(FDS.allJtacs[coaName]) do
					if jtacName ~= args.name and jtacData.target ~= nil and jtacData.target.name == dados.name then
						readyToInsert = false
					end
				end
				if readyToInsert then
					table.insert(unknownType, dados)
					readyToInsert = true
				end
			end
		end
		local selectTarget = ''
        --local selectTarget = FDS.allJtacs[coaName][args.name].sight[math.random(1, #FDS.allJtacs[coaName][args.name].sight)]
		if #samElements > 0 then
			selectTarget = samElements[math.random(1, #samElements)]
		elseif #armorElements > 0 then
			selectTarget = armorElements[math.random(1, #armorElements)]
		elseif #infantryElements > 0 then
			selectTarget = infantryElements[math.random(1, #infantryElements)]
		elseif #unknownType > 0 then
			selectTarget = unknownType[math.random(1, #unknownType)]
		end
		if selectTarget ~= '' then
			local laserSpot = Spot.createLaser(Group.getByName(args.name):getUnits()[1], {x = 0, y = 1, z = 0}, Unit.getByName(selectTarget.name):getPoint(), args.code)
			FDS.allJtacs[coaName][args.name].target = selectTarget
			FDS.allJtacs[coaName][args.name].status = 'lasing'
			FDS.allJtacs[coaName][args.name].laserSpot = laserSpot
			local msg = {}
			msg.text = "Lasing target with code " .. tostring(args.code) .. "\nTarget: " .. selectTarget.uniType .. " | BRA (from JTAC) --> " .. tostring(selectTarget.bra.bearing) .. " for " .. tostring(selectTarget.bra.range) .. ' nm at ' .. tostring(math.floor(selectTarget.bra.altitude)) .. '\nCoord. LL --> ' .. tostring(selectTarget.coordLL.coord) .. ' | MGRS --> ' .. tostring(selectTarget.coordMGRS) .. '\n'
			msg.displayTime = 10
			msg.sound = 'Jtac.ogg'
			--trigger.action.outTextForCoalition(args.coalition,msg.text,msg.displayTime)
			--trigger.action.outSoundForCoalition(args.coalition,msg.sound)
			mist.scheduleFunction(trigger.action.outTextForCoalition,{args.coalition,msg.text,msg.displayTime},timer.getTime()+1)
			mist.scheduleFunction(trigger.action.outSoundForCoalition,{args.coalition,msg.sound},timer.getTime()+1)
		end
    end
end

function jtacRefresh()
	for coalition, jtac in pairs(FDS.allJtacs) do
		for jtacName, jtacInfo in pairs(jtac) do
			if Group.getByName(jtacName) ~= nil and Group.getByName(jtacName):isExist() then
				args = {}
				args.name = jtacName
				args.coalition = FDS.allJtacs[coalition][jtacName].coalition
				args.id = FDS.allJtacs[coalition][jtacName].jtacID
				args.code = FDS.allJtacs[coalition][jtacName].code
				JTACSearch(args)
			else
				trigger.action.removeMark(jtacInfo.drawId[1])
				trigger.action.removeMark(jtacInfo.drawId[2])
				msg = {}
				msg.text = "Our Jtac " .. tostring(jtacInfo.jtacID) .. " has been destroyed."
				msg.displayTime = 10
				msg.sound = 'fdsTroops.ogg'
				mist.scheduleFunction(trigger.action.outTextForCoalition,{jtacInfo.coalition,msg.text,msg.displayTime},timer.getTime()+1)
				mist.scheduleFunction(trigger.action.outSoundForCoalition,{jtacInfo.coalition,msg.sound},timer.getTime()+1)
				local inverseCoalition = {2,1}
				msg.text = "Enemy Jtac " .. tostring(jtacInfo.jtacID) .. " has been destroyed."
				mist.scheduleFunction(trigger.action.outTextForCoalition,{inverseCoalition[jtacInfo.coalition],msg.text,msg.displayTime},timer.getTime()+1)
				mist.scheduleFunction(trigger.action.outSoundForCoalition,{inverseCoalition[jtacInfo.coalition],msg.sound},timer.getTime()+1)
				FDS.allJtacs[coalition][jtacName] = nil
			end
		end
	end
end

function FDS.jtacSummary(g_id)
	local msg = {}
	local jtacNumber = 0
	for key,_ in pairs(FDS.allJtacs[FDS.trueCoalitionCode[g_id[2]]]) do
		jtacNumber = jtacNumber + 1
	end
	if jtacNumber > 0 then
		msg.text = 'JTAC Summary:\n'
	else
		msg.text = 'No JTACs available.\n'
	end
   	msg.displayTime = 30
   	msg.sound = 'Msg.ogg'
	   for _, jtac in pairs(FDS.allJtacs[FDS.trueCoalitionCode[g_id[2]]]) do
		local unitCount = {}
		local totalEnemies = 0
		msg.text = msg.text .. 'JTAC ' .. tostring(jtac.jtacID) .. ': Laser code --> ' .. tostring(jtac.code) .. ' | Status --> ' .. tostring(jtac.status)
		for _, contact in pairs(jtac.sight) do
            --if jtac.target.name ~= contact.name then
			if unitCount[contact.uniType] == nil then
				unitCount[contact.uniType] = 1
			else
				unitCount[contact.uniType] = unitCount[contact.uniType] + 1
			end
            --end
		end
		for contactType, contactNumber in pairs(unitCount) do
			totalEnemies = totalEnemies + contactNumber
		end
		msg.text = msg.text .. ' - Total enemies: ' .. tostring(totalEnemies) .. '\n\n'
	end
	trigger.action.outTextForGroup(g_id[1], msg.text, msg.displayTime)
	trigger.action.outSoundForGroup(g_id[1],msg.sound)
end

function FDS.jtacStatus(g_id)
	local msg = {}
	msg.displayTime = 30
	msg.sound = 'Msg.ogg'
	local jtac = FDS.allJtacs[FDS.trueCoalitionCode[g_id[2]]][g_id[3]]
	if jtac ~= nil then
		local jtacNumber = 0
		for key,_ in pairs(FDS.allJtacs[FDS.trueCoalitionCode[g_id[2]]]) do
			jtacNumber = jtacNumber + 1
		end
		if jtacNumber > 0 then
			msg.text = 'Jtac Status:\n'
		else
			msg.text = 'No JTACs available.\n'
		end
		local unitCount = {}
		msg.text = msg.text .. 'JTAC ' .. tostring(jtac.jtacID) .. ': Laser code --> ' .. tostring(jtac.code) .. ' | Status --> ' .. tostring(jtac.status) .. '\n'
		if jtac.status == 'lasing' then
			msg.text = msg.text .. 'Target --> ' .. jtac.target.uniType .. ' | BRA (from JTAC) --> ' .. tostring(jtac.target.bra.bearing) .. ' for ' .. tostring(jtac.target.bra.range) .. ' nm at ' .. tostring(math.floor(jtac.target.bra.altitude)) .. '\nCoord. LL --> ' .. tostring(jtac.target.coordLL.coord) .. ' | MGRS --> ' .. tostring(jtac.target.coordMGRS) .. '\n'
		end
		for _, contact in pairs(jtac.sight) do
			if jtac.target ~= nil and jtac.target.name ~= contact.name then
				if unitCount[contact.uniType] == nil then
					unitCount[contact.uniType] = 1
				else
					unitCount[contact.uniType] = unitCount[contact.uniType] + 1
				end
			end
		end
		msg.text = msg.text .. '---------------------------------- Total units in sight ----------------------------------\n'
		for contactType, contactNumber in pairs(unitCount) do
			msg.text = msg.text .. contactType .. ' = ' .. tostring(contactNumber) .. '\n'
		end
	else
		msg.text = 'JTAC number might be incorrect update the JTAC list and try again.'
	end
	trigger.action.outTextForGroup(g_id[1], msg.text, msg.displayTime)
	trigger.action.outSoundForGroup(g_id[1],msg.sound)
end

function FDS.createASupport(args)
	local cloneName = ''
	if args[1]:getCoalition() == 1 then
		cloneName = 'Red'.. FDS.airSupportAssetsKeys[args[2]].groupName
	else
		cloneName = 'Blue'..FDS.airSupportAssetsKeys[args[2]].groupName
	end
	local gp = Group.getByName(cloneName)
	local gPData = mist.getGroupData(cloneName,true)
	local gpR = mist.getGroupRoute(gp:getName(),true)
	local new_GPR = mist.utils.deepCopy(gpR)
	local new_gPData = mist.utils.deepCopy(gPData)
	new_gPData.clone = true
	new_gPData.route = new_GPR
	local deployerID = FDS.retrieveUcid(args[1]:getUnits()[1]:getPlayerName(),FDS.isName)
	local msg = {}
	msg.displayTime = 10
	if FDS.playersCredits[FDS.trueCoalitionCode[args[1]:getCoalition()]][deployerID] >= FDS.airSupportAssetsKeys[args[2]].cost or FDS.bypassCredits then
		FDS.playersCredits[FDS.trueCoalitionCode[args[1]:getCoalition()]][deployerID] = FDS.playersCredits[FDS.trueCoalitionCode[args[1]:getCoalition()]][deployerID] - FDS.airSupportAssetsKeys[args[2]].cost
		local newAS = mist.dynAdd(new_gPData)
		FDS.deployedUnits[FDS.trueCoalitionCode[args[1]:getCoalition()]][Group.getByName(newAS.name):getUnits()[1]:getName()] = {['owner'] = deployerID, ['age'] = 0, ['ownerName'] = args[1]:getUnits()[1]:getPlayerName(), ['groupData'] = {['mockUpName'] = '',['x'] = '', ['z'] = '', ['hz'] = '', ['hx'] = '', ['type'] = 'Air', ['coa'] = '', ['showName'] = ''}}	
		msg.text = "Air support is on the way.\nRemaining Credits: $" .. tostring(FDS.playersCredits[FDS.trueCoalitionCode[args[1]:getCoalition()]][deployerID])
		msg.sound = 'fdsTroops.ogg'	
	else
		msg.text = "Insuficient credits.\n"
		msg.sound = 'fdsTroops.ogg'
	end
	trigger.action.outTextForGroup(args[1]:getID(),msg.text,msg.displayTime)
	trigger.action.outSoundForGroup(args[1]:getID(),msg.sound)
end

function checkAirbornFighters(coa)
	coaKeys = {[1]='red',[2]='blue'}
	counterKeys = {[1]='blue',[2]='red'}
	interceptorKeys = {"M-2000C", "Mirage-F1CE", "MiG-21Bis", "F-5E-3"}
	fighterKeys = {"F-16C_50", "F-15C", "FA-18C_hornet", "F-14B", "MiG-29G", "JF-17", "Su-33", "MiG-29S", "Su-27", "F-14A-135-GR", "J-11A", "MiG-29A", }
	gPData = mist.DBs.humansByName
	nFighter = 0
	counterFighter = 0
	nInterceptor = 0
	counterInterceptor = 0
	for i,j in pairs(gPData) do
		if j.coalition == coaKeys[coa] and Group.getByName(i) ~= nil and Group.getByName(i):getUnits()[1]:getPlayerName() ~= nil then
			for _,tp in pairs(fighterKeys) do
				if j.type == tp then
					nFighter = nFighter +1
				end
			end
			for _,tp in pairs(interceptorKeys) do
				if j.type == tp then
					nInterceptor = nInterceptor +1
				end
			end
		elseif j.coalition == counterKeys[coa] and Group.getByName(i) ~= nil and Group.getByName(i):getUnits()[1]:getPlayerName() ~= nil then
			for _,tp in pairs(fighterKeys) do
				if j.type == tp then
					counterFighter = counterFighter +1
				end
			end
			for _,tp in pairs(interceptorKeys) do
				if j.type == tp then
					counterInterceptor = counterInterceptor +1
				end
			end
		end
	end
	if nFighter - counterFighter >= 0 then
		nFighter = nFighter - counterFighter
	else
		nFighter = 0
	end
	if nInterceptor - counterInterceptor >= 0 then
		nInterceptor = nInterceptor - counterInterceptor
	else
		if nFighter + (nInterceptor - counterInterceptor) >= 0 then
			nFighter = nFighter + (nInterceptor - counterInterceptor)
		else
			nFighter = 0
		end
		nInterceptor = 0
	end

	return {['fighter'] = nFighter, ['interceptor'] = nInterceptor, ['total'] = nFighter+nInterceptor}
end

function spawnCargoFS(coa,number,typeFS,fORi)
	coaFSKeys = {[1]='Blue',[2]='Red'}
	number = number - #FDS.cargoFSTable[fORi][coa]
	if number > 0 then
        fighterIteration = 0
        for i = 1, 1 + math.floor((number-1)/4) do
            local gPData = mist.getGroupData(coaFSKeys[coa] .. '_Cargo_Sweep_' .. tostring(typeFS),true)
            local gpMockStart = mist.getGroupRoute(coaFSKeys[coa] .. '_Cargo_Sweep_1',true)
            local gpMockWP = mist.getGroupRoute(coaFSKeys[coa] .. '_Transport_Goods',true)
            local gpR = mist.getGroupRoute(coaFSKeys[coa] .. '_Cargo_Sweep_1',true)

            local new_GPR = mist.utils.deepCopy(gpR)
            local new_gPData = mist.utils.deepCopy(gPData)

            new_gPData.route = new_GPR 
            new_gPData.groupId = nil
            new_gPData.groupName = nil
            new_gPData.name = nil
            new_gPData.route = gpMockStart
			local factor = math.random(100)/100
            new_gPData.route[1].x = gpMockStart[2].x + (gpMockStart[3].x - gpMockStart[2].x)* factor
            new_gPData.route[1].y = gpMockStart[2].y + (gpMockStart[3].y - gpMockStart[2].y)* factor
            new_gPData.route[2].x = gpMockWP[1].x
            new_gPData.route[2].y = gpMockWP[1].y
            new_gPData.route[3].x = gpMockWP[2].x
            new_gPData.route[3].y = gpMockWP[2].y
            
            if fighterIteration == math.floor((number-1)/4) and number - 4*math.floor((number-1)/4) < 4 then
                for deleteUnit = 1, 4 - (number - 4*math.floor((number-1)/4)) do
                    new_gPData.units[5-deleteUnit] = nil
                end
            end
            new_gPData.units[1].x = new_gPData.route[1].x
            new_gPData.units[1].y = new_gPData.route[1].y

            new_gPData.units[1].alt = new_gPData.units[1].alt + 25*(math.random(1,200)-100.0)
            for index, _ in pairs(new_gPData.units) do
                if coa == 2 then
                    new_gPData.units[index].heading = 4.36332
                else
                    new_gPData.units[index].heading = 1.18682
                end
            end
            new_gPData.route[1].alt = new_gPData.units[1].alt 
            new_gPData.route[2].alt = new_gPData.units[1].alt
            new_gPData.route[3].alt = new_gPData.units[1].alt
            new_gPData.route[1].speed = FDS.transportFSSpeed
            new_gPData.route[2].speed = FDS.transportFSSpeed
            new_gPData.route[3].speed = FDS.transportFSSpeed
            new_gPData.clone = true

            newGp = mist.dynAdd(new_gPData)
			--ping('Criei!! Criei!!! Criei!!!!!')
			for _, unitName in pairs(Group.getByName(newGp.name):getUnits()) do
				FDS.cargoFSTable[fORi][coa][#FDS.cargoFSTable[fORi][coa]+1] = unitName:getName()
			end
            mist.scheduleFunction(killCargoFS,{Group.getByName(newGp.name)},timer.getTime()+FDS.deleteTime)

            fighterIteration = fighterIteration + 1
        end
    end
end

function botCargoFS(coa)
	numberPlanes = checkAirbornFighters(coa)
	reactNumberF = 0
    reactNumberI = 0
	if numberPlanes.fighter > 0 then
		reactNumberF = math.random(4,17)
	elseif numberPlanes.interceptor > 0 then
		reactNumberI = math.random(1,3)
	end
	if numberPlanes.fighter > 0 then
		--ping('Venha Fighter')
		spawnCargoFS(coa,numberPlanes.fighter,reactNumberF,'fighter')
	end
	if numberPlanes.interceptor > 0 then
		--ping('Venha Interceptor')
		spawnCargoFS(coa,numberPlanes.interceptor,reactNumberI,'interceptor')
	end
end

function checkCargoZones(coa)
	coaKeys = {[1]='red',[2]='blue'}
    zoneKeys = {[1] = 'cargoCombatZoneBlue', [2] = 'cargoCombatZoneRed'}
	gPData = mist.DBs.humansByName
    local unitNames = {}
	for i,j in pairs(gPData) do
		if j.coalition == coaKeys[coa] then
            table.insert(unitNames,i)
		end
	end
    local unitsLock = mist.getUnitsInZones(unitNames,{zoneKeys[coa]})
    if #unitsLock > 0 then
        return false
    else
        return true
    end
end

function killCargoFS(gp)
    if checkCargoZones(gp.coalition) then 
        gp:destroy()
	else
		mist.scheduleFunction(killCargoFS,{gp},timer.getTime()+FDS.retryTime)
    end
end

function killBombers(gp)
	gp:destroy()
end

function cleanFSTable(coa)
	for ind,_ in pairs(FDS.cargoFSTable) do
		for i,j in pairs(FDS.cargoFSTable[ind][coa]) do
			if Unit.getByName(j) == nil then
				FDS.cargoFSTable[ind][coa][i] = nil
			end
		end
	end
end

function tryCargoFS(coa)
	cleanFSTable(coa)
	local trialSeed = math.random(0,1000000)/1000000
	--ping('Sorteio: ' .. trialSeed .. ' -- Target: ' .. FDS.chanceTrial)
	if trialSeed < FDS.chanceTrial then
		botCargoFS(coa)
	end
	mist.scheduleFunction(tryCargoFS,{coa},timer.getTime()+FDS.cargoFSInterval+FDS.timeMaxVariance)
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
        local gp = Group.getByName(bombingRunTable[zone][2])
        local gPData = mist.getGroupData(bombingRunTable[zone][2],true)
        local gpR = mist.getGroupRoute(gp:getName(),true)
        local new_GPR = mist.utils.deepCopy(gpR)
        local new_gPData = mist.utils.deepCopy(gPData)
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
	local teamCode_forVictory = {
		['blue'] = 'Vermelho',
		['red'] = 'Azul'
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
							msgclear.text = 'Congratulations! All enemy units are eliminated. Mission Accomplished!'
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
							FDS.victoriousTeam = teamCode_forVictory[numero1]
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
		local newBomber = {}
		newBomber = mist.dynAdd(new_gPData)
		mist.scheduleFunction(killBombers,{Group.getByName(newBomber.name)},timer.getTime()+FDS.killTime)
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
		FDS.teamPoints[coa].Base = FDS.teamPoints[coa].Base + squadNumber*FDS.rewardCargo[coa]
		local msgTransp = {}  
		msgTransp.text = 'The air transport delivers our team ' .. squadNumber*FDS.rewardCargo[coa] .. ' points. More planes are on their way.'
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
		if FDS.progressiveReward then
			if FDS.conditionalIncrease then
				local squadNumber = 0
				if Group.getByName(FDS.currentTransport[coa][2]) and Group.getByName(FDS.currentTransport[coa][2]):isExist() then
					local transportGp = Group.getByName(FDS.currentTransport[coa][2])
					squadNumber = transportGp:getSize()
				end
				FDS.rewardCargo[coa] = FDS.rewardCargo[coa] + squadNumber*FDS.rewardIncrease
			else
				FDS.rewardCargo[coa] = FDS.rewardCargo[coa] + FDS.rewardIncrease
			end
		end
		respawnTransport(coa)
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

function buyAwacs(args)
	sideAWACS = {{'Red_AWACS_1', 1, 2,'red'}, {'Blue_AWACS_1', 2, 1,'blue'}}
	msgAWACSBack = {}
	msgAWACSBack.displayTime = 10
	msgAWACSBack.sound = 'fdsTroops.ogg'
	local deployerID = FDS.retrieveUcid(args[1]:getUnits()[1]:getPlayerName(),FDS.isName)
	if FDS.playersCredits[FDS.trueCoalitionCode[args[1]:getCoalition()]][deployerID] >= FDS.airSupportAssetsKeys[args[2]].cost or FDS.bypassCredits then
		if not FDS.awacsActive[sideAWACS[args[1]:getCoalition()][4]] then
			FDS.playersCredits[FDS.trueCoalitionCode[args[1]:getCoalition()]][deployerID] = FDS.playersCredits[FDS.trueCoalitionCode[args[1]:getCoalition()]][deployerID] - FDS.airSupportAssetsKeys[args[2]].cost
			mist.respawnGroup(sideAWACS[args[1]:getCoalition()][1], true)	
			msgAWACSBack.text = 'Our AWACS is now active.'
			FDS.awacsActive[sideAWACS[args[1]:getCoalition()][4]] = true
		else
			msgAWACSBack.text = 'Our AWACS is already active.'
		end
	else
		msgAWACSBack.text = "Insuficient credits.\n"
	end
	trigger.action.outTextForCoalition(sideAWACS[args[1]:getCoalition()][2], msgAWACSBack.text, msgAWACSBack.displayTime)
	trigger.action.outSoundForCoalition(sideAWACS[args[1]:getCoalition()][2],msgAWACSBack.sound)
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

function FDS.checkAWACSStatus()
	local blueAWACS = 'Inactive'
	if Unit.getByName('Blue_AWACS_1') ~= nil and Unit.getByName('Blue_AWACS_1'):isActive() then
		blueAWACS = 'Active'
		FDS.awacsActive['blue'] = true
	end
	local redAWACS = 'Inactive'
	if Unit.getByName('Red_AWACS_1') ~= nil and Unit.getByName('Red_AWACS_1'):isActive() then
		redAWACS = 'Active'
		FDS.awacsActive['red'] = true
	end
	return blueAWACS, redAWACS 
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
		local redAWACS = 'Inactive'
		blueAWACS, redAWACS = FDS.checkAWACSStatus()
		msg.text = msg.text .. 'Blue AWACS: '.. blueAWACS
		msg.text = msg.text .. '\nRed AWACS: '.. redAWACS .. '\n'
		msg.text = msg.text .. '\n -------------------- \n \n'
		msg.text = msg.text .. 'Cargo plane reward (per plane): \n'
		msg.text = msg.text .. 'Blue: ' .. tostring(FDS.rewardCargo['blue']) .. ' points. \n'
		msg.text = msg.text .. 'Red: ' .. tostring(FDS.rewardCargo['red']) .. ' points. \n'
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
		msg.text = msg.text .. 'Cargo plane reward (per plane): \n'
		msg.text = msg.text .. 'Red: ' .. tostring(FDS.rewardCargo['red']) .. ' points. \n'
		msg.text = msg.text .. 'Blue: ' .. tostring(FDS.rewardCargo['blue']) .. ' points. \n'
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
	if _initiator:getCategory() == 0 or _initiator:getCategory() == 1 or _initiator:getCategory() == 2  or _initiator:getCategory() == 3 then
		initCheck = true
	end
	if _target:getCategory() == 0 or _target:getCategory() == 1 or _target:getCategory() == 2  or _target:getCategory() == 3 then
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
						table.insert(FDS.recordDeliveredPoints[index]['deliveries'], {['name']= i.name,['value']= FDS.teamPoints[coa]['Players'][_initEnt:getPlayerName()], ['aircraft'] = _initEnt:getDesc().typeName, ['coalition'] = coa})
					else
						FDS.recordDeliveredPoints[index]['deliveries'] = {}
					end
				end
			end
            if newID then 
                table.insert(FDS.recordDeliveredPoints, {['ucid'] = i.ucid, ['deliveries'] = {{['name']= i.name,['value']= FDS.teamPoints[coa]['Players'][_initEnt:getPlayerName()], ['aircraft'] = _initEnt:getDesc().typeName, ['coalition'] = coa}}})
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
		if i.unit ~= nil and i.category == 'helicopter' and (i.type == 'UH-1H' or i.type == 'Mi-8MT' or i.type == 'SA342L' or i.type == 'SA342M' or i.type == 'SA342Minigun' or i.type =='Mi-24P') then
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
		-- Exporting results
		local outfile = io.open(FDS.exportPath .. "mission_result.json", "w+")
		FDS.endTime['year'] = os.date("%y")
		FDS.endTime['month'] = os.date("%m")
		FDS.endTime['day'] = os.date("%d")
		FDS.endTime['hour'] = os.date("%H")
		FDS.endTime['minute'] = os.date("%M")
		local results_exp = {
			['killRecord'] = FDS.exportPath .. "killRecord_" .. FDS.endTime['year'] .. FDS.endTime['month'] .. FDS.endTime['day'] .. FDS.endTime['hour'] .. FDS.endTime['minute'] .. ".json",
			['currentStats'] = FDS.exportPath .. "currentStats_" .. FDS.endTime['year'] .. FDS.endTime['month'] .. FDS.endTime['day'] .. FDS.endTime['hour'] .. FDS.endTime['minute'] .. ".json",
			['year'] = FDS.endTime['year'],
			['month'] = FDS.endTime['month'],
			['day'] = FDS.endTime['day'],
			['hour'] = FDS.endTime['hour'],
			['minute'] = FDS.endTime['minute'],
			['winner'] = FDS.victoriousTeam
		}
		results_json = net.lua2json(results_exp)
		outfile:write(results_json)
		outfile:close()
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
		if _event['target'] and _event['target'] ~= nil and _event['target']:getCategory() ~= nil and eventExport['targetName'] ~= nil then
			if _event['target']:getCategory() == 3 then
				FDS.killedByEntity[eventExport['targetName']] = eventExport
			elseif _event['target']:getGroup() ~= nil and _event['target']:getGroup():getName() ~= nil and _event['target']:getCategory() ~= 3 then
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

function removePair(args)
	for index, pair in pairs(FDS.doubleGuard) do
		if pair[1] == args[1] and pair[2] == args[2] then
			FDS.doubleGuard[index] = nil
		end
	end
end

function doubleGuardCheck(init, target)
	local doubleGuardCheckOK = false
	if target ~= nil then
		for index, pair in pairs(FDS.doubleGuard) do
			if pair[1] == init and pair[2] == target then
				doubleGuardCheckOK = true
			end
		end
	end
	return doubleGuardCheckOK
end

function awardPoints(initCheck, initCoaCheck, targetCoaCheck, initCoa, targetCoa, _initEnt, _targetEnt, rewardType, forceAward)
	if _initEnt ~= nil and _targetEnt ~= nil and initCheck and initCoaCheck and targetCoaCheck and initCoa ~= targetCoa and _initEnt:isExist() then
		local plName = _initEnt:getPlayerName()
		--local plType = nil
		--local typeFactor = 1.0
		--if _initEnt ~= nil and _initEnt:getPlayerName() ~= nil and _initEnt:getDesc().typeName then
		--	if FDS.typeFactor[_initEnt:getDesc().typeName] 
		--end
		local tgtName = nil
		if _targetEnt:getCategory() == 3 then
			tgtName = nil
		else
			tgtName = _targetEnt:getPlayerName()
		end
		local plGrp = _initEnt:getGroup()
		local plID = plGrp:getID()
		if not doubleGuardCheck(_initEnt:getName(), _targetEnt:getName()) or not FDS.doubleGuardOn then
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
									table.insert(FDS.doubleGuard, {_initEnt:getName(), _targetEnt:getName()})
									mist.scheduleFunction(removePair,{{_initEnt:getName(), _targetEnt:getName()}},timer.getTime()+FDS.doubleGuardTime)
								else
									FDS.teamPoints[i]['Players'][k] = FDS.teamPoints[i]['Players'][k] + FDS.rewardDict[rewardType]
									msgKill.text = 'You receive: ' .. tostring(FDS.rewardDict[rewardType]) .. ' points for your kill.'
									trigger.action.outTextForGroup(plID, msgKill.text, msgKill.displayTime)
									trigger.action.outSoundForGroup(plID,msgKill.sound)	
									table.insert(FDS.doubleGuard, {_initEnt:getName(), _targetEnt:getName()})
									mist.scheduleFunction(removePair,{{_initEnt:getName(), _targetEnt:getName()}},timer.getTime()+FDS.doubleGuardTime)
								end
							end
						elseif forceAward then
							if tgtName ~= nil  then
								FDS.teamPoints[i]['Players'][k] = FDS.teamPoints[i]['Players'][k] + FDS.playerReward
								msgKill.text = 'You receive: ' .. tostring(FDS.playerReward) .. ' points for your kill.'
								trigger.action.outTextForGroup(plID, msgKill.text, msgKill.displayTime)
								trigger.action.outSoundForGroup(plID,msgKill.sound)
								table.insert(FDS.doubleGuard, {_initEnt:getName(), _targetEnt:getName()})
								mist.scheduleFunction(removePair,{{_initEnt:getName(), _targetEnt:getName()}},timer.getTime()+FDS.doubleGuardTime)
							else
								FDS.teamPoints[i]['Players'][k] = FDS.teamPoints[i]['Players'][k] + FDS.rewardDict[rewardType]
								msgKill.text = 'You receive: ' .. tostring(FDS.rewardDict[rewardType]) .. ' points for your kill.'
								trigger.action.outTextForGroup(plID, msgKill.text, msgKill.displayTime)
								trigger.action.outSoundForGroup(plID,msgKill.sound)
								table.insert(FDS.doubleGuard, {_initEnt:getName(), _targetEnt:getName()})
								mist.scheduleFunction(removePair,{{_initEnt:getName(), _targetEnt:getName()}},timer.getTime()+FDS.doubleGuardTime)
							end
						end
					end
				end
			end
		end
	end
end

function awardIndirectCredit(initCoaCheck, targetCoaCheck, initCoa, targetCoa, _initEnt, _targetEnt, rewardType, forceAward)
	if _initEnt ~= nil and _initEnt:isExist() and _initEnt:getName() ~= nil and _initEnt:getCoalition() ~= nil and FDS.deployedUnits[FDS.trueCoalitionCode[_initEnt:getCoalition()]][_initEnt:getName()] ~= nil then
		errorLog("indirectCreditFeed.txt", '\n***************************************\n --- EVENT START ---\n'.. 'Initiator: ' .. tostring(_initEnt) .. '\nExiste: ' .. tostring(_initEnt:isExist()) .. '\nName: ' .. tostring(_initEnt:getName()).. '\nCoalition: ' .. tostring(_initEnt:getCoalition())) 
		local plName = FDS.deployedUnits[FDS.trueCoalitionCode[_initEnt:getCoalition()]][_initEnt:getName()].owner
		local tgtName = nil
		if _targetEnt:getCategory() == 3 then
			tgtName = nil
		elseif _targetEnt:getPlayerName() ~= nil then
			tgtName = _targetEnt:getPlayerName()
		end
		local plGrp = FDS.checkPlayerOnline(plName,FDS.isName,FDS.isOnline)
		local plID = nil
		local plCOA = nil
		local unitCOA = _initEnt:getCoalition()
		if plGrp ~= "" then
			plID = plGrp:getID()
			plCOA = plGrp:getCoalition()
		end
		tgtName = FDS.retrieveUcid(tgtName,FDS.isName)
		local foundIt = false
		if not doubleGuardCheck(_initEnt:getName(), _targetEnt:getName()) or not FDS.doubleGuardOn then
			for k,w in pairs(FDS.playersCredits[FDS.trueCoalitionCode[_initEnt:getCoalition()]]) do
				if plName == k then
					errorLog("indirectCreditFeed.txt", 'Achei o nome na lista de jogadores!!!') 
					foundIt = true
					local msgKill = {}
					msgKill.displayTime = 10
					msgKill.sound = 'indirectKill.ogg'
					if FDS.lastHits[_targetEnt:getID()] ~= nil then
						errorLog("indirectCreditFeed.txt", 'Lasthits nao eh nil...' .. '\n' .. tostring(FDS.lastHits[_targetEnt:getID()]) .. '\n TGTID: ' .. tostring(_targetEnt:getID()) .. '\n segunda coluna: ' .. tostring(FDS.lastHits[_targetEnt:getID()][2]) .. '\n')
						if FDS.lastHits[_targetEnt:getID()] ~= 'DEAD' and not FDS.lastHits[_targetEnt:getID()][2] then
							if tgtName ~= nil and tgtName ~= '' then
								if tgtName ~= plName then
									FDS.playersCredits[FDS.trueCoalitionCode[_initEnt:getCoalition()]][k] = FDS.playersCredits[FDS.trueCoalitionCode[_initEnt:getCoalition()]][k] + FDS.playerReward
									msgKill.text = 'You receive: ' .. tostring(FDS.playerReward) .. ' credits because your troops killed an enemy.'
									errorLog("indirectCreditFeed.txt", 'Ganhou pontos por matar jogador!') 
								end
							else
								FDS.playersCredits[FDS.trueCoalitionCode[_initEnt:getCoalition()]][k] = FDS.playersCredits[FDS.trueCoalitionCode[_initEnt:getCoalition()]][k] + FDS.rewardDict[rewardType]
								msgKill.text = 'You receive: ' .. tostring(FDS.rewardDict[rewardType]) .. ' credits because your troops killed an enemy.'
								table.insert(FDS.doubleGuard, {_initEnt:getName(), _targetEnt:getName()})
								mist.scheduleFunction(removePair,{{_initEnt:getName(), _targetEnt:getName()}},timer.getTime()+FDS.doubleGuardTime)
								errorLog("indirectCreditFeed.txt", 'Ganhou pontos por matar inimigos!') 						
							end
							if plCOA == unitCOA then
								trigger.action.outTextForGroup(plID, msgKill.text, msgKill.displayTime)
								trigger.action.outSoundForGroup(plID,msgKill.sound)	
								errorLog("indirectCreditFeed.txt", 'Jogador esta on e no time, foi notificado.')
							else
								errorLog("indirectCreditFeed.txt", 'Jogador esta off ou no time oposto, nao sera notificado.')
							end
						end
					elseif forceAward then
						errorLog("indirectCreditFeed.txt", 'Nada no lasthits...') 
						if tgtName ~= nil and tgtName ~= '' then
							errorLog("indirectCreditFeed.txt", 'Matou jogador.') 
							if tgtName ~= plName then
								FDS.playersCredits[FDS.trueCoalitionCode[_initEnt:getCoalition()]][k] = FDS.playersCredits[FDS.trueCoalitionCode[_initEnt:getCoalition()]][k] + FDS.playerReward
								table.insert(FDS.doubleGuard, {_initEnt:getName(), _targetEnt:getName()})
								mist.scheduleFunction(removePair,{{_initEnt:getName(), _targetEnt:getName()}},timer.getTime()+FDS.doubleGuardTime)
								msgKill.text = 'You receive: ' .. tostring(FDS.playerReward) .. ' credits because your troops killed an enemy player: ' .. _targetEnt:getPlayerName() .. '\n' or 'You receive: ' .. tostring(FDS.playerReward) .. ' credits because your troops killed an enemy player. \n'
								errorLog("indirectCreditFeed.txt", 'Ganhou pontos por matar jogador!') 
							end
						else
							FDS.playersCredits[FDS.trueCoalitionCode[_initEnt:getCoalition()]][k] = FDS.playersCredits[FDS.trueCoalitionCode[_initEnt:getCoalition()]][k] + FDS.rewardDict[rewardType]
							msgKill.text = 'You receive: ' .. tostring(FDS.rewardDict[rewardType]) .. ' credits because your troops killed an enemy.'
							table.insert(FDS.doubleGuard, {_initEnt:getName(), _targetEnt:getName()})
							mist.scheduleFunction(removePair,{{_initEnt:getName(), _targetEnt:getName()}},timer.getTime()+FDS.doubleGuardTime)
							errorLog("indirectCreditFeed.txt", 'Ganhou pontos por matar inimigos!') 
						end
						if plCOA == unitCOA then
							trigger.action.outTextForGroup(plID, msgKill.text, msgKill.displayTime)
							trigger.action.outSoundForGroup(plID,msgKill.sound)	
							errorLog("indirectCreditFeed.txt", 'Jogador esta on e no time, foi notificado.') 
						else
							errorLog("indirectCreditFeed.txt", 'Jogador esta off ou no time oposto, nao sera notificado.')
						end
					end
				end
			end
			if foundIt == false then
				errorLog("indirectCreditFeed.txt", 'Nao achei o nome na lista de creditos.') 
				if FDS.lastHits[_targetEnt:getID()] ~= nil then
					errorLog("indirectCreditFeed.txt", 'Lasthits está com coisa!') 
					if FDS.lastHits[_targetEnt:getID()] ~= 'DEAD' and not FDS.lastHits[_targetEnt:getID()][2] then
						if tgtName ~= nil and tgtName ~= '' then
							if tgtName ~= plName then
								FDS.playersCredits[FDS.trueCoalitionCode[_initEnt:getCoalition()]][plName] = FDS.playerReward
								errorLog("indirectCreditFeed.txt", 'Criei nome na lista de creditos por matar player.')
							end
						else
							FDS.playersCredits[FDS.trueCoalitionCode[_initEnt:getCoalition()]][plName] = FDS.rewardDict[rewardType]
							errorLog("indirectCreditFeed.txt", 'Criei nome na lista de creditos por matar inimigos.')
						end
					end
				elseif forceAward then
					errorLog("indirectCreditFeed.txt", 'Nada no lasthits!') 
					if tgtName ~= nil and tgtName ~= '' then
						if tgtName ~= plName then
							FDS.playersCredits[FDS.trueCoalitionCode[_initEnt:getCoalition()]][plName] = FDS.playerReward
							errorLog("indirectCreditFeed.txt", 'Criei nome na lista de creditos por matar player.')
						end
					else
						FDS.playersCredits[FDS.trueCoalitionCode[_initEnt:getCoalition()]][plName] = FDS.rewardDict[rewardType]
						errorLog("indirectCreditFeed.txt", 'Criei nome na lista de creditos por matar inimigos.')
					end
				end
			end
		else
			errorLog("indirectCreditFeed.txt", 'Double guard ativado!!!')
		end
		exportPlayerDataNow()
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
		if _initEnt ~= nil and type(_initEnt) == "table" and _initEnt:getPlayerName() ~= nil then 
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
			FDS.addJtacOption(_initEnt:getGroup())
			FDS.addTroopManagement(_initEnt:getGroup())
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
		if _initEnt ~= nil and _initEnt:getID() ~= nil and FDS.lastHits[_initEnt:getID()] ~= nil and FDS.lastHits[_initEnt:getID()][4] ~= nil then
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
			if _initEntLocal ~= nil and _targetEntLocal ~= nil and _initEntLocal:getCategory() and _targetEntLocal:getCategory() and isUnitorStructure(_initEntLocal,_targetEntLocal) then
				if _targetEnt ~= nil and _targetEnt:getID() ~= nil and FDS.exportDataSite and FDS.lastHits[_targetEnt:getID()] ~= nil then
					if _targetEntLocal ~= nil and FDS.lastHits[_targetEntLocal:getID()] ~= nil and FDS.lastHits[_targetEntLocal:getID()] ~= 'DEAD' then 
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
				if _initEnt ~= nil and _targetEnt ~= nil and _initEnt:getID() ~= nil and FDS.lastHits[_targetEnt:getID()] ~= nil then
					FDS.lastHits[_initEnt:getID()][2] = true
				end
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
		if _init ~= nil and _currentTgt ~= nil and _init:getCategory() and _currentTgt:getCategory() and  isUnitorStructure(_init,_currentTgt) and _init:getPlayerName() ~= nil then 
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
		if FDS.lastHits[_initEnt:getID()] ~= nil and FDS.lastHits[_initEnt:getID()][4] ~= nil then
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
				if FDS.exportDataSite and FDS.lastHits[_targetEnt:getID()] ~= nil then
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
				if FDS.lastHits[_targetEnt:getID()] ~= nil then
					FDS.lastHits[_initEnt:getID()][2] = true
				end
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
			if FDS.lastHits[_initEnt:getID()] ~= nil and FDS.lastHits[_initEnt:getID()][4] ~= nil then
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
					if FDS.exportDataSite and FDS.lastHits[_targetEnt:getID()] ~= nil then
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
					if FDS.lastHits[_targetEnt:getID()] ~= nil then
						FDS.lastHits[_initEnt:getID()][2] = true
					end
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
					exportPlayerDataNow()
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
					exportPlayerDataNow()
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
				--[[ for i, j in pairs(FDS.dropZones) do 
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
				end ]]
			end
		end
		if _local ~= nil and _local:getName() == "Mid_Helipad" and _local:getCoalition() == _initEnt:getCoalition() then
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
	-- [world.event.S_EVENT_REFUELING] = function(x, param)
	-- 	local _event = param.event
	-- 	local _initEnt = _event.initiator
	-- 	local initCheck = pcall(FDS.playerCheck,_initEnt)
	-- 	local initCoa = 0
	-- 	local initCoaCheck = pcall(FDS.coalitionCheck,_initEnt)
	-- 	local gpUcid = FDS.retrieveUcid(_initEnt:getPlayerName(),FDS.isName)
	-- 	if initCoaCheck then
	-- 		initCoa = _initEnt:getCoalition()
	-- 	end
	-- 	if _initEnt ~= nil and _initEnt:getPlayerName() ~= nil then
	-- 		if initCheck and initCoaCheck and initCoa == 2 and _initEnt:getPlayerName() ~= nil and FDS.teamPoints.blue['Players'][_initEnt:getPlayerName()] ~= nil and FDS.teamPoints.blue['Players'][_initEnt:getPlayerName()] > 0 then
	-- 			local msgLand = {}
	-- 			local gp = _initEnt:getGroup()
	-- 			msgLand.text = 'You deliver ' .. FDS.teamPoints.blue['Players'][_initEnt:getPlayerName()] .. ' points to your team and receive ' .. FDS.teamPoints.blue['Players'][_initEnt:getPlayerName()] .. ' credits via air refuelling.'
	-- 			msgLand.displayTime = 20  
	-- 			msgLand.sound = 'Msg.ogg'
	-- 			trigger.action.outTextForGroup(gp:getID(), msgLand.text, msgLand.displayTime)
	-- 			trigger.action.outSoundForGroup(gp:getID(),msgLand.sound)
				
	-- 			-- Record land points
	-- 			recordLandPoints(_initEnt, FDS.trueCoalitionCode[initCoa])

	-- 			FDS.teamPoints.blue.Base = FDS.teamPoints.blue.Base + FDS.teamPoints.blue['Players'][_initEnt:getPlayerName()]
	-- 			FDS.playersCredits.blue[gpUcid] = FDS.playersCredits.blue[gpUcid] + FDS.teamPoints.blue['Players'][_initEnt:getPlayerName()]
	-- 			FDS.teamPoints.blue['Players'][_initEnt:getPlayerName()] = 0.0
	-- 			exportPlayerDataNow()
	-- 			if FDS.teamPoints.blue.Base >= FDS.callCost then 
	-- 				local bombTimes = math.floor(FDS.teamPoints.blue.Base/FDS.callCost)
	-- 				for callIt = 1, bombTimes do
	-- 					--mist.scheduleFunction(bombingRun, {'blue'},timer.getTime()+FDS.bomberMinInterval*(callIt-1))
	-- 					mist.scheduleFunction(guidedBombingRun, {'blue'},timer.getTime()+FDS.bomberMinInterval*(callIt-1))
	-- 					FDS.teamPoints.blue.Base = FDS.teamPoints.blue.Base - FDS.callCost
	-- 				end
	-- 			end
	-- 		elseif initCheck and initCoaCheck and initCoa == 1 and _initEnt:getPlayerName() ~= nil and FDS.teamPoints.red['Players'][_initEnt:getPlayerName()] ~= nil and FDS.teamPoints.red['Players'][_initEnt:getPlayerName()] > 0 then
	-- 			local msgLand = {}
	-- 			local gp = _initEnt:getGroup()
	-- 			msgLand.text = 'You deliver ' .. FDS.teamPoints.red['Players'][_initEnt:getPlayerName()] .. ' points to your team and receive ' .. FDS.teamPoints.red['Players'][_initEnt:getPlayerName()] .. ' credits via air refuelling.'
	-- 			msgLand.displayTime = 20  
	-- 			msgLand.sound = 'Msg.ogg'
	-- 			trigger.action.outTextForGroup(gp:getID(), msgLand.text, msgLand.displayTime)
	-- 			trigger.action.outSoundForGroup(gp:getID(),msgLand.sound)

	-- 			-- Record land points
	-- 			recordLandPoints(_initEnt, FDS.trueCoalitionCode[initCoa])

	-- 			FDS.teamPoints.red.Base = FDS.teamPoints.red.Base + FDS.teamPoints.red['Players'][_initEnt:getPlayerName()]
	-- 			FDS.playersCredits.red[gpUcid] = FDS.playersCredits.red[gpUcid] + FDS.teamPoints.red['Players'][_initEnt:getPlayerName()]
	-- 			FDS.teamPoints.red['Players'][_initEnt:getPlayerName()] = 0.0
	-- 			exportPlayerDataNow()
	-- 			if FDS.teamPoints.red.Base >= FDS.callCost then 
	-- 				local bombTimes = math.floor(FDS.teamPoints.red.Base/FDS.callCost)
	-- 				for callIt = 1, bombTimes do
	-- 					--mist.scheduleFunction(bombingRun, {'red'},timer.getTime()+FDS.bomberMinInterval*(callIt-1))
	-- 					mist.scheduleFunction(guidedBombingRun, {'red'},timer.getTime()+FDS.bomberMinInterval*(callIt-1))
	-- 					FDS.teamPoints.red.Base = FDS.teamPoints.red.Base - FDS.callCost
	-- 				end
	-- 			end
	-- 		end
	-- 	end
	-- end,
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
			if FDS.exportDataSite and FDS.lastHits[_targetEnt:getID()] ~= nil then
				if _targetEnt:getID() ~= nil then 
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
			if FDS.lastHits[_targetEnt:getID()] ~= nil then
				FDS.lastHits[_targetEnt:getID()][2] = true
				FDS.lastHits[_targetEnt:getID()] = 'DEAD'
			end
		end
	end,
	[world.event.S_EVENT_MISSION_END] = function(x, param)
		if FDS.exportPlayerUnits then
			exportCreatedUnits()
		end
		if FDS.exportPlayerData then
			--cleanPoints()
			exportPlayerDataNow()
		end
		if FDS.exportRegionsData then
			--cleanPoints()
			exportRegionsData()
		end
		if FDS.endTime['year'] == nil then
			FDS.endTime['year'] = os.date("%y")
			FDS.endTime['month'] = os.date("%m")
			FDS.endTime['day'] = os.date("%d")
			FDS.endTime['hour'] = os.date("%H")
			FDS.endTime['minute'] = os.date("%M")
		end

		if FDS.exportDataSite then
			local infile = io.open(FDS.exportPath .. "killRecord.json", "r")
			local instr = infile:read("*a")
			infile:close()
			
			local outfile = io.open(FDS.exportPath .. "killRecord_" .. FDS.endTime['year'] .. FDS.endTime['month'] .. FDS.endTime['day'] .. FDS.endTime['hour'] .. FDS.endTime['minute'] .. ".json", "w")
			outfile:write(instr)
			outfile:close()
			
			local infile = io.open(FDS.exportPath .. "currentStats.json", "r")
			local instr = infile:read("*a")
			infile:close()
			
			local outfile = io.open(FDS.exportPath .. "currentStats_" .. FDS.endTime['year'] .. FDS.endTime['month'] .. FDS.endTime['day'] .. FDS.endTime['hour'] .. FDS.endTime['minute'] .. ".json", "w")
			outfile:write(instr)
			outfile:close()
			
			local infile = io.open(FDS.exportPath .. "missionError.log", "r")
			local instr = infile:read("*a")
			infile:close()
			
			local outfile = io.open(FDS.exportPath .. "missionError_" .. FDS.endTime['year'] .. FDS.endTime['month'] .. FDS.endTime['day'] .. FDS.endTime['hour'] .. FDS.endTime['minute'] .. ".log", "w")
			outfile:write(instr)
			outfile:close()
			
			-- Exporting results
			local outfile = io.open(FDS.exportPath .. "mission_result.json", "w+")
			local results_exp = {
				['killRecord'] = FDS.exportPath .. "killRecord_" .. FDS.endTime['year'] .. FDS.endTime['month'] .. FDS.endTime['day'] .. FDS.endTime['hour'] .. FDS.endTime['minute'] .. ".json",
				['currentStats'] = FDS.exportPath .. "currentStats_" .. FDS.endTime['year'] .. FDS.endTime['month'] .. FDS.endTime['day'] .. FDS.endTime['hour'] .. FDS.endTime['minute'] .. ".json",
				['year'] = FDS.endTime['year'],
				['month'] = FDS.endTime['month'],
				['day'] = FDS.endTime['day'],
				['hour'] = FDS.endTime['hour'],
				['minute'] = FDS.endTime['minute'],
				['winner'] = FDS.victoriousTeam
			}
			results_json = net.lua2json(results_exp)
			outfile:write(results_json)
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
				trigger.action.removeMark(FDS.farpTextID)
				FDS.markUpNumber = FDS.markUpNumber + 1
				trigger.action.textToAll(-1, FDS.markUpNumber, trigger.misc.getZone('cZone_1').point, {1, 0, 0, 1} , {1, 0, 0, 0.2} , 20, true , 'Capturable FARP: Red Control')
				FDS.farpTextID = FDS.markUpNumber
				if FDS.farpReliever then
					table.insert(FDS.redRelieveZones, 'Mid_Helipad')
					for index, str in pairs(FDS.blueRelieveZones) do
						if str == 'Mid_Helipad' then
							table.remove(FDS.blueRelieveZones,index)
						end
					end
				end
				guards = mist.cloneGroup("Red_Outpost_Crew", true)
			elseif _event.place:getCoalition() == 2 then
				FDS.farpCoalition = 2
				trigger.action.removeMark(FDS.farpTextID)
				FDS.markUpNumber = FDS.markUpNumber + 1
				trigger.action.textToAll(-1, FDS.markUpNumber, trigger.misc.getZone('cZone_1').point, {0, 0, 1, 1} , {0, 0, 1, 0.2} , 20, true , 'Capturable FARP: Blue Control')
				FDS.farpTextID = FDS.markUpNumber
				if FDS.farpReliever then
					table.insert(FDS.blueRelieveZones, 'Mid_Helipad')
					for index, str in pairs(FDS.redRelieveZones) do
						if str == 'Mid_Helipad' then
							table.remove(FDS.redRelieveZones,index)
						end
					end
				end
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
	[world.event.S_EVENT_LANDING_AFTER_EJECTION] = function(x, param)
		Unit.destroy(param.event.initiator)
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
									FDS.victoriousTeam = 'Vermelho'
									msgfinal.text = 'Red Team is victorious! Restarting Server in 60 seconds. It is recommended to disconnect to avoid DCS crash.'
									msgfinal.displayTime = 60  
									msgfinal.sound = 'victory_Lane.ogg'
									trigger.action.outText(msgfinal.text, msgfinal.displayTime)
									trigger.action.outSoundForCoalition(1,msgfinal.sound)
									trigger.action.outSoundForCoalition(2,'zone_killed.ogg')
									playWarning = false
									cleanPoints()
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
									FDS.victoriousTeam = 'Azul'
									msgfinal.text = 'Blue Team is victorious! Restarting Server in 60 seconds. It is recommended to disconnect to avoid DCS crash.'
									msgfinal.displayTime = 60
									msgfinal.sound = 'victory_Lane.ogg'
									trigger.action.outText(msgfinal.text, msgfinal.displayTime)
									trigger.action.outSoundForCoalition(2,msgfinal.sound)
									trigger.action.outSoundForCoalition(1,'zone_killed.ogg')
									playWarning = false
									cleanPoints()
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
		if idCheck and _initEnt:getID() ~= nil and FDS.lastHits[_initEnt:getID()] ~= nil and FDS.lastHits[_initEnt:getID()][4] ~= nil then
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
				if FDS.exportDataSite and FDS.lastHits[_targetEnt:getID()] ~= nil then
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
				if FDS.lastHits[_targetEnt:getID()] ~= nil then
					FDS.lastHits[_initEnt:getID()][2] = true
				end
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
	--msgfinal.text = tostring(eventName .. ' : ' .. _event.id)
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
mist.scheduleFunction(protectCall, {importPlayerDataNow},timer.getTime())
mist.scheduleFunction(protectCall, {creatingBases},timer.getTime()+1)
mist.scheduleFunction(protectCall, {importPlayerUnits},timer.getTime()+2)
mist.scheduleFunction(protectCall, {updateDeployedTroops},timer.getTime()+3, FDS.updateTroopsRefresh)
mist.scheduleFunction(protectCall, {checkFuelLevels},timer.getTime()+3, FDS.refuelRefresh)
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
-- Initialize Regions
--mist.scheduleFunction(protectCall, {initializeRegions},timer.getTime()+2.5)
-- Regions check
--mist.scheduleFunction(protectCall, {checkRegions},timer.getTime()+2.5,FDS.checkRegionPeriod)
-- Regions paycheck
--mist.scheduleFunction(protectCall, {regionsPaycheck},timer.getTime()+5,FDS.regionPayPeriod)
-- Random drop manager
-- mist.scheduleFunction(createRandomDrop, {}, timer.getTime()+3, FDS.randomDropTime)
mist.scheduleFunction(protectCall, {createRandomDrop}, timer.getTime()+3, FDS.randomDropTime)
-- Transport caller
-- mist.scheduleFunction(checkTransport, {'blue'}, timer.getTime()+FDS.firstGroupTime, FDS.refreshTime)
mist.scheduleFunction(protectCall, {checkTransport,'blue'}, timer.getTime()+FDS.firstGroupTime, FDS.refreshTime)
-- mist.scheduleFunction(checkTransport, {'red'}, timer.getTime()+FDS.firstGroupTime, FDS.refreshTime)
mist.scheduleFunction(protectCall, {checkTransport,'red'}, timer.getTime()+FDS.firstGroupTime, FDS.refreshTime)
-- Check Connected Players
-- mist.scheduleFunction(targetInServer, {}, timer.getTime()+3.5, FDS.sendDataFreq)
mist.scheduleFunction(protectCall, {targetInServer}, timer.getTime()+3.5, FDS.sendDataFreq)
-- Export mission data
if FDS.exportDataSite then
	-- mist.scheduleFunction(exportMisData, {}, timer.getTime()+3.5, FDS.sendDataFreq)
	mist.scheduleFunction(protectCall, {exportMisData}, timer.getTime()+3.5, FDS.sendDataFreq)
end
-- AWACS logic
for _,i in pairs(FDS.coalitionCode) do
	if FDS.awacsMode == 'respawnable' then
		mist.respawnGroup('Blue_AWACS_1',true)
		mist.respawnGroup('Red_AWACS_1',true)
		FDS.resAWACSTime[i][2] = mist.scheduleFunction(protectCall,{respawnAWACSFuel, i},timer.getTime()+FDS.fuelAWACSRestart)
	elseif FDS.awacsMode == 'buyable' then
		mist.scheduleFunction(protectCall,{FDS.checkAWACSStatus},timer.getTime()+4, FDS.awacsRefreshCheck)
	end
	FDS.resTankerTime[i][2] = mist.scheduleFunction(protectCall,{respawnTankerFuel, i},timer.getTime()+FDS.fuelTankerRestart)
	FDS.resMPRSTankerTime[i][2] = mist.scheduleFunction(protectCall,{respawnMPRSTankerFuel, i},timer.getTime()+FDS.fuelTankerRestart)
end
-- JTAC Logic
mist.scheduleFunction(protectCall, {jtacRefresh}, timer.getTime()+4.0, FDS.jtacRefresh)
-- Cargo Fighter Sweep
mist.scheduleFunction(tryCargoFS,{1},timer.getTime()+FDS.cargoFSInterval+FDS.timeMaxVariance, FDS.cargoFSInterval+FDS.timeMaxVariance)
mist.scheduleFunction(tryCargoFS,{2},timer.getTime()+FDS.cargoFSInterval+FDS.timeMaxVariance, FDS.cargoFSInterval+FDS.timeMaxVariance)
-- Exporting units
mist.scheduleFunction(exportCreatedUnits,{},timer.getTime()+FDS.exportUnitsT,FDS.exportUnitsT)
-- Discord Advert
mist.scheduleFunction(discordCall,{},timer.getTime()+FDS.discordAdvertisingTime,FDS.discordAdvertisingTime)
-- Events
world.addEventHandler(FDS.eventHandler)
-- Redis Start
mist.scheduleFunction(startRedisMission, {}, timer.getTime()+FDS.redisStartTime)
-- Clean server
--mist.scheduleFunction(protectCall, {cleanServer},timer.getTime()+FDS.cleanTime,FDS.cleanTime)