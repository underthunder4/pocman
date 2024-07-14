extends Node2D
#Main
var astar_grid = AStarGrid2D.new()
var tw: Tween

var circ_wealth:int = Conf.WEALTH_SPRITE_IDX.x
var line_pts:Array
var evil_speed: float = 1.0
var initial_segment_count: int = 1
var score: int = 0
var start_in_disp = Conf.EVIL_FIRST_POS
var start_in_grid = Vector2i.ZERO
var end_in_grid = Vector2i.ZERO

@onready var wealths = $Wealths

func prep_evil_path_line():
	var line2d = Line2D.new()
	line2d.name = "Line2D"
	line2d.default_color = Color.AQUAMARINE
	line2d.width = 2
	return line2d

func prep_wealths():
	var wealths = Node2D.new()
	wealths.name = "Wealths"
	return wealths

func prep_add_evil():
	var evil = Evil.new()
	evil.position = start_in_disp
	add_child(evil)
	evil.owner = self
	
func prep_signalclass():
	var signalclass = SignalClass.new()
	signalclass.name = 'SignalClass'
	return signalclass

func _init():
	print("Main _init")
	add_child(prep_signalclass())
	add_child(prep_evil_path_line())
	add_child(prep_wealths())
	prep_add_evil()

func conf_disp():
	get_tree().root.content_scale_size = Conf.DISP_SIZE
	get_tree().root.content_scale_mode = Window.CONTENT_SCALE_MODE_VIEWPORT
	get_tree().root.content_scale_aspect = Window.CONTENT_SCALE_ASPECT_KEEP

func draw_board():
	for x in Conf.DISP_SIZE.x:
		draw_line(Vector2(x * Conf.CELL_SIZE.x, 0), Vector2(x * Conf.CELL_SIZE.x, Conf.DISP_SIZE.y * Conf.CELL_SIZE.y), Color.DARK_GRAY, 3.0)
	for y in Conf.DISP_SIZE.y:
		draw_line(Vector2(0, y * Conf.CELL_SIZE.y), Vector2(Conf.DISP_SIZE.x * Conf.CELL_SIZE.x, y * Conf.CELL_SIZE.y), Color.DARK_GRAY, 3.0)

func _draw():
	draw_board()

func init_grid():
	astar_grid.region = get_viewport_rect()
	astar_grid.cell_size = Conf.CELL_SIZE
	astar_grid.offset = Conf.CELL_SIZE / 2
	astar_grid.diagonal_mode = AStarGrid2D.DIAGONAL_MODE_NEVER
	#astar_grid.default_estimate_heuristic = AStarGrid2D.HEURISTIC_OCTILE
	astar_grid.default_estimate_heuristic = AStarGrid2D.HEURISTIC_MANHATTAN
	astar_grid.update()

func set_path_to_targ(res):
	print('set_path_to_targ')
	print("		pos start in grid", start_in_grid)
	print("		pos end in disp", res.position)
	end_in_grid = Vector2i(
		round(res.position.x / Conf.CELL_SIZE.x),
		round(res.position.y / Conf.CELL_SIZE.y)
	)
	print("		pos end in grid", end_in_grid)
	var p_array = astar_grid.get_point_path(start_in_grid, end_in_grid)
	line_pts = PackedVector2Array(p_array)
	$Line2D.points = line_pts
	#not need it, the first point was in start_in_grid
	line_pts.remove_at(0)
	
	start_in_grid = end_in_grid

func new_wealth_and_tar():
	var wealth:Wealth = Wealth.new()
	wealth.set_type('star')	
	wealth.position.x = randi_range(0, Conf.DISP_SIZE.x-Conf.CELL_SIZE.x)
	wealth.position.y = randi_range(0, Conf.DISP_SIZE.y-Conf.CELL_SIZE.y)
	
	wealth.position.x = snapped(wealth.position.x, Conf.CELL_SIZE.x)
	wealth.position.y = snapped(wealth.position.y, Conf.CELL_SIZE.y)
	
	set_path_to_targ(wealth)
	wealths.call_deferred("add_child", wealth)

func _on_wealth_eated():
	print("_on_wealth_eated Main")
	new_wealth_and_tar()

func _ready():
	conf_disp()
	get_tree().root.size_changed.connect(init_grid)
	init_grid()
	$SignalClass.wealth_eated.connect(_on_wealth_eated)
	new_wealth_and_tar()
