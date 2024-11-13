extends CenterContainer

@export var DOT_RADIUS : float = 5.0
@export var SMALLER_DOT_RADIUS : float = 2.5
@export var SMALLEST_DOT_RADIUS : float = 1.5
@export var DOT_COLOR : Color = Color.WHITE

func _draw():
	draw_circle(Vector2(0,35), SMALLEST_DOT_RADIUS, DOT_COLOR)
	draw_circle(Vector2(0,20), SMALLER_DOT_RADIUS, DOT_COLOR)
	draw_circle(Vector2(-20,20), SMALLER_DOT_RADIUS, DOT_COLOR)
	draw_circle(Vector2(0,0), DOT_RADIUS, DOT_COLOR)

func _ready():
	queue_redraw()
