extends Node

var debug = true
var musicOn = true
var masterVol = -10
# Called when the node enters the scene tree for the first time.
func _ready():
	var dirMusic = "res://Meow/Music/Reg"
	var player = AudioStreamPlayer.new()
	self.add_child(player)
	player.volume_db = masterVol
	var playlistFiles = dir_counter(dirMusic,".import")
	var playlistPaths = assetsPaths(playlistFiles,"path=\"")
	while (musicOn):
		player.stream = load(playlistPaths[random(playlistPaths.size())-1])
		player.play()
		yield(player, "finished")
		
func assetsPaths(imports,find):
	var file = File.new()
	var array = []
	for i in imports:
		if debug: print("i="+i)
		file.open(i,File.READ)
		while (file.is_open()):
			var line = file.get_line()
			if line.left(find.length()) == find:
				if debug: print("found:" + line.substr(find.length(),line.length()-find.length()-1))
				array.append(line.substr(find.length(),line.length()-find.length()-1))
				file.close()
	return array

func random(count):
	var randSeed = RandomNumberGenerator.new()
	randSeed.randomize()
	var randNum = randSeed.randi_range (1, count)
	if debug: print("randNum = " + str(randNum))
	return randNum

func dir_counter(path,ext):
	var array = []
	var dir = Directory.new()
	if dir.open(path) == OK:
		dir.list_dir_begin()
		var file_name = dir.get_next()
		while file_name != "":
			if dir.current_is_dir():
				if debug: print("Found directory: " + file_name)
			elif file_name.right(file_name.length()-ext.length()) == ext:
				array.append(path+"/"+file_name)
				if debug: print("Found file: " + file_name)
			file_name = dir.get_next()
	else:
		print("An error occurred when trying to access the path. Returning : 0")
		return []
	if debug: print("dircounter return : " + str(array.size()))
	return array

# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
