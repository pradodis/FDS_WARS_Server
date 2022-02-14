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
FDS.recordDeliveredPoints = {}
FDS.teamPoints = {}
FDS.zoneSts = {}
FDS.redZones = {'Red Zone 1','Red Zone 2'}
FDS.blueZones = {'Blue Zone 1','Blue Zone 2'}
FDS.randomDropZones = {'randomDrop_1','randomDrop_2','randomDrop_3','randomDrop_4','randomDrop_5','randomDrop_6','randomDrop_7','randomDrop_8','randomDrop_9','randomDrop_10','randomDrop_11','randomDrop_12','randomDrop_13'}
FDS.dropZones = {}
FDS.activeHovers = {}
FDS.retrievedZones = {}
FDS.dropHeliTypes = {'UH-1H','Mi-8MT'}
FDS.blueRelieveZones = {'Sochi-Adler', 'Kalitka', 'Shpora', 'Yunga', 'Vetka', 'Otkrytka'}
FDS.redRelieveZones = {'Maykop-Khanskaya', 'London', 'Dallas', 'Paris', 'Moscow', 'Berlin'}
FDS.resAWACSTime = {
	['blue'] = {'Blue_AWACS_1', 0},
	['red'] = {'Red_AWACS_1', 0}
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

for i,j in  pairs{'blue','red'} do
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
FDS.distMin = 75.
FDS.numberZones = 45
--FDS.exportPath = lfs.currentdir() .. 'fdsServerData\\'
FDS.exportPath = 'C:\\fdsServerData\\'
FDS.killEventNumber = 0
FDS.killEventVector = {}
FDS.sendDataFreq = 2.0
FDS.exportDataSite = true -- use false for non-multiplayer games

-- Rewards
FDS.playerReward = 250.0
FDS.enemyReward = 30.0
FDS.fuelReward = 75.0
FDS.shelterReward = 100.0
FDS.commandPostReward = 100.0
FDS.escortReward = 75.0
FDS.cargoReward = 50.0

FDS.rewardDict = {
	['.Command Center'] = FDS.commandPostReward,
	['Shelter'] = FDS.shelterReward,
	['Fuel tank'] = FDS.fuelReward,
	['FA-18C_hornet'] = FDS.escortReward,
	['C-130'] = FDS.cargoReward,
	['Default'] = FDS.enemyReward
}

-- Transport
FDS.refreshTime = 2700.
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
FDS.respawnAWACSTime = 600.0
FDS.fuelAWACSRestart = 14400.0

-- DropZones
FDS.randomDropValue = 100.
FDS.randomDropTime = 600.
FDS.hoveringAltitude = 100.0
FDS.hoveringRadius = 150.0
FDS.velocityLimit = 10.0
FDS.hoveringResolution = 18
FDS.refreshScan = 2.0
FDS.hoveringTotalTime = 10.0
FDS.positionHist = {}

-- Units per Zone
FDS.InfAK = 0
FDS.InfRPG = 0

FDS.ArmTrucks = 5
FDS.ArmBMP1 = 0
FDS.ArmBMP2 = 0
FDS.ArmT55 = 0
FDS.ArmT72 = 3
FDS.ArmT80 = 5

FDS.AAA = 2
FDS.AATung = 1
FDS.AAStrela1 = 0
FDS.AAStrela2 = 1
FDS.AAIgla = 1
FDS.AATor = 1
FDS.SAM = 0

FDS.unitsInZones = {}
FDS.countUCat = {}
FDS.unitsInZone = {}

FDS.blueunitsInZones = {}
FDS.bluecountUCat = {}
FDS.blueunitsInZone = {}

-- Starting event file
if FDS.exportDataSite then
	lfs.mkdir(FDS.exportPath)
	local file = io.open(FDS.exportPath .. "killRecord.json", "w")
	file:write(nil)
	file:close()
end

-- Switch
function FDS.switch(t,p)
  t.case = function (self,x,p)
    local f=self[x] or self.default
    if f then
      if type(f)=="function" then
        f(x, p, self)
      else
        error("case "..tostring(x).." not a function")
      end
    end
  end
  return t
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
					local msg = {}
					msg.text = gpPN .. ', you can help your team by:\n\n - Attacking ground targets in enemy zones (AG mission)(See map or [radio]>[F10]>[Where to attack]).\n - Attacking the enemy air transports in enemy supply route (AA mission) (See map).\n - Rescuing point around the map with helicopters (Helo rescue mission).\n\n - Killing enemy players in the process is always a good idea!'
					msg.displayTime = 60
					msg.sound = 'Welcome.ogg'
					mist.scheduleFunction(missionCommands.addCommandForGroup,{gpId,'Current War Status',nil, FDS.warStatus, {gpId, gpCoa, gpPN}},timer.getTime()+FDS.wtime)
					mist.scheduleFunction(missionCommands.addCommandForGroup,{gpId,'Where to Attack',nil, FDS.whereStrike, {gpId, gpCoa, gpName}},timer.getTime()+FDS.wtime)
					mist.scheduleFunction(missionCommands.addCommandForGroup,{gpId,'Where to Defend',nil, FDS.whereDefend, {gpId, gpCoa, gpName}},timer.getTime()+FDS.wtime)
					mist.scheduleFunction(missionCommands.addCommandForGroup,{gpId,'Drop Zones',nil, FDS.whereDropZones, {gpId, gpCoa, gpName}},timer.getTime()+FDS.wtime) 
					mist.scheduleFunction(trigger.action.outTextForGroup,{gpId,msg.text,msg.displayTime},timer.getTime()+FDS.wtime)
					mist.scheduleFunction(trigger.action.outSoundForGroup,{gpId,msg.sound},timer.getTime()+FDS.wtime)
					if i == 1 then 
						FDS.teamPoints['red']['Players'][gpPN] = 0
					elseif i == 2 then
						FDS.teamPoints['blue']['Players'][gpPN] = 0
					end
				elseif i == 2 then
					gp = k:getGroup()
					gpId = gp:getID()
					gpCoa = k:getCoalition()
					gpPN = k:getPlayerName()
					gpName = k:getName()
					local msg = {}
					msg.text = gpPN .. ', you can help your team by:\n\n - Attacking ground targets in enemy zones (AG mission)(See map or [radio]>[F10]>[Where to attack]).\n - Attacking the enemy air transports in enemy supply route (AA mission) (See map).\n - Rescuing point around the map with helicopters (Helo rescue mission).\n\n - Killing enemy players in the process is always a good idea!'
					msg.displayTime = 60
					msg.sound = 'Welcome.ogg'
					mist.scheduleFunction(missionCommands.addCommandForGroup,{gpId,'Current War Status',nil, FDS.warStatus, {gpId, gpCoa, gpPN}},timer.getTime()+FDS.wtime)
					mist.scheduleFunction(missionCommands.addCommandForGroup,{gpId,'Where to Attack',nil, FDS.whereStrike, {gpId, gpCoa, gpName}},timer.getTime()+FDS.wtime)
					mist.scheduleFunction(missionCommands.addCommandForGroup,{gpId,'Where to Defend',nil, FDS.whereDefend, {gpId, gpCoa, gpName}},timer.getTime()+FDS.wtime)
					mist.scheduleFunction(missionCommands.addCommandForGroup,{gpId,'Drop Zones',nil, FDS.whereDropZones, {gpId, gpCoa, gpName}},timer.getTime()+FDS.wtime)
					mist.scheduleFunction(trigger.action.outTextForGroup,{gpId,msg.text,msg.displayTime},timer.getTime()+FDS.wtime)
					mist.scheduleFunction(trigger.action.outSoundForGroup,{gpId,msg.sound},timer.getTime()+FDS.wtime)

					if i == 1 then 
						FDS.teamPoints['red']['Players'][gpPN] = 0
					elseif i == 2 then
						FDS.teamPoints['blue']['Players'][gpPN] = 0
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
				table.insert(auxListName, {['name'] = y[1], ['type'] = y[4], ['unitName'] = y[5], ['isAlive'] = isAlive})
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
	FDS.exportVector['missionTime'] = {
		['elapsed'] = math.floor(timer.getTime()), 
		['current'] = math.floor(timer.getAbsTime()), 
		['initial'] = math.floor(timer.getTime0())
	}
	if FDS.exportDataSite then
		local file = io.open(FDS.exportPath .. "currentStats.json", "w")
		jsonExport = net.lua2json(FDS.exportVector)
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

function bombingRun(coa)
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

function guidedBombingRun(coa)
    local zone = ''
	local qty = 0
	FDS.bomberQty[coa] = FDS.bomberQty[coa] + 1
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
		gp = Group.getByName(bombingRunTable[zone][2])
		gPData = mist.getGroupData(bombingRunTable[zone][2],true)
		gpR = mist.getGroupRoute(gp:getName(),true)
		new_GPR = mist.utils.deepCopy(gpR)
		new_gPData = mist.utils.deepCopy(gPData)
		randomTgt = {}
		for elementos = 1, #tgtObj[bombingRunTable[zone][3]][bombingRunTable[zone][4]] do 
			randomTgt[elementos] = elementos
		end
		for multiTgt = 1, FDS.bomberTargetsNumber do
			if #randomTgt == 0 then
				for elementos = 1, #tgtObj[bombingRunTable[zone][3]][bombingRunTable[zone][4]] do 
					randomTgt[elementos] = elementos
				end
			end
			local selection = math.random(1, #randomTgt)
			local selTgt = tgtObj[bombingRunTable[zone][3]][bombingRunTable[zone][4]][randomTgt[selection]][2]
			table.remove(randomTgt,selection)
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
	for _, i in pairs({'blue','red'}) do
		if i == 'blue' then
			for _,j in pairs(FDS.blueZones) do
				local unitQtyBlue = 0
				local structureQtyBlue = 0
				if FDS.zoneSts.blue[j] == 'Hot' then 
					stsMsg = tostring(#tgtObj[i][j]) 
					for _,k in pairs(tgtObj.blue[j]) do
						if Group.getByName(k[1]) then
							-- If it is unit
							unitQtyBlue = unitQtyBlue + 1
						else
							-- If it is structure
							structureQtyBlue = structureQtyBlue + 1
						end
					end
				else 
					stsMsg = 'Cleared.' 
				end
				msg.text = msg.text .. j .. ': ' .. stsMsg .. ' -- Units: '.. unitQtyBlue .. '  Structures: ' .. structureQtyBlue .. '\n'
			end
		else
			for _,j in pairs(FDS.redZones) do
				local unitQtyRed = 0
				local structureQtyRed = 0
				if FDS.zoneSts.red[j] == 'Hot' then 
					stsMsg = tostring(#tgtObj[i][j]) 
					for _,k in pairs(tgtObj.red[j]) do
						if Group.getByName(k[1]) then
							-- If it is unit
							unitQtyRed = unitQtyRed + 1
						else
							-- If it is structure
							structureQtyRed = structureQtyRed + 1
						end
					end
				else 
					stsMsg = 'Cleared.' 
				end
				msg.text = msg.text .. j .. ': ' .. stsMsg .. ' -- Units: '.. unitQtyRed .. '  Structures: ' .. structureQtyRed .. '\n'
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
		msg.text = msg.text .. 'Base Points: ' .. tostring(FDS.teamPoints.blue.Base) .. '\nYour plane has ' .. tostring(FDS.teamPoints.blue['Players'][g_id[3]]) .. ' points.'
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
		msg.text = msg.text .. 'Base Points: ' .. tostring(FDS.teamPoints.red.Base) .. '\nYour plane has ' .. tostring(FDS.teamPoints.red['Players'][g_id[3]]) .. ' points.'
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
			msg.text = msg.text .. j .. ': ' .. stsMsg .. ' remaining targets -- '.. unitQty .. ' units and ' .. structureQty .. ' structures.' .. '\n'
			
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
			msg.text = msg.text .. j .. ': ' .. stsMsg .. ' remaining targets -- '.. unitQty .. ' units and ' .. structureQty .. ' structures.' .. '\n'
			
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
		trigger.action.smoke(createPoint,3)
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
			for index, data in pairs(FDS.recordDeliveredPoints) do
				if i.ucid == data.ucid then
					newID = false
					if FDS.recordDeliveredPoints[index]['deliveries'] ~= nil then
						table.insert(FDS.recordDeliveredPoints[index]['deliveries'], {['name']= i.name,['value']= FDS.teamPoints[coa]['Players'][_initEnt:getPlayerName()]})
					else
						FDS.recordDeliveredPoints[index]['deliveries'] = {}
					end
				end
			end
            if newID then 
                table.insert(FDS.recordDeliveredPoints, {['ucid'] = i.ucid, ['deliveries'] = {['name']= i.name,['value']= FDS.teamPoints[coa]['Players'][_initEnt:getPlayerName()], ['aircraft'] = _initEnt:getDesc().typeName}})
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

function ping(a)
	local msgPing = {}
	msgPing.text = 'Debug -> argument ' .. a
	msgPing.displayTime = 5
	msgPing.sound = 'Msg.ogg'
	trigger.action.outText(msgPing.text, msgPing.displayTime)
	trigger.action.outSound(msgPing.sound)
end

-- Event Handler
FDS.eventActions = FDS.switch {
	[world.event.S_EVENT_BIRTH] = function(x, param)
		local _event = param.event
		local _initEnt = _event.initiator
		
		if _initEnt:getCategory() == Object.Category.UNIT and _initEnt:getPlayerName() ~= nil then 
			local msg = {}
			msg.text = _initEnt:getPlayerName() .. ', you can help your team by:\n\n - Attacking ground targets in enemy zones (AG mission)(See map or [radio]>[F10]>[Where to attack]).\n - Attacking the enemy air transports in enemy supply route (AA mission) (See map).\n - Rescuing point around the map with helicopters (Helo rescue mission).\n\n - Killing enemy players in the process is always a good idea!'
			msg.displayTime = 60
			msg.sound = 'Welcome.ogg'
			
			pcall(missionCommands.removeItemForGroup,mist.DBs.humansByName[_initEnt:getName()]['groupId'],'Current War Status')
			mist.scheduleFunction(missionCommands.addCommandForGroup,{mist.DBs.humansByName[_initEnt:getName()]['groupId'],'Current War Status',nil, FDS.warStatus, {_initEnt:getGroup().id_, _initEnt:getCoalition(), _initEnt:getPlayerName()}},timer.getTime()+FDS.wtime)
			mist.scheduleFunction(missionCommands.addCommandForGroup,{mist.DBs.humansByName[_initEnt:getName()]['groupId'],'Where to Attack',nil, FDS.whereStrike, {_initEnt:getGroup().id_, _initEnt:getCoalition(), _initEnt:getName()}},timer.getTime()+FDS.wtime)
			mist.scheduleFunction(missionCommands.addCommandForGroup,{mist.DBs.humansByName[_initEnt:getName()]['groupId'],'Where to Defend',nil, FDS.whereDefend, {_initEnt:getGroup().id_, _initEnt:getCoalition(), _initEnt:getName()}},timer.getTime()+FDS.wtime)
			mist.scheduleFunction(missionCommands.addCommandForGroup,{mist.DBs.humansByName[_initEnt:getName()]['groupId'],'Drop Zones',nil, FDS.whereDropZones, {_initEnt:getGroup().id_, _initEnt:getCoalition(), _initEnt:getName()}},timer.getTime()+FDS.wtime)
			mist.scheduleFunction(trigger.action.outTextForGroup,{_initEnt:getGroup().id_,msg.text,msg.displayTime},timer.getTime()+FDS.wtime)
			mist.scheduleFunction(trigger.action.outSoundForGroup,{_initEnt:getGroup().id_,msg.sound},timer.getTime()+FDS.wtime)

			if _initEnt:getCoalition() == 1 then 
				FDS.teamPoints['red']['Players'][_initEnt:getPlayerName()] = 0
			elseif _initEnt:getCoalition() == 2 then
				FDS.teamPoints['blue']['Players'][_initEnt:getPlayerName()] = 0
			end
		end
	end,
	[world.event.S_EVENT_HIT] = function(x, param)
		local _event = param.event
		local _init = _event.initiator
		local _currentTgt = _event.target
		local playerCheck1 = pcall(FDS.playerCheck,_init)
		local playerCheck2 = pcall(FDS.playerCheck,_currentTgt)
		if playerCheck1 and playerCheck2 and _init and _init:getPlayerName() and _currentTgt and _currentTgt:getPlayerName() then
			FDS.lastHits[_currentTgt:getPlayerName()] = {_init:getPlayerName(),_init:getID(),false}
		end
	end,
	--[world.event.S_EVENT_SHOT] = function(x, param)
	--	local _event = param.event
	--	local _init = _event.initiator
	--	local _weap = _event.weapon
	--	local weaponTarget = _weap:getTarget()
	--	if _weap.Category and _weap.Category == 1 and _init:getPlayerName() and weaponTarget:getPlayerName() then
	--		FDS.currentEngagements[weaponTarget:getPlayerName()] = {_init:getPlayerName(),0}
	--		FDS.currentEngagements[weaponTarget:getPlayerName()][2] = mist.scheduleFunction(removeEngagement, {weaponTarget:getPlayerName()},timer.getTime())
	--	end
	--end,
	[world.event.S_EVENT_CRASH] = function(x, param)
		local _event = param.event
		local _initEnt = _event.initiator
		local currV = 0
		if _initEnt:getPlayerName() then
			if FDS.lastHits[_initEnt:getPlayerName()] ~= nil then
				FDS.lastHits[_initEnt:getPlayerName()] = nil
			end
			for i,j in pairs(FDS.lastHits) do
				if _initEnt:getPlayerName() == j[1] then
					FDS.lastHits[i] = nil
				end
			end
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
	end,
	[world.event.S_EVENT_PLAYER_LEAVE_UNIT] = function(x, param)
		local _event = param.event
		local _initEnt = _event.initiator
		local currV = 0
		if _initEnt and _initEnt:getPlayerName() then
			for _,i in pairs(FDS.teamPoints) do
				for name,value in pairs(i['Players']) do
					if _initEnt:getPlayerName() == name then
						currV = value
					end
				end
			end
			for i,j in pairs(FDS.lastHits) do
				if _initEnt:getPlayerName() == j[1] then
					FDS.lastHits[i] = nil
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
			if FDS.lastHits[_initEnt:getPlayerName()] ~= nil then
				--if _initEnt:getCoalition() then
				--	initCoa = _initEnt:getCoalition()
				--	targetCoa = _targetEnt:getCoalition()
				--end

				--Exporting event record
				if FDS.exportDataSite then
					local file = io.open(FDS.exportPath .. "killRecord.json", "w")
					FDS.killEventNumber = FDS.killEventNumber + 1
					eventExport = {}
					eventExport['initiator'] = FDS.lastHits[_initEnt:getPlayerName()][1]
					eventExport['target'] = _initEnt:getPlayerName()
					eventExport['weapon'] = '** LEFT **'
					FDS.killEventVector[FDS.killEventNumber] = eventExport
					jsonExport = net.lua2json(FDS.killEventVector)
					file:write(jsonExport)
					file:close()
				end

				local msgKillLeft = {}
				msgKillLeft.displayTime = 20
				msgKillLeft.sound = 'Msg.ogg'
				FDS.teamPoints[FDS.coalitionCode[_initEnt:getCoalition()]]['Players'][FDS.lastHits[_initEnt:getPlayerName()][1]] = FDS.teamPoints[FDS.coalitionCode[_initEnt:getCoalition()]]['Players'][FDS.lastHits[_initEnt:getPlayerName()][1]] + FDS.playerReward
				msgKillLeft.text = 'You receive: ' .. tostring(FDS.playerReward) .. ' points for your kill.'
				trigger.action.outTextForGroup(FDS.lastHits[_initEnt:getPlayerName()][2], msgKillLeft.text, msgKillLeft.displayTime)
				trigger.action.outSoundForGroup(FDS.lastHits[_initEnt:getPlayerName()][2],msgKillLeft.sound)
				FDS.lastHits[_initEnt:getPlayerName()][3] = true
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
		if initCoaCheck then
			initCoa = _initEnt:getCoalition()
		end
		if _initEnt:getPlayerName() then
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
				if FDS.lastHits[_initEnt:getPlayerName()] ~= nil and (flagBlue or flagRed) then
					FDS.lastHits[_initEnt:getPlayerName()] = nil
				end
				if initCheck and initCoaCheck and initCoa == 2 and flagBlue and _initEnt:getPlayerName() and FDS.teamPoints.blue['Players'][_initEnt:getPlayerName()] > 0 then
					local msgLand = {}
					local gp = _initEnt:getGroup()
					msgLand.text = 'You land at ' .. _local:getName() .. '. You deliver ' .. FDS.teamPoints.blue['Players'][_initEnt:getPlayerName()] .. ' points to your team.' 
					msgLand.displayTime = 20  
					msgLand.sound = 'Msg.ogg'
					trigger.action.outTextForGroup(gp:getID(), msgLand.text, msgLand.displayTime)
					trigger.action.outSoundForGroup(gp:getID(),msgLand.sound)
					
					-- Record land points
					recordLandPoints(_initEnt, FDS.trueCoalitionCode[initCoa])

					FDS.teamPoints.blue.Base = FDS.teamPoints.blue.Base + FDS.teamPoints.blue['Players'][_initEnt:getPlayerName()]
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
		if FDS.exportDataSite then
			local file = io.open(FDS.exportPath .. "killRecord.json", "w")
			FDS.killEventNumber = FDS.killEventNumber + 1
			eventExport = mist.utils.deepCopy(_event)
			if initCheck and eventExport['initiator'] ~= nil and eventExport['initiator']:getPlayerName() ~= nil then 
				eventExport['initiatorPlayerName'] = eventExport['initiator']:getPlayerName()
			end
			if eventExport['initiator'] ~= nil and eventExport['initiator']:getDesc() then 
				eventExport['initiatorDesc'] = eventExport['initiator']:getDesc()
				eventExport['initiatorName'] = eventExport['initiator']:getName()
			end
			if targetCheck and eventExport['target'] ~= nil and eventExport['target']:getPlayerName() ~= nil then 
				eventExport['targetPlayerName'] = eventExport['target']:getPlayerName()
			end
			if eventExport['target'] ~= nil and eventExport['target']:getDesc() then 
				eventExport['targetDesc'] = eventExport['target']:getDesc()
				eventExport['targetName'] = eventExport['target']:getName()
			end
			if eventExport['weapon'] ~= nil and eventExport['weapon']:getDesc() then 
				eventExport['weaponDesc'] = eventExport['weapon']:getDesc()
				eventExport['weaponName'] = eventExport['weapon']:getName()
			end
			FDS.killEventVector[FDS.killEventNumber] = eventExport
			jsonExport = net.lua2json(FDS.killEventVector)
			file:write(jsonExport)
			file:close()
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
		if initCheck and initCoaCheck and targetCoaCheck and initCoa ~= targetCoa then
			local plName = _initEnt:getPlayerName()
			local plGrp = _initEnt:getGroup()
			local plID = plGrp:getID()

			for i,j in pairs(FDS.teamPoints) do
				for k,w in pairs(FDS.teamPoints[i]['Players']) do
					if plName == k then
						local msgKill = {}
						msgKill.displayTime = 20
						msgKill.sound = 'Msg.ogg'
						if targetCheck == false then
							FDS.teamPoints[i]['Players'][k] = FDS.teamPoints[i]['Players'][k] + FDS.rewardDict[rewardType]
							msgKill.text = 'You receive: ' .. tostring(FDS.rewardDict[rewardType]) .. ' points for your kill.'							
						elseif _targetEnt:getPlayerName() ~= nil then 
							if FDS.lastHits[_targetEnt:getPlayerName()] ~= nil then
								if FDS.lastHits[_targetEnt:getPlayerName()][3] == true then
									FDS.lastHits[_targetEnt:getPlayerName()] = nil
								else
									FDS.lastHits[_targetEnt:getPlayerName()] = nil
									FDS.teamPoints[i]['Players'][k] = FDS.teamPoints[i]['Players'][k] + FDS.playerReward
									msgKill.text = 'You receive: ' .. tostring(FDS.playerReward) .. ' points for your kill.'
									trigger.action.outTextForGroup(plID, msgKill.text, msgKill.displayTime)
									trigger.action.outSoundForGroup(plID,msgKill.sound)
								end
							else
								FDS.teamPoints[i]['Players'][k] = FDS.teamPoints[i]['Players'][k] + FDS.playerReward
								msgKill.text = 'You receive: ' .. tostring(FDS.playerReward) .. ' points for your kill.'
								trigger.action.outTextForGroup(plID, msgKill.text, msgKill.displayTime)
								trigger.action.outSoundForGroup(plID,msgKill.sound)
							end
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

			pcall(killDCSProcess,{})
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
									trigger.action.setUserFlag(901, true)
									msgfinal.text = 'Red Team is victorious! Restarting Server in 60 seconds. It is recommended to disconnect to avoid DCS crash.'
									msgfinal.displayTime = 20  
									msgfinal.sound = 'victory_Lane.ogg'
									trigger.action.outText(msgfinal.text, msgfinal.displayTime)
									trigger.action.outSoundForCoalition(1,msgfinal.sound)
									trigger.action.outSoundForCoalition(2,'zone_killed.ogg')
									playWarning = false
								end	
							end
							if playWarning then
								local msgfinal = {}  
								msgfinal.text = 'Warning! ' .. j .. ' is under attack.'
								msgfinal.displayTime = 30  
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
									trigger.action.setUserFlag(900, true)
									msgfinal.text = 'Blue Team is victorious! Restarting Server in 60 seconds. It is recommended to disconnect to avoid DCS crash.'
									msgfinal.displayTime = 20
									msgfinal.sound = 'victory_Lane.ogg'
									trigger.action.outText(msgfinal.text, msgfinal.displayTime)
									trigger.action.outSoundForCoalition(2,msgfinal.sound)
									trigger.action.outSoundForCoalition(1,'zone_killed.ogg')
									playWarning = false
								end
							end
							if playWarning then
								local msgfinal = {}  
								msgfinal.text = 'Warning! ' .. j .. ' is under attack.'
								msgfinal.displayTime = 30  
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
			if _initEnt:getPlayerName() then
				for i,j in pairs(FDS.lastHits) do
					if _initEnt:getPlayerName() == j[1] then
						FDS.lastHits[i] = nil
					end
				end
			end
			local plName = _initEnt:getPlayerName()
			for i,j in pairs(FDS.teamPoints) do
				for k,w in pairs(FDS.teamPoints[i]['Players']) do
					if plName == k then
						FDS.teamPoints[i]['Players'][k] = 0.0
					end
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
	--msgfinal.text = tostring(_event.id)
	--msgfinal.displayTime = 5 
	--msgfinal.sound = 'Msg.ogg' 
	--trigger.action.outText(msgfinal.text, msgfinal.displayTime)
	table.insert(FDS.exportVector,'evento')
	FDS.eventActions:case(_event.id, {event = _event})
end

-- Main
-- Creating Bases, Zones and SAMs
mist.scheduleFunction(creatingBases, {},timer.getTime()+1)
-- Updating Players
mist.scheduleFunction(checkPlayersOn, {},timer.getTime()+2,5)
-- Starting check drop routine
mist.scheduleFunction(checkDropZones, {},timer.getTime()+3,300)
-- Hover checker
mist.scheduleFunction(detectHover, {},timer.getTime()+4,FDS.refreshScan)
-- Random drop manager
mist.scheduleFunction(createRandomDrop, {}, timer.getTime()+5, FDS.randomDropTime)
-- Transport caller
mist.scheduleFunction(checkTransport, {'blue'}, timer.getTime()+FDS.firstGroupTime, FDS.refreshTime)
mist.scheduleFunction(checkTransport, {'red'}, timer.getTime()+FDS.firstGroupTime, FDS.refreshTime)
-- Export mission data
if FDS.exportDataSite then
	mist.scheduleFunction(exportMisData, {}, timer.getTime()+6, FDS.sendDataFreq)
end

for _,i in pairs(FDS.coalitionCode) do
	FDS.resAWACSTime[i][2] = mist.scheduleFunction(respawnAWACSFuel, {i},timer.getTime()+FDS.fuelAWACSRestart)
end

--Events
world.addEventHandler(FDS.eventHandler)

function createVehicle()
	local route = {}
	route.points={
		[1] = rou[1],
		[2] = rou[2]
		}
	
	local unitDesc = {}
	unitDesc = {}
	unitDesc.x = -107014.61718741
	unitDesc.y = 426438.43749992  
	unitDesc.type = 'T-80UD'
	unitDesc.skill = 'Ace'
	unitDesc.route = route
	
	local unitDesc2 = {}
	unitDesc2 = {}
	unitDesc2.x = -107034.61718741
	unitDesc2.y = 426438.43749992  
	unitDesc2.type = 'ZSU-23-4 Shilka'
	unitDesc2.skill = 'Ace'
	unitDesc.route2 = route
	

	local var = {}
	var.units = {
		[1] = unitDesc,
		[2] = unitDesc2
		}
	var.country = 1
	var.category = 2
	uni = mist.dynAdd(var)
	return uni
end

function rota()
	zones = mist.DBs.zonesByName

	trueRoute = {}
	for i = 1,8,1 do
		trueRoute[i] = {}
		trueRoute[i].action = "Off Road"
		trueRoute[i].type = "Turning Point"
		trueRoute[i].speed = 4.0
		trueRoute[i].form = "Vee"
		trueRoute[i].x = zones[FDS.blueZones[1]]["point"].x + zones[FDS.blueZones[1]]["radius"]*math.cos(i*2*3.1415/8)
		trueRoute[i].y = zones[FDS.blueZones[1]]["point"].z + zones[FDS.blueZones[1]]["radius"]*math.sin(i*2*3.1415/8)
	end
	
	--mist.ground.patrol('UKRAINE gnd 98')
	mist.goRoute('UKRAINE gnd 97', {trueRoute[1],trueRoute[2]})
end

function controlAA()
	number = 0
	wpTasks = {}
	staticObj = {}
	taskNumber = 1
	gp = Group.getByName('Molde_blue_AG')
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
	
	mist.goRoute('USA air 7',new_GPR)
	return new_GPR
end