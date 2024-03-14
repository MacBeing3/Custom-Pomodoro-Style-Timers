extends ProgressBar

@onready var timer: Timer= $Timer
@onready var time_left:float
@onready var nom: String
@onready var minutes:int

@onready var task_name:=$TaskName
@onready var task_minutes:=$TaskMinutes

@export var dev_mode: bool

signal window_visible
signal window_hide

func _ready():
	task_name.text = nom
	task_minutes.text = str(minutes) + " min"
	if dev_mode:
		timer.start(minutes)
	else: timer.start(minutes*60)
	
	timer.set_paused(true)
	

	
	
func _process(_delta):
	time_left = timer.get_time_left()
	var percent_full = 1 - time_left/timer.get_wait_time()
	
	#timerbar value
	self.value = percent_full

func _on_timer_timeout():
	timer.stop()
	$AlarmTimerOff.play()
	window_visible.emit()

	
#		var time_left = glyph["timer"].get_time_left()
#		var percent_full = time_left/glyph["wait_time"]
#
#		glyph["fill_bar"].value = percent_full


func _on_popup_pressed() -> void:
	window_hide.emit()
	$AlarmTimerOff.stop()
