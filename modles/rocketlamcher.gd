extends Node3D

@onready var anim = $lancherAnimation
@onready var timer = $Timer
@onready var marker_3d = $Marker3D
var can_shoot : bool = true
const muzzle_flash = preload("res://modles/muzzleflash.tscn")

func _muzzleflash():
	marker_3d.set_visible(true)
	var muzzleflash = muzzle_flash.instantiate()
	marker_3d.add_child(muzzleflash)

func _play():
	timer.start()
	can_shoot = false
	anim.play("CylinderAction")
	
	
func _process(delta):
	if Input.is_action_just_pressed("fire") and can_shoot:
		_muzzleflash()
		_play()


func _on_timer_timeout() -> void:
	marker_3d.set_visible(false)
	can_shoot = true
	pass # Replace with function body.
