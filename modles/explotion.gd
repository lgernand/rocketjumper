extends Node3D

@onready var anim = $AnimationPlayer
@onready var timer = $Timer

func _ready():
	timer.start()
	anim.play("boom")
	pass
	
	


func _on_timer_timeout() -> void:
	queue_free()
	pass # Replace with function body.
