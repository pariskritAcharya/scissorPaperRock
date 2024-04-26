extends Control

@onready var player = $ScrollContainer/HBoxContainer/player
@onready var computer = $ScrollContainer/HBoxContainer/computer
@onready var win_loose = $"ScrollContainer/HBoxContainer/win loose"
@onready var results = $results




func _ready():
	display_array_in_lines(Global.blue_recent_options,player,"Player:")
	display_array_in_lines(Global.red_recent_options,computer,"Computer:")
	display_array_in_lines(Global.blue_win_history_full,win_loose,"Wins:")
	count_and_display_results(Global.blue_win_history,results)

func _on_button_pressed():
	get_tree().change_scene_to_file("res://scenes/game_settings.tscn")



func display_array_in_lines(arr: Array, label,title:String):
	label.text=title+"\n"
	var info_str = ""
	for element in arr:
		info_str += element + "\n"
	label.text += info_str


func count_and_display_results(player_win_loss: Array, label):
	var win_count = 0
	var loss_count = 0
	var draw_count = 0

	# Count the occurrences of wins, losses, and draws
	if player_win_loss.size()>0:
		for result in player_win_loss:
			if result == "w":
				win_count += 1
			elif result == "l":
				loss_count += 1
			elif result == "d":
				draw_count += 1

	# Display the counts in the label
	label.text = "Wins: " + str(win_count) + "\nLosses: " + str(loss_count) + "\nDraws: " + str(draw_count)
