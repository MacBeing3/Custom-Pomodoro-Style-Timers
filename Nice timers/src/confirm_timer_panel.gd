extends Panel

func _process(_delta):
	var but:Button = get_parent() 
	if but.is_hovered(): modulate= Color(1,1,1,0.25)


