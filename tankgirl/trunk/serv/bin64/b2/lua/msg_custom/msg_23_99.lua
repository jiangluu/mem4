
local lcf = ffi.C

function onMsg(me,merge_meta,merge)
	print('msg 23_99')
	
		
		-- local bin = pb.encode('A2Data.User',me)
		
		-- for i=1,12 do
			-- lcf.cur_write_stream_cleanup()
			-- lcf.cur_stream_push_string(bin,#bin)		-- 放入发送缓冲
			-- lcf.cur_stream_write_back()
		-- end
		
		local forma = { idx=2,heroIDs={1002,1036,1050,1049,1051},runeIDs={1,2,3} }
		table.insert(merge_meta,'User.Formation')
		table.insert(merge,forma)
	
	return 0
end
