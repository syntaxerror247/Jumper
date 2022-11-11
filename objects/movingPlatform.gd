extends Path2D

onready var platform = get_node("PathFollow2D/platform")
onready var animationPlayer = get_node("AnimationPlayer")

signal screen_exited
signal body_entered

func _ready():
	set_random_starting_position()
	var n = randi()%2
	if n==1: animationPlayer.play("move2")

func set_random_starting_position():
	var i = randi()%8
	animationPlayer.seek(i)


func _on_VisibilityNotifier2D_screen_exited():
	emit_signal("screen_exited")
	queue_free()


func _on_platform_body_entered(body):
	emit_signal("body_entered",body)
