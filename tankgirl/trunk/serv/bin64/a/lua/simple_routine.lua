
local o = {}

simple_routine = o



local lcf = ffi.C

o.sessions = {}

-- 从65（A）开始，到122（z）
local function gen_session_key()
	local t = {}
	for i=1,16 do
		table.insert(t,65+(math.random(100000)%58))
	end
	return string.char(unpack(t))
end


function o.come(msg_id)
	local skey = gen_session_key()
	
	lcf.cur_write_stream_cleanup()
	lcf.cur_stream_push_string(skey,#skey)
	lcf.copy_read_buf_to_write()
	
	-- 这里的session把它视为 短连接。虽然物理上可能是长连接，但是与逻辑无关
	o.sessions[skey] = lcf.get_cur_link_index()
	

	local online_apps = getOnlineApps()
	
	-- 给所有S类型节点发送此消息
	for ta_id,on_app in pairs(online_apps) do
		if string.sub(ta_id,1,1)=='S' then
			local link_id = on_app[2]
			lcf.cur_stream_write_2_link(link_id,msg_id)
		end
	end
	
end


function o.back(msg_id)
	local skey = ffi.string(lcf.cur_stream_get_string())
	
	local link_id = o.sessions[skey]
	if nil~=link_id then
		lcf.cur_write_stream_cleanup()
		lcf.copy_read_buf_to_write()
		
		lcf.cur_stream_write_2_link(link_id,msg_id)
	end
	
	-- 一个session只能返回一次，就结束
	o.sessions[skey] = nil
end

