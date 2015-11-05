
local lcf = ffi.C

function onMsg(me,merge_meta,merge)
	local hero_id = lcf.cur_stream_get_int32() 
	local item_id = lcf.cur_stream_get_int32() 
	
	print('msg 25_1',hero_id,item_id)
	
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
	
	if me.items[item_i].num<1 then
		return 3
	end
	
	
	local exp_add = ssd.item[item_id].exp
	
	-- modify
	local the_item = me.items[item_i]
	the_item.num = the_item.num - 1
	if the_item.num<=0 then
		table.remove(me.items,item_i)
	end
	
	
	local the_hero = me.heroes[hero_i]
	the_hero.exp = the_hero.exp + exp_add
	
	
	table.insert(merge_meta,'User.Item')
	table.insert(merge,the_item)
	
	table.insert(merge_meta,'User.Hero')
	table.insert(merge,the_hero)
	
	return 0
end
