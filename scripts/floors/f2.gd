extends Node

const pos_next_floor = Vector2(1, 1)
const pos_prev_floor = Vector2(2, 2)

func _ready():
	self.name = "CurrentFloor"
	System.init()
	Character.init_pos(pos_prev_floor)
	System.prev_floor = "res://scenes/floors/f1.tscn"
	System.next_floor = ""

func _process(_delta):
	System.process_handler()
