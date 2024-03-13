extends Control



signal popup_button_pressed

@onready var popup_window :Window = get_tree().get_root().get_child(0).get_node("PopupContainer")

@onready var popup_button_size_y :int = get_child(0).size.y

@onready var inherited_title_name  #does not have use yet

#@onready var parent_of_timer_unit_node:= get_parent().get_node("MainWindow/ScrollContainer/GridContainer")

#@onready var parent_of_timer_unit_node:Node2D 
func _ready(): ##### This whole for loop needs to change, should instantiate from proj root node, then connect from there
	print("parent of inst window:   ", get_parent())
	print("index of window popup is :  ", get_index())



func _on_window_visible():
	self.visible = true
#	popup_window.resize_v_box()	
	
	popup_window.show()

	
#	popup_window.resize_v_box()

#	popup_window.grab_focus()
#	popup_window.move_to_foreground()

	print("received show request")

func _on_window_hide():
	self.visible = false
	
#	if(popup_window):
#		popup_window.resize_v_box()

	
	print("received hidden request", "  popup window is  ", popup_window)



func _on_start_next_timer_pressed():
	popup_button_pressed.emit()

	popup_window.hide()
		
#	popup_window.set_size(popup_window.size - Vector2i(0,73))



