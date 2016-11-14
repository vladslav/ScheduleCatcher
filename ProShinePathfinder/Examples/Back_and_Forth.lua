name = "Back and Forth"
author = "Melt"

description = [[Example moving back and forth between two pokecenters]]

local PathFinder = require "Pathfinder/MoveToApp" -- requesting table with methods
local dest = nil
local map = nil
--[[
----- Check out settings in s.lua -------------------------------
------------------
moveTo(dest) --> Main function for moving to dest. true if destination is not reached, false when done. Need to be called multiple times.
moveToPC()   --> Move to nearest Pokecenter
ResetPath() --> reseting the current Path, used in onStop()
SolveDialog(message, PathFinder) --> allow the bot interact with NPC maps

--> Possible Setting Calls (Bike and Dig are set depending of Bot item/pokemons)
    enableBikePath()
    disableBikePath()
    enableDigPath()
    disableDigPath()
------------------]]

function onPathAction()
    map = getMapName()
    if dest then
        if PathFinder.moveTo(map, dest) then
            return
        else
            dest = nil
            log("destination reached.")
        end
    end
    if map == "Pokecenter Oldale Town" then
        log("Moving to Ever Grande City")
        dest = "Pokecenter Ever Grande City"
    elseif map == "Pokecenter Ever Grande City" then
        log("Moving to Pokecenter Oldale Town")
        dest = "Pokecenter Oldale Town"
    else dest = "Pokecenter Ever Grande City" log("Moving to Pokecenter Ever Grande City")
    end
    move = PathFinder.moveTo(map, dest)
end

function onBattleAction()
    run()
end
