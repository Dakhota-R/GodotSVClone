extends PointLight2D

@onready var rootNode = get_tree().get_root().get_node("Root")

var player_node;

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	player_node = rootNode.get_node("Objects/Player/SpriteAnimated")

func _physics_process(delta: float) -> void:
	delta = delta
	self.global_position = Vector2i(player_node.global_position.x, player_node.global_position.y + 32)