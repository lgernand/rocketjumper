extends CharacterBody3D

@onready var nav_agent = $NavigationAgent3D
@onready var hit_box = $badguy2
@onready var marker_3d = $Marker3D
@onready var deathtimer = $deathtimer
@onready var body = $badguy2

var gravity = 9.8
const JUMP_VELOCITY = 5
var SPEED = 10
var health = 100
const bloodsplat = preload("res://modles/bloodsplater.tscn")

func _bloodsplater():
	var _blood = bloodsplat.instantiate()
	marker_3d.add_child(_blood)



func hurt(hit_points):
	if hit_points < health:
		health -= hit_points
	else:
		health = 0
	
	if health == 0:
		die()
	print("ouch")

func die():
	remove_child(body)
	set_physics_process(false)
	deathtimer.start()
	_bloodsplater()
	pass




func _physics_process(delta):
	
	
	if not is_on_floor():
		velocity.y -= gravity * delta
	
	var current_location = global_transform.origin
	var next_location = nav_agent.get_next_path_position()
	var new_velocity = (next_location - current_location).normalized() * SPEED
	
	nav_agent.set_velocity(new_velocity)
	
func update_target_location(target_location):
	nav_agent.target_position = target_location


func _on_area_3d_body_entered(body: Node3D) -> void:
	#if body.is_in_group("player"):
		#set_physics_process(true)
	#else:
		#set_physics_process(false)
	pass


func _on_area_3d_body_exited(body: Node3D) -> void:
	#if body.is_in_group("player"):
		#set_physics_process(false)
	pass


func _on_hitbox_body_entered(body: Node3D) -> void:
	pass


func _on_hitbox_area_entered(area: Area3D) -> void:
	
	if area.is_in_group("rockets"):
		hurt(25)
	elif area.is_in_group("blastzones"):
		hurt(15)
	pass # Replace with function body.


func _on_deathtimer_timeout() -> void:
	queue_free()
	pass # Replace with function body.


func _on_navigation_agent_3d_velocity_computed(safe_velocity: Vector3) -> void:
		velocity = velocity.move_toward(safe_velocity, .25)
		move_and_slide()
