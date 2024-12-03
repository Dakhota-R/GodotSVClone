extends Node2D


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	delta = delta 
	if Input.is_action_just_pressed("Pause"):
		var pause_menu_node = self.get_node("Objects/Player/PauseMenu")
		pause_menu_node.set_visible(true)
		get_tree().paused = true
