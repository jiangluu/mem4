
local lcf = ffi.C


function onMsg(me,merge_meta,merge)
	local hero_id = lcf.cur_stream_get_int32() 
	local skill_index = lcf.cur_stream_get_int32() 
	
	print('msg 25_3',hero_id,skill_index)
	
	if skill_index<1 or skill_index>4 then
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
	
	local the_hero = me.heroes[hero_i]
	
	local lv_now = the_hero.skill_lv[skill_index]
	assert(lv_now)
	
	local colname = 'money'..skill_index
	local coin_dec = sd.unit_skill[lv_now][colname]
	
	
	if me.coin<coin_dec then
		return 4
	end
	
	
	
	-- modify
	me.coin = me.cpoin - coin_dec
	the_hero.skill_lv[skill_index] = lv_now + 1
	
	
	local me2 = {}
	me2.coin = me.coin
	me2.heroes = { the_hero }
	table.insert(merge_meta,'User')
	table.insert(merge,me2)
	
	
	return 0
end
