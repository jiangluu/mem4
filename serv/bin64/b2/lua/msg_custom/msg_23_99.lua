
local lcf = ffi.C

function onMsg(me,merge)
	print('msg 23_99')
	
		
		--local bin = pb.encode('A2Data.User',me)
		local bin = string.rep('abcd',498)
		
		for i=1,12 do
			lcf.cur_writestream_cleanup()
			lcf.cur_stream_push_string(bin,#bin)		-- 放入发送缓冲
			lcf.cur_stream_write_back()
		end
	
	return 0
end