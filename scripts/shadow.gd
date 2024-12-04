extends Sprite2D

@onready var rootNode = get_tree().get_root().get_node("Root")

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	self.modulate.a = 0.5


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	delta = delta

func _physics_process(delta: float) -> void:
	self.global_position = rootNode.get_node("Objects/Player/SpriteAnimated").global_position
	self.global_position.y += 20