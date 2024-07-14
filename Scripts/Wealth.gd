class_name Wealth
extends Area2D

var signalclass

func rot_sprite2d_txt(sprite2d, rot):
	var image = sprite2d.texture.get_image()
	image.rotate_90(rot)
	sprite2d.texture = ImageTexture.create_from_image(image)
	
func set_type(type:String = "star"):
	$Sprite2D.texture = Conf.sprite[type]
	#rot_sprite2d_txt($Sprite2D, COUNTERCLOCKWISE)
	$Sprite2D.position = Conf.CELL_CENTER
	var shape = RectangleShape2D.new()
	shape.size = Conf.CELL_SIZE - Conf.WEALTH_COLL_MARG
	$CollisionShape2D.shape = shape
	$CollisionShape2D.position = $Sprite2D.position 

func _init():
	name = "Wealth"
	var sprite2d = Sprite2D.new()
	sprite2d.name = 'Sprite2D'
	var coll_sha = CollisionShape2D.new()
	coll_sha.name = 'CollisionShape2D'
	add_child(sprite2d)
	add_child(coll_sha)
	set_type()

func _on_area_entered(area):
	print('_on_area_entered Wealth')
	signalclass.wealth_eated.emit()
	queue_free()

func _ready():
	owner = get_parent()
	signalclass = owner.get_parent().get_node('SignalClass')
	self.connect('area_entered', _on_area_entered)
