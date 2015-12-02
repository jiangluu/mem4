
local lcf = ffi.C

function onMsg(me,merge_meta,merge)
	local hero_id = lcf.cur_stream_get_int32() 
	local item_id = lcf.cur_stream_get_int32() 
	local support_item_id1 = lcf.cur_stream_get_int32() 
	local support_item_id2 = lcf.cur_stream_get_int32() 
	local support_item_id3 = lcf.cur_stream_get_int32() 
	local support_item_id4 = lcf.cur_stream_get_int32() 
	local dis_times = lcf.cur_stream_get_int32() 	-- 调教次数
	local play_add = lcf.cur_stream_get_float32() 
	
	print('msg 27_1',hero_id,item_id)
	print('----',support_item_id1,support_item_id2,support_item_id3,support_item_id4)
	print('----',dis_times,play_add)
	
	
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
	
	
	local nan = me.heroes[hero_i]
	local nan_dis_type = sd.unit[hero_id].dis_type
	nan_dis_type = pb.enum_id('com.artme.data.Unit.DISType',nan_dis_type)
	local item_dis_type1 = sd.dis_item[item_id].type
	local colname1 = 'effect'..item_dis_type1
	
	if dis_times > sd.dis_lv[nan.dis_lv].dis_max_item then
		return 4
	end
	
	local t_sup = {}
	if 0~=support_item_id1 then
		t_sup[support_item_id1] = true
	end
	if 0~=support_item_id2 then
		t_sup[support_item_id2] = true
	end
	if 0~=support_item_id3 then
		t_sup[support_item_id3] = true
	end
	if 0~=support_item_id4 then
		t_sup[support_item_id4] = true
	end
	
	if not bag.check(me,item_id,dis_times) then
		return 3
	end
	
	for k,v in pairs(t_sup) do
		if not bag.check(me,k,dis_times) then
			return 3
		end
	end
	
	local play_add_max = 0
	for i=1,dis_times do
		play_add_max = play_add_max + sd.dis_play[i].add3
	end
	if play_add > play_add_max then
		return 5
	end
	
	
	local multi1 = sd.dis_type[nan_dis_type][colname1]
	
	local base_exp = sd.dis_item[item_id].exp
	if t_sup[10204] then
		base_exp = base_exp + sd.dis_support[10204].para
	end
	
	local final_exp = base_exp * multi1 * play_add
	if t_sup[10202] then
		final_exp = final_exp + sd.dis_support[10202].para * dis_times
	end
	
	print('final_exp',final_exp, base_exp, multi1)
	
	
	local items_dec = {}
	-- modify data
	table.insert(items_dec,bag.dec(me,item_id,dis_times,'discipline'))
	for k,v in pairs(t_sup) do
		table.insert(items_dec,bag.dec(me,k,dis_times,'discipline'))
	end
	
	nan.dis_exp = (nan.dis_exp or 0) + final_exp
	
	local cd_fix = sd.dis_item[item_id].cd
	cd_fix = final_exp / sd.dis_item[item_id].exp * cd_fix
	if t_sup[10203] then
		cd_fix = cd_fix * sd.dis_support[10203].para
	end
	print('cd',cd_fix)
	
	nan.dis_cd = now() + cd_fix
	nan.dis_lv = nan.dis_lv or 1
	-- level up auto
	for lv=nan.dis_lv, 999 do
		local raw = sd.dis_lv[lv]
		if nil==raw then
			break
		end
		
		if nan.dis_exp >= raw.dis_exp then
			nan.dis_lv = nan.dis_lv + 1
		else
			break
		end
	end
	
	
	local me2 = {}
	me2.items = items_dec
	me2.heroes = { nan }
	table.insert(merge_meta,'User')
	table.insert(merge,me2)
	
	
	return 0
end
