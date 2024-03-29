extends Node

var manual_node: CanvasLayer = CanvasLayer.new()
var map_node: TileMap
var is_lock := false

func init_nodes():
	pass
	#map_node = get_node("/root/World/TileMap")
	
	# 怪物手册黑色背景
	#var color_rect = ColorRect.new()
	#color_rect.position = Vector2(160, 0)
	#color_rect.size = Vector2(640, 640)
	#color_rect.color = Color.html("#111")
	#manual_node.add_child(color_rect)
	
	# 用来复用怪物图块
	#var new_map_node: TileMap = map_node.duplicate()
	#new_map_node.clear_layer(0)
	#new_map_node.clear_layer(1)
	#manual_node.add_child(new_map_node)

	#manual_node.visible = false
	
	#var world_node = get_node("/root/World")
	#world_node.add_child(manual_node)

func show():
	var used_cells = map_node.get_used_cells(1)
	for cell in used_cells:
		var data = Map.get_data(cell)
		if data.monster_id != "0":
			# 图集坐标
			var coords = map_node.get_cell_atlas_coords(1, cell)
			# 图块 id
			var source_id = map_node.get_cell_source_id(1, cell)
			#map_node.set_cell(1, Vector2i(3, 3), source_id, coords)
	#var new_node: TileMap = map_node.duplicate()
	#new_node.clear_layer(1)
	#map_node.add_child(new_node)
	
func process_handler():
	if is_lock: 
		return
	if Input.is_action_pressed("x_key"):
		print("press X")
