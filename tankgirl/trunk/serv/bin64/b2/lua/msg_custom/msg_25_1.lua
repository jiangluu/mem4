
local lcf = ffi.C

function onMsg(me,merge_meta,merge)
	local hero_id = lcf.cur_stream_get_int32() 
	local item_id = lcf.cur_stream_get_int32() 
	
	print('msg 25_1',hero_id,item_id)
	
	
	
	return 0
end
