extends Node3D

enum{
	standing,
	running,
	attacking,
	wandering
}

var state = standing
var target
var SPEED = 5
const turnspeed = 10

@onready var eyes = $eyes
@onready var an = $AnimationPlayer
@onready var attcraycast = $attacker
@onready var shootimer = $Timer



func _on_area_3d_body_entered(body: Node3D) -> void:
	if body.is_in_group("player"):
		state = running
		target = body
		print("player found")
		
	pass # Replace with function body.
	
func _on_area_3d_body_exited(body: Node3D) -> void:
	if body.is_in_group("player"):
		state = standing
		print("playerloast")
	pass # Replace with function body.
	
func _on_hitrange_body_entered(body: Node3D) -> void:
	if body.is_in_group("player"):
		state = attacking
		shootimer.start()
	pass # Replace with function body.


func _on_hitrange_body_exited(body: Node3D) -> void:
	if body.is_in_group("player"):
		state = running
		target = body
		shootimer.stop()
	pass # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	
	match state:
		standing:
			an.play("standing")
		running:
			an.play("run")
			eyes.look_at(target.global_transform.origin, Vector3.UP)
			rotate_y(deg_to_rad(eyes.rotation.y * turnspeed))
		attacking:
			an.play("attac")
			eyes.look_at(target.global_transform.origin, Vector3.UP)
			rotate_y(deg_to_rad(eyes.rotation.y * turnspeed))
		wandering:
			an.play("run")


func _on_timer_timeout():
	if attcraycast.is_colliding():
		var hit = attcraycast.get_collider()
		if hit.is_in_group("player"):
			get_tree().call_group("player", "hurt", 10)
			print("hit")
