
local lcf = ffi.C

function onMsg()
	local node_id = l_gx_cur_stream_get_slice()
	local port = l_gx_cur_stream_get_slice()
	local stat = lcf.gx_cur_stream_get_int16()
	
	l_gx_simple_ack()
	
	-- router只关心router
	if 1==stat and 'R'==string.sub(node_id,1,1) then
		local old = nodes_table[node_id]
		if nil==old or old[4]<1 then
			local r = lcf.gx_make_portal_sync(node_id,port)
			if r<0 then
				print(string.format('make_portal failed. id: %s  port: %s',node_id,port))
				return -1
			end
			
			nodes_table[node_id] = {node_id,port,r,1}
			
			lcf.gx_cur_writestream_cleanup()
			l_gx_cur_writestream_put_slice(g_node_id)
			l_gx_cur_writestream_put_slice(g_port)
			
			lcf.gx_cur_writestream_send_to(r,8011)
		end
	end
	
	
	return 0
end
