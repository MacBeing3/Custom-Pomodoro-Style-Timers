extends Container


signal active_unit_hidden(b:bool)
@onready var this_window:= get_tree().get_root().get_node("ProjectManagerNode").get_node("MainWindow") #gets "mainwindow" / help window
@export var is_active_unit_child:bool = true

func _ready():
	self.tree_entered.connect(_update_this_window) ##this doesnt work, not work on tree change

func _can_drop_data(_position, data):
	#print("can drop")
	return typeof(data) == TYPE_DICTIONARY and data.has("name") and data.has("duration")

func _drop_data(_position, data):
	print("dropped")
	if is_active_unit_child:
		active_unit_hidden.emit(false)
		
		get_parent().name_bar.text = data["name"]
		get_parent().work_label.text = str(data["duration"])+ " min"
		get_parent().minutes_duration = data["duration"]

	else:
		print(this_window)
		this_window.drag_on_add_task_button_pressed( data["name"],data["duration"])


func _update_this_window():
	print("updated window")
	this_window= get_tree().get_root().get_node("ProjectManagerNode").get_child(0)
##this doesnt work
