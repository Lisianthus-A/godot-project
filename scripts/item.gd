extends Node

const item_data = {
	"1": {
		"id": "1",
		"name": "红宝石",
		"type": "ability_atk",
		"value": 1,
		"immediately": true
	},
	"2": {
		"id": "2",
		"name": "蓝宝石",
		"type": "ability_def",
		"value": 1,
		"immediately": true
	},
	"3": {
		"id": "3",
		"name": "血瓶",
		"type": "ability_hp",
		"value": 50,
		"immediately": true
	}
}

# 获得物品
func obtain(id: String):
	var item = item_data[id]
	if item.immediately: # 需要立即使用的物品
		use(id)
	else:
		if Character.items.has(id):
			Character.items[id].count += 1
		else:
			Character.items[id] = {
				"id": id,
				"count": 1,
			}

# 使用物品
func use(id: String):
	var item = item_data[id]
	if item.type == "ability_atk": # 增加攻击力
		Character.atk += item.value
	elif item.type == "ability_def": # 增加防御力
		Character.def += item.value
	elif item.type == "ability_hp": # 增加血量
		Character.hp += item.value
	Battle.map_id_to_damage.clear()
	Character.update_hud()
	Map.update_monster_damage()
