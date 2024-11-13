extends CharacterBody3D

var gravity = 9.8


func _physics_process(delta: float) -> void:
	if not is_on_floor():
		velocity.y -= gravity * delta
