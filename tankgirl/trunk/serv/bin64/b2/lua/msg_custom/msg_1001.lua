
-- Offline 1001

local lcf = ffi.C

function onMsg(me)
	print('1001 offline',me.id_)
	
	local bin2 = pb.encode('com.artme.data.User',me)				-- 调用protobuf序列化
	redis.set(0,me.id_,bin2)		-- 向redis存数据
	
	
	ma.release(me.__id)
	
	return 0
end
