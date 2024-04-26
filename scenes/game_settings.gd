extends Control


@onready var time = $CenterContainer/VBoxContainer/time
@onready var difficulty = $CenterContainer/VBoxContainer/difficulty
@onready var total_score = $"CenterContainer/VBoxContainer/HBoxContainer/total score"








#when ready displays current score to win 
func _ready():
	total_score.placeholder_text=str(Global.total_scores)
	difficulty.text=Global.difficulty
	time.text=str(Global.total_time)+" seconds"

#change score and reset level
func _get_total_scores():
	var total_scores=int(total_score.text)
	if total_scores>0:
		Global.total_scores=total_scores

func _on_quit_pressed():
	get_tree().quit()




func _on_time_pressed():
	var timearr=["3","5"]
	Global.total_time=int(change_value(timearr,str(Global.total_time)))
	time.text=str(Global.total_time)+" seconds"

func _on_difficulty_pressed():
	var difficulties=["easy","medium","AI (beta)","asian"]
	Global.difficulty=change_value(difficulties,Global.difficulty)
	difficulty.text=Global.difficulty

func _on_start_game_pressed():
	_get_total_scores()
	get_tree().change_scene_to_file("res://scenes/world.tscn")
	Global.reload()



#extra functions

#function to change to next value in an array

func change_value(array: Array, current_value: String) -> String:
	var index = array.find(current_value)
	if index == -1:
		return current_value # If current_value is not in the array, return it as is
	
	index = (index + 1) % array.size() # Calculate the next index, wrapping around if necessary
	return array[index]


func _on_results_pressed():
	get_tree().change_scene_to_file("res://scenes/result.tscn")
