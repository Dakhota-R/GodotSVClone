extends CharacterBody2D

@onready var _animation_player = $AnimationPlayer

@export var dialogue_resource: Array[npc_dialogue]

@onready var dialogue_list = dialogue_resource[0].dialogue

var npc_pos = Vector2i(0, 1)

func _ready() -> void:
	pass
	

func _physics_process(delta: float) -> void:
	delta = delta
	_animation_player.play("NPC_idle")
