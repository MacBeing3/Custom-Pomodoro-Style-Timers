extends Control

@export var name_bar:Node

@export var increase_button : Button 
@export var decrease_button : Button
@export var work_label :Label

@onready var active_unit #= get_tree().get_root().get_child(0).get_child(0).get_node("BackgroundImage/MarginContainer/HSplitContainer/TimersBackground/TaskVsPresetDivider/TaskBackground/MarginContainer/SelectedTaskContainer/ActiveUnit")

@export var task_name:String = "Preset"
@export var minutes_duration: int = 1
@export var is_active_unit:bool = false


signal active_unit_hidden(b:bool)

func _ready():

	print("active unit", active_unit)
	active_unit_hidden.connect(_on_active_unit_hide_toggled)
	
	name_bar.text = task_name
	
	work_label.text = str(minutes_duration)+ " min"
	increase_button.pressed.connect(_on_increase_button_pressed)
	decrease_button.pressed.connect(_on_decrease_button_pressed)

func _get_drag_data(_position):
	print("get drag data going brr")
#	active_unit_hidden.emit(true)

	var preset_data = {"name":name_bar.text, "duration":minutes_duration}
	
	set_drag_preview(_get_preview_control())
	
	return preset_data

func _on_increase_button_pressed():
	minutes_duration+=1
	_on_changed_label("work", work_label,minutes_duration)
	
func _on_decrease_button_pressed():
	if minutes_duration > 1:
		minutes_duration -=1
		_on_changed_label("work", work_label,minutes_duration)



func _on_changed_label(_type, label, minutes):
	label.text = str(minutes) + " min"
	

func _on_active_unit_hide_toggled(b:bool):  #p sure is legacy code
	return
	if b == true:
		active_unit.visible = false
	else: 
		active_unit.visible = true

	
	
func _get_preview_control() -> Control:
#    """
#    The preview control must not be in the scene tree. You should not free the control, and
#    you should not keep a reference to the control beyond the duration of the drag.
#    It will be deleted automatically after the drag has ended.
#    """
	var preview = ColorRect.new()
	preview.size = Vector2(300.0*0.50,100.0*0.50)
	var preview_color = Color(255/255,126/255,202/255)
	preview_color.a = .5
	preview.color = preview_color
	preview.set_rotation(.1) # in readians
	return preview

#
#func _input(event):
#	if event is InputEventMouseButton:
#		if event.is_pressed() == false and drop_container.visible == true:
#			await get_tree().create_timer(0.05).timeout
#			drop_container.visible = false

