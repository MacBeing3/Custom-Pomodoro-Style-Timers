extends ColorRect
class_name HighlightChild

@onready var highlight:ColorRect = get_child(0)
@onready var highlight_percent_size = Vector2(highlight.size.x/get_viewport().size.x, highlight.size.y/get_viewport().size.y)
	#MULTIPLY highlight size by this

@export var background_dim:Color


var all_rects:Array
#TODO shoudl scale with size of viewport to always take up percetnage size
#set size in ready to be controlled by @export size
#make it percent of viewport size in ready

#at ready should take size and convert it itno a percentage of the viewport
#scaled size shoud then be used in hihglight size

var some_time = 0

func _process(_delta):
	highlight.position = Vector2(get_global_mouse_position().x - (0.5 * highlight.size.x), get_global_mouse_position().y - (0.5 * highlight.size.y))
	_calculate_highlight()
	some_time +=1
	if some_time == 10:
		queue_redraw()
		some_time = 0

	

	
func _ready():
	highlight.color = Color(0,0,0,0)


func _draw():
	_calculate_highlight()
	for rect in all_rects:
		if rect is Rect2:
			draw_rect(rect,background_dim)
			

func _calculate_highlight():
	var viewport = get_viewport_rect()

	#highlight_percent_size
	#highlight.size.x *= highlight_percent_size.x
	#highlight.size.y *= highlight_percent_size.y
	#shrinks it even when aat base
	#put this calced size over intiial percent size
	
	
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
