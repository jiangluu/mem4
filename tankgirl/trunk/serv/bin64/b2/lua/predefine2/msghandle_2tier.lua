
local lcf = ffi.C

local hd4 = {}


local function gen_first_tier_common_handle(ud)
	local function first_tier_common_handle(me)
		local c_frame_no = lcf.cur_stream_get_int32()
		
		local sub_command_id = lcf.cur_stream_get_int16()

		local hd_second_tier = ud[sub_command_id]

		local err_no = -1
		local err_msg = 'second_tier handle NOT found'

		if hd_second_tier then
			local for_merge = {}
			local ok,ret = pcall(hd_second_tier,me,for_merge)
			if ok then
				if 0==ret then
					-- logic suc, push merge data
					local bin = pb.encode('A2Data.User',for_merge)

					lcf.cur_write_stream_cleanup()
					lcf.cur_stream_push_int32(c_frame_no)
					lcf.cur_stream_push_string(bin,#bin)
					lcf.cur_stream_write_back2(4)
				end

				lcf.cur_write_stream_cleanup()
				lcf.cur_stream_push_int32(c_frame_no)
				lcf.cur_stream_push_int16(ret)
				lcf.cur_stream_write_back()
				
				return ret
			else
				err_msg = ret
			end
		end

		print(err_msg)

		lcf.cur_write_stream_cleanup()
		lcf.cur_stream_push_int32(c_frame_no)
		lcf.cur_stream_push_int16(err_no)
		lcf.cur_stream_write_back()

		return -1

	end

	return first_tier_common_handle
end


function regAllHandlers4()
	-- 注册消息handler
	local the_dir = g_lua_dir..'msg_custom/'
	for file in lfs.dir(the_dir) do
		local msg_id,sub_id = string.match(file,'msg_(%d+)_(%d+)%.lua')
		if msg_id and sub_id then
			onMsg = nil
			jlpcall(dofile,the_dir..file)
			if nil~=onMsg then
				local hd_first_tier = nan_hd[tonumber(msg_id)]

				if nil==hd_first_tier then
					hd4[tonumber(msg_id)] = {}

					nan_hd[tonumber(msg_id)] = gen_first_tier_common_handle(hd4[tonumber(msg_id)])
				end

				hd4[tonumber(msg_id)][tonumber(sub_id)] = onMsg
			end
			onMsg = nil
		end
	end
end


-- register custom msgs
regAllHandlers4()
