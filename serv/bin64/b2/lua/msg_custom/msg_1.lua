
local lcf = ffi.C

local cur_init_version = 17


local function init_player_data(me)
		-- ========  初始化玩家数据开始 ========
		me.curExp = 0
		me.level = 1
		me.diamond = 100
		me.coin = 999999
		me.energy = 999
		
		local bag = {}
	
		table.insert(bag,{ itemID=10011 ,num=99,idx=1})
		table.insert(bag,{ itemID=10012 ,num=20 ,idx=2})
		table.insert(bag,{ itemID=10013 ,num=20 ,idx=3})
		table.insert(bag,{ itemID=10014 ,num=10 ,idx=4})
		table.insert(bag,{ itemID=15001 ,num=300 ,idx=5})
		table.insert(bag,{ itemID=15036 ,num=100 ,idx=6})
		table.insert(bag,{ itemID=15005 ,num=100 ,idx=7})
		table.insert(bag,{ itemID=15050 ,num=200 ,idx=8})
		table.insert(bag,{ itemID=15002 ,num=100 ,idx=9})
		
		
		
		me.items = bag
		
		me.heroes = {}
		table.insert(me.heroes,{id=1001,level=1,dis_lv=1,skill_lv={1,1,1,1},star_lv=1,exp=0})
		table.insert(me.heroes,{id=1002,level=10,dis_lv=1,skill_lv={10,10,10,10},star_lv=2,exp=3428})
		table.insert(me.heroes,{id=1036,level=10,dis_lv=1,skill_lv={10,10,10,10},star_lv=2,exp=3428})
		table.insert(me.heroes,{id=1050,level=15,dis_lv=1,skill_lv={20,20,20,20},star_lv=3,exp=12188})
		table.insert(me.heroes,{id=1005,level=15,dis_lv=1,skill_lv={20,20,20,20},star_lv=3,exp=12188})
		
		table.insert(me.heroes,{id=1003,level=1,dis_lv=0,skill_lv={1,1,1,1},star_lv=1,exp=20})
		table.insert(me.heroes,{id=1004,level=3,dis_lv=0,skill_lv={1,1,1,1},star_lv=1,exp=68})
		table.insert(me.heroes,{id=1006,level=3,dis_lv=1,skill_lv={1,1,1,1},star_lv=1,exp=68})
		table.insert(me.heroes,{id=1007,level=3,dis_lv=2,skill_lv={1,1,1,1},star_lv=1,exp=68})
		
		table.insert(me.heroes,{id=1008,level=2,dis_lv=0,skill_lv={1,1,1,1},star_lv=1,exp=20})
		table.insert(me.heroes,{id=1009,level=2,dis_lv=1,skill_lv={1,1,1,1},star_lv=1,exp=20})
		table.insert(me.heroes,{id=1010,level=2,dis_lv=2,skill_lv={1,1,1,1},star_lv=1,exp=20})
		
		table.insert(me.heroes,{id=1016,level=4,dis_lv=0,skill_lv={1,1,1,1},star_lv=1,exp=176})
		table.insert(me.heroes,{id=1017,level=4,dis_lv=1,skill_lv={1,1,1,1},star_lv=1,exp=176})
		table.insert(me.heroes,{id=1013,level=4,dis_lv=2,skill_lv={1,1,1,1},star_lv=1,exp=176})

		

		me.formations = {}
		table.insert(me.formations,{ idx=1,heroIDs={1001,1002,1036,1050,1005},runeIDs={1,2,3} })
		table.insert(me.formations,{ idx=2,heroIDs={1001,1002,1036,1050,1005},runeIDs={1,2,3} })
		

		-- ======== 初始化玩家数据结束 ========
end


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
		me.create_time = lcf.cur_game_time()
		me.versions = { cur_init_version }

		me.displayName = 'guest'..sn
		init_player_data(me)

		
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
		assert(player_data)
		
		if nil==player_data.versions or (player_data.versions[1] or 0)<cur_init_version then
			print('Reinit player',player_data.userId)
		
			me.userId = player_data.userId
			me.displayName = player_data.displayName
			me.create_time = player_data.create_time or lcf.cur_game_time()
			
			init_player_data(me)
			me.versions = me.versions or {}
			me.versions[1] = cur_init_version
			
			local bin2 = pb.encode('A2Data.User',me)	
			lcf.cur_stream_push_string(bin2,#bin2)
			lcf.cur_stream_write_back()
		else
			for k,v in pairs(player_data) do		-- 遍历数据，复制到me上
				me[k] = v
			end
			
			
			lcf.cur_stream_push_string(player_data_bin,#player_data_bin)
			lcf.cur_stream_write_back()
		end
		
	end
	
	return 0
end

