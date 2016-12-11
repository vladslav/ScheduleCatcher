-------------------------------------------------------------------------------------------------------------
-- LIB FUNCTIONS

-- TRY CATCH --
function ifNotThen(anything, call)
	if not anything then
		return call
	end
end

 -- SWAP TWO VAR --
function swapVar(v1, v2)
	local tmp = v1
	v1 = v2
	v2 = tmp
end

function print_r ( t ) 
    local print_r_cache={}
    local function sub_print_r(t,indent)
        if (print_r_cache[tostring(t)]) then
            log(indent.."*"..tostring(t))
        else
            print_r_cache[tostring(t)]=true
            if (type(t)=="table") then
                for pos,val in pairs(t) do
                    if (type(val)=="table") then
                        log(indent.."["..pos.."] => "..tostring(t).." {")
                        sub_print_r(val,indent..string.rep(" ",string.len(pos)+8))
                        log(indent..string.rep(" ",string.len(pos)+6).."}")
                    else
                        log(indent.."["..pos.."] => "..tostring(val))
                    end
                end
            else
                log(indent..tostring(t))
            end
        end
    end
    sub_print_r(t,"  ")
end

-------------------------------------------------------------------------------------------------------------
-- GAME FUNCTIONS

-- RETURN ID OF POKEMON WITH THE ItemName --
function getPokemonIdWithItem(ItemName)	
	for pokemonId=1, getTeamSize(), 1 do
		if getPokemonHeldItem(pokemonId) == ItemName then
			return pokemonId
		end
	end
	return 0
end

-- RETURN ID OF POKEMON WITH THE Move --
function getPokemonIdWithMove(move, joy) -- optional parameter happiness
    joy = joy or 0
    for i = 1, getTeamSize() do
        if hasMove(i, move) and getPokemonHappiness(i) >= joy then
            return i
        end
    end
    return false
end

-- RETURN TABLE WITH FIRST USABLE POKEMON ID AND MOVE OF MoveList --
function getUsablePokemonIdWithMove(MoveList)
	local usablePokemonIdWithMove = {}
	usablePokemonIdWithMove["id"] = 0
	usablePokemonIdWithMove["move"] = nil
	for i=1, getTeamSize(), 1 do
		for _,Move in pairs(MoveList) do
			if hasMove(i, Move) and getRemainingPowerPoints(i, Move) >= 1 and isPokemonUsable(i) then
				usablePokemonIdWithMove["id"] = i
				usablePokemonIdWithMove["move"] = Move
				return usablePokemonIdWithMove
			end
		end
	end
	return usablePokemonIdWithMove
end

-- RETURN ID OF FIRST POKEMON WITH MOVE OF MoveList --
function getPokemonIdWithMove(MoveList)
	for i=1, getTeamSize(), 1 do
		for _,Move in pairs(MoveList) do
			if hasMove(i, Move) then
				return i
			end
		end
	end
	return 0
end

-- RETURN ID OF FIRST USABLE POKEMON WITH SYNCHRONIZE AND Nature --
function getUsablePokemonIdWithSynch(Nature)
	for i=1, getTeamSize(), 1 do
		if getPokemonAbility(i) == "Synchronize" and getPokemonNature(i) == Nature and isPokemonUsable(i) then
			return i
		end
	end
	return 0
end

-- RETURN ID OF FIRST POKEMON WITH SYNCHRONIZE AND Nature --
function getPokemonIdWithSynch(Nature)
	for i=1, getTeamSize(), 1 do
		if getPokemonAbility(i) == "Synchronize" and getPokemonNature(i) == Nature then
			return i
		end
	end
	return 0
end

-- RETURN ID OF FIRST USABLE POKEMON --
function getFirstUsablePokemonId()
	for i=1, getTeamSize(), 1 do
		if isPokemonUsable(i) then
			return i
		end
	end
	return 0
end

-- USE MOUNT --
function useMount(M)
	local mount = M or "Bicycle"
	if hasItem(mount) then
		if not isMounted() and not isSurfing() and isOutside() then
			return useItem(mount)
		else
			return true
		end
	else
		return false
	end
end

-- IN RECTANGLE --
function inRectangle(UpperX, UpperY, LowerX, LowerY)
	local ActX = getPlayerX()
	local ActY = getPlayerY()
	if (ActX >= UpperX and ActX <= LowerX) and (ActY >= UpperY and ActY <= LowerY) then
		return true
	else
		return false
	end
end

-- RETURN DISTANCE OF TWO COORDINATES
function getDistance(xa, ya, xb, yb)
    local xDist = xb - xa
    local yDist = yb - ya
    return math.sqrt((xDist ^ 2) + (yDist ^ 2))
end

-- MOVE TO mapZone {"grass"} / {"water"} / {"cave"} / {x1, y1, x2, y2}
function moveToMapZone(mapZone)
	if mapZone[1] == "grass" then
		return moveToGrass()
	elseif mapZone[1] == "water" then
		return moveToWater()
	elseif mapZone[1] == "cave" then
		return moveToNormalGround()
	elseif getTableLength(mapZone) == 4 then
		return moveToRectangle(mapZone[1], mapZone[2], mapZone[3], mapZone[4])
	else
		fatal("Error: Zone Map Config - { {"..table.concat(mapZone,"}, {").."} }")
	end
end

-- SWAP TO THE FIRST USABLE POKEMON WITH SYNCHRONIZE AND Nature --
function swapSynch(nature)
	if nature ~= "" then
		local synchPokeId = getUsablePokemonIdWithSynch(nature)
		if synchPokeId ~= 1 and synchPokeId ~= 0 then
			return swapPokemon(1, synchPokeId)
		else
			return false
		end
	else
		return false
	end
end


-------------------------------------------------------------------------------------------------------------
-- STRING FUNCTIONS

-- SEARCH STRING needle IN haystack
function inString(haystack, needle)
	haystack = upper(haystack)
	needle   = upper(needle)
	if find(haystack, needle) ~= nil then
		return true
	end
	return false
end

-- STRING SPLIT --> RETURN ARRAY TABLE --
function splitString(s, delimiter)
    local result = {}
    for match in (s..delimiter):gmatch("(.-)"..delimiter) do
        insert(result, match)
    end
    return result
end


-------------------------------------------------------------------------------------------------------------
--TABLE FUNCTIONS

-- CHECK IF val IN TABLE --
function inTable (T, val)
   for k, v in pairs (T) do
       if v == val then
           return true
       end
   end
   return false
end

-- RETURN TABLE OF VALUES USING KEYS OF T
function getTableKeys(T)
    local tab = {}
    for k, v in pairs(T) do
        insert(tab, k)
    end
    return tab
end

-- RETURN TABLE OF KEYS = true USING THE VALUES OF T --
function getTableValues(T)
	local tab = {}
	for _, v in pairs(T) do tab[v] = true end
	return tab
end

-- RETURN TABLE OF KEYS = 0 USING THE VALUES OF T --
function getTableValuesZero(T)
	local tab = {}
	for _, v in pairs(T) do tab[v] = 0 end
	return tab
end

-- RETURN TABLE LENGTH --
function getTableLength(T)
	local count = 0
	for _ in pairs(T) do count = count + 1 end
	return count
end

 -- SORT TABLE KEYS BY ALPHA OR F AS ALTERNATIVE ORDER --
function pairsByKeys(t, f)
	local a = {}
	for n in pairs(t) do insert(a, n) end
	sort(a, f)
	local i = 0      -- iterator variable
	local iter = function ()   -- iterator function
		i = i + 1
		if a[i] == nil then return nil
		else return a[i], t[a[i]]
    	end
	end
	return iter
end

-- CONCAT TWO TABLES
function tableConcat(t1, t2)
    for i = 1, #t2 do
        t1[#t1+1] = t2[i]
    end
    return t1
end