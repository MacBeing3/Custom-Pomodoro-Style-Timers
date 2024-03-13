extends Container


signal active_unit_hidden(b:bool)


func _can_drop_data(position, data):
	print("can drop")
	return typeof(data) == TYPE_DICTIONARY and data.has("name") and data.has("duration")

func _drop_data(position, data):
	print("dropped")
	active_unit_hidden.emit(false)
	
	get_parent().name_bar.text = data["name"]
	get_parent().work_label.text = str(data["duration"])+ " min"
	get_parent().minutes_duration = data["duration"]



