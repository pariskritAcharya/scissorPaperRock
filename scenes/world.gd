extends Control


@onready var blue_hand = $"blue hand"
@onready var blue_rock = $"blue hand/Blue-rock"
@onready var blue_scissor = $"blue hand/Blue-scissor"
@onready var blue_paper = $"blue hand/Blue-paper"
@onready var label = $CanvasLayer/Label
@onready var red_hand = $"red hand"
@onready var win = $CanvasLayer/win
@onready var red_rock = $"red hand/Red-rock"
@onready var red_scissor = $"red hand/Red-scissor"
@onready var red_paper = $"red hand/Red-paper"

var total_time = Global.total_time
var time = total_time
var total_scores=Global.total_scores

var options_enabled = true

func _ready():
	Global.matches+=1
	$"CanvasLayer/total matches".text ="Matches: "+str(Global.matches)
	label.text=str(total_time)
	label.visible=true
	if Global.blue_score==total_scores or Global.red_score==total_scores:
		get_tree().change_scene_to_file("res://scenes/over_Scene.tscn")
	red_rock.visible=true
	Global.red_option="rock"
	red_paper.visible=false
	red_scissor.visible=false
	if Global.blue_option=="rock":
		blue_rock.visible=true
		blue_paper.visible=false
		blue_scissor.visible=false
	elif Global.blue_option=="paper":
		blue_rock.visible=false
		blue_paper.visible=true
		blue_scissor.visible=false
	else:
		blue_rock.visible=false
		blue_paper.visible=false
		blue_scissor.visible=true
	time=total_time
	win.visible=false
	
	label.visible=true
	
	options_enabled=true
	$CanvasLayer/win/ColorRect2.modulate=Color("#ab1cf582")
	$"CanvasLayer/blue score".text = str(Global.blue_score)
	$"CanvasLayer/red score".text = str(Global.red_score)
	
func _input(event):
	if Input.is_action_pressed("exit"):
		get_tree().change_scene_to_file("res://scenes/game_settings.tscn")
	if Input.is_action_pressed("rock"):
		_on_rock_pressed()
	elif Input.is_action_pressed("paper"):
		_on_paper_pressed()
	elif Input.is_action_pressed("scissors"):
		_on_scissor_pressed()

func _on_paper_pressed():
	if options_enabled:
		$click.play()
		Global.blue_option="paper"
		blue_rock.visible=false
		blue_paper.visible=true
		blue_scissor.visible=false

func _on_rock_pressed():
	if options_enabled:
		$click.play()
		blue_rock.visible=true
		blue_paper.visible=false
		blue_scissor.visible=false
		Global.blue_option="rock"

func _on_scissor_pressed():
	if options_enabled:
		$click.play()
		blue_rock.visible=false
		blue_paper.visible=false
		blue_scissor.visible=true
		Global.blue_option="scissors"

func _on_timer_timeout():
	time-=1
	if time==0:
		red_hand.choose()
		options_enabled=false
		label.visible=false
		await wait(0.5)
		test()
		await wait(3.0)  # Wait for 3 seconds
		_ready()
	else:
		label.text=str(time)

func wait(duration: float) -> void:
	await get_tree().create_timer(duration, false, false, true).timeout


func test():
	Global.blue_recent_options.append(Global.blue_option)
	Global.red_recent_options.append(Global.red_option)
	if Global.blue_option==Global.red_option:
		win.visible=true
		win.text = "Draw"
		update_win_history("d") # Append a draw
		Global.blue_win_history_full.append("draw")
		$CanvasLayer/win/ColorRect2.modulate=Color("#00b170b8")
		$draw.play()
	elif Global.blue_option=="rock" and Global.red_option=="scissors":
		$rock.play()
		$win.play()
		win.visible=true
		win.text = "blue wins"
		update_win_history("w") # Append a win
		Global.blue_win_history_full.append("win")
		Global.blue_score +=1
	elif Global.blue_option=="paper" and Global.red_option=="rock":
		win.visible=true
		win.text = "blue wins"
		update_win_history("w") # Append a win
		Global.blue_win_history_full.append("win")
		Global.blue_score +=1
		$paper.play()
		$win.play()
	elif Global.blue_option=="scissors" and Global.red_option=="paper":
		win.visible=true
		win.text = "blue wins"
		update_win_history("w") # Append a win
		Global.blue_win_history_full.append("win")
		Global.blue_score +=1
		$scissor.play()
		$win.play()
	else:
		win.visible=true
		win.text = "red wins"
		update_win_history("l") # Append a loose
		Global.blue_win_history_full.append("loose")
		Global.red_score +=1
		$CanvasLayer/win/ColorRect2.modulate=Color("#ff2d1ccc")
		$loose.play()
	
	if Global.blue_option=="scissors" and Global.red_option=="rock":
		$rock.play()
	elif Global.blue_option=="rock" and Global.red_option=="paper":
		$paper.play()
	elif Global.blue_option=="paper" and Global.red_option=="scissors":
		$scissor.play()
		
	$"CanvasLayer/blue score".text = str(Global.blue_score)
	$"CanvasLayer/red score".text = str(Global.red_score)



func update_win_history(outcome: String) -> void:
	# Append the outcome to the global win history array
	Global.blue_win_history.append(outcome)

func _on_setting_pressed():
	get_tree().change_scene_to_file("res://scenes/game_settings.tscn")



