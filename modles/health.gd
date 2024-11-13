extends Node3D


func _on_area_3d_body_entered(body: Node3D) -> void:
	if body.is_in_group("player"):
		get_tree().call_group("player", "restore", 50)
		queue_free()
