
local o = {}

bag = o


function o.find(me,item_id)
	for i=1,#me.items do
		if item_id == me.items[i].itemID then
			local dd = me.items[i]
			dd.num = dd.num or 0		-- just fix
			return  dd, i
		end
	end
	return nil
end

function o.check(me,item_id,num)
	if 10001==item_id then
		return (me.coin or 0) >= num
	elseif 10002==item_id then
		return (me.diamond or 0) >= num
	end
	
	local it = o.find(me,item_id)
	if it and it.num>=num then
		return true
	end
	return false
end

function o.dec(me,item_id,num,tag)
	if 10001==item_id then
		if (me.coin or 0) >= num then
			me.coin = (me.coin or 0) - num
			return true
		else
			return false
		end
	elseif 10002==item_id then
		if (me.diamond or 0) >= num then
			me.diamond = (me.diamond or 0) - num
			return true
		else
			return false
		end
	end

	local it = o.find(me,item_id)
	if it and it.num>=num then
		it.num = it.num - num
		-- @TODO: 记运营日志
		return it
	end
	return false
end

function o.add(me,item_id,num,tag)
	-- @TODO: 记运营日志
	
	if 10001==item_id then
		me.coin = (me.coin or 0) + num
		return true
	elseif 10002==item_id then
		me.diamond = (me.diamond or 0) + num
		return true
	elseif 10005==item_id then
		me.curExp = (me.curExp or 0) + num
		return true
	end
	
	local it = o.find(me,item_id)
	if it then
		it.num = it.num + num
		return it
	else
		local a = { itemID=item_id,num=num,idx=#me.items+1 }
		table.insert(me.items,a)
		return a
	end
end


-- ================================
local lcf = ffi.C

function now()
	return tonumber(lcf.cur_game_time())
end

