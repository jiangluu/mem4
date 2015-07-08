
-- 聊天

local lcf = ffi.C

function onMsg(me)
	
	local bin = l_cur_stream_get_slice()							-- 得到客户端发送的字节序列
	local param = pb.decode('SimpleParam',bin)		-- 调用protobuf反序列化
	
	if 1==param.uint1_ then
		-- 普通聊天
		local data_to_send_back = {}								-- 要发送回客户端的数据初始化
		data_to_send_back.uint1_ = 1								-- 聊天类型是1（普通）
		data_to_send_back.string1_ = me.name			-- 说话人名字是我
		data_to_send_back.string2_ = param.string1_	-- 说话内容是刚才客户端发上来的
		
		local serialized = pb.encode('SimpleParam',data_to_send_back)		-- 调用protobuf序列化
		
		lcf.cur_stream_push_string(serialized,#serialized)	-- 放入发送缓冲
		lcf.cur_stream_broadcast(13+1)									-- 广播出去（14号消息）
		
	elseif 2==chat_type then
		-- TODO: 公会聊天
		
		lcf.cur_stream_write_back()		-- 公会聊天功能未实现，这里只是返回给客户端一个空的应答，消息ID是13+1，无内容
	end
	
	return 0
end

