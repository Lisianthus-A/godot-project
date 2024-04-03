extends Node

# (1, 1) (1, 4) (1, 7) (1, 10) (1, 13) (1, 16)
const grids := [
	Vector2i(1, 1),
	Vector2i(1, 4),
	Vector2i(1, 7),
	Vector2i(1, 10),
	Vector2i(1, 13),
	Vector2i(1, 16)
]

var manual_node: CanvasLayer = CanvasLayer.new()
var world_map_node: TileMap
var manual_map_node: TileMap
var is_lock := false
var is_show := false

func init_nodes():
	manual_node.visible = false
	world_map_node = get_node("/root/World/TileMap")
	
	# 怪物手册黑色背景
	var color_rect = ColorRect.new()
	color_rect.position = Vector2(160, 0)
	color_rect.size = Vector2(640, 640)
	color_rect.color = Color.html("#111")
	manual_node.add_child(color_rect)
	
	# 用来复用怪物图块
	manual_map_node = world_map_node.duplicate()
	manual_map_node.clear_layer(0)
	clear_map()
	manual_node.add_child(manual_map_node)
	
	var world_node = get_node("/root/World")
	world_node.add_child(manual_node)

func process_handler():
	if is_lock:
		return

	# Todo: 方向键选择怪物
	if Input.is_action_pressed("x_key"):
		# 按钮节流
		is_lock = true
		var t = Timer.new()
		t.wait_time = 0.5
		manual_node.add_child(t)
		t.one_shot = true
		t.start()
		t.timeout.connect(func():
			is_lock = false
			t.queue_free()
		)
		
		if manual_node.visible:
			manual_node.visible = false
			is_show = false
		else:
			draw()
			manual_node.visible = true
			is_show = true

func create_label(x: int, y: int, is_row2 := false) -> Label:
	var label := Label.new()
	label.size.x = 72
	label.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	label.position = Vector2(96 + 100 * x, 24 + 96 * y)
	if is_row2:
		label.position.y += 31
	return label

func draw():
	clear_map()
	var used_cells = world_map_node.get_used_cells(1)
	var idx = 0
	for cell in used_cells:
		var data = Map.get_data(cell)
		if data.monster_id != "0":
			# Todo: 怪物去重，分页
			# 图集坐标
			var coords = world_map_node.get_cell_atlas_coords(1, cell)
			# 图块 id
			var source_id = world_map_node.get_cell_source_id(1, cell)
			manual_map_node.set_cell(1, grids[idx], source_id, coords)
			
			var monster = Battle.monster_data[data.monster_id]
			# 怪名
			var label_name = create_label(0, idx)
			label_name.text = monster.name
			# 技能 Todo
			var label_skill = create_label(0, idx, true)
			label_skill.text = "技能名"
			# 生命
			var label_hp = create_label(1, idx)
			label_hp.text = "生命"
			# 生命 - 数值
			var label_hp_value = create_label(1, idx, true)
			label_hp_value.text = String.num_int64(monster.hp)
			# 攻击
			var label_atk = create_label(2, idx)
			label_atk.text = "攻击"
			# 攻击 - 数值
			var label_atk_value = create_label(2, idx, true)
			label_atk_value.text = String.num_int64(monster.atk)
			# 防御
			var label_def = create_label(3, idx)
			label_def.text = "防御"
			# 防御 - 数值
			var label_def_value = create_label(3, idx, true)
			label_def_value.text = String.num_int64(monster.def)
			# 伤害
			var label_damage = create_label(4, idx)
			label_damage.text = "伤害"
			# 防御 - 数值
			var label_damage_value = create_label(4, idx, true)
			label_damage_value.text = String.num_int64(Battle.get_damage(data.monster_id))
			
			manual_map_node.add_child(label_name)
			manual_map_node.add_child(label_skill)
			manual_map_node.add_child(label_hp)
			manual_map_node.add_child(label_hp_value)
			manual_map_node.add_child(label_atk)
			manual_map_node.add_child(label_atk_value)
			manual_map_node.add_child(label_def)
			manual_map_node.add_child(label_def_value)
			manual_map_node.add_child(label_damage)
			manual_map_node.add_child(label_damage_value)
			idx += 1
			
# 清理手册里的怪物，以便下次绘制
func clear_map():
	for child in manual_map_node.get_children():
		child.queue_free()
	manual_map_node.clear_layer(1)
