extends Node


func _ready():
	$HUD.update_score(Main.last_score)


func _on_Button_pressed():
	get_tree().change_scene("res://screens/Game.tscn")
