extends CharacterBody2D


const SPEED = 300.0
const JUMP_VELOCITY = -400.0

#@onready var ap = $AnimationPlayer
@onready var sprite = $AnimatedSprite2D
@onready var timer: Timer = $Timer
@onready var hitbox_shape = $attackbox/CollisionShape2D
var pshell
var attacking: bool = false
var enemyinattackrange: bool = false
var hit: bool = false
var pikedout: bool = false
var pikedonwall: bool = false
var inshell: bool = false

var blueshel = preload("res://blueshell.tscn")
var jumpshel = preload("res://jumpshell.tscn")
var turtleshel = preload("res://turtleshell.tscn")
var pikeshel = preload("res://pikeshell.tscn")

var enemy


func _ready() -> void:
	timer.one_shot = true
	timer.timeout.connect(_on_action_completed)
	pshell = jumpshell.new()
	
func _process(delta: float) -> void:


	
	if pshell.has_method("get_shell_type") and Input.is_action_pressed("ui_accept") and pshell.type == "blue" and not attacking and not hit:
		
		attacking = true
		sprite.play("attack")
		
		if enemyinattackrange:
			attack()
			
		await sprite.animation_finished
		attacking = false

	if pshell.has_method("get_shell_type") and Input.is_action_just_pressed("ui_accept") and pshell.type == "pike" and pikedout and not pikedonwall:
		pikedout = false;
		print("pikeup")
	else: if pshell.has_method("get_shell_type") and Input.is_action_just_pressed("ui_accept") and pshell.type == "pike" and pikedout and pikedonwall:
		wall_jump_h()
	else: if pshell.has_method("get_shell_type") and Input.is_action_just_pressed("ui_accept") and pshell.type == "pike" and not pikedout:
		print("pikeout")
		pikedout = true;


func wall_jump_h() -> void:
			var wall_normal = get_wall_normal()
			velocity.x = wall_normal.x * 2000
			velocity.y = JUMP_VELOCITY
			sprite.flip_h = (wall_normal.x < 0)
			pikedonwall = false
			
func attack():
	
	print("attack!")
	attacking = true

	enemy.die()



func _on_action_completed() -> void:
	print("you died")
	get_tree().reload_current_scene()
	

func _physics_process(delta: float) -> void:
	if attacking:
		velocity.x = move_toward(velocity.x, 0, SPEED)
		
		move_and_slide()
		return # Skip the rest of the movement/animation code while attacking

	wallslide(delta)
	if not is_on_floor():
		velocity += get_gravity() * delta
		
	if Input.is_action_pressed("ui_accept") and pshell.has_method("get_shell_type") and pshell.type == "turtle":
		velocity = Vector2.ZERO
		inshell = true
		sprite.play("entershell")
		sprite.play("shellidle")
		return
	

	if Input.is_action_just_pressed("ui_accept") and is_on_floor() and pshell.has_method("get_shell_type") and (pshell.type == "jump" or hit):
		velocity.y = JUMP_VELOCITY

	var direction := Input.get_axis("ui_left", "ui_right")
	if direction and hit:
		sprite.play("hitwalk")
		velocity.x = direction * SPEED

	else: if hit:

		sprite.play("hitidle")
		velocity.x = move_toward(velocity.x, 0, SPEED)

	else: if direction and pshell.has_method("get_shell_type") and pshell.type == "jump":
		sprite.play("walk")
		velocity.x = direction * SPEED


	else: if direction and pshell.has_method("get_shell_type") and pshell.type == "blue":
		sprite.play("bluewalk")
		velocity.x = direction * SPEED
	else: if direction and pshell.has_method("get_shell_type") and pshell.type == "pike" and not pikedout:
		sprite.play("pikewalk")
		velocity.x = direction * SPEED
		
	else: if direction and pshell.has_method("get_shell_type") and pshell.type == "pike" and pikedout:
		sprite.play("pikeoutwalk")
		velocity.x = direction * SPEED
	else: if pshell.has_method("get_shell_type") and pshell.type == "pike" and pikedout:
		sprite.play("pikeoutidle")
		velocity.x = move_toward(velocity.x, 0, SPEED)

	else: if direction and pshell.has_method("get_shell_type") and pshell.type == "turtle":
		sprite.play("turtlewalk")
		velocity.x = direction * SPEED
	else: if pshell.has_method("get_shell_type") and pshell.type == "blue":
		sprite.play("blueidle")
		velocity.x = move_toward(velocity.x, 0, SPEED)

	else: if pshell.has_method("get_shell_type") and pshell.type == "pike":
		sprite.play("pikeidle")
		velocity.x = move_toward(velocity.x, 0, SPEED)

	else: if pshell.has_method("get_shell_type") and pshell.type == "turtle":
		sprite.play("turtleidle")
		velocity.x = move_toward(velocity.x, 0, SPEED)

	else:
		sprite.play("idle")

		
		velocity.x = move_toward(velocity.x, 0, SPEED)
		
	if(direction != 0):
		
		sprite.flip_h = (direction == -1)
		
	move_and_slide()
	
	for i in get_slide_collision_count():
		var collision = get_slide_collision(i)
		var collider = collision.get_collider()
		
		if collider is RigidBody2D and pshell.type == "blue":
			collider.apply_central_impulse(-collision.get_normal() *95.2)
	
	update_animations(direction)
	
func take_hit():
	if Input.is_action_pressed("ui_accept") and pshell.has_method("get_shell_type") and pshell.type == "turtle":
		print("crabblocked")
	
	else: if not hit:
		timer.start(4.0)
		pikedout = false
		hit = true
		print("oh no! You've lost your shell! better find another!")
	
func new_shell(pshoill):
	pikedout = false
	print("soup")
	if not timer.is_stopped():
		timer.stop()
		hit = false
	if pshell.has_method("get_shell_type") and pshell.type == "turtle":
		turtleshel.instantiate()
	else: if pshell.has_method("get_shell_type") and pshell.type == "blue":
		blueshel.instantiate()
	else: if pshell.has_method("get_shell_type") and pshell.type == "pike":
		pikeshel.instantiate()
	else:
		jumpshel.instantiate()

	pshell = pshoill
	
	
func update_animations(direction):
		pass


func _on_attackbox_body_entered(body: Node2D) -> void:
	if  body.has_method("die"):
		print("enemyinrange");
		enemy = body
		enemyinattackrange = true

func wallslide(delt: float) -> void:
		if is_on_wall() and pikedout and not is_on_floor():
			var input_dir = Input.get_axis("ui_left", "ui_right")
			var wall_normal = get_wall_normal()
			#var piking_into_wall: bool = (input_dir < 0 and wall_normal.x > 0) or (input_dir > 0 and wall_normal.x < 0)
			
			#if piking_into_wall:
			print("pikedonwal")
			
			pikedonwall = true
			if velocity.y > 0:
				velocity.y = min(velocity.y, 14)


func _on_attackbox_body_exited(body: Node2D) -> void:
	print("enemyoutrange");
	if  body.has_method("die"):
		print("enemyoutofrange");
		enemyinattackrange = false


func _on_animated_sprite_2d_animation_looped() -> void:
	if sprite.animation == "attack":
		print("idk")
		attacking = false
