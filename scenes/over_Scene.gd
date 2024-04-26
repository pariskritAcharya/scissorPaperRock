extends Control


# Called when the node enters the scene tree for the first time.
func _ready():
	$CenterContainer/VBoxContainer/difficulty.text="difficulty: "+Global.difficulty
	$CenterContainer/VBoxContainer/matches.text = "Matches:"+str(Global.matches-1)
	$CenterContainer/VBoxContainer/blueScore.text="Blue Score: "+str(Global.blue_score)
	$CenterContainer/VBoxContainer/RedScore.text="Red Score: "+str(Global.red_score)
	if Global.blue_score>Global.red_score:
		$CenterContainer/VBoxContainer/Label.text="Blue wins!!!"
		$ColorRect.modulate=Color("#1f8eff")
		$"final win".play()
	else:
		$CenterContainer/VBoxContainer/Label.text="Red wins!!!"
		$ColorRect.modulate=Color("#ef4141")
		$"final loose".play()
	Global.reload()
	

		

func _on_reload_pressed():
	$click.play()
	get_tree().change_scene_to_file("res://scenes/world.tscn")


func _on_settings_pressed():
	get_tree().change_scene_to_file("res://scenes/game_settings.tscn")
