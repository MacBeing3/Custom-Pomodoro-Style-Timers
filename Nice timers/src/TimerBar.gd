extends ProgressBar


#toggle mode button : continuous
#timer _start():
	##on timer start, fill left to right based on Work Timer.get_wait_time
	#on work timer.emitted call _on_work_timer complete
##wait for timer complete acknowledge by user
##then change enum to fill right left, change fill color, get pause.wait_time, pause.start
#wait for timer complete acknoledge by user
##if continuous == true: _start()	else: return
@export var on_fill :StyleBox
@export var off_fill :StyleBox

func _ready():
#	add_theme_stylebox_override("on",on_fill)
	pass
	
#on_turning_off(): add)them ("off", off_fill)
