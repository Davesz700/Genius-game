extends Node
var pause = false

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if (Input.is_action_just_pressed("esc") && pause == false):
		get_tree().paused = true
		pause = true
	elif (Input.is_action_just_pressed("esc") && pause == true):
		pause = false
		get_tree().paused = false
