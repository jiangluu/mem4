
local lcf = ffi.C

function onMsg(me)
	print('MSG 1 recv')
	
	apb.begin_push_user()
	
	apb.push_user('id_','u1')
	apb.push_user('name_','jiangwei')
	apb.push_user('exp_',88)
	apb.push_user('lv_',2)
	apb.push_user('diamond_',10)
	
	local bag = lcf.pbc_wmessage_message(apb.user,'bag_')
	apb.push(bag,'item_id_',2)
	
	bag = lcf.pbc_wmessage_message(apb.user,'bag_')
	apb.push(bag,'item_id_',3)
	
	-- local s = apb.end_push(apb.user)
	-- local bin = ffi.string(ffi.cast('const char*',s.buffer),s.len)
	-- local fh = io.open('msg_1.out','w+')
	-- fh:write(bin)
	-- fh:close()
	
	apb.end_push_user()
	
	lcf.cur_stream_write_back()
	
	local aa = apb.new_w2('User')
	
	--[[
	local key = l_cur_stream_get_slice()
	
	local player_data_bin = redis.get(0,key)
	if nil~=player_data_bin then
		local player_data = box.unSerialize(player_data_bin)
		
		me.data = player_data
	end
	--]]
	
	return 0
end

