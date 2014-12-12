
local lcf = ffi.C

local o = {}
o.handles = {}

-- from controlpanel  1101
box.reg_handle(1101,function(me)
	
	local skey = l_cur_stream_get_slice()
	local tag = lcf.cur_stream_get_int32()
	local user_cmd = l_cur_stream_get_slice()
	
	local send_ack = function(ack_str)
		lcf.cur_write_stream_cleanup()
		lcf.cur_stream_push_string(skey,#skey)
		lcf.cur_stream_push_int32(tag)
		lcf.cur_stream_push_string(user_cmd,user_cmd_len)
		lcf.cur_stream_push_string(ack_str,#ack_str)
		lcf.cur_stream_write_back()
	end
	
	print(1101,skey,user_cmd)
	
	local hd = o.get_handle(user_cmd)
	if hd then
		pcall(hd,send_ack)
	end
	
	return 0
end)


function o.reg_cmd(cmd,func)
	o.handles[tostring(cmd)] = func
end

function o.get_handle(cmd)
	return o.handles[tostring(cmd)]
end


o.reg_cmd('reload handles',function(ack)
	--regAllHandlers()
		
	ack('not impl')
end)

o.reg_cmd('reload all',function(ack)
	local ll_call = jlpcall
	
	ll_call(dofile,g_lua_dir.."init.lua")
	
	ack('reload all success')
end)

o.reg_cmd('reconnect redis',function(ack)
	--redis.init()
	
	ack('not impl')
end)

