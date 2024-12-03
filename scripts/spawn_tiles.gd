extends TileMapLayer

var npc_tiles = []

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	

	# get spawn tile at 0 index
	var spawn_tile = map_to_local(self.get_used_cells()[0])
	# need to get global position of tile
	var test = local_to_map(spawn_tile)
	##### GOT THE CUSTOM DATA
	var custom_data = self.get_cell_tile_data(test).get_custom_data("Spawn")
	print(custom_data)




#////////////////////////////////////////testing
	var spawn_tiles = self.get_used_cells()
	parse_spawns(spawn_tiles)

	


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	delta = delta
	

func parse_spawns(spawns):
	var rootNode = get_tree().get_root().get_node("Root")
	var player_node = rootNode.get_node("Objects/Player")
	

	# load scene
	var trashke_scene = preload("res://scenes/npc.tscn")
	# instantiate node
	var trashke_node = trashke_scene.instantiate()
	# change name
	trashke_node.name = "Trashke"
	# add to objects node
	rootNode.get_node("Objects").add_child(trashke_node)
	# get node
	var npc_node = rootNode.get_node("Objects/Trashke")

	var torch_id = 0
	
	for tile in spawns:
		var cell = map_to_local(tile)
		var cell_global_pos = local_to_map(cell)
		var cell_custom_data = self.get_cell_tile_data(cell_global_pos).get_custom_data("Spawn")
		
		if cell_custom_data == "Player":
			cell.y = cell.y - 16
			# move player sprite to spawn tile
			player_node.position = cell
			# move player_pos to spawn tile pos
			player_node.player_pos = self.get_used_cells()[0]
			
			
		if cell_custom_data == "Trashke":
			# add tile to npc_tiles
			npc_tiles.append(tile)
			# adjust for tile offset
			cell.y = cell.y - 16
			cell.x = cell.x + 5
			# move NPC sprite to spawn tile
			npc_node.position = cell
			# move NPC to spawn tile pos
			npc_node.npc_pos = self.get_used_cells()[0]

		if cell_custom_data == "Torch":
			cell.y -= 8
			var torch_scene = preload("res://scenes/torch.tscn")
			var torch_node = torch_scene.instantiate()
			torch_node.name = "torch_" + str(torch_id)
			rootNode.get_node("Objects").add_child(torch_node)
			var torch = rootNode.get_node("Objects/torch_" + str(torch_id))
			torch.position = cell
			torch_id += 1
			
			
	
