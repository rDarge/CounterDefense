extends Node

var debug = true
var musicOn = true
var masterVol = -10
# Called when the node enters the scene tree for the first time.
func _ready():
	var dirMusic = "res://Meow/Music/Reg/"
	#dir_contents(dirMusic)
	var player = AudioStreamPlayer.new()
	self.add_child(player)
	player.volume_db = masterVol
	while (musicOn):
		player.stream = load(dirMusic+"/"+get_audio(dirMusic,random(dir_counter(dirMusic))))
		player.play()
		yield(player, "finished")

func random(count):
	var randSeed = RandomNumberGenerator.new()
	randSeed.randomize()
	var randNum = randSeed.randi_range (1, count)
	if debug: print("randNum = " + str(randNum))
	return randNum

func dir_counter(path):
	var omit = ".import"
	var i = 0
	var dir = Directory.new()
	if dir.open(path) == OK:
		dir.list_dir_begin()
		var file_name = dir.get_next()
		while file_name != "":
			if dir.current_is_dir():
				if debug: print("Found directory: " + file_name)
			elif file_name.right(file_name.length()-omit.length()) != omit:
				i = i + 1
				if debug: print("Found file: " + file_name)
			file_name = dir.get_next()
	else:
		print("An error occurred when trying to access the path. Returning : 0")
		return 0
	if debug: print("dircounter return : " + str(i))
	return i

func dir_contents(path):
	var omit = ".import"
	var dir = Directory.new()
	if dir.open(path) == OK:
		dir.list_dir_begin()
		var file_name = dir.get_next()
		while file_name != "":
			if dir.current_is_dir():
				if debug: print("Found directory: " + file_name)
			elif file_name.right(file_name.length()-omit.length()) != omit:
				if debug: print("Found file: " + file_name)
			file_name = dir.get_next()
	else:
		print("An error occurred when trying to access the path.")

func get_audio(path, i):
	var omit = ".import"
	var x = 0
	var dir = Directory.new()
	if dir.open(path) == OK:
		dir.list_dir_begin()
		var file_name = dir.get_next()
		while file_name != "":
			if dir.current_is_dir():
				if debug: print("Found directory: " + file_name)
			elif file_name.right(file_name.length()-omit.length()) != omit:
				x = x + 1
				if debug: print("Found file: " + file_name)
				if (x == i):
					if debug: print("Returning " + file_name)
					return file_name
			file_name = dir.get_next()
	else:
		print("An error occurred when trying to access the path.")
# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
