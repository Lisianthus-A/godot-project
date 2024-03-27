extends Node

const monster_data = {
	"1": {
		"id": "1",
		"name": "兽人",
		"hp": 50,
		"atk": 15,
		"def": 0
	}
}

func get_damage(monster_id: String):
	var monster = monster_data[monster_id]
	# 无法破防
	if Character.atk <= monster.def:
		return null

	var rounds = ceili(float(monster.hp) / Character.atk)
	var damage_per_round = max(monster.atk - Character.def, 0)
	return rounds * damage_per_round

func fight(monster_id: String) -> bool:
	var damage = get_damage(monster_id)
	print("damage:", damage)
	if damage == null:
		return false

	if Character.hp > damage:
		Character.hp -= damage
		return true

	return false
