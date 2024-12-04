extends Node2D

@export var framerate = 60

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
		Engine.max_fps = framerate
		Engine.physics_ticks_per_second = framerate * 2


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	delta = delta 
	if Input.is_action_just_pressed("Pause"):
		var pause_menu_node = self.get_node("Objects/Player/PauseMenu")
		pause_menu_node.set_visible(true)
		get_tree().paused = true
