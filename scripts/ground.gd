extends TileMapLayer

var floor_tiles;

func _ready() -> void:
	get_floor_tiles()
	
func get_floor_tiles():
	floor_tiles = self.get_used_cells()