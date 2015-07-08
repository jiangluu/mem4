
local lcf = ffi.C

function onMsg(me)
	print('MSG 1 recv')
	
	local bin = l_cur_stream_get_slice()							-- 得到客户端发送的字节序列
	local param = pb.decode('SimpleParam',bin)		-- 调用protobuf反序列化
	
	local key = param.string1_							-- 客户端发送的登录key
	local player_data_bin = redis.get(0,key)		-- 从redis读取数据
	
	if nil==player_data_bin then
		-- 未从数据层读到数据，认为这是个新号，初始化玩家数据
		local sn = redis.command_and_wait(0,'INCR c_usersn')		-- 得到一个自增长序号
		
		me.id_ = 'u'..sn
		me.name_ = 'guest'..me.id_
		me.exp_ = 88
		me.lv_ = 1
		me.diamond_ = 100
		
		local bag = {}
		table.insert(bag,{ item_id_=2 })
		table.insert(bag,{ item_id_=3 })
		
		me.bag_ = bag
		-- 初始化玩家数据结束
		
		local bin2 = pb.encode('User',me)				-- 调用protobuf序列化
		lcf.cur_stream_push_string(bin2,#bin2)		-- 放入发送缓冲
		lcf.cur_stream_write_back()							-- 返回消息给客户端，消息ID是1+1，内容是放入发送缓冲的字节
		
	else
		-- 读到了以前的存盘数据
		
		local player_data = pb.decode('User',player_data_bin)		-- 调用protobuf反序列化
		
		for k,v in pairs(player_data) do		-- 遍历数据，复制到me上
			me[k] = v
		end
		
		lcf.cur_stream_push_string(player_data_bin,#player_data_bin)		-- 放入发送缓冲
		lcf.cur_stream_write_back()																	-- 返回消息给客户端，消息ID是1+1，内容是放入发送缓冲的字节
	end
	
	return 0
end

