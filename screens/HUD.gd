extends CanvasLayer

onready var score_label = get_node("MarginContainer/VBoxContainer/HBoxContainer/score")
onready var highscore_label = get_node("MarginContainer/VBoxContainer/HBoxContainer/highscore")
func _ready():
	update_highscore(Main.highscore)
	
func update_score(score):
	score_label.text = str(score)

func update_highscore(highscore):
	var pretext = "HI:"
	highscore_label.text = pretext+str(highscore)
