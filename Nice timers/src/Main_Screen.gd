extends Control
class_name MainWindow

@onready var packed_scene_active_unit: PackedScene = preload("res://src/V2_Block_Template.tscn")
@onready var pck_scne_task_box: PackedScene = preload("res://src/task_box.tscn")

@onready var grid_container:= $BackgroundImage/MarginContainer/HSplitContainer/TimersBackground/PresetsBackground/VSplitContainer/PresetsScrollContainer/GridContainer
signal window_visible(current_info, next_up)
signal window_hide

#active unit outdated
@onready var active_unit #:= $BackgroundImage/MarginContainer/HSplitContainer/TimersBackground/TaskVsPresetDivider/TaskBackground/MarginContainer/SelectedTaskContainer/ActiveUnit
@onready var sched_vbox := $BackgroundImage/MarginContainer/HSplitContainer/TaskBoard/VSplitContainer/Control/ScheduleVBox
@onready var sched_button :Button= $BackgroundImage/MarginContainer/HSplitContainer/TaskBoard/VSplitContainer/StartSchedule
@onready var rest_clr_button:Button=$BackgroundImage/MarginContainer/HSplitContainer/TaskBoard/VSplitContainer/StartSchedule/VBoxContainer/ResetButton
@onready var pause_play_button:Button = 	$BackgroundImage/MarginContainer/HSplitContainer/TaskBoard/VSplitContainer/StartSchedule/VBoxContainer/PausePlayButton
@onready var num_sched_completed_label = $BackgroundImage/MarginContainer/HSplitContainer/TaskBoard/VSplitContainer/StartSchedule/VBoxContainer/NumSchedCompleted


@onready var current_timer:Timer = null

@onready var dev_mode_toggle_button:CheckButton= get_node("CheckButton")
var dev_mode_enabled :bool= false

var timers_scheduled:Array #array of dictionaries: "name", "duration" #export this so can easily save presets?
var bound_timers:Array
var num_tasks :int= 0

#var schedule_state:String= "paused"

@onready var timer_popup_scene : PackedScene = preload("res://src/confirm_timer_popup.tscn")
@onready var timer_popup_instance
@export var add_popup_child_to: String

var popup_called_times:int=0
var num_schedules_completed:int = 0


#state machine for schedule states? pause, play, invalid?
var is_timers_paused = false:
	set(pause_state):
		is_timers_paused = pause_state
		if pause_state == false:
			pause_play_button.text = "| |"
			
		else: pause_play_button.text = "|>"
		
	get: return is_timers_paused

var schedule_button_function= "paused":
	set(state):
		schedule_button_function = state
		sched_button.text = state

		
	get:
		return schedule_button_function

var rest_clr_button_function = "Restart":
	set(state):
		rest_clr_button_function = state
		rest_clr_button.text = state

	get:
		return rest_clr_button_function
	
func _ready():
	
	var scheduler:Button = $BackgroundImage/MarginContainer/HSplitContainer/TaskBoard.get_node("VSplitContainer/StartSchedule")
	scheduler.pressed.connect(_on_start_schedule_pressed)

	
	var reset:Button = $BackgroundImage/MarginContainer/HSplitContainer/TaskBoard.get_node("VSplitContainer/StartSchedule/VBoxContainer/ResetButton")
	reset.pressed.connect(_reset_schedule)
	
	timer_popup_instance = timer_popup_scene.instantiate()
	var project_root_node := get_tree().get_root().get_node("ProjectManagerNode")


	is_timers_paused = true
		

	project_root_node.get_node(add_popup_child_to).add_child.call_deferred(timer_popup_instance)
	project_root_node.get_node(add_popup_child_to).move_child.call_deferred(timer_popup_instance,0) #so in correct order for vbox
	
	await timer_popup_instance.child_entered_tree



	pause_play_button.pressed.connect(_on_pause_play_button_pressed)
	timer_popup_instance.popup_button_pressed.connect(_on_popup_pressed)
	
	window_visible.connect(timer_popup_instance._on_window_visible)
	window_hide.connect(timer_popup_instance._on_window_hide)
	
	window_hide.emit()
	#sched_button.disabled = false

	if timers_scheduled == []:
		schedule_button_function= "Invalid"

##create new timer button
func _on_button_pressed():
	print("button not work yet")
	var new_active_unit_instance = packed_scene_active_unit.instantiate()
	grid_container.add_child(new_active_unit_instance)

	print("after button press size",get_parent().get_node("PopupContainer").get_size().y)
	


func _on_start_schedule_pressed(): #should replace with a pause and a stop timer
	print("yo I did it")
	
	if schedule_button_function == "Start Schedule":
		bound_timers[0].set_paused(false)
		is_timers_paused = false
		rest_clr_button_function = "Restart"
		print(bound_timers[0])
		


		schedule_button_function = "| |"

		
		await bound_timers[0].timeout
#		window_visible.emit()
		window_visible.emit(timers_scheduled[popup_called_times],_get_next_scheduled_timer(timers_scheduled, popup_called_times))
		#sched_button.disabled = true 
		
	if schedule_button_function == "| |" or "| >":
		_on_pause_play_button_pressed()
	
	

	elif schedule_button_function == "Restart":

		_reset_schedule()

	else: return
func _on_add_task_button_pressed(): #not used now I belive
	
	
	#adds new to timers_schedule
#	scheduling system name and duration, plus is devmode?
	var new_task:= {}
	new_task["name"] =  active_unit.name_bar.text
	new_task["duration"] = active_unit.minutes_duration
	
	timers_scheduled.push_back(new_task)
	#worth saving the taking of the array if want to have imports/presets

	print("timer scheduled    ", timers_scheduled)
	
	#assign task_boxes from dictionary			#would just need to call this if importing list
	if timers_scheduled.size()>=1:
		schedule_button_function= "Start Schedule"

	#taskbx is the box that shows how full, appears in task_board
	#instanciate taskbox scene were task_name is active.namebar.text, taskminutes is active.minutesdura, and timer dur is active.minutesdura
	var new_task_box_inst = pck_scne_task_box.instantiate()
	new_task_box_inst.nom = active_unit.name_bar.text
	new_task_box_inst.minutes = active_unit.minutes_duration
	new_task_box_inst.dev_mode = dev_mode_enabled
	
	sched_vbox.add_child(new_task_box_inst)
	
	bound_timers = []
	num_tasks = -1 #ERROR 1
	for dictionary in timers_scheduled:
		num_tasks+=1
		bound_timers.push_back(sched_vbox.get_child(num_tasks).get_node("Timer"))

func _on_timer_transition():


	if popup_called_times < bound_timers.size():
		bound_timers[popup_called_times].set_paused(false)
		is_timers_paused = false
		current_timer = bound_timers[popup_called_times]
		print("current timer is    ", bound_timers[popup_called_times])
		
		await bound_timers[popup_called_times].timeout
		
		if popup_called_times == bound_timers.size() - 1:
			timer_popup_instance.get_node("StartNextTimer").text = "End Sched"
		

		window_visible.emit(timers_scheduled[popup_called_times],_get_next_scheduled_timer(timers_scheduled, popup_called_times))
		#sched_button.disabled = true 
		
	else: #if end of timer
		schedule_button_function = "                                             ↗"
		num_schedules_completed += 1
		num_sched_completed_label.text = str(num_schedules_completed) + " completed! "


func _on_popup_pressed() -> void:
	popup_called_times += 1
	_on_timer_transition()
	
	
func _reset_schedule():

	
	if rest_clr_button_function == "Restart" and sched_vbox.get_child_count() != 0:
		popup_called_times = 0
		
		for child in sched_vbox.get_child_count():
			if sched_vbox.get_child(child) is Container:
				sched_vbox.get_child(child).value = 0

			var dictionary = timers_scheduled[child]
			sched_vbox.get_child(child).timer.start(dictionary["duration"])
			current_timer = sched_vbox.get_child(child).timer
			
			sched_vbox.get_child(child).dev_mode = dev_mode_enabled
			sched_vbox.get_child(child)._check_dev_mode()
			sched_vbox.get_child(child).timer.set_paused(true)
			is_timers_paused = true
		
		current_timer = bound_timers[0]
				
		schedule_button_function = "Start Schedule"
		rest_clr_button_function = "Clear"


	elif rest_clr_button_function == "Clear":
		for child in sched_vbox.get_child_count():
			sched_vbox.get_child(child).call_deferred("queue_free")
		
		current_timer = null
		timers_scheduled = []
		schedule_button_function = "Invalid"
		rest_clr_button_function = "Restart"


func _on_cancel_pressed():
	_reset_schedule()


func _on_check_button_pressed():
	dev_mode_enabled = not dev_mode_enabled
	print("devmode", dev_mode_enabled)

	_reset_schedule()
	drag_on_add_task_button_pressed("test 1 timer", 1)
	drag_on_add_task_button_pressed("test 2 timer", 1)
	
	#redoing function to take inputs instead
	
func drag_on_add_task_button_pressed(task_name, task_duration):
	#task_name shoudl be name_bar.text 				of the dragged
	#task_duration should be minutes_duration 		of the dragged

	#adds new to timers_schedule
	var new_task:= {}
	new_task["name"] =  task_name			#name_bar.text
	new_task["duration"] = task_duration		#minutes_duration
	
	timers_scheduled.push_back(new_task)
	#worth saving the taking of the array if want to have imports/presets

	print("timer scheduled    ", timers_scheduled)
	
	#assign task_boxes from dictionary			#would just need to call this if importing list
	if timers_scheduled.size()>=1:
		schedule_button_function= "Start Schedule"
	
	#instanciate taskbox scene were task_name is active.namebar.text, taskminutes is active.minutesdura, and timer dur is active.minutesdura
	var new_task_box_inst = pck_scne_task_box.instantiate()
	new_task_box_inst.nom = task_name		#new.nom = name_bar.text 
	new_task_box_inst.minutes = task_duration	#new.minutes = minutes_duration
	new_task_box_inst.dev_mode = dev_mode_enabled			#new.dev_mode = dev_mode_enabled
	
	sched_vbox.add_child(new_task_box_inst)
	
	bound_timers = []
	num_tasks = -1
	for dictionary in timers_scheduled:
			
		num_tasks+=1
		bound_timers.push_back(sched_vbox.get_child(num_tasks).get_node("Timer"))
		
	
	if current_timer == null:
		current_timer = bound_timers[0]

func _on_pause_play_button_pressed():
	print(is_timers_paused)
	if current_timer:
		if schedule_button_function == "Start Schedule":
			_on_start_schedule_pressed()
			return
			
		if is_timers_paused == true: #if paused, play timer
			current_timer.set_paused(false)
			is_timers_paused = false
			schedule_button_function = "| |"
			rest_clr_button_function = "Restart"
		elif is_timers_paused == false: #if not apused, now pause
			is_timers_paused = true
			current_timer.set_paused(true)
			schedule_button_function = "| >"



func _get_next_scheduled_timer(timer_sched, popup_times) -> Dictionary:
	var next_up: Dictionary
	if timer_sched.size() > popup_times+1:
		next_up =  timer_sched[popup_times+1]
	
	else: next_up = {"name":"the end","duration":0}
	
	return next_up
