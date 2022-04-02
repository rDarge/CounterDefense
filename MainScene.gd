extends Node2D
# Declare member variables here. Examples:
# var a = 2
# var b = "text"
var client_id;
var counters;
var elapsedSinceUpdate = 0;

signal fire(old_value, new_value)
signal water(old_value, new_value)
signal earth(old_value, new_value)
signal air(old_value, new_value)
signal aether(old_value, new_value)

func updateText(old_value, new_value, label, prefix):
	print("updating text!!")
	print(label);
	label.text = prefix + str(new_value)

func updateCounters(result):
	print("updating counters with ", result)
	if(result.fire != counters.fire):
		print("fire is updated")
		var old = counters.fire
		counters.fire = result.fire
		emit_signal("fire", old, result.fire)
	if(result.water != counters.water):
		var old = counters.water
		counters.water = result.water
		emit_signal("water", old, result.water)
	if(result.earth != counters.earth):
		var old = counters.earth
		counters.earth = result.earth
		emit_signal("earth", old, result.earth)
	if(result.air != counters.air):
		var old = counters.air
		counters.air = result.air
		emit_signal("air", old, result.air)
	if(result.aether != counters.aether):
		var old = counters.aether
		counters.aether = result.aether
		emit_signal("aether", old, result.aether)

func _on_request_completed(result, response_code, headers, body):
	print("about to parse response")
	print(result)
	print(response_code)
	var json = JSON.parse(body.get_string_from_utf8())
	client_id = json.result.clientId;
	print(json.result)

func _on_get_counters(result, response_code, headers, body, request):
	print("about to parse counter response")
	print(result)
	print(response_code)
	var json = JSON.parse(body.get_string_from_utf8())
	#print(json.result.fire)
	if("result" in json.result && "fire" in json.result.result):
		print("fire is in json.result")
		updateCounters(json.result.result)
	request.queue_free()
	
func getCounters(): 
	print("getting counters")
	var request = HTTPRequest.new();
	$requests.add_child(request);
	request.connect("request_completed", self, "_on_get_counters", [request])
	var query = "{\"clientId\": \""+client_id+"\",\"command\": \"getCounters\"}";
	var headers = ["Content-Type: application/json"]
	print(query)
	var result = request.request("http://127.0.0.1:3002/rpc", headers, false, HTTPClient.METHOD_POST, query);
	if(result != OK):
		print("not okay,")
		print(result)

# Called when the node enters the scene tree for the first time.
func _ready():
	Input.set_mouse_mode(Input.MOUSE_MODE_CONFINED)
	$CounterLabel.text = "this is updated from a script";
	
	$HTTPRequest.connect("request_completed", self, "_on_request_completed")
	$GetCountersButton.connect("pressed", self, "getCounters")
	connect("fire", self, "updateText", [$fireLabel, "Fire: "])
	connect("water", self, "updateText", [$waterLabel, "Water: "])
	connect("earth", self, "updateText", [$earthLabel, "Earth: "])
	connect("air", self, "updateText", [$airLabel, "Air: "])
	connect("aether", self, "updateText", [$aetherLabel, "Aether: "])
	
	counters = {
		"fire": 0,
		"water": 0,
		"earth": 0,
		"air": 0,
		"aether": 0	
	};

	
	var query = "{\"command\": \"register\"}";
	var headers = ["Content-Type: application/json"]
	var result = $HTTPRequest.request("http://127.0.0.1:3002/rpc", headers, false, HTTPClient.METHOD_POST, query);
	#var result = $HTTPRequest.request("http://www.mocky.io/v2/5185415ba171ea3a00704eed")
	if(result != OK):
		print("not okay " +result);
	pass # Replace with function body.

	
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	elapsedSinceUpdate += delta;
	if(elapsedSinceUpdate > 2):
		getCounters();
		elapsedSinceUpdate = 0;
	pass
	
var tower_obj = load("res://Tower.tscn")
var hbar = load("res://ui/object_info.tscn")
var placed = false
# Declare member variables here. Examples:
# var a = 2
# var b = "text"


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

