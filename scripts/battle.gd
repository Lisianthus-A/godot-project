extends Node

const monster_data = {
	"1": {
		"id": "1",
		"name": "兽人",
		"hp": 50,
		"atk": 12,
		"def": 5,
		"money": 10,
		"exp": 15
	},
	"2": {
		"id": "2",
		"name": "绿兽人",
		"hp": 100,
		"atk": 20,
		"def": 10,
		"money": 20,
		"exp": 20
	}
}

# 用于缓存相同怪物的伤害 Todo: 清理缓存逻辑
var map_id_to_damage := {}

func get_damage(monster_id: String):
	if map_id_to_damage.has(monster_id):
		return map_id_to_damage[monster_id]
	
	var monster = monster_data[monster_id]
	# 无法破防
	if Character.atk <= monster.def:
		map_id_to_damage[monster_id] = null
		return null

	# 回合数
	var rounds = ceili(float(monster.hp) / (Character.atk - monster.def))
	# 每回合被造成的伤害
	var damage_per_round = max(monster.atk - Character.def, 0)
	var res = (rounds - 1) * damage_per_round
	map_id_to_damage[monster_id] = res
	return res

func fight(monster_id: String) -> bool:
	var damage = get_damage(monster_id)
	#print("damage:", damage)
	if damage == null:
		return false

	if Character.hp > damage:
		Character.hp -= damage
		return true

	return false
