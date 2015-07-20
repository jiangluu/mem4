
local ap = require('atabletopointer')

local pairs_bak = pairs
pairs = function(t)
	local typr = type(t)
	if 'table'==typr then
		return next,t,nil
	elseif 'userdata'==typr then
		return ap.pairs(t)
	end
end

-- 下面是企图修正5.1里table其实无视__len的行为
table.getn2 = table.getn
table.getn = function(o)
	if nil==o then
		return 0
	end
	
	return #o
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
		if t.index.enum then
			local ee = t.index.enum
			local lenth = table.getn(ee)
			for i=1,lenth do
				local k = ee[i]
				pcall(f,t,k)
			end
		else
			for k,v in pairs(t) do
				pcall(f,t,k)
			end
		end
end

