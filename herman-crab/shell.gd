extends Area2D
class_name shell

var type = "nothing yet"
var in_range:bool = false
signal interact
var bum


#func set_type(colou):
#	type = colou
	
#func get_type():
#	type

func _ready() -> void:
	body_entered.connect(_on_range)
	#body_entered.connect(_activate_Shell)
	body_exited.connect(_out_range)

	
func _unhandled_input(event: InputEvent) -> void:
	if in_range and event.is_action_pressed("interact"):
		interact.emit()
		#body_entered.connect(_activate_Shell)
		bum.new_shell(get_parent())

func _on_range(body: Node2D) -> void:
	if body.is_in_group("player"):
		in_range = true
		bum = body
		

func _out_range(body: Node2D) -> void:
	if body.is_in_group("player"):
		in_range = false


func _on_interact() -> void:
	pass # Replace with function body.
