
local lcf = ffi.C

local hd4 = {}


local typr_2_int = {}
typr_2_int['User'] = 1
typr_2_int['User.Formation'] = 2
typr_2_int['User.Hero'] = 3
typr_2_int['User.Item'] = 4

local function gen_first_tier_common_handle(ud)
	local function first_tier_common_handle(me)
		local c_frame_no = lcf.cur_stream_get_int32()
		
		local sub_command_id = lcf.cur_stream_get_int16()

		local hd_second_tier = ud[sub_command_id]

		local err_no = -1
		local err_msg = 'second_tier handle NOT found'

		if hd_second_tier then
			local merge_meta = {}
			local for_merge = {}
			local ok,ret,r2,r3,r4 = pcall(hd_second_tier,me,merge_meta,for_merge)
			if ok then
				lcf.cur_write_stream_cleanup()
				lcf.cur_stream_push_int32(c_frame_no)
				lcf.cur_stream_push_int16(ret)
				if nil~=r2 then
					lcf.cur_stream_push_int32(r2)
				end
				if nil~=r3 then
					lcf.cur_stream_push_int32(r3)
				end
				if nil~=r4 then
					lcf.cur_stream_push_int32(r4)
				end
				
				
				if 0==ret then
					-- logic suc, push merge data
					for j=1,#merge_meta do
						local t = rawget(for_merge,j)
						if nil==t then
							break
						end

						-- local typr = typr_2_int[merge_meta[j]]
						-- if nil==typr then
							-- break
						-- end
						
						local ok,bin = pcall(pb.encode, 'A2Data.' .. merge_meta[j], t)
						if ok then
							lcf.cur_stream_push_string(bin,#bin)
						else
							print(bin)
						end
					end
				end

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
