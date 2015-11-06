
local lcf = ffi.C

local stone_map = { 'star_stone','moon_stone','sun_stone' }

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
	local stone_col = stone_map[sd.unit_evo[the_hero.star_lv].stone_type]
	assert(stone_col)
	local item_id = sd.unit[hero_id][stone_col]
	
	print(stone_col,item_id)
	
	
	local item_i = -1
	for i=1,#me.items do
		if item_id == me.items[i].itemID then
			item_i = i
			break
		end
	end
	
	if item_i<0 then
		return 1
	end
	
	local need_item_num = sd.unit_evo[the_hero.star_lv].stone_count
	local coin_dec = sd.unit_evo[the_hero.star_lv].cost
	
	
	if me.coin<coin_dec then
		return 4
	end
	
	if me.items[item_i].num<need_item_num then
		return 3
	end
	
	
	
	-- modify
	me.coin = me.coin - coin_dec
	
	local the_item = me.items[item_i]
	the_item.num = the_item.num - need_item_num
	if the_item.num<=0 then
		table.remove(me.items,item_i)
	end
	
	
	the_hero.star_lv = the_hero.star_lv + 1
	
	
	local me2 = {}
	me2.coin = me.coin
	me2.items = { the_item }
	me2.heroes = { the_hero }
	table.insert(merge_meta,'User')
	table.insert(merge,me2)
	
	
	return 0
end
