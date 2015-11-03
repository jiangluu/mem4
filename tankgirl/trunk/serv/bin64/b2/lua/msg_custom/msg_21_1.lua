
local lcf = ffi.C

function onMsg(me,merge_meta,merge)
	print('msg 21_1')
	
		local formation_id = lcf.cur_stream_get_int16() + 1
		local bin = l_cur_stream_get_slice()
		
		local forma = pb.decode('A2Data.User.Formation',bin)
		assert(forma)
		
		me.formations = me.formations or {}
		
		local forma_id = math.min(formation_id,#me.formations+1)
		forma.idx = forma_id
		
		print('========',formation_id,forma_id)
		for i=1,#forma.heroIDs do
			print(forma.heroIDs[i])
		end
		print('========')
		
		
		me.formations[forma_id] = forma
		
		--merge.formations = me.formations
		table.insert(merge_meta,'User.Formation')
		table.insert(merge,forma)
	
	return 0
end
