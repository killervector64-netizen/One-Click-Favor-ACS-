local reduceMod = GameMain:NewMod("ReduceResistanceAutomatically");

local currentDay = 0;

function reduceMod:OnInit()
    currentDay = CS.XiaWorld.World.Instance.DayCount

end

function reduceMod:OnStep(dt)
    local newDay = CS.XiaWorld.World.Instance.DayCount
    if currentDay ~= newDay then
        --print("New day detected! Day:", currentDay)
        currentDay = newDay
        local npcList = Map.Things.m_lisNpcs;
        reduceRes(npcList)
    end

end

function getIncrement(v)
    if v <= 0 then return 0.01 end
    if v >= 1 then return 0 end
    return 0.01 * (1 - v)
end

function reduceRes(npcList)
    for i = 0, npcList.Count - 1 do
        local npc = npcList[i]
        --print(npc.Name)
        if npc.ElixirFesistance ~= nil then
            --print("ElixirFesistance found for npc: " .. npc.Name)

            --Temporary Lua table
            local entries = {}
            local enumerator = npc.ElixirFesistance:GetEnumerator()
            while enumerator:MoveNext() do
                local kv = enumerator.Current
                entries[#entries + 1] = { key = kv.Key, value = kv.Value }
            end

            --Safely update to avoid errors
            for _, entry in ipairs(entries) do
                local inc = getIncrement(entry.value)
                if inc > 0 then
                    npc.ElixirFesistance:set_Item(entry.key, math.min(entry.value + inc, 1))
                    --print("Reduced resistance for " .. entry.key)
                end
            end
        end
    end
end



-- function reduceMod:OnStep(dt)
-- 	myTime = myTime + dt
-- 	if myTime >= interval then
-- 		--print("Example Step"..dt);
-- 		if enabled then 
-- 			doUnbanPoop()
-- 		end
-- 		myTime = 0
		
-- 	end
-- end
function reduceMod:OnLeave()
	
end

function reduceMod:OnSave()
	-- local window = GameMain:GetMod("Windows"):GetWindow("unbanWindow")
	local taggle = "false"
	if enabled then
		taggle = "true"
	end
	local tbSave = {
		toggle = taggle,
		interval = interval
	};
	
	return tbSave
end

function reduceMod:OnLoad(tbLoad)
	-- tbLoad = tbLoad or {}
end

function reduceMod:NeedSyncData()
	 return false;
end

function reduceMod:OnSyncLoad(tbData)
	-- self.syncdata = tbData;
end

function reduceMod:OnSyncSave()
	-- return {a=1,b=2};
end

function reduceMod:OnAfterLoad()
	
end
function reduceMod:getDebug()
	return debug
end
local tbTest = GameMain:GetMod("ReduceResistanceAutomatically");