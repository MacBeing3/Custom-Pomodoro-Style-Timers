extends Control
class_name MainWindow

@onready var packed_scene_active_unit: PackedScene = preload("res://src/V2_Block_Template.tscn")
@onready var pck_scne_task_box: PackedScene = preload("res://src/task_box.tscn")

@onready var grid_container:= $BackgroundImage/MarginContainer/HSplitContainer/TimersBackground/TaskVsPresetDivider/PresetsBackground/VSplitContainer/PresetsScrollContainer/GridContainer
signal window_visible
signal window_hide

@onready var active_unit := $BackgroundImage/MarginContainer/HSplitContainer/TimersBackground/TaskVsPresetDivider/TaskBackground/MarginContainer/SelectedTaskContainer/ActiveUnit
@onready var sched_vbox := $BackgroundImage/MarginContainer/HSplitContainer/TaskBoard/VSplitContainer/ScheduleVBox
@onready var sched_button :Button= $BackgroundImage/MarginContainer/HSplitContainer/TaskBoard/VSplitContainer/StartSchedule

@onready var dev_mode_toggle_button:CheckButton= get_parent().get_node("CheckButton")
var dev_mode_enabled :bool= false

var timers_scheduled:Array #array of dictionaries: "name", "duration" #export this so can easily save presets?
var bound_timers:Array
var num_tasks :int= 0

#var schedule_state:String= "paused"

@onready var timer_popup_scene : PackedScene = preload("res://src/confirm_timer_popup.tscn")
@onready var timer_popup_instance
@export var add_popup_child_to: String
var popup_called_times:int=0

var schedule_button_function= "paused":
	set(state):
		schedule_button_function = state
		sched_button.text = state

		
	get:
		return schedule_button_function



func _ready():
	timer_popup_instance = timer_popup_scene.instantiate()
	var project_root_node := get_tree().get_root().get_node("ProjectManagerNode")



		

	project_root_node.get_node(add_popup_child_to).add_child.call_deferred(timer_popup_instance)
	project_root_node.get_node(add_popup_child_to).move_child.call_deferred(timer_popup_instance,0) #so in correct order for vbox
	
	await timer_popup_instance.child_entered_tree



	timer_popup_instance.popup_button_pressed.connect(_on_popup_pressed)
	
	window_visible.connect(timer_popup_instance._on_window_visible)
	window_hide.connect(timer_popup_instance._on_window_hide)
	
	window_hide.emit()

	if timers_scheduled == []:
		schedule_button_function= "Invalid"

##create new timer button
func _on_button_pressed():
	print("button not work yet")
	pass
	var new_active_unit_instance = packed_scene_active_unit.instantiate()
	grid_container.add_child(new_active_unit_instance)

	print("after button press size",get_parent().get_node("PopupContainer").get_size().y)
	


func _on_start_schedule_pressed(): #should replace with a pause and a stop timer

	
	if schedule_button_function == "Start Schedule":
		bound_timers[0].set_paused(false)
		print(bound_timers[0])
		


		schedule_button_function = "In Progress"

		
		await bound_timers[0].timeout
		window_visible.emit()
	#	
	#else: print("You finished, YAAY")

	elif schedule_button_function == "Restart":

		_reset_schedule()

	else: return
func _on_add_task_button_pressed():
	
	
	#adds new to timers_schedule
	var new_task:= {}
	new_task["name"] =  active_unit.name_bar.text
	new_task["duration"] = active_unit.minutes_duration
	
	timers_scheduled.push_back(new_task)
	#worth saving the taking of the array if want to have imports/presets

	print("timer scheduled    ", timers_scheduled)
	
	#assign task_boxes from dictionary			#would just need to call this if importing list
	if timers_scheduled.size()>=1:
		schedule_button_function= "Start Schedule"
	
	#instanciate taskbox scene were task_name is active.namebar.text, taskminutes is active.minutesdura, and timer dur is active.minutesdura
	var new_task_box_inst = pck_scne_task_box.instantiate()
	new_task_box_inst.nom = active_unit.name_bar.text
	new_task_box_inst.minutes = active_unit.minutes_duration
	new_task_box_inst.dev_mode = dev_mode_enabled
	
	sched_vbox.add_child(new_task_box_inst)
	
	bound_timers = []
	num_tasks = -1
	for dictionary in timers_scheduled:
		num_tasks+=1
		bound_timers.push_back(sched_vbox.get_child(num_tasks).get_node("Timer"))

func _on_timer_transition():

	if popup_called_times < bound_timers.size():
		bound_timers[popup_called_times].set_paused(false)
		print(bound_timers[popup_called_times])
		
		await bound_timers[popup_called_times].timeout
		
		if popup_called_times == bound_timers.size() - 1:
			timer_popup_instance.get_node("StartNextTimer").text = "End Timer"
		
		window_visible.emit()

		
	else: 
		schedule_button_function = "                                             ↗"


func _on_popup_pressed() -> void:
	popup_called_times += 1
	_on_timer_transition()
	
	
func _reset_schedule():
	popup_called_times = 0
		
	for child in sched_vbox.get_child_count():
		sched_vbox.get_child(child).value = 0
		var dictionary = timers_scheduled[child]
		sched_vbox.get_child(child).timer.start(dictionary["duration"])
		
		sched_vbox.get_child(child).timer.set_paused(true)
			
	schedule_button_function = "Start Schedule"



func _on_cancel_pressed():
	_reset_schedule()


func _on_check_button_pressed():
	dev_mode_enabled = not dev_mode_enabled

	print("devmode", dev_mode_enabled)
