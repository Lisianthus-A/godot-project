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
var map_node: TileMap


# World
#   - Player
#     - AnimationPlayer
#   - TileMap
func init_nodes():
	player_node = get_node("/root/World/Player")
	animation_node = get_node("/root/World/Player/AnimationPlayer")
	map_node = get_node("/root/World/TileMap")
	# erase_cell(layer: int, coords: Vector2i) 
	# map_node.erase_cell()
	
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
	else:
		get_direction()
		if dir == "":
			is_first_animation = true
			animation_node.stop()
		else:
			var next_position = position + velocity
			var tile_data = map_node.get_cell_tile_data(1, next_position)
			var tile_type := 0
			if tile_data:
				tile_type = tile_data.get_custom_data("type")
			
			# 根据所按的方向播放动画
			animation_node.play(dir)
			if tile_type == 1: # 地图障碍
				animation_node.stop()
			else:
				is_moving = true
				if is_first_animation:
					is_first_animation = false
					animation_node.seek(0.2)
				if tile_type == 2: # 敌人
					var id = tile_data.get_custom_data("monster_id")
					Battle.get_demage(id)
					map_node.erase_cell(1, next_position)
