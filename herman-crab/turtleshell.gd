extends Node2D
class_name turtleshell

var mshell 
var type: String = "turtle":
	get:return type

func get_shell_type():
	pass 
	
func _on_area_2d_interact() -> void:
	print("turtle")
	
