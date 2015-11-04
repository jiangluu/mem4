
local lcf = ffi.C

function onMsg(me,merge_meta,merge)
	local summon_typr = lcf.cur_stream_get_int32() 
	
	print('msg 23_1',summon_typr)
	
	if 1==summon_typr then
		local item = {itemID=15001,num=10}
		
		me.last_summmon_time1 = tonumber(lcf.cur_game_time()) + 900
		
		table.insert(me.items,item)
		
		local me2 = { last_summmon_time1=me.last_summmon_time1 }
		
		table.insert(merge_meta,'User')
		table.insert(merge,me2)
		
		table.insert(merge_meta,'User.Item')
		table.insert(merge,item)
	end
	
	return 0,0,0
end
