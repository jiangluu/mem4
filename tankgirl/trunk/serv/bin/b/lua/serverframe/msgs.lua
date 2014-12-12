
function regAllHandlers()
	if isServ() then
		-- 注册消息handler
		for file in lfs.dir(g_lua_dir..'msg/') do
			local msg_id = string.match(file,'msg_(%d+)%.lua')
			if msg_id then
				onMsg = nil
				jlpcall(dofile,g_lua_dir..'msg/'..file)
				if nil~=onMsg then
					box.reg_handle(tonumber(msg_id),onMsg)
					print(file..'  registed')
				end
				onMsg = nil
			end
		end
	end
end

regAllHandlers()
