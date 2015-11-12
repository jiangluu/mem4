
local lcf = ffi.C

local free_cd = 900		-- 多久能免费召唤一次

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
	conf1 = conf1 or s_conf[1]
	
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
	
	local now = lcf.cur_game_time()
	
	local could_summon = false
	local is_free_summon = false
	if 2==summon_typr then
		could_summon = now >= (me.last_summmon_time1 or 0)
		is_free_summon = could_summon
		
		if not could_summon then
			could_summon = bag.dec(me,conf1.costId,conf1.costNum,'summon')
		end
	else
		could_summon = bag.dec(me,conf1.costId,conf1.costNum,'summon')
	end
	
	
	if could_summon then
		surprise(conf1.staticGroup)
		surprise(conf1.solidGroup)
		
		for i=1,4 do
			surprise(conf1.randomGroup)
		end
		
		local hero_change = {}
		
		for i=#item_change,1,-1 do
			local a = item_change[i]
			
			print(i,a.itemID,a.num)
			
			if a.itemID < 10000 then
				local found = false
				for j=1,#me.heroes do
					if a.itemID == me.heroes[j].id then
						found = true
						break
					end
				end
				
				-- 是否抽到重复的魔娘
				if not found then
					table.remove(item_change,i)
					local h = { id=a.itemID,level=1,dis_lv=0,skill_lv={1,1,1,1},star_lv=1,exp=0 }
					table.insert(me.heroes, h)
					table.insert(hero_change, h)
				else
					local tr = nil
					for i3=1,#sd.summon_trans do
						if me.level <= sd.summon_trans[i3].maxlv then
							tr =  sd.summon_trans[i3]
							break
						end
					end
					assert(tr)
					
					item_change[i] = { itemID=tr.stoneId, num=tr.stoneNum,op=a.itemID }
					bag.add(me,tr.stoneId, tr.stoneNum,'summon')
				end
			else
				bag.add(me,a.itemID,a.num,'summon')
			end
		end
		
		if is_free_summon then
			me.last_summmon_time1 = now + free_cd
		end
		local key1 = 'summon_times'..summon_typr
		me[key1] = (me[key1] or 0) + 1
		
		local me2 = {}
		me2.coin = me.coin
		me2.diamond = me.diamond
		me2.last_summmon_time1 = me.last_summmon_time1
		me2[key1] = me[key1]
		me2.items = item_change
		if #hero_change > 0 then
			me2.heroes = hero_change
		end
		table.insert(merge_meta,'User')
		table.insert(merge,me2)
		
		return 0
	end
	
	return 1
end
