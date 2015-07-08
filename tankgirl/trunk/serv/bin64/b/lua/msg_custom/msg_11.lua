
-- HeartBeat

local lcf = ffi.C					-- LuaJit相关，可以不用理解，照抄即可

function onMsg(me)		-- 函数定义，此目录下每个消息的定义都一样，照抄即可
	print('HeartBeat')
	
	lcf.cur_stream_write_back()			-- 返回消息给客户端，消息ID是11+1
	
	return 0
end
