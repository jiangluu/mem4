
function isServ()
	return true
end


function jlpcall(func,...)
	local err,msg = pcall(func,...)
	if err == false then
		print(err,msg)
	end
end


function eval(str)
    if type(str) == "string" then
        return loadstring("return " .. str)()
    else
        error("is not a string")
    end
end


function InitLogic(currentTime)
	print('InitLogic')
	--math.randomseed(currentTime)
	math.randomseed(1000000)
end

function EmuTest()
end

g_lua_dir = "lua/"
g_data_dir = "data/"


if isServ() then
	jlpcall(dofile,g_lua_dir.."serverframe/init_ffi.lua")
	jlpcall(dofile,g_lua_dir.."serverframe/lz.lua")
	jlpcall(dofile,g_lua_dir.."serverframe/log.lua")
	jlpcall(dofile,g_lua_dir.."serverframe/yylog.lua")
	jlpcall(dofile,g_lua_dir.."serverframe/apb.lua")
	
	jlpcall(dofile,g_lua_dir.."atable.lua")
	jlpcall(dofile,g_lua_dir.."redis_port.lua")
	
	jlpcall(dofile,g_lua_dir.."serverframe/transaction.lua")
	--jlpcall(dofile,g_lua_dir.."serverframe/aredis.lua")
	--jlpcall(dofile,g_lua_dir.."serverframe/db.lua")
	jlpcall(dofile,g_lua_dir.."serverframe/box.lua")
	jlpcall(dofile,g_lua_dir.."serverframe/profiler.lua")
	jlpcall(dofile,g_lua_dir.."serverframe/player.lua")
	jlpcall(dofile,g_lua_dir.."serverframe/msgs.lua")
	
end

