extends Node2D
class_name pikeshell 

var type: String = "pike":
	get:return type
	
func get_shell_type():
	pass 
	
func _on_area_2d_interact() -> void:
	print("pike")
	
