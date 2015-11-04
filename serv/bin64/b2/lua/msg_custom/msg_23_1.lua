
local lcf = ffi.C

function onMsg(me,merge_meta,merge)
	local summon_typr = lcf.cur_stream_get_int16() 
	
	print('msg 23_1',summon_typr)
	
	if 1==summon_typr then
		local item = {itemID=15001,num=10}
		
		table.insert(me.items,item)
		
		table.insert(merge_meta,'User.Item')
		table.insert(merge,item)
	end
	
	return 0,0,0
end
