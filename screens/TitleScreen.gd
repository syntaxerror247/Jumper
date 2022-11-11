extends Control

func _on_start_button_pressed():
# warning-ignore:return_value_discarded
	get_tree().change_scene("res://screens/Game.tscn")


func _on_start_body_entered(body):
	body.velocity.y = -900
	

