extends Control

#try and make draggable if possible, for now just copy to

@onready var work_timer :Timer= $Work
@onready var pause_timer :Timer= $Pause

@onready var progress_bar : ProgressBar = $CenterContainer/VBoxContainer/TimerBar
#@onready var timer_popup := get_tree().get_root().get_node("ProjectManagerNode/ConfirmTimerPopup") #need to inst new
@onready var timer_popup_scene : PackedScene = preload("res://src/confirm_timer_popup.tscn")
@onready var timer_popup

@onready var start_button : Button = $CenterContainer/VBoxContainer/TimerBar/StartButton
@onready var continuous_check : Button = $CenterContainer/VBoxContainer/ContinuousButton
@onready var setting_work_timer : Node = $CenterContainer/VBoxContainer/SettingWorkTimer

@onready var total_time_label:= $CenterContainer/VBoxContainer/TimerBar/TotalTime
@onready var current_mode_label := $CenterContainer/VBoxContainer/TimerBar/CurrentMode

@onready var title_name := $CenterContainer/VBoxContainer/TextEdit
#should make it so that on this text edit, leads to relevant linked popup changing label

#@onready var popup_window := $Popup
#make it the scene window
@onready var work_going_buttons_disabled :Array = setting_work_timer.buttons_disabled_on_start
#@onready var bla = work_going_buttons_disabled.append(start_button)

@export var on_prog_bar_stylebox: StyleBoxFlat
@export var off_prog_bar_stylebox: StyleBoxFlat

@export var add_popup_child_to: String

var time_remaining: int
var time_minutes

var work_time_minutes
@onready var work_time_seconds: set = _set_work_time_seconds, get = _get_work_time_seconds

##important
@export var dev_mode:bool


func _set_work_time_seconds(minutes):
	work_time_seconds = minutes*1 if dev_mode else minutes*60 #should be x60

func _get_work_time_seconds():
	return work_time_seconds

var pause_time_seconds: set = _set_pause_time_seconds, get = _get_pause_time_seconds

func _set_pause_time_seconds(minutes):
	pause_time_seconds = minutes*1 if dev_mode else minutes*60 #should be x60

func _get_pause_time_seconds():
	return pause_time_seconds

var pause_time_minutes

var timer_going: set = _set_timer_going, get = _get_timer_going

func _set_timer_going(going:bool):
	if going:


		for button in work_going_buttons_disabled:
			button.disabled = true
		
		timer_going = true
		
	elif not going:
	
		for button in  work_going_buttons_disabled:
			button.disabled = false
			
		
		return false

func _get_timer_going():
	return timer_going

var timer_running: bool = false
var continuous_mode: set = _set_continuous_mode, get =  _get_continuous_mode

func _set_continuous_mode(val:bool):
	continuous_mode = val
	
func  _get_continuous_mode():
	return continuous_mode

var total_num_cycles :int = 1
var current_num_cycles: int = 0

var work_mode:bool
var pause_mode: bool
enum timer_transition_stage{after_work,after_pause}


signal timer_started

signal window_visible
signal window_hide

@onready var work =["get_work",work_timer]
@onready var pause =["get_pause",pause_timer]

var timer_lengths = {
	
	"default": [5,2],
	"dev": [1,1]
	
}
##progressbar.value is time remaing

var popup_called_times: int = 0


##label.get_stylebox("normal").bg_color = new_color
# Or if you want to change the color independently for each label use the 
#Control.add_stylebox_override("normal", new_stylebox) method

func _ready(): #### notes for how to fx in read of confirm timer popuop
#	self.get_stylebox("normal")
	#change theme each time for button?
#	print(work_going_buttons_disabled)
#	print(setting_work_timer.buttons_disabled_on_start)
	
	work_going_buttons_disabled.append(start_button)
	
	work_mode = false
	pause_mode = false #maybe necessary, maybe not
	
	timer_popup = timer_popup_scene.instantiate()
	var project_root_node := get_tree().get_root().get_node("ProjectManagerNode")

#	var y_offset = 150 * (project_root_node.get_node("PopupContainer").get_child_count()+1)
#	timer_popup.position = Vector2(170000,y_offset) #should change to be less arbitrary

		

	project_root_node.get_node(add_popup_child_to).add_child.call_deferred(timer_popup)
	project_root_node.get_node(add_popup_child_to).move_child.call_deferred(timer_popup,0) #so in correct order for vbox
	
	await timer_popup.child_entered_tree
#	var y_offset = 150 * (project_root_node.get_node("PopupContainer").get_child_count()+1)
#	timer_popup.position = Vector2(1710,y_offset) #should change to be less arbitrary		
#disabled for now

	
	timer_started.connect(_on_timer_started)
	timer_popup.popup_button_pressed.connect(_on_popup_pressed)
	
	window_visible.connect(timer_popup._on_window_visible)
	window_hide.connect(timer_popup._on_window_hide)
	
	window_hide.emit()
	
	var start_times = timer_lengths["default"]
#	var start_times = timer_lengths["dev"] #note: does not change display labels
	
	if dev_mode:
		start_times = timer_lengths["dev"] #note: does not change display labels
	
	elif not dev_mode:
		start_times = timer_lengths["default"]
		
	_set_work_time_seconds(start_times[0])
	_set_pause_time_seconds(start_times[1])
	


func _process(delta:float) -> void:
	if _get_timer_going():

		if work_mode:
			_update_timer_fill_bar(work)
			return

		elif pause_mode:
			_update_timer_fill_bar(pause)
			return
			
		else: return
	
	else: return


func _on_start_button_pressed():

	_set_timer_going(true)
	
	work_mode = true
	_on_timer_transition(work, current_num_cycles)

	
func _on_timer_started():
	

	for button in work_going_buttons_disabled:
		button.disabled = true

	
func _update_timer_fill_bar(timer_array): 

	var time_seconds = _get_work_time_seconds() if timer_array[0] == "get_work" else _get_pause_time_seconds()
	var timer_node = timer_array[1]


	total_time_label.set_text("Timer: " + str(time_seconds/60) + " minutes") #this will correct itself once time_seconds is back to *60
	current_mode_label.text = "Mode: on" if timer_array[0] == "get_work" else "Mode: off"


#	print("var time_seconds", time_seconds)
#	print("var time_get_left",  timer_node.get_time_left())
#	print("_get_work_time_seconds()  ", _get_work_time_seconds())
	var time_elapsed = time_seconds - timer_node.get_time_left()	#need time in seconds and timer node
	var percent_full = (time_elapsed)/time_seconds
#		print("time elapsed: ", time_elapsed)
#		print("work timer left", work_timer.time_left)
	
	progress_bar.value = percent_full
#	print("percent full: ", percent_full)
#	print("prog_bar.value: ", progress_bar.value)
#	print("time elapased: ", time_elapsed)
	
	
func _on_work_timeout():
	
	
	work_timer.stop()
	work_mode = false
	
	pause_mode = true 

	$AlarmTimerOff.play()

	timer_popup.get_node("StartNextTimer").text = "Start Next Timer"

	window_visible.emit()

		
func _on_pause_timeout():
	current_num_cycles += 1
		
	pause_timer.stop()
	pause_mode = false
	
	
	work_mode = true #this may cause problems
	
	$AlarmTimerOff.play()

	timer_popup.get_node("StartNextTimer").text = "Start Next Timer" if current_num_cycles < total_num_cycles or _get_continuous_mode() else "End Timer"

	window_visible.emit()


func _on_continuous_button_toggled(button_pressed):
	var new_cont_mode = not _get_continuous_mode()
	_set_continuous_mode(new_cont_mode)





func _on_start_next_timer_pressed():
	pass # Replace with function body.
#	for first will be work
#		make so starts pause timer
#	for second will be pause going off
#		make so when click
#			if cont: start work timer
#			elif not cont: timer_running = false


func _change_themed_timer(mode:String):
	if mode == "get_work":
		progress_bar.value = 0
		progress_bar.set_fill_mode(0) 
		progress_bar.remove_theme_stylebox_override("fill")
		progress_bar.add_theme_stylebox_override("fill",on_prog_bar_stylebox)
		return
	
	elif mode == "get_pause":
		progress_bar.value = 0
		progress_bar.set_fill_mode(1)
		progress_bar.remove_theme_stylebox_override("fill")
		progress_bar.add_theme_stylebox_override("fill",off_prog_bar_stylebox)
		return
	
	

func _on_timer_transition(timer_mode: Array, current_cycles): #I think you can take out current_cycles var no problem
	var node = timer_mode[1]
	var get_wait_time = _get_work_time_seconds() if timer_mode[0] == "get_work"  else _get_pause_time_seconds()#not timer_mode[2] anymore
	
	
#	print("timer mode thingy is ", timer_mode)
	print("current cycles: ", current_num_cycles)
	window_hide.emit()
	
	_change_themed_timer(timer_mode[0])
	node.set_wait_time(get_wait_time)
	

	if (current_num_cycles < total_num_cycles) or _get_continuous_mode() == true:
		node.start()
		print("currect cyc < total || contin mode is true")
	else: 
		work_mode = false
		pause_mode = false
		_set_timer_going(false)
		current_num_cycles = 0
		progress_bar.value = 0
#		_update_timer_fill_bar(work)
		print("timer stopped")

	
#	else: print("ERROR transition states")
	#else: return ## call stop/restart timer function, then return function (if needed)

	
func _on_popup_pressed() -> void:

	popup_called_times += 1
	print(self,"'s popup clicked ", popup_called_times, " times")
	$AlarmTimerOff.stop()
	
	if work_mode:

		_on_timer_transition(work, current_num_cycles) #get back when finished debug
		print("(popup if workmode) pause mode is ", pause_mode)
		return

	elif pause_mode:
		_on_timer_transition(pause, current_num_cycles) #get back when finished debug
		print("(popup if pausetrue) pause mode is ", pause_mode) 
		return
	
	else: print("ERROR with current popup timer mode")

	##	print("popup button pressed")
	#	print("(popup) work mode is ", work_mode)
	#	print("(popup) pause mode is ", pause_mode)
