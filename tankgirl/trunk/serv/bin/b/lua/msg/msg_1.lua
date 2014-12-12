
local lcf = ffi.C

function onMsg(me)
	
	print('msg_1 aaaaaaaaaaaaaaaaaaaaaaaaaaaa')
	
	apb.begin_push_user()
	apb.push_user('id',8)
	apb.push_user('name','yanglongjun')
	apb.push_user('phone',13988888888)
	
	apb.push_user('test',5)
	apb.push_user('test',6)
	apb.push_user('test',7)
	
	local s = apb.end_push(apb.user)
	print(s)
	
	lcf.cur_stream_push_string(ffi.cast('const char*',s.buffer),s.len)
	lcf.cur_stream_write_back()
	
	return 0
end

