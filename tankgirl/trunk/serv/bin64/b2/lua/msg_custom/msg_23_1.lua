
local lcf = ffi.C

function onMsg(me,merge_meta,merge)
	local summon_typr = lcf.cur_stream_get_int32() 
	
	print('msg 23_1',summon_typr)
	
	if 1==summon_typr then
		local item = { {itemID=15001,num=10,op=1},
			{itemID=10100,num=10,op=1},
			{itemID=10103,num=10,op=1},
			{itemID=10106,num=10,op=1},
			{itemID=10109,num=10,op=1},
			{itemID=10112,num=10,op=1},
		}
		
		me.last_summmon_time1 = lcf.cur_game_time() + 900
		me.summon_times1 = (me.summon_times1 or 0) + 1
		
		for i=1,#item do
			table.insert(me.items,item[i])
		end
		
		local me2 = { last_summmon_time1=me.last_summmon_time1 }
		me2.items = item
		
		table.insert(merge_meta,'User')
		table.insert(merge,me2)
		
	end
	
	return 0,0,0
end
