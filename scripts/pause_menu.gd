extends Control

@onready var rootNode = get_tree().get_root().get_node("Root")

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.




func _on_unpause_pressed() -> void:
	var pause_menu_node = rootNode.get_node("Objects/Player/PauseMenu")
	pause_menu_node.set_visible(false)
	get_tree().paused = false


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

	


func _on_temp_load_game_pressed() -> void:
	if not FileAccess.file_exists("user://savegame.save"):
		return # no save exists

	# copied tut comments: 
	# We need to revert the game state so we're not cloning objects
	# during loading. This will vary wildly depending on the needs of a
	# project, so take care with this step.
	# For our example, we will accomplish this by deleting saveable objects.
	#var save_nodes = self.get_tree().get_nodes_in_group("Persist")
	#for i in save_nodes:
		#i.queue_free()

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

		# create object and add to tree
		#var new_object = load(node_data["filename"]).instantiate()
		#get_node(node_data["parent"]).add_child(new_object)
		#print(str_to_var("Vector2i" + node_data["player_pos"]))
		rootNode.get_node("Objects/Player").player_pos = str_to_var("Vector2i" + node_data["player_pos"])

		get_tree().paused = false
		#for i in node_data.keys():
			#if i == "player_pos":
				#continue
