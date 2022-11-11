extends Area2D

onready var animatedSprite = get_node("AnimatedSprite")

signal screen_exited


func _on_VisibilityNotifier2D_screen_exited():
	emit_signal("screen_exited")
	queue_free()




func play_animation():
	$AnimatedSprite.play()
