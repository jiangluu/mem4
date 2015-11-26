
local lcf = ffi.C

--local stone_map = { 'star_stone','moon_stone','sun_stone' }

function onMsg(me,merge_meta,merge)
	local hero_id = lcf.cur_stream_get_int32() 
	
	print('msg 25_2',hero_id)
	

	
	
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
	
	local the_hero = me.heroes[hero_i]
	
	
	print('AAAAAAAA',the_hero.star_lv, sd.unit_evo[the_hero.star_lv].stone_type)
	local stone_col = sd.unit_evo[the_hero.star_lv].stone_type .. '_stone'
	assert(stone_col)
	local item_id = sd.unit[hero_id][stone_col]
	
	print(stone_col,item_id)
	
	
	local need_item_num = sd.unit_evo[the_hero.star_lv].stone_count
	local coin_dec = sd.unit_evo[the_hero.star_lv].cost
	
	
	if me.coin<coin_dec then
		return 4
	end
	
	if not bag.check(me,item_id,need_item_num) then
		return 3
	end
	
	
	
	-- modify
	bag.dec(me,10001,coin_dec,'hero_star_up')
	
	local the_item = bag.dec(me,item_id,need_item_num,'hero_star_up')
	
	
	the_hero.star_lv = the_hero.star_lv + 1
	local mo = nil
	if 6==the_hero.star_lv then
		mo = table.deepclone(the_hero)
		
		mo.id = mo.id + 4000	-- 魔化
		the_hero.flag = 1
	end
	
	
	local me2 = {}
	me2.coin = me.coin
	me2.items = { the_item }
	me2.heroes = { the_hero }
	if mo then
		table.insert(me2.heroes, mo)
	end
	table.insert(merge_meta,'User')
	table.insert(merge,me2)
	
	
	return 0
end
