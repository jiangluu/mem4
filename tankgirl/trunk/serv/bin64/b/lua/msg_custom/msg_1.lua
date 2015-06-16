
function onMsg(me)
	print('BBBBBBBBBBBBBBBBBBBBBB')
	
	local key = l_cur_stream_get_slice()
	
	local player_data_bin = redis.get(0,key)
	if nil~=player_data_bin then
		local player_data = box.unSerialize(player_data_bin)
		
		me.data = player_data
	end
	
	return 0
end

