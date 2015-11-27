
local lcf = ffi.C


function onMsg(me,merge_meta,merge)
	local form_index = lcf.cur_stream_get_int32() 
	
	print('msg 25_7',form_index)
	if form_index<0 or form_index>4 then
		return 1
	end
	
	me.CurrentForm = form_index
	
	
	local me2 = {}
	me2.CurrentForm = form_index
	table.insert(merge_meta,'User')
	table.insert(merge,me2)
	
	
	return 0
end
