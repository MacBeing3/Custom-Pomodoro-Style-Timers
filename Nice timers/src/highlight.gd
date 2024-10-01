extends ColorRect

@onready var highlight_size = size

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.
	var viewport_size = get_viewport_rect()
	
	#everything above position y, is grey
	#everything below position y + size.y  is grey
	
	#everything less than postion.x is grey
	#evertything greater than position.x + size.x = grey
	var positionV
	var sizeV
	var left_rect = Rect2(Vector2(0,0), Vector2(position.x, viewport_size.y))
	var right_rect = Rect2(Vector2(0,0),Vector2(0,0))
	
#	draw_rect(rect: Rect2, color: Color, filled: bool = true, width: float = -1.0)
	

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
