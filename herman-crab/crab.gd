extends CharacterBody2D


@export var speed: float = 60.0
@export var gravity: float = 900.0
var dumbdist: int = 0
var dead: bool = false
var direction: int = -1 
@onready var sprite: AnimatedSprite2D = $AnimatedSprite2D
@onready var box: CollisionShape2D = $CollisionShape2D

func die() -> void:
	print("crabdead")
	velocity.y = -200
	velocity.x = 0
	#var gum = "true"
	box.disabled=true
	box.set_deferred("disabled", true)

	dead = true

func _physics_process(delta: float) -> void:
	if dead:
		
		velocity.y += gravity * delta
		move_and_slide()
		if global_position.y > 1000:
			queue_free()
			print("crabdespawned")
	else:
		if not is_on_floor():
			velocity.y += gravity * delta
		velocity.x = speed * direction
		dumbdist=dumbdist+1
		move_and_slide()
		if is_on_wall():
			direction *= -1
			sprite.flip_h = direction < 0
			dumbdist = 0
			
		if dumbdist == 150:
			direction *= -1
			sprite.flip_h = direction < 0
			dumbdist = 0
	
	


func _on_area_2d_body_entered(body: Node2D) -> void:
	body.take_hit()
	#print("hit")
