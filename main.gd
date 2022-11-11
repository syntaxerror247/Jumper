extends Node

var savefile = "user://playerdata.save"

var last_score = 0
var highscore = 0

var speed = 110
var gravity = 15
var max_gravity = 1000
var normal_jump_height = 9
var spring_jump_height = 20
var booster_jump_height = 50

func save_highscore():
	var f = File.new()
	f.open(savefile, File.WRITE)
	f.store_64(highscore)
	f.close()

func load_highscore():
	var f = File.new()
	if f.file_exists(savefile):
		f.open(savefile, File.READ)
		highscore = f.get_64()
		f.close()

func _ready():
	load_highscore()


