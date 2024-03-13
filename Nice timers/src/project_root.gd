extends Control

var yes = true

@onready var parent_of_timer_unit_node:= get_node("MainWindow/ScrollContainer/GridContainer")

@onready var child_place = get_parent().get_children()

func _ready():
	pass
	
# ScrollContainer/GridContainer/CoolTimer


#func _get_child_index(): #not needed atm
#	var child_place : int
#
#	var list_timers = parent_of_timer_unit_node.get_children()
#	var manager_node_children = get_children()
	
#
#		for i in parent_of_timer_unit_node.get_child_count():
#		print("+1 child")
#		parent_of_timer_unit_node.get_child(i).window_visible.connect(_on_window_visible)
#		parent_of_timer_unit_node.get_child(i).window_hide.connect(_on_window_hide)
#
#		timer_popup.get_node("StartNextTimer").pressed.connect(_on_popup_pressed)
