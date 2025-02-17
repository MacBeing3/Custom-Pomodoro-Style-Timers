extends Button
#signal change_scene(new_scene)
enum scenes{main,help}
@export var go_to:scenes

# Called when the node enters the scene tree for the first time.
func _ready():
	self.pressed.connect(_on_help_press)


func _on_help_press():
	print(get_tree().get_root().get_child(0))

	get_tree().get_root().get_child(0).change_scene.emit(go_to)

	#print("htis is es", get_tree().get_root().get_node("ProjectManagerNode").get_child(0))
	#get_tree().change_scene_to_packed()
