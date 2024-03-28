extends Node

# 能力
var hp := 100
var atk := 10
var def := 10

# 起始点 (16, 16) 每格像素 32x32
var position := Vector2(0, 0)

# 移动相关
const MOVE_FRAME = 8 # 每次移动花费多少帧
const PIXEL_PER_FRAME = 32.0 / MOVE_FRAME # 每一帧移动多少像素
var current_frame := 0 # 当前移动花费了多少帧
var dir := "" # 移动方向
var velocity := Vector2.ZERO # 移动向量
var is_moving := false # 是否正在移动
var is_first_animation := true # 用于开始移动时 seek 动画

# node 
var player_node: Node2D
var animation_node: AnimationPlayer
var hp_node: Label
var atk_node: Label
var def_node: Label

# World
#   - Player
#     - AnimationPlayer
#   - TileMap
#   - HUD
#     - LevelValue
#     - HPValue
#     - AttackValue
#     - DefenseValue

func init_nodes():
	player_node = get_node("/root/World/Player")
	animation_node = get_node("/root/World/Player/AnimationPlayer")
	hp_node = get_node("/root/World/HUD/HPValue")
	atk_node = get_node("/root/World/HUD/AttackValue")
	def_node = get_node("/root/World/HUD/DefenseValue")
	
func init_pos(pos: Vector2):
	position = pos
	player_node.position = compute_position(pos)
	
func compute_position(pos: Vector2):
	return pos * 32 + Vector2(176, 16)
	
# 根据当前按下的方向键进行设置
func get_direction():
	if Input.is_action_pressed("ui_left"):
		dir = "left"
		velocity = Vector2.LEFT
	elif Input.is_action_pressed("ui_right"):
		dir = "right"
		velocity = Vector2.RIGHT
	elif Input.is_action_pressed("ui_up"):
		dir = "up"
		velocity = Vector2.UP
	elif Input.is_action_pressed("ui_down"):
		dir = "down"
		velocity = Vector2.DOWN
	else:
		dir = ""
		velocity = Vector2.ZERO

func process_handler():
	if is_moving:
		# 开始移动角色
		current_frame += 1
		player_node.position = compute_position(position) + velocity * PIXEL_PER_FRAME * current_frame
		if current_frame >= MOVE_FRAME:
			is_moving = false
			current_frame = 0
			position += velocity
			print("pos:", position)
			#print("pos2:", player_node.position)
	else:
		get_direction()
		if dir == "":
			is_first_animation = true
			animation_node.stop()
		else:
			# 下一位置的图块数据
			var next_position = position + velocity
			var map_data = Map.get_data(next_position)
			
			# 根据所按的方向播放动画
			animation_node.play(dir)
			if map_data.type == "1": # 地图障碍
				animation_node.stop()
				return
			elif map_data.type == "2": # 敌人
				var is_win = Battle.fight(map_data.monster_id)
				# 打不过
				if not is_win:
					animation_node.stop()
					return
				# 更新左侧面板
				update_hud()
				# 消除敌人图块
				Map.erase(next_position)

			is_moving = true
			if is_first_animation:
				is_first_animation = false
				animation_node.seek(0.2)

func update_hud():
	hp_node.text = String.num_int64(hp)
	atk_node.text = String.num_int64(atk)
	def_node.text = String.num_int64(def)
