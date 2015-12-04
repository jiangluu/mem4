
local lcf = ffi.C


function onMsg(me,merge_meta,merge)
	local stage_id = lcf.cur_stream_get_int32() 
	
	print('msg 25_5',stage_id)
	
	-- 为了测试方便先不检查状态
	local conf = sd.stage_stage[stage_id]
	
	if me.energy < conf.cost then
		return 1
	end
	
	
	
	
	-- modify
	local t_item_get = {}
	
	local function loot(a)
		local col2 = 'prob'..a
		if math.random(100)<=conf[col2] then
			local col1 = 'item'..a
			table.insert(t_item_get, { itemID=conf[col1],num=1 })
		end
	end
	
	for i=1,5 do
		loot(i)
	end
	
	if nil~=conf.captureId and 0~=conf.captureId then
		local found = false
		for i=1,#me.heroes do
			if conf.captureId == me.heroes[i].id then
				found = true
				break
			end
		end
	
		if false==found then
			table.insert(t_item_get, { itemID=conf.captureId, num=1 })
			table.insert(t_item_get, { itemID=conf.special_item, num=1 })
		end
	end
	
	-- cache things
	local ca = { stage_id=stage_id, forma=(me.CurrentForm or 0)+1, pool=t_item_get }
	me._cache = ca
	
	
	local me2 = {}
	me2.items = t_item_get
	table.insert(merge_meta,'User')
	table.insert(merge,me2)
	
	
	return 0
end
