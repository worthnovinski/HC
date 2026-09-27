extends RigidBody2D





func _on_blockbottom_body_entered(body: Node2D) -> void:
	print("crabcrushed")
	if body.has_method("die"):
		if global_position.y < body.global_position.y:
			body.die()
