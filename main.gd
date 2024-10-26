extends Node2D
@onready var red = $GridContainer/Red
@onready var green = $GridContainer/Green
@onready var yellow = $GridContainer/Yellow
@onready var blue = $GridContainer/Blue

const colors = ['r','g','y','b']
const SCORE_FILE = "res://score.save"
var showing
var bonus_score = 60
var wrong = false
var sequence = []
var p_input = []
var max_colors = 1
var score = 0
var highest_score
var time = 0


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	Highscore.main = self
	highest_score = Highscore.highest_score
	showing = true
	$log.text = "Pay attention"
	await _generate_sequence()
	showing = false
	$highestscore.text = "Highest score:
		"+ str(highest_score)
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	$Score.text = "Score:
		" + str(score)
	$highestscore.text = "Highest score:
		"+ str(highest_score)
	if Input.is_action_just_pressed("teste"):
		_shine(red)
	if p_input.size() == max_colors:
		if p_input == sequence:
			max_colors +=1
			p_input = []
			bonus_score += 2
			if time != 0:
				score += 10 + round(bonus_score/time)
			_ace()
			await _ace()
			showing = true
			$log.text = "Pay attention"
			await _generate_sequence()
			showing = false  
			
	if p_input.size() >= 1:
		for i in range(p_input.size()):
			if p_input[i] != sequence[i]:
				p_input = []
				wrong = true
				_mistake()
				await  _mistake()
				Highscore.highscore()
				$Timer.start(1.0)
				await $Timer.timeout
				wrong = false
				_normal_colors()
				await _show_sequence()
				get_tree().reload_current_scene()
	
	
	pass

func _generate_sequence():
	time = 0
	$cronometer.start()
	
	sequence.append(colors.pick_random())
	print(sequence)
	_show_sequence()
	
func _show_sequence():
	var i = 0
	while  i < sequence.size():
		$Timer.start(0.5)
		await  $Timer.timeout
		if sequence[i] == "r":
			await _shine(red)
			i+=1
		elif sequence[i] == "g":
			await _shine(green)
			i+=1
		elif sequence[i] == "y":
			await _shine(yellow)
			i+=1
		else:
			await _shine(blue)
			i +=1
			
func _shine(color):
	if color == yellow:
		$yellowS.play()
		yellow.self_modulate = Color(1,1,0,1)
		$Timer.start()
		await $Timer.timeout
		if wrong == false:
			yellow.self_modulate = Color(0.5,0.5,0,1)
	elif color == blue:
		$blueS.play()
		$GridContainer/Blue.self_modulate = Color(0,0,1,1)
		$Timer.start()
		await $Timer.timeout
		if wrong == false:
			$GridContainer/Blue.self_modulate = Color(0,0,0.5,1)
	elif  color == red:
		$redS.play()
		$GridContainer/Red.self_modulate = Color(1,0,0,1)
		$Timer.start()
		await $Timer.timeout
		if wrong == false:
			$GridContainer/Red.self_modulate = Color(0.5,0,0,1)
	elif color == green:
		$greenS.play()
		$GridContainer/Green.self_modulate = Color(0,1,0,1)
		$Timer.start()
		await $Timer.timeout
		if wrong == false:
			$GridContainer/Green.self_modulate = Color(0,0.5,0,1)
		
	
func _mistake():
	showing = true
	green.self_modulate = Color(100,0,0,1)
	blue.self_modulate = Color(100,0,0,1)
	yellow.self_modulate = Color(100,0,0,1)
	red.self_modulate = Color(100,0,0,1)
	$log.text = "Wrong. This was the right sequence"
	$game_over.play()
func _ace():
	$log.text = "Right"
	red.self_modulate = Color(0,100,0,1)
	blue.self_modulate = Color(0,100,0,1)
	green.self_modulate = Color(0,100,0,1)
	yellow.self_modulate = Color(0,100,0,1)
	$ACE.play()
	$Timer.start(1.0)
	await $Timer.timeout
	_normal_colors()
func _normal_colors():
	red.self_modulate = Color(0.5,0,0,1)
	blue.self_modulate = Color(0,0,0.5,1)
	yellow.self_modulate = Color(0.5,0.5,0,1)
	green.self_modulate = Color(0,0.5,0,1)

func _on_red_pressed() -> void:
	if !showing:
		p_input.append('r')
		_shine(red)
		print(p_input)
	pass # Replace with function body.


func _on_green_pressed() -> void:
	if !showing:
		p_input.append('g')
		_shine(green)
		print(p_input)
	pass # Replace with function body.


func _on_yellow_pressed() -> void:
	if !showing:
		p_input.append('y')
		_shine(yellow)
		print(p_input)
	pass # Replace with function body.


func _on_blue_pressed() -> void:
	if !showing:
		p_input.append('b')
		_shine(blue)
		print(p_input)
	pass # Replace with function body.


func _on_cronometer_timeout() -> void:
	time += 1
