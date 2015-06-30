
local lcf = ffi.C

-- Offline 1001
function onMsg(me)
	
	local actor_id = tonumber(lcf.cur_actor_id())
	box.release_actor(actor_id)
	
	-- C里的工作 目前只要计数器减一就可以了
	lcf.box_actor_num_dec(1)
	
	return 0
end


box.add_exit_message(1001)
