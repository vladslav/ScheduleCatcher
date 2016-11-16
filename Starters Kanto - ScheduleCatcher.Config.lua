--###############################################################################################################
--NO EDIT!!!!!!! =====================================================
scheduleList = {} for i=0, 23, 1 do scheduleList[i] = {["map"]=nil, ["zone"]=nil, ["sync"]=nil, ["ignoreFarm"]=nil} end
--###############################################################################################################


--###############################################################################################################
--General config =====================================================
catchUncaught = true		--true/false Capture Uncaught Pokemons
farmOn = true				--true/false Kill Pokemons
firstPokeAwaysUsable = true	--true/false First Pokemon Aways Usable
autoEvolveOn = true			--true/false Auto Evolve
bikePathOn = true			--true/false Bike Path
digPathOn = true			--true/false Dig Path


--###############################################################################################################
--Refill Pokeball config =============================================

refillPokeballOn = true		--true/false auto refill Pokeball
minPokeball = 100			--minimum quantity of Pokeball
qtPokeball = 50				--quantity to buy


--###############################################################################################################
--Catch config =======================================================

weakMoveCatchOn = true		--true/false Weak Move to Catch
statusMoveCatchOn = false	--true/false Status Move to Catch

--List of Weak Move
weakMoveList = {"False Swipe"}
--Minimum HP percentage of oponent to use weakMove, if weakMove = "False Swipe" minimun is 5%.
weakMonveOponentMinHpPercentToAtack = 20
--Ignored Pokemon List by Weak Move
weakMoveIgnoreList = { "Eevee", "Beldum", "Sableye" }

--List of Status Move
statusMoveList = {"Spore","Sleep Powder","Lovely Kiss","Hypnosis","Sing","Thunder Wave","Glare","Stun Spore"}
--Ignored Pokemon List by Status Move
statusMoveIgnoreList = {}


--###############################################################################################################
--Pokemon Hunt List====================================================

huntList = { "Squirtle", "Bulbasaur", "Chansey", "Snorlax", "Lapras", "Charmander", "Magmar" }


--###############################################################################################################
--Schedule Hunt Map and Synchronize Config ============================

--Time: Number of hours
--Zone: {"grass"} / {"water"} / {x1, y1, x2, y2}
--Sync: Nature name or "" to disabled
--IgnoreFarm: Ignore "farmOn = true"

--scheduleList[Time]["map"] = "map name"
--scheduleList[Time]["zone"] = {"zone hunt"}
--scheduleList[Time]["sync"] = "sync name"
--scheduleList[Time]["ignoreFarm"] = true/false

--If there is no time configured, will be cloned the configuration from the previous hour.

--Time 0 is required setting
--Time 00:00 ~ 00:59
scheduleList[0]["map"] = "Safari Area 2"
scheduleList[0]["zone"] = {"grass"}
scheduleList[0]["sync"] = "Bold"
scheduleList[0]["ignoreFarm"] = true

--Time 04:00 ~ 04:59
scheduleList[4]["map"] = "Vermilion City"
scheduleList[4]["zone"] = {"water"}
scheduleList[4]["sync"] = "Bold"
scheduleList[4]["ignoreFarm"] = false

--Time 12:00 ~ 12:59
scheduleList[12]["map"] = "Cinnabar mansion 3_A"
scheduleList[12]["zone"] = {1,14,14,25}
scheduleList[12]["sync"] = "Timid"
scheduleList[12]["ignoreFarm"] = false

--Time 20:00 ~ 20:59
scheduleList[20]["map"] = "Safari Area 2"
scheduleList[20]["zone"] = {"grass"}
scheduleList[20]["sync"] = "Bold"
scheduleList[20]["ignoreFarm"] = true


--###############################################################################################################
--NO EDIT!!!!!!! =====================================================
dofile "Core/Core.lua"
--###############################################################################################################