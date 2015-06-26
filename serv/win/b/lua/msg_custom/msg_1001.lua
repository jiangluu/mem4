
-- Offline 1001

local lcf = ffi.C

function onMsg(me)
	print('1001 offline',me.id_)
	
	local bin2 = pb.encode('User',me)				-- 调用protobuf序列化
	redis.set(0,me.id_,bin2)		-- 向redis存数据
	
	
	-- 下面两步是框架要求的释放资源，照抄即可
	local actor_id = tonumber(lcf.cur_actor_id())
	box.release_actor(actor_id)
	
	lcf.box_actor_num_dec(1)
	
	return 0
end


box.add_exit_message(1001)		-- 注册下线消息，可以不用理解，照抄即可
