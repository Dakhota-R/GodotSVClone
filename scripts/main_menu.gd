extends Control

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass



func _on_start_button_pressed() -> void:
	get_tree().change_scene_to_file("res://scenes/root.tscn")

func _on_load_button_pressed() -> void:
	get_tree().change_scene_to_file("res://scenes/root.tscn")
	load_game()

	


func load_game():
	if not FileAccess.file_exists("user://savegame.save"):
		return # no save exists

	# copied tut comments: 
	# We need to revert the game state so we're not cloning objects
	# during loading. This will vary wildly depending on the needs of a
	# project, so take care with this step.
	# For our example, we will accomplish this by deleting saveable objects.
	var save_nodes = self.get_tree().get_nodes_in_group("Persist")
	for i in save_nodes:
		i.queue_free()

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

		# create object and add to tree
		var new_object = load(node_data["filename"]).instantiate()
		get_node(node_data["parent"]).add_child(new_object)
		new_object.player_pos = node_data["player_pos"]

		get_tree().paused = false
		
		#for i in node_data.keys():
			#if i == "player_pos":
				#continue
