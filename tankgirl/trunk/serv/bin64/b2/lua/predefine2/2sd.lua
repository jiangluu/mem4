
local pb = require('protobuf')
local o = {}
local data = {}

sd = data		-- sd means static data


-- CONFIG SEGMENT
local protofiles = {
	'proto/P01_base.pb',
	'proto/P02_unit.pb',
	'proto/P03_item.pb',
	'proto/P05_discipline.pb',
}

local metas = {
	--p01_common = {typr='com.artme.data.CommonSheet'},
	p01_lv = {typr='com.artme.data.LvSheet',key='lv'},
	p01_purchase = {typr='com.artme.data.PurchaseSheet',key='buy_num'},
	p02_unit = {typr='com.artme.data.UnitSheet'},
	p02_unit_evo = {typr='com.artme.data.UEvoSheet',key='star_lv'},
	p02_unit_lv = {typr='com.artme.data.ULvSheet',key='lv'},
	p02_unit_skill = {typr='com.artme.data.USkillSheet',key='skillLv'},
	p03_item = { typr='com.artme.data.ItemSheet',key='unitId' },
	p03_group = { typr='com.artme.data.GroupSheet',key='groupId' },
	p03_group_content = { typr='com.artme.data.GContentSheet',key='groupId' },
	--p03_item_bag = { typr='com.artme.data.BagSheet',key='bagId' },
	p05_dis_item = {typr='com.artme.data.DisItemSheet',key='item_id'},
	--p05_dis_lv = {typr='com.artme.data.DisLvSheet',key='dis_lv'},
	p05_dis_play = {typr='com.artme.data.DisPlaySheet'},
	p05_dis_script = {typr='com.artme.data.DisScriptSheet'},
	p05_dis_support = {typr='com.artme.data.DisSupportSheet',key='item_id'},
	p05_dis_type = {typr='com.artme.data.DisTypeSheet',key='dis_type'},
}
-- CONFIG SEGMENT END

function o.register()
	-- 注册proto
	for i=1,#protofiles do
		print('parsing',protofiles[i])
		pb.register_file(protofiles[i])
	end
end

function o.init()
	--if 50 == g_box_id then
		o.register()
		
		-- local meta = {typr='com.artme.data.UnitSheet'}
		-- o.read_a_dat('p02_unit.dat',meta)
		for k,v in pairs(metas) do
			local filename = g_data_dir..k..'.bytes'
			local ok,msg = pcall(o.read_a_dat,filename,v)
			if not ok then
				print('read sd error!',k)
				print(msg)
				os.exit(-2)
			end
		end
	--end
end

function o.read_a_dat(dat_name,meta)
	local fh = io.open(dat_name,'rb')
	local bin = fh:read('*a')
	fh:close()
	
	
	local lua_t = pb.decode(meta.typr,bin)
	assert(lua_t)
	
	local level1 = string.match(dat_name,'.-_([^%.]+)%.bytes')
	assert(level1)
	
	data[level1] = {}
	local d = data[level1]
	
	for i=1,#lua_t.value do
		local v = lua_t.value[i]
		local key_name = meta.key or 'id'
		d[v[key_name]] = v
	end
	
	print(string.format('%s loaded %d row',level1,#lua_t.value))
end


o.init()
