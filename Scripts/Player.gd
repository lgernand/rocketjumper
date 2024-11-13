extends CharacterBody3D

var ammo = 100
var armore = 100
var health = 100
var speed
const WALK_SPEED = 11.0
const SPRINT_SPEED = 11.0
const JUMP_VELOCITY = 6
const SENSITIVITY = 0.004
var can_shoot : bool = true
var has_ammo : bool = true

#bob variables
const BOB_FREQ = 2.4
const BOB_AMP = 0.08
var t_bob = 0.0


#fov variables
const BASE_FOV = 90.0
const FOV_CHANGE = 1.5
const rocket = preload("res://modles/rocket.tscn")


# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity = 9.8

@onready var deathtimer = $deathTimer
@onready var healthbar = $Head/Camera3D/healthbar
@onready var head = $Head
@onready var camera = $Head/Camera3D
@onready var armorebar = $Head/Camera3D/armore
@onready var marker_3d = $Head/Camera3D/Marker3D
@onready var ammobar = $Head/Camera3D/ammo
@onready var shoot_timer = $shoot_timer
	

func out_of_ammo():
	has_ammo = false

func useammo(ammo_ammount):
	if ammo_ammount < ammo:
		ammo -= ammo_ammount
	else:
		ammo = 0
	ammobar.value = ammo
	if ammo == 0:
		out_of_ammo()


func hurt(hit_points):
	if hit_points < health:
		health -= hit_points - (armore * 0.05)
	else:
		health = 0
	healthbar.value = health
	if health == 0:
		die()
	
	if hit_points < armore:
		armore -= hit_points
	else:
		armore = 0
	armorebar.value = armore

func restore(hit_points):
	if ((hit_points + health) < 100):
		health += hit_points
	else:
		health = 100
	
	healthbar.value = health
	
func restorearmore(hit_points):
	if ((hit_points + armore) < 100):
		armore += hit_points
	else:
		armore = 100
	
	armorebar.value = health

func die():
	deathtimer.start()
	pass

func _ready():
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)


func _unhandled_input(event):
	if event is InputEventMouseMotion:
		head.rotate_y(-event.relative.x * SENSITIVITY)
		camera.rotate_x(-event.relative.y * SENSITIVITY)
		camera.rotation.x = clamp(camera.rotation.x, deg_to_rad(-90), deg_to_rad(90))
		
		
func _shoot_rocket():
		shoot_timer.start()
		useammo(1)
		can_shoot = false
		var rocket_node = rocket.instantiate()
		
		rocket_node.rotation_degrees = marker_3d.global_transform.basis.get_euler()
		marker_3d.add_child(rocket_node)

func _rocket_jump():
	#if is_on_floor():
	velocity.y = JUMP_VELOCITY * 2.5

func _physics_process(delta):
	
	
	
	if Input.is_action_just_pressed("fire") and can_shoot and has_ammo:
		print("fire")
		_shoot_rocket()
	
	# Add the gravity.
	if not is_on_floor():
		velocity.y -= gravity * delta

	# Handle Jump.
	if Input.is_action_just_pressed("jump") and is_on_floor():
		velocity.y = JUMP_VELOCITY
	
	# Handle Sprint.
	if Input.is_action_pressed("sprint"):
		speed = SPRINT_SPEED
	else:
		speed = WALK_SPEED

	# Get the input direction and handle the movement/deceleration.
	var input_dir = Input.get_vector("left", "right", "up", "down")
	var direction = (head.transform.basis * transform.basis * Vector3(input_dir.x, 0, input_dir.y)).normalized()
	if is_on_floor():
		if direction:
			velocity.x = direction.x * speed
			velocity.z = direction.z * speed
		else:
			velocity.x = lerp(velocity.x, direction.x * speed, delta * 7.0)
			velocity.z = lerp(velocity.z, direction.z * speed, delta * 7.0)
	else:
		velocity.x = lerp(velocity.x, direction.x * speed, delta * 3.0)
		velocity.z = lerp(velocity.z, direction.z * speed, delta * 3.0)
	
	# Head bob
	t_bob += delta * velocity.length() * float(is_on_floor())
	camera.transform.origin = _headbob(t_bob)
	
	# FOV
	var velocity_clamped = clamp(velocity.length(), 0.5, SPRINT_SPEED * 2)
	var target_fov = BASE_FOV + FOV_CHANGE * velocity_clamped
	camera.fov = lerp(camera.fov, target_fov, delta * 8.0)
	
	move_and_slide()


func _headbob(time) -> Vector3:
	var pos = Vector3.ZERO
	pos.y = sin(time * BOB_FREQ) * BOB_AMP
	pos.x = cos(time * BOB_FREQ / 2) * BOB_AMP
	return pos



func _on_shoot_timer_timeout() -> void:
	can_shoot = true


func _on_death_timer_timeout() -> void:
	get_tree().reload_current_scene()
	pass # Replace with function body.
