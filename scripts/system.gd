extends Node

var transition_node: AnimationPlayer

func init(map_node: TileMap):
	transition_node = get_node("/root/World/Transition/AnimationPlayer")
	Character.init_nodes()
	Map.init_nodes(map_node)
	Manual.init_nodes(map_node)

func process_handler():
	Manual.process_handler()
	if Manual.is_show:
		return

	Character.process_handler()

func change_floor():
	transition_node.queue("fade_in")
	#Todo: change fllor start
	transition_node.queue("fade_out")

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
