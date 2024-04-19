extends Node

const pos_next_floor = Vector2(1, 1)
const pos_prev_floor = Vector2(2, 2)

func _ready():
	var map_node = get_node("/root/World/F1/TileMap")
	System.init(map_node)
	Character.init_pos(pos_prev_floor)

func _process(_delta):
	System.process_handler()
