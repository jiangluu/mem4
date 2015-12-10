
local lcf = ffi.C


function onMsg(me,merge_meta,merge)
	local stage_id = lcf.cur_stream_get_int32() 
	local star = 3		-- for now
	
	print('msg 25_6',stage_id)
	
	assert(me._cache)
	local predata = me._cache
	me._cache = nil
	
	if stage_id ~= predata.stage_id then
		return 2
	end	
	
	
	local conf = sd.stage_stage[stage_id]
	local forma = me.formations[predata.forma]
	assert(forma)
	
	
	-- modify
	me.stages = me.stages or {}
	local stage_found = false
	for i=1,#me.stages do
		if stage_id == me.stages[i].stageId then
			stage_found = true
			me.stages[i].star = star
			break
		end
	end
	if false == stage_found then
		table.insert(me.stages, { stageId=stage_id, star=star })
	end
	
	
	local t_item_get = {}
	local t_hero_changed = {}
	
	
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
	
	for i=1,#predata.pool do
		local d = predata.pool[i]
		if d.itemID < 10000 then
			-- it's monan
			local h = { id=d.itemID,level=1,dis_lv=1,skill_lv={1,1,1,1},star_lv=1,exp=0 }
			table.insert(t_hero_changed, h)
			table.insert(me.heroes, h)
		else
			table.insert(t_item_get, d)
		end
	end
	
	for i=1,#t_item_get do
		bag.add(me,t_item_get[i].itemID, t_item_get[i].num, 'pve')
	end
	
	
	local me2 = {}
	me2.energy = me.energy
	me2.coin = me.coin
	me2.curExp = me.curExp
	me2.level = me.level
	me2.stages = me.stages
	me2.heroes = t_hero_changed
	me2.items = t_item_get
	table.insert(merge_meta,'User')
	table.insert(merge,me2)
	
	
	
	return 0
end
