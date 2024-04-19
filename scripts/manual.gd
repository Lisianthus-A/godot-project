extends Node

# (1, 1) (1, 4) (1, 7) (1, 10) (1, 13) (1, 16)
const _grids := [
	Vector2i(1, 1),
	Vector2i(1, 4),
	Vector2i(1, 7),
	Vector2i(1, 10),
	Vector2i(1, 13),
	Vector2i(1, 16)
]

var _manual_node: CanvasLayer = CanvasLayer.new()
var _world_map_node: TileMap
var _manual_map_node: TileMap
var _is_lock := false
var is_show := false

func init_nodes(node: TileMap):
	_manual_node.visible = false
	_world_map_node = node
	
	# 怪物手册黑色背景
	var color_rect = ColorRect.new()
	color_rect.position = Vector2(160, 0)
	color_rect.size = Vector2(640, 640)
	color_rect.color = Color.html("#111")
	_manual_node.add_child(color_rect)
	
	# 用来复用怪物图块
	_manual_map_node = _world_map_node.duplicate()
	_manual_map_node.clear_layer(0)
	clear_map()
	_manual_node.add_child(_manual_map_node)
	
	var world_node: Node = get_node("/root/World")
	world_node.add_child.call_deferred(_manual_node)

func process_handler():
	if _is_lock:
		return

	# Todo: 方向键选择怪物
	if Input.is_action_pressed("x_key"):
		throttle()
		
		if _manual_node.visible:
			_manual_node.visible = false
			is_show = false
		else:
			draw()
			_manual_node.visible = true
			is_show = true

# 按钮节流
func throttle(time := 0.5):
	_is_lock = true
	var t = Timer.new()
	t.wait_time = time
	_manual_node.add_child(t)
	t.one_shot = true
	t.start()
	t.timeout.connect(func():
		_is_lock = false
		t.queue_free()
	)

func create_label(x: int, y: int, is_row2 := false) -> Label:
	var label := Label.new()
	label.size.x = 72
	label.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	label.position = Vector2(96 + 100 * x, 24 + 96 * y)
	if is_row2:
		label.position.y += 32
	return label

func draw():
	clear_map()
	var used_cells = _world_map_node.get_used_cells(1)
	var idx = 0
	var drawn = {}

	for cell in used_cells:
		var data = Map.get_data(cell)
		# 还未绘制到手册上的敌人
		if data.type == "2" and not drawn.has(data.target_id):
			drawn[data.target_id] = 1
			# Todo: 分页
			# 图集坐标
			var coords = _world_map_node.get_cell_atlas_coords(1, cell)
			# 图块 id
			var source_id = _world_map_node.get_cell_source_id(1, cell)
			_manual_map_node.set_cell(1, _grids[idx], source_id, coords)
			
			var monster = Battle.monster_data[data.target_id]
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
			# 伤害 - 数值
			var label_damage_value = create_label(4, idx, true)
			var damage = Battle.get_damage(data.target_id)
			label_damage_value.text = String.num_int64(damage) if damage != null else "???"
			
			_manual_map_node.add_child(label_name)
			_manual_map_node.add_child(label_skill)
			_manual_map_node.add_child(label_hp)
			_manual_map_node.add_child(label_hp_value)
			_manual_map_node.add_child(label_atk)
			_manual_map_node.add_child(label_atk_value)
			_manual_map_node.add_child(label_def)
			_manual_map_node.add_child(label_def_value)
			_manual_map_node.add_child(label_damage)
			_manual_map_node.add_child(label_damage_value)
			idx += 1
			
# 清理手册里的怪物，以便下次绘制
func clear_map():
	for child in _manual_map_node.get_children():
		child.queue_free()
	_manual_map_node.clear_layer(1)
