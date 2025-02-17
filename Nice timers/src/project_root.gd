extends Control

const main_screen :PackedScene=preload("res://src/Main_Screen.tscn")
const help_screen :PackedScene=preload("res://src/Scenes/Help_Screen.tscn")
signal change_scene(new_scene)
enum scenes{main,help}

func _ready():
	self.connect("change_scene",do_change_scene)
	
func do_change_scene(new_scene):
	remove_child(get_child(0))
	
	var to_insantiate:PackedScene = main_screen if new_scene == scenes.main else help_screen
		
	var new_scene_instance = to_insantiate.instantiate() #this doesnt work still
	add_child(new_scene_instance)
	
	print("yo i got called btw thx")
	#remove MainWindow
	#add Help Window -- have to insatntiate I belive
