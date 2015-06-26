
-- HeartBeat

local lcf = ffi.C					-- LuaJit相关，可以不用理解，照抄即可

function onMsg(me)		-- 函数定义，此目录下每个消息的定义都一样，照抄即可
	print('HeartBeat')
	
	return 0
end
