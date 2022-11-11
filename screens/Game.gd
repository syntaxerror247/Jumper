extends Node

onready var jumper = $Jumper
onready var hud = $HUD
onready var platform_container = $platforms
onready var soundEffects_container = $soundEffects_container

var soundEffects = {}

var score = 0
var score_multiplyer = 1


var normal_platform = preload("res://objects/normalPlatform.tscn")
var spring_platform = preload("res://objects/springPlatform.tscn")
var moving_platform = preload("res://objects/movingPlatform.tscn")
var bursting_platform = preload("res://objects/burstingPlatform.tscn")
var booster_platform = preload("res://objects/boosterPlatform.tscn")
var moving_booster_platform = preload("res://objects/moving_boosterPlatform.tscn")
var living_bomb = preload("res://objects/livingBomb.tscn")

var last_y_pos = null #to spawn platforms
var created_highscore = false

var last_platform_y_pos = null
var current_platform_y_pos = null

var jumper_died = false



func load_all_sounds():
	soundEffects = {
		"jump": soundEffects_container.get_node("jump")
	}

func _ready():
	randomize()
	load_all_sounds()
	last_y_pos = $platforms/normalPlatform.global_position.y
	current_platform_y_pos = last_y_pos
	last_platform_y_pos = last_y_pos
	while last_y_pos > -150:
		create_platform()

func create_platform():
#	var types_list = [living_bomb,normal_platform,normal_platform,normal_platform,normal_platform,spring_platform,spring_platform,moving_platform,moving_platform,bursting_platform,bursting_platform,booster_platform]
#	types_list.shuffle()
#	var type = types_list[0].instance()
	var type = choose_platform_type()
	match type.name:
		"normalPlatform": spawn_normal_platform(type)
		"springPlatform": spawn_spring_platform(type)
		"movingPlatform": spawn_moving_platform(type)
		"burstingPlatform": spawn_bursting_platform(type)
		"boosterPlatform":
			if can_spawn_moving_booster():
				spawn_moving_booster_platform(moving_booster_platform.instance())
			else:
				spawn_booster_platform(type)
		"livingBomb": spawn_living_bomb(type)

func choose_platform_type():
	var i = randi()%100
	if i < 50: return normal_platform.instance()
	elif i < 60: return spring_platform.instance()
	elif i < 70: return moving_platform.instance()
	elif i < 80: return bursting_platform.instance()
	elif i < 90: return booster_platform.instance()
	elif i < 100:
		if platform_container.has_node("livingBomb"):
			return normal_platform.instance()
		return living_bomb.instance()

func can_spawn_moving_booster():
	var i = randi()%2
	if i == 1:
		return true
	else:
		return false

func spawn_normal_platform(platform):
	var x = rand_range(0+30,720-30) # 30 is approx width/2 of normal_platform.png
	var y = -130
	y += last_y_pos
	last_y_pos = y
	platform.global_position = Vector2(x,y)
	platform.connect("body_entered",self,"jumper_on_normal_platform")
	platform.connect("screen_exited",self,"_on_platform_screen_exited")
	platform_container.add_child(platform)

func spawn_spring_platform(platform):
	var x = rand_range(0+26,720-26) # 26 is approx width/2 of normal_platform.png
	var y = -135
	y += last_y_pos
	last_y_pos = y
	platform.global_position = Vector2(x,y)
	platform.connect("body_entered",self,"jumper_on_spring_platform",[platform])
	platform.connect("screen_exited",self,"_on_platform_screen_exited")
	platform_container.add_child(platform)

func spawn_moving_platform(path2d):
	var x = 20
	var y = -135
	y += last_y_pos
	last_y_pos = y
	path2d.global_position = Vector2(x,y)
	platform_container.add_child(path2d)
	path2d.connect("body_entered",self,"jumper_on_moving_platform")
	path2d.connect("screen_exited",self,"_on_platform_screen_exited")
	
func spawn_bursting_platform(platform):
	var x = rand_range(0+40,720-40) # 40 is approx width/2 of normal_platform.png
	var y = -135
	y += last_y_pos
	last_y_pos = y
	platform.global_position = Vector2(x,y)
	platform.connect("body_entered",self,"jumper_on_bursting_platform",[platform])
	platform.connect("screen_exited",self,"_on_platform_screen_exited")
	platform_container.add_child(platform)

func spawn_booster_platform(platform):
	var x = rand_range(0+58,720-58) # 58 is approx width of normal_platform.png
	var y = -150
	y += last_y_pos
	last_y_pos = y
	platform.global_position = Vector2(x,y)
	platform.connect("body_entered",self,"jumper_on_booster_platform")
	platform.connect("screen_exited",self,"_on_platform_screen_exited")
	platform_container.add_child(platform)

func spawn_moving_booster_platform(path2d):
	var x = 20
	var y = -150
	y += last_y_pos
	last_y_pos = y
	path2d.global_position = Vector2(x,y)
	platform_container.add_child(path2d)
	path2d.connect("body_entered",self,"jumper_on_booster_platform")
	path2d.connect("screen_exited",self,"_on_platform_screen_exited")


func spawn_living_bomb(bomb):
	var x = 10
	var y = -50
	y += last_y_pos
	last_y_pos = y
	bomb.global_position = Vector2(x,y)
	platform_container.add_child(bomb)
	bomb.connect("body_entered",self,"jumper_on_touching_bomb")
	bomb.connect("screen_exited",self,"_on_platform_screen_exited")


func jumper_on_normal_platform(body):
	if jumper.is_jumping(): return
	update_positions(body)
	jumper.velocity.y = - Main.normal_jump_height * Main.speed
	Input.vibrate_handheld(40)
	soundEffects.jump.play(11.21)
	yield(get_tree().create_timer(0.2),"timeout")
	soundEffects.jump.stop()

func jumper_on_spring_platform(body,platform):
	if jumper.is_jumping(): return
	update_positions(body)
	jumper.velocity.y = -Main.spring_jump_height * Main.speed
	platform.play_animation()
	Input.vibrate_handheld(40)
	soundEffects.jump.play(11.21)
	yield(get_tree().create_timer(0.2),"timeout")
	soundEffects.jump.stop()
	
	score_multiplyer = 2

func jumper_on_moving_platform(body):
	if jumper.is_jumping(): return
	update_positions(body)
	jumper.velocity.y = - Main.normal_jump_height * Main.speed
	Input.vibrate_handheld(40)
	soundEffects.jump.play(11.21)
	yield(get_tree().create_timer(0.2),"timeout")
	soundEffects.jump.stop()

func jumper_on_bursting_platform(body,platform):
	if jumper.is_jumping(): return
	update_positions(body)
	jumper.velocity.y = -Main.normal_jump_height * Main.speed
	platform.play_animation()
	Input.vibrate_handheld(60)
	soundEffects.jump.play(11.21)
	yield(get_tree().create_timer(0.2),"timeout")
	soundEffects.jump.stop()
	yield(platform.animatedSprite,"animation_finished")
	platform.queue_free()

func jumper_on_booster_platform(body):
	if jumper.is_jumping(): return
	update_positions(body)
	jumper.animatedSprite.play("booster")
	jumper.velocity.y = - Main.booster_jump_height * Main.speed
	
	Input.vibrate_handheld(40)
	score_multiplyer = 3
	soundEffects.jump.play(11.21)
	yield(get_tree().create_timer(0.2),"timeout")
	soundEffects.jump.stop()
	
	yield(get_tree().create_timer(2),"timeout")
	jumper.animatedSprite.play("default")
	
func jumper_on_touching_bomb(body):
	if score_multiplyer >1: return
	Input.vibrate_handheld(150)
	get_tree().paused = true
	yield(get_tree().create_timer(0.2),"timeout")
	get_tree().paused = false
	get_tree().change_scene("res://screens/GameOverScreen.tscn")

func update_positions(platform):
	last_platform_y_pos = current_platform_y_pos
	current_platform_y_pos = platform.global_position.y

func update_score():
	score += score_multiplyer
	hud.update_score(score)
	if not created_highscore:
		if score > Main.highscore:
			Main.highscore = score
			hud.update_highscore(score)
			print("new highscore")
			created_highscore = true
	else:
		Main.highscore = score
		hud.update_highscore(score)

func _on_platform_screen_exited():
	var p_count = platform_container.get_child_count()
	while p_count < 14:
		p_count+=1
		create_platform()

func gameover():
	Main.last_score = score
	jumper.camera.drag_margin_v_enabled = false
	jumper.animatedSprite.play("fall")
	yield(get_tree().create_timer(1),"timeout")
	jumper.camera.smoothing_enabled = true
	jumper.velocity.y += 3000
	Main.save_highscore()
	yield(get_tree().create_timer(0.15),"timeout")
	get_tree().change_scene("res://screens/GameOverScreen.tscn")

func _physics_process(_delta):
	#print(platform_container.get_child_count())
	if jumper_died:
		jumper.velocity = Vector2.ZERO
		return
		
	if jumper.is_jumping():
		if (current_platform_y_pos < last_platform_y_pos):
			update_score()
	else:
		score_multiplyer = 1

