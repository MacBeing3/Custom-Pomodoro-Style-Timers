extends ColorRect

@export var color_type:String
# Called when the node enters the scene tree for the first time.
func _ready():
	theme_changed.connect(on_theme_change)
	color = get_owner().theme.get_color(color_type,"ColorRect")
	print("color rect yooo ", get_owner().theme.get_color(color_type,"ColorRect"))


func on_theme_change():
	color = get_owner().theme.get_color(color_type,"ColorRect")
