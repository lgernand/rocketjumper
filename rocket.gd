extends Area3D

@export var speed = 50
@export var damage = 50
const blast_zone = preload("res://modles/blastzone.tscn")
@onready var marker_3d = $Marker3D
@onready var timer = $Timer
var dir = Vector3()
@onready var hit_box = $CollisionShape3D
const backup_rocket = preload("res://modles/rocket.tscn")
@onready var timer2 = $Timer2
@onready var rocket = $rocket
@onready var collshape = $CollisionShape3D
@onready var prticals = $smoke

func _ready():
	set_as_top_level(true)

func _blast_zone():
	timer.start()
	var blastzone = blast_zone.instantiate()
	marker_3d.add_child(blastzone)

func _dud():
	timer2.start()
	remove_child(prticals)
	remove_child(collshape)
	remove_child(rocket)
	var backup = backup_rocket.instantiate()
	marker_3d.add_child(backup)
	print ("poof")

func _process(delta):
	
	position -= transform.basis.x * speed * delta
	
	#var dir = get_tree().get_first_node_in_group("player").global_transform_basis.z.normalized()
	#global_position += dir * speed * delta
	pass


func _on_body_entered(body: Node3D) -> void:
	set_process(false)
	
	if body.is_in_group("badguy"):
		#get_tree().call_group("badguy", "hurt", 35)
		_blast_zone()
	elif body.is_in_group("player"):
		_dud()
		pass
	else:
		_blast_zone()


func _on_timer_timeout() -> void:
	queue_free()
	pass # Replace with function body.


func _on_timer_2_timeout() -> void:
	queue_free()
	pass # Replace with function body.
