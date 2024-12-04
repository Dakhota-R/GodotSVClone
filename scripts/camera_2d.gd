extends Camera2D

@onready var rootNode = get_tree().get_root().get_node("Root")

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	self.position = rootNode.get_node("Objects/Player").position


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	delta = delta 

func _physics_process(delta: float) -> void:
	delta = delta
	self.global_position = rootNode.get_node("Objects/Player").global_position.round()


	


	
	
