
local lcf = ffi.C

function onMsg(me)
	print('MSG 1 recv')
	
	me.id_ = 'u1'
	me.name_ = 'jiangwei'
	me.exp_ = 88
	me.lv_ = 2
	me.diamond_ = 100
	
	local bag = {}
	table.insert(bag,{ item_id_=2 })
	table.insert(bag,{ item_id_=3 })
	
	me.bag_ = bag
	
	local w = apb.table_to_wm(me,'User')
	apb.end_push2(w)
	
	lcf.cur_stream_write_back()
	
	-- local s = apb.end_push(apb.user)
	-- local bin = ffi.string(ffi.cast('const char*',s.buffer),s.len)
	-- local fh = io.open('msg_1.out','w+')
	-- fh:write(bin)
	-- fh:close()
	
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

