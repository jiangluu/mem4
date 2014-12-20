
local app_type = {
	D = {1,1},	-- type in number,layer
	S = {2,2},
	G = {3,3},
	
	-- ================ 下面是非核心节点类型 ================
	P = {10,100},	-- ControlPanel
}

local hds = {}

local online_apps = 0
local offline_apps = 0
if apps_bak then
	online_apps = apps_bak[1]
	offline_apps = apps_bak[2]
else
	online_apps = {}
	offline_apps = {}
end


apps_bak = {online_apps,offline_apps}	-- 这个变量是为了热更新


local lcf = ffi.C


function OnMessage(msg_id)
	logg('OnMessage',msg_id)
	
	local handler = hds[msg_id]
	if handler then
		jlpcall(handler)
	else
		logg(string.format('message [%d] has NO handler',msg_id))
	end
end

function OnOffline(link_index)
	print('OnOffline',link_index)
	-- 下线的节点从online_apps里去除
	for gid,v in pairs(online_apps) do
		if link_index==v[2] then
			-- TODO: 通知相关节点，这货下线了
			
			offline_apps[gid] = online_apps[gid]
			online_apps[gid] = nil
			return
		end
	end
end


function hds.regHandler(msg_id,hd)
	hds[msg_id] = hd
end

hds.regHandler(1001,function()
	local first = lcf.cur_stream_get_int32()
	local app_gid = ffi.string(lcf.cur_stream_get_string())
	
	print(1001,first,app_gid)
	
	if true then
		local app = hds.findapp(app_gid)
		if nil==app then
			-- 不存在的app，不理他
			return
		end
		
		if nil ~= app.frontend then
			lcf.cur_stream_push_int32(1)
			lcf.cur_stream_push_string(app.frontend.port,0)
			lcf.cur_stream_push_int32(app.frontend.max_connection)
			lcf.cur_stream_push_int32(app.frontend.read_buffer)
			lcf.cur_stream_push_int32(app.frontend.write_buffer)
		else
			lcf.cur_stream_push_int32(0)
		end
		
		if nil ~= app.backend then
			lcf.cur_stream_push_int32(1)
			lcf.cur_stream_push_int32(app.backend.max_connection)
			lcf.cur_stream_push_int32(app.backend.read_buffer)
			lcf.cur_stream_push_int32(app.backend.write_buffer)
		else
			lcf.cur_stream_push_int32(0)
		end
		
		lcf.cur_stream_write_back()
		
	end
end)

function hds.findapp(gid)
	for i,v in pairs(global_config.apps) do
		if gid == v.gid then
			return v
		end
	end
	
	return nil
end

function hds.find_app_and_write_frontend(gid,is_backend)
	local ta_app = hds.findapp(gid)
	if ta_app~=nil then
		lcf.cur_stream_push_int32(1)
		lcf.cur_stream_push_int32(is_backend)
		lcf.cur_stream_push_string(gid,0)
		lcf.cur_stream_push_string(ta_app.frontend.port,0)
	end
end

hds.regHandler(1003,function()
	local app_stat = lcf.cur_stream_get_int32()
	local app_gid = ffi.string(lcf.cur_stream_get_string())
	
	local app = hds.findapp(app_gid)
	if nil==app then
		-- 不存在的app，不理他
		return
	end
	
	-- 记入online节点列表
	local prefix = string.sub(app_gid,1,1)
	local type_and_layer = app_type[prefix]
	if nil==type_and_layer then
		return
	end
	
	-- stat，link索引，类型in数字，层
	local layer = type_and_layer[2]
	online_apps[app_gid] = {app_stat,lcf.get_cur_link_index(),type_and_layer[1],layer}
	
	if nil ~= app.backend then
		if app.backend.connect_all_lowlayer then
			-- 找所有下一层的，发给此link
			for ta_id,v in pairs(online_apps) do
				if layer-1==v[4] then
					hds.find_app_and_write_frontend(ta_id,1)
				end
			end
		end
		
		if app.backend.connect_destiny then
			for ta_id in string.gmatch(app.backend.connect_destiny,'(%w+)') do
				local onlined = online_apps[ta_id]
				if onlined then
					hds.find_app_and_write_frontend(ta_id,1)
				end
			end
		end
	end
	
	if nil ~= app.frontend then
		if app.frontend.connect_destiny then
			for ta_id in string.gmatch(app.frontend.connect_destiny,'(%w+)') do
				local onlined = online_apps[ta_id]
				if onlined then
					hds.find_app_and_write_frontend(ta_id,0)
				end
			end
		end
	end
	
	lcf.cur_stream_push_int32(0)
	
	lcf.cur_stream_write_back()
	
	
	-- 检查是否是断线重连的app，如果是，通知其他会用到它的服务的app
	local prev_life = offline_apps[app_gid]
	offline_apps[app_gid] = nil
	
	--if nil~=prev_life then
	if true then
		for ta_id,on_app in pairs(online_apps) do
			local ta_app = hds.findapp(ta_id)
			local ta_type_and_layer = app_type[string.sub(ta_id,1,1)]
			
			local a = ta_app.backend and ta_app.backend.connect_all_lowlayer and layer+1==ta_type_and_layer[2]
			local b = false
			if ta_app.backend and ta_app.backend.connect_destiny then
				for aaa_id in string.gmatch(ta_app.backend.connect_destiny,'(%w+)') do
					if aaa_id==app_gid then
						b = true
					end
				end
			end
			
			if app.frontend and (a or b) then
				lcf.cur_write_stream_cleanup()
				lcf.cur_stream_push_int32(1)
				lcf.cur_stream_push_int32(1)
				lcf.cur_stream_push_string(app_gid,0)
				lcf.cur_stream_push_string(app.frontend.port,0)
				lcf.cur_stream_push_int32(0)
				lcf.cur_stream_write_2_link(on_app[2],1004)
				print('send 1004',app_gid,app.frontend.port,on_app[2])
			end
			
		end
	end
end)


function getOnlineApps()
	return online_apps
end


-- 1101是监控相关
hds.regHandler(1101,function()
	simple_routine.come(1101)
end)

hds.regHandler(1102,function()
	simple_routine.back(1102)
end)

hds.regHandler(1103,function()
	local safe_call = jlpcall
	safe_call(dofile,g_lua_dir.."init.lua")
end)


