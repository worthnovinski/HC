extends CharacterBody2D


const SPEED = 300.0
const JUMP_VELOCITY = -400.0

@onready var ap = $AnimationPlayer
@onready var sprite = $Sprite2D
@onready var timer: Timer = $Timer
@onready var hitbox_shape = $attackbox/CollisionShape2D
var pshell
var attacking: bool = false
var enemyinattackrange: bool = false
var hit: bool = false
var pikedout: bool = false
var pikedonwall: bool = false
var enemy


func _ready() -> void:
	timer.one_shot = true
	timer.timeout.connect(_on_action_completed)
	pshell = jumpshell.new()
	
func _process(delta: float) -> void:
	if pshell.has_method("get_shell_type") and Input.is_action_just_pressed("ui_accept") and pshell.type == "blue" and enemyinattackrange:
		attack()
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
	enemy.die()



func _on_action_completed() -> void:
	print("you died")
	get_tree().reload_current_scene()
	

func _physics_process(delta: float) -> void:
	wallslide(delta)
	if not is_on_floor():
		velocity += get_gravity() * delta
		
	if Input.is_action_pressed("ui_accept") and pshell.has_method("get_shell_type") and pshell.type == "turtle":
		velocity = Vector2.ZERO
		return
	

	if Input.is_action_just_pressed("ui_accept") and is_on_floor() and pshell.has_method("get_shell_type") and (pshell.type == "jump" or hit):
		velocity.y = JUMP_VELOCITY

	var direction := Input.get_axis("ui_left", "ui_right")
	if direction:
		velocity.x = direction * SPEED
	else:
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
