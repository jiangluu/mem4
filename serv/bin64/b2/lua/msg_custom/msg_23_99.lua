
local lcf = ffi.C

function onMsg(me,merge)
	print('msg 23_99')
	
		
		-- local bin = pb.encode('A2Data.User',me)
		
		-- for i=1,12 do
			-- lcf.cur_write_stream_cleanup()
			-- lcf.cur_stream_push_string(bin,#bin)		-- 放入发送缓冲
			-- lcf.cur_stream_write_back()
		-- end
		
		me.coin = me.coin + 1
		merge.coin = me.coin
	
	return 0
end
