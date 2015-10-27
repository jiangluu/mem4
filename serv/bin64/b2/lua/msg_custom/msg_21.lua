
local lcf = ffi.C

function onMsg(me)
	local c_frame_no = lcf.cur_stream_get_int32()
	
	local sub_command_id = lcf.cur_stream_get_int16()
	
	
	print('msg 21',c_frame_no,sub_command_id)
	
	if 1==sub_command_id then
		--[[
		local formation_id = lcf.cur_stream_get_int16()
		local bin = l_cur_stream_get_slice()
		
		local forma = pb.decode('com.artme.data.User.Formation',bin)
		assert(forma)
		
		
		me.formations = me.formations or {}
		
		local forma_id = math.min(formation_id,#me.formations+1)
		
		
		me.formations[forma_id] = forma
		
		local me2 = {}
		me2.formations = me.formations
		
		bin = pb.encode('com.artme.data.User',me2)
		
		lcf.cur_stream_push_string(bin,#bin)
		lcf.cur_stream_write_back2(4)
		--]]

		local bin = pb.encode('com.artme.data.User',me)
		lcf.cur_stream_push_string(bin,#bin)
		lcf.cur_stream_write_back2(4)
		
	end
	
	
	lcf.cur_write_stream_cleanup()
	lcf.cur_stream_push_int32(c_frame_no)
	lcf.cur_stream_push_int16(0)
	lcf.cur_stream_write_back()
	
	return 0
end
