
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
		me.displayName = 'guest'..sn
		me.curExp = 88
		me.level = 1
		me.diamond = 100
		me.coin = 9999
		me.energy = 999
		
		-- local bag = {}
		-- table.insert(bag,{ itemIDs=2 })
		-- table.insert(bag,{ itemIDs=3 })
		
		-- me.package = bag
		
		local harem = { heros={} }
		table.insert(harem.heros,{id=1001,name='艾丽卡',level=1,hp=33, attack=123})
		table.insert(harem.heros,{id=1002,name='卡玫尔',level=2,hp=12, attack=123})
		table.insert(harem.heros,{id=1003,name='萝拉',level=3,hp=32, attack=123})
		table.insert(harem.heros,{id=1004,name='柚夜',level=4,hp=34, attack=123})
		table.insert(harem.heros,{id=1005,name='西弥斯',level=5,hp=45, attack=123})
		table.insert(harem.heros,{id=1007,name='蔻蔻洛',level=6,hp=53, attack=123})
		table.insert(harem.heros,{id=1008,name='柯纳罕',level=7,hp=13, attack=123})
		table.insert(harem.heros,{id=1009,name='帕拉斯',level=8,hp=37, attack=123})
		table.insert(harem.heros,{id=1010,name='亚述',level=9,hp=23, attack=123})
		table.insert(harem.heros,{id=1013,name='珂赛特',level=10,hp=44, attack=123})
		table.insert(harem.heros,{id=1014,name='艾妮',level=11,hp=123, attack=123})
		table.insert(harem.heros,{id=1015,name='嘉比儿',level=12,hp=25, attack=123})
		table.insert(harem.heros,{id=1016,name='诗蒂雅',level=13,hp=53, attack=123})
		table.insert(harem.heros,{id=1017,name='凛',level=14,hp=56, attack=123})
		table.insert(harem.heros,{id=1031,name='米可',level=15,hp=86, attack=123})
		table.insert(harem.heros,{id=1032,name='艾娜斯',level=16,hp=838, attack=123})
		table.insert(harem.heros,{id=1034,name='帕尔希',level=17,hp=929, attack=123})
		table.insert(harem.heros,{id=1036,name='薇莉雅',level=18,hp=63, attack=123})
		table.insert(harem.heros,{id=1038,name='狄丽尔',level=19,hp=85, attack=123})
		table.insert(harem.heros,{id=1039,name='戈林尔',level=21,hp=23, attack=123})
		table.insert(harem.heros,{id=1040,name='妮姆妮姆',level=22,hp=34, attack=123})
		table.insert(harem.heros,{id=1041,name='毕库理',level=23,hp=345, attack=123})
		table.insert(harem.heros,{id=1042,name='嘉尔姆',level=24,hp=647, attack=123})
		table.insert(harem.heros,{id=1043,name='艾尔萨雷雅',level=25,hp=78, attack=123})
		table.insert(harem.heros,{id=1044,name='嘉格丽',level=26,hp=34, attack=123})
		table.insert(harem.heros,{id=1045,name='莉莉丝',level=27,hp=67, attack=123})
		table.insert(harem.heros,{id=1046,name='贝露丹',level=28,hp=236, attack=123})
		table.insert(harem.heros,{id=1047,name='库玛',level=29,hp=72, attack=123})
		table.insert(harem.heros,{id=1049,name='美杜莎',level=30,hp=83, attack=123})
		table.insert(harem.heros,{id=1051,name='早苗',level=31,hp=23, attack=123})
		table.insert(harem.heros,{id=1006,name='涅涅',level=32,hp=56, attack=123})
		table.insert(harem.heros,{id=1012,name='西比尔',level=33,hp=82, attack=123})
		table.insert(harem.heros,{id=1018,name='理莎',level=34,hp=35, attack=123})
		table.insert(harem.heros,{id=1019,name='木木',level=35,hp=93, attack=123})
		table.insert(harem.heros,{id=1020,name='圣洛玛',level=36,hp=858, attack=123})
		table.insert(harem.heros,{id=1021,name='阿格莱亚',level=37,hp=120, attack=123})
		table.insert(harem.heros,{id=1022,name='旦卫莉',level=38,hp=23, attack=123})
		table.insert(harem.heros,{id=1024,name='乌托',level=39,hp=73, attack=123})
		table.insert(harem.heros,{id=1025,name='安娜',level=40,hp=52, attack=123})
		table.insert(harem.heros,{id=1026,name='洛伊',level=41,hp=53, attack=123})
		table.insert(harem.heros,{id=1027,name='爱瑟',level=42,hp=81, attack=123})
		table.insert(harem.heros,{id=1028,name='妖奇',level=43,hp=57, attack=123})
		table.insert(harem.heros,{id=1029,name='塞莉亚',level=44,hp=48, attack=123})
		table.insert(harem.heros,{id=1030,name='风名铃',level=45,hp=49, attack=123})
		table.insert(harem.heros,{id=1033,name='贝雅儿',level=46,hp=28, attack=123})
		table.insert(harem.heros,{id=1035,name='希德',level=47,hp=125, attack=123})
		table.insert(harem.heros,{id=1037,name='夏柏',level=48,hp=171, attack=123})
		table.insert(harem.heros,{id=1048,name='蜂人',level=49,hp=19, attack=123})
		table.insert(harem.heros,{id=1050,name='真夏',level=50,hp=56, attack=123})
		me.harem = harem
		

		me.formations = {}
		table.insert(me.formations,{ heroIDs={1001,1002,1003,1004,1005},runeIDs={1,2,3} })
		table.insert(me.formations,{ heroIDs={1010,1016,1014,1031,1032},runeIDs={1,2,3} })
		table.insert(me.formations,{ heroIDs={1040,1043,1013,1005,1017},runeIDs={1,2,3} })
		table.insert(me.formations,{ heroIDs={1044,1047,1049,1051,1006},runeIDs={1,2,3} })
		table.insert(me.formations,{ heroIDs={1017,1031,1039,1051,1010},runeIDs={1,2,3} })

		-- 初始化玩家数据结束
		
		local ok,bin2 = pcall(pb.encode,'com.artme.data.User',me)				-- 调用protobuf序列化
		if not ok then
			print(debug.traceback())
			print(bin2)
			return 1
		end
		lcf.cur_stream_push_string(bin2,#bin2)		-- 放入发送缓冲
		lcf.cur_stream_write_back()							-- 返回消息给客户端，消息ID是1+1，内容是放入发送缓冲的字节
		
	else
		-- 读到了以前的存盘数据
		
		local player_data = pb.decode('com.artme.data.User',player_data_bin)		-- 调用protobuf反序列化
		
		for k,v in pairs(player_data) do		-- 遍历数据，复制到me上
			me[k] = v
		end
		
		lcf.cur_stream_push_string(player_data_bin,#player_data_bin)		-- 放入发送缓冲
		lcf.cur_stream_write_back()																	-- 返回消息给客户端，消息ID是1+1，内容是放入发送缓冲的字节
	end
	
	return 0
end

