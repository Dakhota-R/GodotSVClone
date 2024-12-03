extends TileMapLayer


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	var tiles = self.get_used_cells()
	
	var ground_tiles = []

	for tile in tiles:
		var map_to_tile = map_to_local(tile)
		var maptile = local_to_map(map_to_tile)
		var tile_data = self.get_cell_tile_data(maptile)
		var custom_tile_data = tile_data.get_custom_data("Type")

		if custom_tile_data == "Ground":
			ground_tiles.append(tile)
		
	var water_tiles = get_water_tiles(ground_tiles)
		
	for tile in water_tiles:
		self.set_cell(tile, 2, Vector2i(0,0))
		print(tile)
	
			

		

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	delta = delta

func get_water_tiles(ground_tiles):

	# change instead to an animated tile that replaces tiles touching air!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!

	var water_tiles = []

	for tile in ground_tiles:
		if !ground_tiles.has(Vector2i(tile.x, tile.y + 1)):
			water_tiles.append(Vector2i(tile.x, tile.y + 1))
			
		if !ground_tiles.has(Vector2i(tile.x + 1, tile.y)):
			water_tiles.append(Vector2i(tile.x + 1, tile.y))

		if !ground_tiles.has(Vector2i(tile.x + 1, tile.y + 1)):
			water_tiles.append(Vector2i(tile.x + 1, tile.y + 1))
	
	return water_tiles
