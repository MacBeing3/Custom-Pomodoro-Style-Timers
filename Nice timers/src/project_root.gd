extends Control

const main_screen :PackedScene=preload("res://src/Main_Screen.tscn")
const help_screen :PackedScene=preload("res://src/Scenes/Help_Screen.tscn")
signal change_scene(new_scene)
enum scenes{main,help}

@onready var pop_up_parent = get_node("PopupContainer/PopUpParent")

func _ready():
	self.connect("change_scene",do_change_scene)
	
func do_change_scene(new_scene):
	remove_child(get_child(0))
	
	var to_insantiate:PackedScene = main_screen if new_scene == scenes.main else help_screen
		
	var new_scene_instance = to_insantiate.instantiate() #this doesnt work still
	add_child(new_scene_instance)
	print(new_scene_instance.get_parent())
	move_child($PopupContainer,1)
	
	# for now, just queuefree confrirm popup
		#b/c might want it to add automatically each time a window is called if you want to 
		#have multiple "timelines/environments" going at once
	for child in pop_up_parent.get_children(): 
		child.queue_free()
	

	print("yo i got called btw thx")

