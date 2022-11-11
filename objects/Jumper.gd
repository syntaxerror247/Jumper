extends KinematicBody2D

onready var animatedSprite = get_node("AnimatedSprite")
onready var camera = get_node("Camera2D")

var velocity = Vector2.ZERO

signal gameover

func _physics_process(_delta):
	apply_gravity()
	var input = Input.get_accelerometer()
#	if Input.is_action_pressed("ui_left"):
#		input.x -= 3
#	elif Input.is_action_pressed("ui_right"):
#		input.x += 3
	
	if input.x < 0.12:
		animatedSprite.flip_h=true
	elif input.x > 0.12:
		animatedSprite.flip_h= false

	velocity.x = input.x*188
	
	if position.x>720:
		position.x=0
	if position.x<0:
		position.x=720
	
# warning-ignore:return_value_discarded
	move_and_slide(velocity)


func apply_gravity():
	velocity.y += Main.gravity
	

func is_jumping():
	return velocity.y < 0


func _on_VisibilityNotifier2D_screen_exited():
	if not is_jumping():
		emit_signal("gameover")
