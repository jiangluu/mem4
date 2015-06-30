
local lcf = ffi.C

function onMsg(me)
	
	lcf.cur_stream_write_back()
	
	return 0
end

