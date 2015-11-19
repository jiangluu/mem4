
local lcf = ffi.C

function onMsg(me,merge_meta,merge)
	print('msg 23_99')
	
		
		-- local bin = pb.encode('A2Data.User',me)
		
		-- for i=1,12 do
			-- lcf.cur_write_stream_cleanup()
			-- lcf.cur_stream_push_string(bin,#bin)		-- 放入发送缓冲
			-- lcf.cur_stream_write_back()
		-- end
	
	local hero_id = 1002
	local nan_dis_type = sd.unit[hero_id].dis_type
	
	print(nan_dis_type,type(nan_dis_type))
	print(sd.dis_type[1])
	local pbc = require('protobuf')
	print('pbc',pbc,pbc.enum_id)
	local aa = pbc.enum_id('com.artme.data.Unit.DISType',nan_dis_type)
	print('bbbbbbbb',aa)
	
	return 0
end
