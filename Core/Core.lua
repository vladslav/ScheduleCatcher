name = "Schedule Catcher"
author = "Vladslav"
description = [[The script lets you configure maps and nature according to schedule, capture method, pokemon list and others.]]



function getScheduleMap(scheduleList)
	local scheduleMap = {}
	for i=0, 23, 1 do
		if scheduleList[i]["map"] == nil then
			scheduleMap[i] = scheduleMap[i-1]
		else
			scheduleMap[i] = scheduleList[i]
		end
	end
	return scheduleMap
end

require "Core/Lib"
local pf = require "ProShinePathfinder/Pathfinder/MoveToApp"
local toHunt = getTableValues(huntList)
local toWeakMoveIgnore = getTableValues(weakMoveIgnoreList)
local toStatusMoveIgnore = getTableValues(statusMoveIgnoreList)
local scheduleMap = getScheduleMap(scheduleList)
local runStuck = false

-------------------------------------------------------------------------

function checkPokemon()
	if firstPokeAwaysUsable and not isPokemonUsable(1) then
		return false
	elseif scheduleMap[getTime()]["sync"] ~= "" and getUsablePokemonIdWithSynch(scheduleMap[getTime()]["sync"]) == 0 then
		return false
	elseif weakMoveCatchOn and getUsablePokemonIdWithMove(weakMoveList)["id"] == 0 then
		return false
	elseif statusMoveCatchOn and getUsablePokemonIdWithMove(statusMoveList)["id"] == 0 then
		return false
	else
		return true
	end
end

function checkPokeball()
	if refillPokeballOn and minPokeball > getItemQuantity("Pokeball") then
		return false
	else
		return true
	end
end

function usePokeball()
	return useItem("Pokeball") or useItem("Great Ball") or useItem("Ultra Ball") or attack() or sendAnyPokemon() or run()
end

function weakMoveCatch()
	if toWeakMoveIgnore[getOpponentName()] then
		return false
	else
		local usablePokemonIdWithMove = getUsablePokemonIdWithMove(weakMoveList)
		local weakMovePokeId = usablePokemonIdWithMove["id"]
		local weakMove = usablePokemonIdWithMove["move"]
		if weakMovePokeId == 0 then
			return false
		elseif weakMove == "False Swipe" and getOpponentHealthPercent() < 5 then
			return false
		elseif weakMove ~= "False Swipe" and getOpponentHealthPercent() < weakMonveOponentMinHpPercentToAtack then
			return false
		elseif getActivePokemonNumber() ~= weakMovePokeId then
			return sendPokemon(weakMovePokeId) or false
		elseif getActivePokemonNumber() == weakMovePokeId and weakMove == "False Swipe" and getOpponentHealthPercent() >= 5 then
			return useMove(weakMove) or false
		elseif getActivePokemonNumber() == weakMovePokeId and weakMove ~= "False Swipe" and getOpponentHealthPercent() >= weakMonveOponentMinHpPercentToAtack then
			return useMove(weakMove) or false
		else
			return false
		end
	end
end

function statusMoveCatch()
	if toStatusMoveIgnore[getOpponentName()] then
		return false
	else
		local usablePokemonIdWithMove = getUsablePokemonIdWithMove(statusMoveList)
		local statusMovePokeId = usablePokemonIdWithMove["id"]
		local statusMove = usablePokemonIdWithMove["move"]
		if statusMovePokeId == 0 then
			return false
		elseif getActivePokemonNumber() ~= statusMovePokeId then
			return sendPokemon(statusMovePokeId) or false
		elseif ( getActivePokemonNumber() == statusMovePokeId ) and ( getOpponentStatus() ~= "SLEEP" and getOpponentStatus() ~= "PARALIZE" and getOpponentStatus() ~= "POISON" and getOpponentStatus() ~= "BURN" ) then
			return useMove(statusMove) or false
		else
			return false
		end
	end
end

--------------------------------------------------------------------------------------

function onPathAction()
	local map = getMapName()
    if checkPokemon() then
		if checkPokeball() then
			if not swapSynch(scheduleMap[getTime()]["sync"]) then
				if not pf.moveTo(map, scheduleMap[getTime()]["map"]) then
					moveToMapZone(scheduleMap[getTime()]["zone"])
				end
			end
		else
			pf.useNearestPokemart(map, "Pokeball",qtPokeball)
		end
    else
       pf.useNearestPokecenter(map)
    end
end

function onBattleAction()
    if isWildBattle() and ( isOpponentShiny() or (catchUncaught and not isAlreadyCaught()) or toHunt[getOpponentName()] ) then
        if weakMoveCatchOn and not statusMoveCatchOn then
			if not weakMoveCatch() then
					return usePokeball()
				end
		elseif not weakMoveCatchOn and statusMoveCatchOn then
			if not statusMoveCatch() then
				return usePokeball()
			end
		elseif weakMoveCatchOn and statusMoveCatchOn then
			if not weakMoveCatch() then
				if not statusMoveCatch() then
					return usePokeball()
				end
			end
		else
			return usePokeball()
		end
	elseif farmOn then
		if not scheduleMap[getTime()]["ignoreFarm"] then
			if runStuck then
				return attack() or sendUsablePokemon() or sendAnyPokemon() or run()
			else
				return attack() or run() or sendUsablePokemon() or sendAnyPokemon()
			end
		else
			if runStuck then
				return attack() or sendUsablePokemon() or sendAnyPokemon() or run()
			else
				return run() or attack() or sendUsablePokemon() or sendAnyPokemon()
			end
		end
	else
		if runStuck then
			return attack() or sendUsablePokemon() or sendAnyPokemon() or run()
		else
			return run() or attack() or sendUsablePokemon() or sendAnyPokemon()
		end
	end
end

-----------------------------------------------------------------------------------------




function onStart()
	startime = os.time()
	shinyCounter = 0
	pokecenterCounter = 0
	wildCounter = 0	
	pokeballCounter = 0
	startMoney = getMoney()
	pokeFound = getTableValuesZero(huntList)
	if autoEvolveOn then
		enableAutoEvolve()
	else
		disableAutoEvolve()
	end
	log("-----------------------------------------------------------")
	log("----------------------- BOT STARTED -----------------------")
	if isPrivateMessageEnabled() then
		disablePrivateMessage()
		log("-----------------------------------------------------------")
		log("~~~~~~~~~~~~~~ Private messages disabled ~~~~~~~~~~~~~~~~~~")
	end
	log("-----------------------------------------------------------")
	log("~~~~~~~~~~~~~~~~~~~~~~ Started Itens ~~~~~~~~~~~~~~~~~~~~~~")
	log("- Pokedolar: "..tostring(getMoney()))
	log("- Pokeball: "..tostring(getItemQuantity("Pokeball")))
	log("- Great Ball: "..tostring(getItemQuantity("Great Ball")))
	log("- Ultra Ball: "..tostring(getItemQuantity("Ultra Ball")))
	log("-----------------------------------------------------------")
	log("~~~~~~~~~~~~~~~~~~~~~ General Config ~~~~~~~~~~~~~~~~~~~~~~")
	if catchUncaught then
		log("- Catch Uncaught: Enabled")
	else
		log("- Catch Uncaught: Disabled")
	end
	if farmOn then
		log("- Farm: Enabled")
	else
		log("- Farm: Disabled")
	end
	if firstPokeAwaysUsable then
		log("- First Pokemon Aways Usable: Enabled")
	else
		log("- First Pokemon Aways Usable: Disabled")
	end
	if autoEvolveOn then
		log("- Auto Evolve: Enabled")
	else
		log("- Auto Evolve: Disabled")
	end
	if bikePathOn then
		log("- Bike Path: Enabled")
	else
		log("- Bike Path: Disabled")
	end
	if digPathOn then
		log("- Dig Path: Enabled")
	else
		log("- Dig Path: Disabled")
	end
	if fishOn then
		log("- Fishing: Enabled")
	else
		log("- Fishing: Disabled")
	end
	log("-----------------------------------------------------------")
	log("~~~~~~~~~~~~~~~~~~~~~ Map Information ~~~~~~~~~~~~~~~~~~~~~")
	for i=0, 23, 1 do
		log("- Time: "..i)
		log("- Map: "..scheduleMap[i]["map"])
		log("- Zone: "..table.concat(scheduleMap[i]["zone"]," | "))
		log("- Synchronize: "..scheduleMap[i]["sync"])
		if scheduleMap[i]["ignoreFarm"] then
			log("- Ignore Farm: Enabled")
		else
			log("- Ignore Farm: Disabled")
		end
		log("~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~")
	end
	log("-----------------------------------------------------------")
	log("~~~~~~~~~~~~~~~~~~~~~~ Catch Method ~~~~~~~~~~~~~~~~~~~~~~~")
	if weakMoveCatchOn then
		log("- Weak Move Catch: Enabled")
	else
		log("- Weak Move Catch: Disabled")
	end
	if statusMoveCatchOn then
		log("- Status Move Catch: Enabled")
	else
		log("- Status Move Catch: Disabled")
	end
	log("-----------------------------------------------------------")
	log("~~~~~~~~~~~~~~~~~~~~~ Hunted Pokemons ~~~~~~~~~~~~~~~~~~~~~")
	for _,value in pairs(huntList) do
		log("- "..value)
	end
	log("-----------------------------------------------------------")

	if weakMoveCatchOn and getPokemonIdWithMove(weakMoveList) == 0 then
		fatal("- ERROR: NO HAVE POKEMON WITH WEAKMOVE")
	elseif statusMoveCatchOn and getPokemonIdWithMove(statusMoveList) == 0 then
		fatal("- ERROR: NO HAVE POKEMON WITH STATUSMOVE")
	else
		for i=0, 23, 1 do
			if scheduleMap[i]["sync"] ~= "" and getPokemonIdWithSynch(scheduleMap[i]["sync"]) == 0 then
				fatal("- ERROR: NO HAVE POKEMON WITH SYNCHRONIZE "..scheduleMap[i]["sync"].." TO "..i.." HOURS")
			end
		end
	end

end

function onDialogMessage(pokecenter)
	if stringContains(pokecenter, "Would you like me to heal your Pokemon?") then
		pokecenterCounter = pokecenterCounter + 1
	end
end

function onBattleMessage(wild)
	if stringContains(wild, "You can not run away!") then
		runStuck = true
	else
		runStuck = false
	end
	if stringContains(wild, "A Wild SHINY ") then
		shinyCounter = shinyCounter + 1
	elseif stringContains(wild, "You throw") then
		pokeballCounter = pokeballCounter + 1
	else
		found = false
		for _,value in pairs(huntList) do
			if wild == "A Wild [FF9900]"..value.."[-] Attacks!" then
				pokeFound[value] = pokeFound[value] + 1
				found = true
				break
			end
		end
		if not found and stringContains(wild, "A Wild ") then
			wildCounter = wildCounter + 1
		end
	end
end

function onPause()
	log("-----------------------------------------------------------")
	log("----------------------- BOT PAUSED ------------------------")
	log("-----------------------------------------------------------")
	log("~~~~~~~~~~~~~~~~~~~~~~ Current Itens ~~~~~~~~~~~~~~~~~~~~~~")
	log("- Pokedolar: "..tostring(getMoney()))
	log("- Pokeball: "..tostring(getItemQuantity("Pokeball")))
	log("- Great Ball: "..tostring(getItemQuantity("Great Ball")))
	log("- Ultra Ball: "..tostring(getItemQuantity("Ultra Ball")))
	log("-----------------------------------------------------------")
	log("~~~~~~~~~~~~~~~~~~~~~ Hunted Pokemons ~~~~~~~~~~~~~~~~~~~~~")
	for key,value in pairs(pokeFound) do
		log("- "..key..": "..value)
	end
	log("-----------------------------------------------------------")
	log("- Pokeball's used: " .. pokeballCounter)
	log("-----------------------------------------------------------")
	log("- Shinies Caught: " .. shinyCounter)
	log("-----------------------------------------------------------")
	log("- Pokemons encountered: " .. wildCounter)
	log("-----------------------------------------------------------")
	log("- Times in Pokecenter: " .. pokecenterCounter)
	if farmOn then
		log("-----------------------------------------------------------")
		log("- Pokedollars earned: "..tostring(getMoney() - startMoney))
	end
	log("-----------------------------------------------------------")
end

function onStop()
	log("-----------------------------------------------------------")
	log("----------------------- BOT STOPED ------------------------")
	log("-----------------------------------------------------------")
	log("~~~~~~~~~~~~~~~~~~~~~ Hunted Pokemons ~~~~~~~~~~~~~~~~~~~~~")
	for key,value in pairs(pokeFound) do
		log("- "..key..": "..value)
	end
	log("-----------------------------------------------------------")
	log("- Pokeball's used: " .. pokeballCounter)
	log("-----------------------------------------------------------")
	log("- Shinies Caught: " .. shinyCounter)
	log("-----------------------------------------------------------")
	log("- Pokemons encountered: " .. wildCounter)
	log("-----------------------------------------------------------")
	log("- Times in Pokecenter: " .. pokecenterCounter)
	if farmOn then
		log("-----------------------------------------------------------")
		log("- Pokedollars earned: "..tostring(getMoney() - startMoney))
	end
	log("-----------------------------------------------------------")
	endtime = os.time()
	log(string.format("- Bot running time: %.2f", os.difftime(endtime,startime)/3600 ).. " hours")
	log(string.format("- Bot running time: %.2f", os.difftime(endtime,startime)/60 ).. " minutes")
	log("-----------------------------------------------------------")
end