extends Control

@onready var rootNode = get_tree().get_root().get_node("Root")

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.




func _on_unpause_pressed() -> void:
	var pause_menu_node = rootNode.get_node("Objects/Player/PauseMenu")
	pause_menu_node.set_visible(false)
	get_tree().paused = false
