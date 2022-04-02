extends Node

var tower_obj = load("res://Tower.tscn")
var hbar = load("res://ui/object_info.tscn")
var placed = false
# Declare member variables here. Examples:
# var a = 2
# var b = "text"


# Called when the node enters the scene tree for the first time.
func _ready():
	Input.set_mouse_mode(Input.MOUSE_MODE_CONFINED)


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass


func _input(event):
	if event is InputEventMouseButton:
	   print("Mouse Click/Unclick at: ", event.position)
	if event.is_action_pressed("ui_cancel"):
		Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
		
	if event.is_action_pressed("click"):
		print("Clicked!")
		if Input.get_mouse_mode() == Input.MOUSE_MODE_VISIBLE:
			Input.set_mouse_mode(Input.MOUSE_MODE_CONFINED)
		elif placed == false:
			var mouse_pos = get_viewport().get_mouse_position()
			spawn_object(mouse_pos)
			
			
func spawn_object(position):
	var tower = tower_obj.instance()
	tower.set_position(Vector2(position.x -140, position.y - 200)	)
	add_child(tower)
	print("Tower: ", tower.position)
	#print("Health: ", health.position)
	
	if placed == true:
		$UI/PlacementWindow.visible = false
		#begin_level()
