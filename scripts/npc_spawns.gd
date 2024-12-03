extends TileMapLayer


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	# get spawn tile at 0 index
	var npc_spawn_tile = map_to_local(self.get_used_cells()[0])
	
	if false:
		# adjust for tile offset
		npc_spawn_tile.y = npc_spawn_tile.y - 16
		npc_spawn_tile.x = npc_spawn_tile.x + 5
		# move NPC sprite to spawn tile
		self.get_node("../Ground").get_child(0).get_child(1).position = npc_spawn_tile
		# move NPC to spawn tile pos
		self.get_node("../Ground").get_child(0).get_child(1).npc_pos = self.get_used_cells()[0]

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	delta = delta
