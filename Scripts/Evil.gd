class_name Evil
extends Area2D

var tw: Tween
var can_move: bool = true
var current_dir: Vector2 = Vector2.ZERO
var speed: float = 1.0
var rot_speed: float

func rot_sprite2d_txt(sprite2d, rot):
	var image = sprite2d.texture.get_image()
	#image.rotate_90(rot)
	sprite2d.texture = ImageTexture.create_from_image(image)

func set_type(type:String = "pocman1"):
	$Sprite2D.texture = Conf.sprite[type]
	rot_sprite2d_txt($Sprite2D, COUNTERCLOCKWISE)
	var shape = RectangleShape2D.new()
	shape.size = Conf.CELL_SIZE - Conf.EVIL_COLL_MARG
	$CollisionShape2D.shape = shape

func _init():
	var sprite2d = Sprite2D.new()
	sprite2d.name = 'Sprite2D'
	var coll_sha = CollisionShape2D.new()
	coll_sha.name = 'CollisionShape2D'
	add_child(sprite2d)
	add_child(coll_sha)
	set_type()
	
func _on_area_entered(area):
	print('_on_area_entered Evil')
	
func _ready():
	self.connect("area_entered", _on_area_entered)

func get_direction(a, b):
	if a.x > b.x :
		return Vector2.LEFT
	if a.x < b.x :
		return Vector2.RIGHT
	if a.y > b.y :
		return Vector2.UP
	if a.y < b.y :
		return Vector2.DOWN
	return Vector2.ZERO

func _process(delta):
	# Rotation speed must equal movement speed
	rot_speed = speed
	
	if can_move:
		can_move = false
		
		var main_node = get_tree().root.get_node("Main")
		#print(main_node.line_pts)
		if main_node.line_pts.size() > 0:
			var pos_b = main_node.line_pts[0]
			var prev_dir = current_dir
			current_dir = get_direction(position, pos_b)
			main_node.line_pts.remove_at(0)
			
			tw = create_tween().set_parallel()
			
			if !(prev_dir == current_dir):
				tw.tween_property(self, "rotation", transform.x.angle_to(current_dir), 1.0/rot_speed
					).set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_CUBIC).as_relative()
			
			tw.tween_property(self, "position", pos_b, 1.0/speed)
		
		# Wait until the tween is finished, then move the player again
		await tw.finished
		can_move = true
