
local lcf = ffi.C

-- just for TEST
function onMsg(me)
	
	local key = redis.command_and_wait(0,'RANDOMKEY')
	
	local v = redis.get(0,key)
	
	lcf.cur_stream_write_back()
	
	return 0
end

