extends Node2D

func _ready():
	Character.init_nodes()
	Character.init_pos(Vector2(1, 1))
	# 读取
	#FileAccess.file_exists("./test.bi")
	#var bi = FileAccess.get_file_as_bytes("./test.bi")
	#var ss = bytes_to_var(bi)
	#print(ss)
	# 保存
	#var file = FileAccess.open("./test.bi", FileAccess.WRITE)
	#var bi = var_to_bytes({
		#"dis": 1,
		#"asd": [1,2,3],
		#"sd": "asd"
	#})
	#file.store_buffer(bi)
	#file.close()
	

func _process(_delta):
	Character.process_handler()
