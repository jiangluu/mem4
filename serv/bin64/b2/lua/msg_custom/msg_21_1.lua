
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
		
		-- check
		for i=1,#forma.heroIDs do
			local h = forma.heroIDs[i]
			local found = false
			for j=1,#me.heroes do
				if h == me.heroes[j].id then
					found = true
					break
				end
			end
			
			if not found then
				return 2
			end
			
			for j=1,#me.formations do
				if j ~= forma_id then
					local aa = me.formations[j].heroIDs
					found = false
					for j2=1,#aa do
						if h == aa[j2] then
							found = true
							break
						end
					end
					
					if found then
						return 3
					end
				end
			end
		end
		
		for i=1,#forma.runeIDs do
			local h = forma.runeIDs[i]
			local found = false
			for j=1,#me.runes do
				if h == me.runes[j].id then
					found = true
					break
				end
			end
			
			if not found then
				return 2
			end
			
			for j=1,#me.formations do
				if j ~= forma_id then
					local aa = me.formations[j].runeIDs
					found = false
					for j2=1,#aa do
						if h == aa[j2] then
							found = true
							break
						end
					end
					
					if found then
						return 3
					end
				end
			end
		end
		
		
		me.formations[forma_id] = forma
		
		local me2 = {}
		me2.formations = { forma }
		table.insert(merge_meta,'User')
		table.insert(merge,me2)
	
	return 0
end
