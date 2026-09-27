extends Node2D
class_name jumpshell

var lshell 
var type: String = "jump":
	get:return type
	 
func get_shell_type():
	pass 
	

func _on_area_2d_interact() -> void:
	print("jump")
	
