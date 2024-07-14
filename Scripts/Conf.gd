extends Node
class_name Conf

const DISP_SIZE = Vector2i(240,240)
const CELL_SQUARE_SIDE = 16
const CELL_SIZE = Vector2i(CELL_SQUARE_SIDE, CELL_SQUARE_SIDE)
const CELL_CENTER = CELL_SIZE / 2
const EVIL_FIRST_POS = CELL_CENTER
const EVIL_COLL_MARG = Vector2i(6,6)
const WEALTH_COLL_MARG = Vector2i(10,10)

const sprite: Dictionary = {
	"pocman1": preload('res://Sprites/pocman_001.png'),
	"pocman2": preload('res://Sprites/pocman_002.png'),
	'star': preload('res://Sprites/star_001.png'),
}
const WEALTH_SPRITE_IDX = Vector2i(2,5)
