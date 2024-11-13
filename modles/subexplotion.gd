extends Node

@onready var anim = $subAnimationPlayer
@onready var timer = $Timer

func _ready():
	anim.play("boom")
	pass

func _on_timer_timeout() -> void:
	queue_free()
	pass # Replace with function body.
