extends Window


@onready var VBoxCon:= $PopUpParent
var button_size_y := 150
var v_separation := 200 - button_size_y

@export var initial_position_y : int


#var old_size: set= _set_old_size, get =_get_old_size #this should also be removed
#
#func _set_old_size(value):
#	old_size = value
#
#func _get_old_size():
#	return old_size

#@onready var new_size:int= get_size().y

func _ready():

	
##	_set_old_size(130)
#	print("newsize popup   ", get_window().get_size().y)
#
#	print("view port ", get_parent().get_parent().get_viewport().get_visible_rect())
#	var viewport:= get_parent().get_parent().get_viewport().get_visible_rect()
#
#	var popupdims = viewport.size
#	var popupX = popupdims[0]
#	var popupY = popupdims[1]
#
##	set_position( Vector2(popupX+390, popupY))
	
	
	
func resize_v_box(): #called on _on_window_hide/show in confirm_timer_popup
#	pass  #NOTE THIS PASS MEANS EVERYTHING BLANK PAST IT
	#this should being called when a timer confirm button is hidden or seen
	#should add size of button + spacing if showing
	#should minus it if hidden
	#if all of the timers are hidden, should hide popupcontainer window
	
	#size shoudl be function of how many are visible
	#button sizey 150 #vsepaaration is 200
	

	var num_buttons_vis :int = 0

	print("resize_v_box called", " num buttons visible is", num_buttons_vis)
	
	for child in VBoxCon.get_children():
		if child.visible:
			num_buttons_vis += 1
	
	print("loop finished:  ", "num buttons visible is", num_buttons_vis)
	size.y = (button_size_y + v_separation) * num_buttons_vis
	position.y = initial_position_y - ( (button_size_y + v_separation) * num_buttons_vis)


#func _on_v_box_container_resized(): #this needs to be fazed out
#	print("oldsize popup   ", _get_old_size())
#	print("newsize popup   ", size.y)
#	if get_size().y >= _get_old_size():
#
#		position.y -= 50
#		print("new > old")
##		_set_old_size( int(new_size) )
#
#	else: position.y += 50
#
#	_set_old_size( int(get_size().y) )
#
#	print("new oldsize   ", old_size)
#	print("what new oldsize should be    ", int(get_size().y))
	
	
