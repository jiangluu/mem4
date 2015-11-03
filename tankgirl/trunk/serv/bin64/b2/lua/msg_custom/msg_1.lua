
local lcf = ffi.C

function onMsg(me)
	print('MSG 1 recv')
	
	local typ = lcf.cur_stream_get_int16()
	local bin = l_cur_stream_get_slice()							-- 得到客户端发送的字节序列
	local is_reset = lcf.cur_stream_get_int16()
	
	print(typ,bin)
	local db_key = 'weak'..bin
	
	local player_data_bin = nil
	local sn = redis.get(0,db_key)		-- 从redis读取数据
	
	if sn then
		player_data_bin = redis.get(0,sn)
	end
	
	if 1==is_reset or nil==player_data_bin then
		-- 未从数据层读到数据，认为这是个新号，初始化玩家数据
		print('初始化玩家数据')
		local sn = redis.command_and_wait(0,'INCR c_usersn')		-- 得到一个自增长序号
		
		redis.set(0,db_key, 'u'..sn)
		
		me.userId = 'u'..sn
		
		-- ========  初始化玩家数据开始 ========
		me.displayName = 'guest'..sn
		me.curExp = 0
		me.level = 1
		me.diamond = 100
		me.coin = 9999
		me.energy = 999
		
		local bag = {}
		table.insert(bag,{ itemID=10001 ,num=1000 })
		table.insert(bag,{ itemID=10002 ,num=5000 })
		table.insert(bag,{ itemID=10003 ,num=50 })
		table.insert(bag,{ itemID=10004 ,num=5 })
		table.insert(bag,{ itemID=10011 ,num=10 })
		
		me.items = bag
		
		local harem = { heros={} }
		table.insert(harem.heros,{id=1001,level=1,dis_lv=1,skill_lv={1,1,1,1},star_lv=1,skillLv=1})
		table.insert(harem.heros,{id=1002,level=10,dis_lv=1,skill_lv={10,10,10,10},star_lv=2,skillLv=1})
		table.insert(harem.heros,{id=1036,level=10,dis_lv=1,skill_lv={10,10,10,10},star_lv=2,skillLv=1})
		table.insert(harem.heros,{id=1050,level=15,dis_lv=1,skill_lv={20,20,20,20},star_lv=3,skillLv=1})
		table.insert(harem.heros,{id=1049,level=15,dis_lv=1,skill_lv={20,20,20,20},star_lv=3,skillLv=1})
		table.insert(harem.heros,{id=1051,level=20,dis_lv=1,skill_lv={30,30,30,30},star_lv=4,skillLv=1})
		
		me.harem = harem
		

		me.formations = {}
		table.insert(me.formations,{ heroIDs={1001,1002,1036,1050,1049},runeIDs={1,2,3} })
		table.insert(me.formations,{ heroIDs={1002,1036,1050,1049,1051},runeIDs={1,2,3} })
		

		-- ======== 初始化玩家数据结束 ========
		
		local ok,bin2 = pcall(pb.encode,'A2Data.User',me)				-- 调用protobuf序列化
		if not ok then
			print(debug.traceback())
			print(bin2)
			return 1
		end
		lcf.cur_stream_push_string(bin2,#bin2)		-- 放入发送缓冲
		lcf.cur_stream_write_back()							-- 返回消息给客户端，消息ID是1+1，内容是放入发送缓冲的字节
		
	else
		-- 读到了以前的存盘数据
		
		local player_data = pb.decode('A2Data.User',player_data_bin)		-- 调用protobuf反序列化
		
		for k,v in pairs(player_data) do		-- 遍历数据，复制到me上
			me[k] = v
		end
		
		lcf.cur_stream_push_string(player_data_bin,#player_data_bin)		-- 放入发送缓冲
		lcf.cur_stream_write_back()																	-- 返回消息给客户端，消息ID是1+1，内容是放入发送缓冲的字节
	end
	
	return 0
end

