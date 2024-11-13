extends Area3D

const explosion = preload("res://modles/explotion.tscn")
@onready var marker_3d = $Marker3D

func _explosion():
	var Explosion = explosion.instantiate()
	marker_3d.add_child(Explosion)

func _on_body_entered(body: Node3D) -> void:
		_explosion()
		#if body.is_in_group("badguy"):
			#get_tree().call_group("badguy", "_rocket_jump")
		if body.is_in_group("player"):
			get_tree().call_group("player", "hurt", 10)
			get_tree().call_group("player", "_rocket_jump")


func _on_timer_timeout() -> void:
	queue_free()
	pass # Replace with function body.
