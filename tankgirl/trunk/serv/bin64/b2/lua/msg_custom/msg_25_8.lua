
local lcf = ffi.C


function onMsg(me,merge_meta,merge)
	local energy_want = lcf.cur_stream_get_int32() 
	
	print('msg 25_8',energy_want)
	if energy_want<0 or energy_want>200 then
		return 1
	end
	
	
	local aa = energy_want * 2		-- TODO
	
	me.energy = (me.energy or 0) + energy_want
	bag.dec(me,10002,aa,'buy_energy')
	
	
	local me2 = {}
	me2.energy = me.energy
	me2.diamond = me.diamond
	table.insert(merge_meta,'User')
	table.insert(merge,me2)
	
	
	return 0
end
