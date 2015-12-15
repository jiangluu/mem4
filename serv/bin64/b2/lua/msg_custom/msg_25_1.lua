
local lcf = ffi.C

function onMsg(me,merge_meta,merge)
	local hero_id = lcf.cur_stream_get_int32() 
	local item_id = lcf.cur_stream_get_int32() 
	
	print('msg 25_1',hero_id,item_id)
	
	
	local hero_i = -1
	for i=1,#me.heroes do
		if hero_id == me.heroes[i].id then
			hero_i = i
			break
		end
	end
	
	if hero_i<0 then
		return 2
	end
	
	if not bag.check(me,item_id,1) then
		return 3
	end
	
	local exp_max = sd.unit_lv[me.level].exp
	local the_hero = me.heroes[hero_i]
	if (the_hero.exp or 0)>=exp_max then
		return 4
	end
	
	
	local exp_add = sd.item[item_id].exp
	
	-- modify
	local the_item = bag.dec(me,item_id,1,'hero_add_exp')
	
	
	the_hero.exp = (the_hero.exp or 0)+ exp_add
	the_hero.exp = math.min(exp_max, the_hero.exp)
	
	
	-- level up auto
	for lv=the_hero.level, 999 do
		if lv>=me.level then
			break
		end
		
		local raw = sd.unit_lv[lv]
		if nil==raw then
			break
		end
		
		if the_hero.exp >= raw.exp then
			the_hero.level = the_hero.level + 1
		else
			break
		end
	end
	
	
	local me2 = {}
	me2.items = { the_item }
	me2.heroes = { the_hero }
	table.insert(merge_meta,'User')
	table.insert(merge,me2)
	
	
	return 0
end
