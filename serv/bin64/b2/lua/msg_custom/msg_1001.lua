
-- Offline 1001

local lcf = ffi.C

function onMsg(me)
	print('1001 offline',me.userId)
	
	if me.userId then
		print('======== 1001')
		local forma = me.formations[1]
		for i=1,#forma.heroIDs do
			print(forma.heroIDs[i])
		end
		print('========')
		
		local bin2 = pb.encode('A2Data.User',me)				-- 调用protobuf序列化
		redis.set(0,me.userId,bin2)		-- 向redis存数据
	end
	
	ma.release(me.__id)
	
	return 0
end
