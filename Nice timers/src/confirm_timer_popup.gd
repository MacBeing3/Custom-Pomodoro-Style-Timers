extends Control



signal popup_button_pressed

@onready var popup_window :Window = get_tree().get_root().get_child(0).get_node("PopupContainer")
@onready var main_screen_node:Control= get_tree().get_root().get_child(0).get_node("MainWindow")
@onready var sched_button:Button= get_tree().get_root().get_child(0).get_node("MainWindow/BackgroundImage/MarginContainer/HSplitContainer/TaskBoard/VSplitContainer/StartSchedule")
@export var current_task_name_label:RichTextLabel
@export var next_timer_label:Label


@onready var popup_button_size_y :int = get_child(0).size.y

@onready var inherited_title_name  #does not have use yet

#@onready var parent_of_timer_unit_node:= get_parent().get_node("MainWindow/ScrollContainer/GridContainer")

#@onready var parent_of_timer_unit_node:Node2D 
func _ready(): ##### This whole for loop needs to change, should instantiate from proj root node, then connect from there
	#print("parent of inst window:   ", get_parent())
	print("index of window popup is :  ", get_index())



func _on_window_visible(current_info, next_up):
	print("current timer name is    ", current_info["name"])
	print("current timer duration is     ", current_info["duration"])
	print("up next is    ", next_up["name"], "  for ", next_up["duration"], " time units")
	self.visible = true
#	popup_window.resize_v_box()	
		
#											italics strike			strikethough
	current_task_name_label.text = "[center] [i] [s]" + current_info["name"] + " [s]"

	
#	current_task_name_label.text = current_info["name"] 

	next_timer_label.text = "NEXT: " + next_up["name"] + " for " + str(next_up["duration"]) + " min"
	
	sched_button.disabled = true
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

	sched_button.disabled = false
	main_screen_node.is_timers_paused = false
	popup_window.hide()
		
#	popup_window.set_size(popup_window.size - Vector2i(0,73))





