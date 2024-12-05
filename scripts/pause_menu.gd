extends Control

@onready var rootNode = get_tree().get_root().get_node("Root")

func _on_unpause_pressed() -> void:
	unpause()


func _on_save_pressed() -> void:
	
	var save_file = FileAccess.open("user://savegame.save", FileAccess.WRITE)
	print("save location: " + OS.get_data_dir())

	var save_nodes = self.get_tree().get_nodes_in_group("Persist")
	
	for node in save_nodes:
		# check if the node is an instanced scene, so it can be instanced again during load time
		if node.scene_file_path.is_empty():
			print("persistent node '%s' is not an instanced scene, skipped" % node.name)
			continue
		
		# check if the node has a save() function
		if !node.has_method("save"):
			print("persistent node '%s' is missing a save() function, skipped" % node.name)

		# Call the nodes save function
		var node_data = node.call("save")

		# Serialize json 
		var json_string = JSON.stringify(node_data)

		# store save dict as a new line in save file
		save_file.store_line(json_string)
		unpause()

func load_game():
	if not FileAccess.file_exists("user://savegame.save"):
		return # no save exists

	var player_node = rootNode.get_node("Objects/Player")

	var save_file = FileAccess.open("user://savegame.save", FileAccess.READ)
	while save_file.get_position() < save_file.get_length():
		var json_string = save_file.get_line()

		# Create json helper
		var json = JSON.new()

		#check for errors, skip if error
		var parse_result = json.parse(json_string)
		if not parse_result == OK:
			print("JSON Parse Error: ", json.get_error_message(), " in ", json_string, " at line ", json.get_error_line())
			continue
		
		# data from json object
		var node_data = json.data
		print(node_data)

		# set player pos
		player_node.player_pos = str_to_var("Vector2i" + node_data["player_pos"])
		var new_player_location = rootNode.get_node("Ground").map_to_local(str_to_var("Vector2i" + node_data["player_pos"]))
		new_player_location.y = new_player_location.y - 64
		player_node.position = new_player_location
		player_node.direction = node_data["direction"]
		player_node.anim_side = node_data["anim_side"]
		player_node.anim_flip = node_data["anim_flip"]

		# set placed tiles
		if node_data.has("placed_tiles"):
			var parsed_tiles = []
			for tile in node_data["placed_tiles"]:
				var tile_data = []
				tile_data.append(str_to_var("Vector2i" + tile[0]))
				tile_data.append(tile[1])
				tile_data.append(str_to_var("Vector2i" + tile[2]))
				parsed_tiles.append(tile_data)
			
			player_node.placed_tiles = parsed_tiles
			player_node.load_placed_tiles()


		#unpause the game and close pause menu if open
		get_tree().paused = false
		unpause()

func unpause():
	var pause_menu_node = rootNode.get_node("Objects/Player/PauseMenu")
	pause_menu_node.set_visible(false)
	get_tree().paused = false


func _on_main_menu_button_pressed() -> void:
	# must unpuase game when button pressed or no game actions lol
	unpause()
	get_tree().change_scene_to_file("res://scenes/mainMenu.tscn")
