
--simple log system
function logg(...)
	print(...)
end

function jlpcall(func,...)
	local err,msg = pcall(func,...)
	if err == false then
		print(err,msg)
	end
end

function InitLogic(unix_time)
	print('InitLogic')
	math.randomseed(unix_time)
end


g_lua_dir = "lua/"

jlpcall(dofile,g_lua_dir.."init_ffi.lua")
jlpcall(dofile,g_lua_dir.."artme1.lua")
jlpcall(dofile,g_lua_dir.."simple_routine.lua")
jlpcall(dofile,g_lua_dir.."config.lua")


