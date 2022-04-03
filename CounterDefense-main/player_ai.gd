extends KinematicBody2D


# Declare member variables here. Examples:
# var a = 2
# var b = "text"

var velocity = Vector2()
var speed = 200

# Called when the node enters the scene tree for the first time.
func _ready():
	set_process(true)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	velocity = move_and_slide(velocity)

func _input(event):
	print(event)
	velocity = Vector2() # The player's movement vector.
	if event.is_action("ui_right"):
		velocity.x += 100
	if event.is_action("ui_left"):
		velocity.x -= 100
	if event.is_action("ui_down"):
		velocity.y += 100
	if event.is_action("ui_up"):
		velocity.y -= 100
