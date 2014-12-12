
-- 一些table相关操作。写这些的部分原因是要兼容客户端脚本环境


if isServ() then
	table_insert = table.insert
	
	table_remove = table.remove
	
	table_sort = table.sort
	
	newArray = function()
		return {}
	end
	
	-- 为了支持conf模块，又因为5.1没有__pairs metamethod，所以自定义一个pairs函数并替代原有的
	local local_next = next
	next_backup = next
	
	local conf_t = require("conf_lua")
	local local_conf_next = conf_t.next
	
	pairs__backup = pairs
	
	pairs = function(t)
		if nil~=rawget(t,'__parent') then
			-- a conf userdata
			return local_conf_next,t,nil
		else
			-- a NORMAL one
			return local_next,t,nil
		end
	end
	
else
	function deepCloneTableToUserData(u,a)
		for k,v in pairs(a) do
			if type(v)=='table' then
				if 'list'==k then
					u[k] = newArray()
				else
					u[k] = {}
				end
				deepCloneTableToUserData(u[k],v)
			else
				u[k] = v
			end
		end
	end

	table_insert = function(t,a)
		if type(t) == 'table' then
			return table.insert(t,a)
		end
		local ll = #t
		if type(a)=='table' then
			local fake_t = t[ll+1]
			-- for k,v in pairs(a) do
				-- if type(v)=='table' then
					-- fake_t[k] = {}
					-- deepCloneTableToUserData(fake_t[k],v)
				-- else
					-- fake_t[k] = v
				-- end
			-- end
			deepCloneTableToUserData(fake_t,a)
		else
			t[ll+1] = a
		end
		
		return ll+1
	end
	
	table_remove = function(t,index)
		if 'table'==type(t) then
			return table.remove(t,index)
		else
			removeElement(t,index)
		end
	end
	
	table_sort = function(t,fun)
		local lenth = #t
		for i=2,lenth do
			for j=i,2,-1 do
				if fun(t[j],t[j-1]) then
					t[j],t[j-1] = t[j-1],t[j]
				end
			end
		end
	end
end


function table.shuffle_array(t)
	local size = #t
	if size<=1 then
		return t
	end
	
	for outer=1,2 do
		for i=1,size-1 do
			local random_pos = math.random(1,size)
			local tail = table.remove(t)
			table.insert(t,random_pos,tail)
		end
	end
	
	return t
end

local function table_deepclone(t)
	if not ('table'==type(t) or 'userdata'==type(t)) then
		return nil
	end
	
	local ret = {}
	for k,v in pairs(t) do
		if '__'~=string.sub(k,1,2) then		-- 必须过滤掉meta
			if 'table'==type(v) or 'userdata'==type(v) then
				ret[k] = table_deepclone(v)
			else
				ret[k] = v
			end
		end
	end
	
	return ret
end

table.deepclone = table_deepclone

deepCloneTable = table_deepclone


function table.travel_sd(t,f)
	-- if nil==t.index.enum then
		-- return -1
	-- end
	
	-- for i=1,99999 do
		-- local k = t.index.enum[i]
		-- if k then
			-- pcall(f,t,k)
		-- else
			-- return i
		-- end
	-- end
	for k,v in pairs(t) do
		pcall(f,t,k)
	end
end

