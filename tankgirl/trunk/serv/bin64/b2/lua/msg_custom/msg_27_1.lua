
local lcf = ffi.C

function onMsg(me,merge_meta,merge)
	local hero_id = lcf.cur_stream_get_int32() 
	local item_id = lcf.cur_stream_get_int32() 
	local support_item_id1 = lcf.cur_stream_get_int32() 
	local support_item_id2 = lcf.cur_stream_get_int32() 
	local play_add = lcf.cur_stream_get_int32() 
	
	print('msg 27_1',hero_id,item_id,support_item_id1,support_item_id2)
	
	
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
	
	if 0~=support_item_id1 then
		if not bag.check(me,support_item_id1,1) then
			return 3
		end
	end
	
	if 0~=support_item_id2 then
		if not bag.check(me,support_item_id2,1) then
			return 3
		end
	end
	
	
	local nan = me.heroes[hero_i]
	local nan_dis_type = sd.unit[hero_id].dis_type
	local item_dis_type1 = sd.dis_item[item_id].type
	local colname1 = 'effect'..item_dis_type1
	local colname2 = 'up'..nan_dis_type
	
	print(nan_dis_type,type(nan_dis_type))
	print(sd.dis_type[1])
	local pbc = require('protobuf')
	print('pbc',pbc,pbc.enum_id)
	local aa = pbc.enum_id('com.artme.data.Unit.DISType',nan_dis_type)
	print('bbbbbbbb',aa)
	
	local multi1 = sd.dis_type[nan_dis_type][colname1]
	local multi2 = 0
	local multi3 = 0
	if 0~=support_item_id1 then
		multi2 = sd.dis_support[support_item_id1][colname2]
	end
	if 0~=support_item_id2 then
		multi3 = sd.dis_support[support_item_id2][colname2]
	end
	local multi4 = sd.dis_play[play_add]
	assert(multi4)
	
	local rand = math.random(80,120)
	local base_exp = sd.dis_item[item_id].exp
	
	local final_exp = base_exp * rand * (multi1 + multi2 + multi3 + multi4) / 10000
	print('dis',final_exp,base_exp,rand,(multi1 + multi2 + multi3 + multi4))
	
	
	local items_dec = {}
	-- modify data
	table.insert(items_dec,bag.dec(me,item_id,1,'discipline'))
	if 0~=support_item_id1 then
		table.insert(items_dec,bag.dec(me,support_item_id1,1,'discipline'))
	end
	if 0~=support_item_id2 then
		table.insert(items_dec,bag.dec(me,support_item_id2,1,'discipline'))
	end
	
	nan.dis_exp = (nan.dis_exp or 0) + final_exp
	nan.dis_cd = now() + sd.dis_item[item_id].cd
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
