extends Node

var prev_floor := ""
var next_floor := ""

func init():
	Character.init_nodes()
	Map.init_nodes()
	Manual.init_nodes()

func process_handler():
	Manual.process_handler()
	if Manual.is_show:
		return

	Character.process_handler()

func change_floor(type: String):
	var world_node = get_node("/root/World")
	var cur_floor = get_node("/root/World/CurrentFloor")
	world_node.remove_child(cur_floor)
	cur_floor.queue_free()
	var new_floor = load(next_floor if type == "next" else prev_floor).instantiate()
	world_node.add_child(new_floor)

func save_game():
	# 保存
	#var file = FileAccess.open("./test.bi", FileAccess.WRITE)
	#var bi = var_to_bytes({
		#"dis": 1,
		#"asd": [1,2,3],
		#"sd": "asd"
	#})
	#file.store_buffer(bi)
	#file.close()
	pass
	
func load_game():
	# 读取
	#FileAccess.file_exists("./test.bi")
	#var bi = FileAccess.get_file_as_bytes("./test.bi")
	#var ss = bytes_to_var(bi)
	#print(ss)
	pass
