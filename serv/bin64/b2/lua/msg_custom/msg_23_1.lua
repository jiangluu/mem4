
local lcf = ffi.C

function onMsg(me,merge_meta,merge)
	local summon_typr = lcf.cur_stream_get_int32() 
	
	print('msg 23_1',summon_typr)
	
	local s_conf = sd.summon[summon_typr]
	assert(s_conf)
	
	
	local conf1 = nil
	for i=#s_conf,1,-1 do
		if me.level >= s_conf[i].maxlv then
			conf1 = s_conf[i]
			break
		end
	end
	
	local item_change = {}
	
	local function surprise(box_id)
		local conf = sd.group_content[box_id]
		
		local total_weight = 0
		for i=1,#conf do
			total_weight = total_weight + conf[i].weight
		end
		
		local wtf = math.random(total_weight)
		local aa = 0
		local idx = -1
		for i=1,#conf do
			aa = aa + conf[i].weight
			if aa >= wtf then
				idx = i
				break
			end
		end
		
		table.insert(item_change,{ itemID=conf[idx].itemId, num=conf[idx].num })
	end
	
	local r1 = bag.dec(me,conf1.costId,conf1.costNum,'summon')
	if r1 then
		surprise(conf1.staticGroup)
		surprise(conf1.solidGroup)
		
		for i=1,4 do
			surprise(conf1.randomGroup)
		end
		
		for i=1,#item_change do
			local a = item_change[i]
			-- 是否抽到重复的魔娘
			if a.itemID < 10000 then
			end
			
			bag.add(me,a.itemID,a.num,'summon')
		end
		
		me.last_summmon_time1 = lcf.cur_game_time() + 900
		me.summon_times1 = (me.summon_times1 or 0) + 1
		
		table.insert(merge_meta,'User')
		table.insert(merge,me)
		
		return 0
	end
	
	return 1
end
