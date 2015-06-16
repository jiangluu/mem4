
local lcf = ffi.C



-- ChatNoTarget 	13 	<<(WORD)chat_type<<(string)text 	chat_type:1-本服 text：聊天内容
function onMsg(me)
	
	local chat_type = lcf.cur_stream_get_int16()
	local bin = l_cur_stream_get_slice()
	local aa = box.unSerialize(bin)
	local bin2 = box.serialize(aa)
	--print('say',bin,bin_len)
	
	if 1==chat_type then
		-- 普通聊天
		lcf.cur_write_stream_cleanup()
		lcf.cur_stream_push_int16(chat_type)
		lcf.cur_stream_push_string(me.basic.name,0)
		lcf.cur_stream_push_int64(tonumber(me.basic.usersn))
		lcf.cur_stream_push_string(bin,#bin)
		--lcf.cur_stream_write_back()
		--lcf.cur_stream_broadcast(14)
		
		lcf.cur_stream_write_back();
		
		ach.key_inc4(me,'chatn')
	elseif 2==chat_type then
		-- 公会聊天
		if nil==me.basic.guild then
			return 1
		end
	end
	
	
	
	return 0
end

