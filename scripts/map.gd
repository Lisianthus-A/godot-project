extends Node

var map_node: TileMap
# { cell: LabelNode }
var map_cell_to_label := {}

func init_nodes():
	map_node = get_node("/root/World/CurrentFloor/Map")
	map_cell_to_label = {}
	update_monster_damage()

# 获取地图上图块数据
func get_data(pos: Vector2) -> Dictionary:
	var cell_data = map_node.get_cell_tile_data(1, pos)
	var type = cell_data.get_custom_data("type") if cell_data else "0"
	var target_id = cell_data.get_custom_data("target_id") if cell_data else "0"
	
	return {
		"type": type,
		"target_id": target_id,
	}

# 消除地图上的图块
func erase(pos: Vector2):
	map_node.erase_cell(1, pos)
	var cell_key = "%s_%s" % [pos.x, pos.y]
	if map_cell_to_label.has(cell_key):
		var node = map_cell_to_label[cell_key]
		map_cell_to_label.erase(cell_key)
		node.queue_free()

# 更新敌人伤害显示
func update_monster_damage():
	var cells = map_node.get_used_cells(1)
	for cell in cells:
		var data = get_data(cell)
		if data.type == "2":
			var damage = Battle.get_damage(data.target_id)
			var cell_key = "%s_%s" % [cell.x, cell.y]
			if not map_cell_to_label.has(cell_key):
				var node = Label.new()
				node.size.y = 32
				node.vertical_alignment = VERTICAL_ALIGNMENT_BOTTOM
				node.position = Vector2(cell) * 32 + Vector2(0, 4)
				# font
				node.label_settings = LabelSettings.new()
				node.label_settings.font_size = 12
				# Todo: 根据伤害改变颜色
				node.label_settings.font_color = Color.WHITE
				map_cell_to_label[cell_key] = node
				map_node.add_child(node)
				
			var label_node: Label = map_cell_to_label[cell_key]

			if damage == null:
				label_node.text = "???"
			else:
				label_node.text = String.num_int64(damage)
