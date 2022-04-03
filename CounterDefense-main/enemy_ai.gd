extends Node2D

var speed = 8
var initial_pos = self.get_position()

func _ready():
	set_process(true)

func _process(delta):
	var move = Vector2()
	self.position.x += speed
	var screen = get_parent().get_viewport_rect()
	if self.position.x >= get_viewport_rect().size.x:
		self.position = initial_pos
		#print(self.position.x)
	
