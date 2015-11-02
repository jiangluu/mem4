
local o = require('protobuf')

pb = {}


local filename = 'proto/user.pb'


--[[
有
pb.encode()

pb.decode()

pb.register_file()
--]]

pb.register_file = o.register_file
pb.encode = o.encode

function pb.decode(typr,aa)
	local not_a_real_table = o.decode(typr,aa)
	return o.extract(not_a_real_table)
end


function pb.init()
	-- 注册proto
	o.register_file(filename)
end

function pb.test()
	-- 注册proto
	o.register_file(filename)
	
	
	-- encode
	print('EEEEEEEEENCODE')
	local me = {}
	me.id_ = 'u1'
	me.name_ = 'jiangwei'
	me.exp_ = 88
	me.lv_ = 2
	me.diamond_ = 100
	
	local bag = {}
	table.insert(bag,{ item_id_=2 })
	table.insert(bag,{ item_id_=3 })
	
	me.bag_ = bag
	
	local bin = o.encode('User',me)
	
	print(#bin,bin)
	
	
	--decode
	print('DDDDDDDDDDDECODE')
	local t = o.decode('User',bin)
	print(t)
	
	for k,v in pairs(t) do
		print(k,v)
		if 'bag_'==k then
			for i=1,#v do
				print(i,v[i],v[i].item_id_)
			end
		end
	end
end


pb.init()
