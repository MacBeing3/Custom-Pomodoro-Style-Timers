extends Control

@onready var work_label :Label = get_node("OnButton/ButtonAndDisplay/TimeRect/TimeSet")
@onready var pause_label :Label = get_node("OffButton/ButtonAndDisplay/TimeRect/TimeSet")

@onready var work_increase_button : Button = $OnButton/ButtonAndDisplay/IncreaseButton
@onready var work_decrease_button : Button = $OnButton/ButtonAndDisplay/DecreaseButton
@onready var pause_increase_button : Button = $OffButton/ButtonAndDisplay/DecreaseButton
@onready var pause_decrease_button : Button = $OffButton/ButtonAndDisplay/IncreaseButton

@onready var buttons_disabled_on_start :Array = [work_increase_button, work_decrease_button, pause_increase_button, pause_decrease_button]

var minutes_work_time:int = 5
var seconds_work_time := minutes_work_time * 60

var minutes_pause_time:int = 2
var seconds_pause_time := minutes_work_time * 60


signal timer_started

##all the timer info should go here for how long the on and off timers should be

func _ready():
	work_label.text = str(minutes_work_time)+ " min"
	pause_label.text = str(minutes_pause_time)+ " min"
	

func _on_work_decrease_button_pressed():
	minutes_work_time-=1
	_on_changed_label("work", work_label,minutes_work_time)

func _on_work_increase_button_button_up():
	minutes_work_time+=1
	_on_changed_label("work", work_label,minutes_work_time)

func _on_pause_decrease_button_pressed():
	minutes_pause_time-=1
	_on_changed_label("pause", pause_label,minutes_pause_time)

func _on_pause_increase_button_pressed():
	minutes_pause_time+=1
	_on_changed_label("pause", pause_label,minutes_pause_time)

func _on_changed_label(type, label, minutes):
	label.text = str(minutes) + " min"
	
	if type == "work":
		owner._set_work_time_seconds(minutes)
		print("wokr time set to ", owner._get_work_time_seconds())
		return
		
	if type == "pause": #below causing probs?
		owner._set_pause_time_seconds(minutes)
		print("wokr time set to ", owner._get_pause_time_seconds())
		return
		
	return
	
	
		


#instead of this just make it so when teh button is pressed buttons.disabled != buttons.disabled
#func _toggle_timers_lock(crease: String):
#	pass
#	#add it so you can lock the increase decrease buttons and that makes it so the buttons become disabled
#	if crease == "increase":
#		pass
#		#if button.disabled in buttons = true:
#		#	button.disabled in buttons = false

