extends Node

# 能力
var hp := 100
var atk := 10
var def := 10

# 拥有的物品 { [id]: { id: string; count: int; } }
var items := {}

# 起始点 (16, 16) 每格像素 32x32
var position := Vector2(0, 0)

# 移动相关
const _MOVE_FRAME = 8 # 每次移动花费多少帧
const _PIXEL_PER_FRAME = 32.0 / _MOVE_FRAME # 每一帧移动多少像素
var _current_frame := 0 # 当前移动花费了多少帧
var _dir := "" # 移动方向
var _velocity := Vector2.ZERO # 移动向量
var _is_moving := false # 是否正在移动
var _is_first_animation := true # 用于开始移动时 seek 动画
var _change_floor_type := ""

# node 
var _player_node: Node2D
var _animation_node: AnimationPlayer
var _hp_node: Label
var _atk_node: Label
var _def_node: Label

# - Player
#     - AnimationPlayer
# HUD
# - LevelValue
# - HPValue
# - AttackValue
# - DefenseValue
# FloorN
#   - TileMap

func init_nodes():
	_player_node = get_node("/root/World/Player")
	_animation_node = get_node("/root/World/Player/AnimationPlayer")
	_hp_node = get_node("/root/World/HUD/HPValue")
	_atk_node = get_node("/root/World/HUD/AttackValue")
	_def_node = get_node("/root/World/HUD/DefenseValue")
	
func init_pos(pos: Vector2):
	position = pos
	_player_node.position = compute_position(pos)
	
func compute_position(pos: Vector2):
	return pos * 32 + Vector2(176, 16)
	
# 根据当前按下的方向键进行设置
func get_direction():
	if Input.is_action_pressed("ui_left"):
		_dir = "left"
		_velocity = Vector2.LEFT
	elif Input.is_action_pressed("ui_right"):
		_dir = "right"
		_velocity = Vector2.RIGHT
	elif Input.is_action_pressed("ui_up"):
		_dir = "up"
		_velocity = Vector2.UP
	elif Input.is_action_pressed("ui_down"):
		_dir = "down"
		_velocity = Vector2.DOWN
	else:
		_dir = ""
		_velocity = Vector2.ZERO

func process_handler():
	if _is_moving:
		# 开始移动角色
		_current_frame += 1
		_player_node.position = compute_position(position) + _velocity * _PIXEL_PER_FRAME * _current_frame
		if _current_frame >= _MOVE_FRAME:
			_is_moving = false
			_current_frame = 0
			position += _velocity
			if _change_floor_type != "":
				System.change_floor(_change_floor_type)
				_change_floor_type = ""
			#print("pos:", position)
			#print("pos2:", _player_node.position)
	else:
		get_direction()
		if _dir == "":
			_is_first_animation = true
			_animation_node.stop()
		else:
			# 下一位置的图块数据
			var next_position = position + _velocity
			var map_data = Map.get_data(next_position)
			
			# 根据所按的方向播放动画
			_animation_node.play(_dir)
			if map_data.type == "1": # 地图障碍
				_animation_node.stop()
				return
			elif map_data.type == "2": # 敌人
				var is_win = Battle.fight(map_data.target_id)
				# 打不过
				if not is_win:
					_animation_node.stop()
					return
				# 更新左侧面板
				update_hud()
				# 消除敌人图块
				Map.erase(next_position)
			elif map_data.type == "3": # 物品
				Item.obtain(map_data.target_id)
				Map.erase(next_position)
			elif map_data.type == "4": # 上楼
				_change_floor_type = "next"
			elif map_data.type == "5": # 下楼
				_change_floor_type = "prev"

			_is_moving = true
			if _is_first_animation:
				_is_first_animation = false
				_animation_node.seek(0.2)

func update_hud():
	_hp_node.text = String.num_int64(hp)
	_atk_node.text = String.num_int64(atk)
	_def_node.text = String.num_int64(def)
 
