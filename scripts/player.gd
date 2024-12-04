extends CharacterBody2D 

const tile_size = 16 * 4
var moving = false
var input_dir

var player_pos = Vector2i(0, 0)

var tilemaps_dict = {
	"floor_tiles": [],
	"obstacle_tiles": [],
	"npc_tile": []
}

@onready var _animation_player = $AnimationPlayer


var anim_side = "Front";
var anim_flip = false;

var direction = "down";

var dialog_box;
var dialogging = false;
var dialog_index = 0;
var more_dialog = true

@onready var rootNode = get_tree().get_root().get_node("Root")

func _ready() -> void:
	print(get_node(rootNode.get_node("Objects").get_path()))

	# this will eventually let me tell which npc im talking to (use custom data dummy)
	var spawnTilesLayer = rootNode.get_node("SpawnTiles")

	var npc_tile = spawnTilesLayer.npc_tiles
	
	tilemaps_dict.npc_tile = npc_tile

	var floor_tiles = []
	var floor_cells = rootNode.get_node("Ground").get_used_cells()
	for tile in floor_cells:
		if check_water_tiles(tile):
			floor_tiles.append(tile)
	tilemaps_dict.floor_tiles = floor_tiles

	var obstacle_tiles = self.get_parent().get_used_cells()
	tilemaps_dict.obstacle_tiles = obstacle_tiles



func _physics_process(delta: float) -> void:
	delta = delta
	var speed = .15
	var next_pos
	input_dir = Vector2.ZERO

#-DOWN-------------------------------------------------------------
	if Input.is_action_pressed("ui_down") and not Input.is_action_pressed("ui_right"):
		input_dir = Vector2(-1, .5)
		next_pos = Vector2i(player_pos.x, player_pos.y + 1)
		anim_side = "Front"
		anim_flip = false
		direction = "down"

		move(next_pos, speed)
#-LEFT---------------------------------------------------------------
	elif Input.is_action_pressed("ui_left"):
		input_dir = Vector2(-1, -.5)
		next_pos = Vector2i(player_pos.x - 1, player_pos.y)
		anim_side = "Back"
		anim_flip = false
		direction = "left"

		move(next_pos, speed)
#-UP---------------------------------------------------------------
	elif Input.is_action_pressed("ui_up"):
		input_dir = Vector2(1, -.5)
		next_pos = Vector2i(player_pos.x, player_pos.y - 1)
		anim_side = "Back"
		anim_flip = true
		direction = "up"

		move(next_pos, speed)
#-RIGHT------------------------------------------------------------
	elif Input.is_action_pressed("ui_right"):
		input_dir = Vector2(1,.5)
		next_pos = Vector2i(player_pos.x + 1, player_pos.y)
		anim_side = "Front"
		anim_flip = true
		direction = "right"

		move(next_pos, speed) 
#------------------------------------------------------------------

#-Test Interact
	if Input.is_action_just_pressed("Interact"):
		if get_facing_tile(direction, player_pos) == Vector2i(tilemaps_dict.npc_tile[0]):
			play_npc_dialog()
		else:
			test_change_tile(get_facing_tile(direction, player_pos))

	play_animation("Eye_", anim_side, anim_flip)
	update_camera()
	move_and_slide()
	

func move(next_pos, speed):
	if dialog_box:
		disable_dialog()
	if !check_floor_tiles(next_pos):
		return
	if check_obstacle_tiles(next_pos):
		return
	if check_npc_tiles(next_pos):
		return
	if input_dir:
		if moving == false:
			moving = true
			var tween = create_tween()
			tween.set_process_mode(Tween.TWEEN_PROCESS_PHYSICS)
			tween.tween_property(self, "position", position + input_dir*tile_size, speed)
			tween.tween_callback(update_player_pos.bind(next_pos))
			tween.tween_callback(move_false)

func play_animation(prefix = "Eye_", side = "Front", flip = false):
	_animation_player.play(prefix + side)
	self.get_node("SpriteAnimated").flip_h = flip

func move_false():
	moving = false

func update_player_pos(next_pos):
	player_pos = next_pos

func check_floor_tiles(next_pos):
	if tilemaps_dict.floor_tiles.has(next_pos):
		return true

func check_water_tiles(cell):
	var ground_node = rootNode.get_node("Ground")
	var map_to_tile = ground_node.map_to_local(cell)
	var maptile = ground_node.local_to_map(map_to_tile)
	var tile_data = ground_node.get_cell_tile_data(maptile)
	var custom_tile_data = tile_data.get_custom_data("Type")
	if custom_tile_data == "Water":
		return false
	return true

func check_obstacle_tiles(next_pos):
	if tilemaps_dict.obstacle_tiles.has(next_pos):
		return true

func check_npc_tiles(next_pos):
	if tilemaps_dict.npc_tile.has(next_pos):
		return true

func get_facing_tile(facing_direction, next_pos):
	match facing_direction: 
		"left":
			return Vector2i(next_pos.x - 1, next_pos.y)
		"right":
			return Vector2i(next_pos.x + 1, next_pos.y)
		"up":
			return Vector2i(next_pos.x, next_pos.y - 1)
		"down":
			return Vector2i(next_pos.x, next_pos.y + 1)

func play_npc_dialog():

	var npc = rootNode.get_node("Objects/Trashke")
	var dialog_list = npc.dialogue_list

	# get dialog box node 
	dialog_box = npc.get_child(2)
	dialog_box.visible = true

	var dialog_text = dialog_box.get_child(0)

	if !more_dialog:
		disable_dialog()
		return

	if !dialogging:
		dialog_index = 0
		dialogging = true
		more_dialog = true
		dialog_box.get_child(1).visible = true

	elif dialog_index < dialog_list.size() - 1:
		dialog_index = dialog_index + 1

	if dialog_index + 1 == dialog_list.size():
		more_dialog = false
		dialog_box.get_child(1).visible = false


	dialog_text.text = '"' + dialog_list[dialog_index] + '"'


func test_change_tile(facing_tile):
	rootNode.get_node("Ground").set_cell(facing_tile, 0, Vector2i(4, 1))
	tilemaps_dict.floor_tiles.append(facing_tile)

func disable_dialog():
	dialog_box.visible = false
	dialogging = false
	more_dialog = true
	dialog_index = 0


func update_camera():
	self.get_node("Smoothing2D").get_node("Camera2D").global_position = self.global_position



func _on_unpause_pressed() -> void:
	get_tree().paused = false


func save():
	var save_dict = {
		"filename" : self.get_scene_file_path(),
		"parent" : rootNode.get_node("Objects").get_path(),
		"player_pos" : player_pos,
	}

	return save_dict