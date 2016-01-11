
local lcf = ffi.C

function onMsg(me,merge_meta,merge)
	local hero_id = lcf.cur_stream_get_int32() 
	
	
	local hero_i = -1
	for i=1,#me.heroes do
		if hero_id == me.heroes[i].id then
			hero_i = i
			break
		end
	end
	
	if hero_i<0 then
		return 2
	end
	
	
	local nan = me.heroes[hero_i]
	local now = now()
	if (nan.dis_cd or 0) <= now then
		return 3
	end
	
	local cost = math.floor(sd.dis_cd[1].price_perSec * (nan.dis_cd - now))
	cost = math.max(1,cost)
	
	if not bag.dec(me,10002,cost,'clear_dis_cd') then
		return 4
	end
	
	nan.dis_cd = now - 1
	
	
	local me2 = {}
	me2.diamond = me.diamond
	me2.heroes = { nan }
	table.insert(merge_meta,'User')
	table.insert(merge,me2)
	
	
	return 0
end
