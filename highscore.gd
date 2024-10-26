extends Node

var main
var highest_score 
var score
const SCORE_FILE = "res://score.save"

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	loadscore()
	pass # Replace with function body.


func _process(delta: float) -> void:
	if main != null:
		score = main.score
		loadscore()
func highscore():
	if score > highest_score and score != 0:
		var file = FileAccess.open(SCORE_FILE, FileAccess.WRITE_READ)
		file.store_32(score)
func loadscore():
	var file = FileAccess.open(SCORE_FILE, FileAccess.READ)
	if FileAccess.file_exists(SCORE_FILE):
		highest_score = file.get_32()
	else:
		highest_score = 0
