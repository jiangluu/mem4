
local lcf = ffi.C


function onMsg(me,merge_meta,merge)
	local stage_id = lcf.cur_stream_get_int32() 
	local forma_idx = lcf.cur_stream_get_int32() 
	
	print('msg 25_4',stage_id,forma_idx)
	
	local forma = nil
	for i=1,#me.formations do
		if forma_idx == me.formations[i].idx then
			forma = me.formations[i]
			break
		end
	end
	assert(forma)
	
	-- 为了测试方便先不检查状态
	local conf = sd.stage_stage[stage_id]
	
	if me.energy < conf.cost then
		return 1
	end
	
	
	
	
	-- modify
	local t_item_get = {}
	local t_hero_changed = {}
	
	me.energy = me.energy - conf.cost
	
	me.curExp = (me.curExp or 0) + (conf.expDevil * math.random(80,120) / 100)
	-- level up auto
	for lv=me.level,999 do
		local raw = sd.lv[lv]
		if nil==raw then
			break
		end
		
		if me.curExp >= raw.exp then
			me.level = me.level + 1
		else
			break
		end
	end
	
	me.coin = me.coin + (conf.gold * math.random(80,120) / 100)
	
	for i=1,#forma.heroIDs do
		for j=1,#me.heroes do
			local h = me.heroes[j]
			if h.id == forma.heroIDs[i] then
				h.exp = h.exp + conf.expHero
				
				-- level up auto
				for lv=h.level, 999 do
					local raw = sd.unit_lv[lv]
					if nil==raw then
						break
					end
					
					if h.exp >= raw.exp then
						h.level = h.level + 1
					else
						break
					end
				end
				
				table.insert(t_hero_changed, h)
			end
		end
	end
	
	local function loot(a)
		local col2 = 'prob'..a
		if math.random(100)<=conf[col2] then
			local col1 = 'item'..a
			table.insert(t_item_get, { itemID=conf[col1],num=1 })
		end
	end
	
	for i=1,5 do
		loot(i)
	end
	
	for i=1,#t_item_get do
		bag.add(me,t_item_get[i].itemID, t_item_get[i].num, 'saodang')
	end
	
	
	local me2 = {}
	me2.energy = me.energy
	me2.coin = me.coin
	me2.curExp = me.curExp
	me2.level = me.level
	me2.heroes = t_hero_changed
	me2.items = t_item_get
	table.insert(merge_meta,'User')
	table.insert(merge,me2)
	
	
	return 0
end
