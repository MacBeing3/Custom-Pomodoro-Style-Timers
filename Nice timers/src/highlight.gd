extends ColorRect
class_name HighlightChild

@onready var highlight:ColorRect = get_child(0)
@onready var og_highlight_percent_size = Vector2(highlight.size.x/get_viewport().size.x, highlight.size.y/get_viewport().size.y)
#take highlight percent and divide by og-percent

@export var background_dim:Color

var alert_warning:bool=true

var all_rects:Array

var some_time = 0

func _process(_delta):
	if self.visible:
		#highlight.position = Vector2(get_global_mouse_position().x - (0.5 * highlight.size.x), get_global_mouse_position().y - (0.5 * highlight.size.y))
		_calculate_highlight()
		some_time +=1
		if some_time == 3:
			queue_redraw()
			some_time = 0

	

	
func _ready():
	highlight.color = Color(0,0,0,0)

	get_viewport().size_changed.connect(viewport_size_change)
func _draw():
	_calculate_highlight()
	for rect in all_rects:
		if rect is Rect2:
			draw_rect(rect,background_dim)
			

func _calculate_highlight():
	var viewport = get_viewport_rect()



	
	
	var left_rect := Rect2(
	Vector2(0,0), #position
	Vector2(highlight.position.x, viewport.size.y) #size
	)	


	var right_rect := Rect2(
	Vector2(highlight.position.x+highlight.size.x,0), #position
	Vector2(viewport.end.x - (highlight.position.x + highlight.size.x),viewport.size.y) #size
	)


	var top_rect := Rect2(
	Vector2(highlight.position.x,0), #position
	Vector2(highlight.size.x, highlight.position.y ) #size
	)	

	var bottom_rect := Rect2(
	Vector2(highlight.position.x,highlight.position.y +highlight.size.y), #position
	Vector2(highlight.size.x,(viewport.end.y - (highlight.position.y + highlight.size.y)) ) #size
	)
	
	all_rects = [left_rect,right_rect,top_rect,bottom_rect]


func viewport_size_change():
		#tf highlight.size needs to change				#second half is not really adjusting much
	var percent_changer= og_highlight_percent_size/Vector2(highlight.size.x/get_viewport().size.x, highlight.size.y/get_viewport().size.y)
	#print("og print size   ", og_highlight_percent_size)
	#print(og_highlight_percent_size/Vector2(highlight.size.x/get_viewport().size.x, highlight.size.y/get_viewport().size.y))	#when decrease viewport size, that increase hihglight.size 
	highlight.size *= percent_changer #this seems to work
	
	#if change it to an array of sizes and positions, then can use size = array_size[current_size] * percent_changer
	#on viewport size changed
	if alert_warning == true:
		push_warning("highlight box wrong size now")
		alert_warning = false
