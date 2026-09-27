extends Node2D
class_name blueshell

var mshell 
var type: String = "blue":
	get:return type

#func _ready() -> void:
func get_shell_type():
	pass 
	

	 
#func _process(delta: float) -> void:
	
func _on_area_2d_interact() -> void:
	print("bluee")
	
