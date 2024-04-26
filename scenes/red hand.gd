extends Node2D

@onready var red_rock = $"Red-rock"
@onready var red_scissor = $"Red-scissor"
@onready var red_paper = $"Red-paper"


enum Choice { ROCK, PAPER, SCISSORS }


func _ready():
	red_paper.visible=false
	red_rock.visible=true
	red_scissor.visible=false
	

	
func choose():
	var choice
	if Global.difficulty=="easy":
		choice=easy()
	elif  Global.difficulty=="medium":
		choice=medium()
	elif  Global.difficulty=="AI (beta)":
		choice=generate_ai_choice(Global.blue_recent_options,Global.blue_win_history)
	else:
		choice=asian()
		
		
	change_sprite(choice)
	
	
func change_sprite(choice:int):
	if choice==0:
		red_paper.visible=false
		red_rock.visible=true
		red_scissor.visible=false
		Global.red_option="rock"
	elif choice==1:
		red_paper.visible=true
		red_rock.visible=false
		red_scissor.visible=false
		Global.red_option="paper"
	else:
		red_paper.visible=false
		red_rock.visible=false
		red_scissor.visible=true
		Global.red_option="scissors"
		


#game modes  rock=0 paper=1 scissor=2
func medium():
	randomize()
	return randi()%3
	
func asian():
	if Global.blue_option=="rock":
		return 1
	elif Global.blue_option=="paper":
		return 2
	else:
		return 0
		
func easy():
	if Global.blue_option=="rock":
		return generate_random_except(1,0,2)
	elif Global.blue_option=="paper":
		return generate_random_except(2,0,2)
	else:
		return generate_random_except(0,0,2)






# Function to generate the AI's choice based on player's recent choices
func generate_ai_choice(player_options: Array, win_loss_history: Array) -> int:
	var last_choice = -1

	# Step 1: Check frequency in last 3 previous steps by player
	if player_options.size() >= 3:
		var last_three_choices = slice_array(player_options, player_options.size() - 3, player_options.size())
		var choice_counts = [0, 0, 0]
		for choice_str in last_three_choices:
			var choice_int = choice_string_to_int(choice_str)
			if choice_int != -1:
				choice_counts[choice_int] += 1

		# Step 2: Check if same move is repeated continuously in last 2 rounds
		if choice_counts[choice_string_to_int(last_three_choices[last_three_choices.size() - 1])] >= 3:
			last_choice = (choice_string_to_int(last_three_choices[last_three_choices.size() - 1]) + 1) % 3
			print("found repeated")
			return last_choice
		else:	
			
			# Step 6: Check for various series
			var series_list = [
				["scissors", "rock", "scissors"],  # s, r, s
				["scissors","paper","scissors"], #s,p,s
				
				["rock","scissors","rock"],  #r,s,r
				["rock","paper","rock"],	#r,p,r
				
				["paper","rock","paper"],
				["paper","scissors","paper"],
				
				["rock", "rock", "scissors"],     # r, r, s
			]

			for series in series_list:
				var counter_choice = check_series(last_three_choices, series)
				if counter_choice != -1:
					last_choice = counter_choice
					print("found in series")
					return last_choice
					break  # Stop checking further series if a match is found
				#find if there are any pattern and counter them
			#last_choice=find_and_counter_pattern(Global.blue_recent_options)
			#if last_choice!=-1:
			#	print("found some pattern")
			#	return (last_choice+2)%3
			# Step 3: In last 3 choices played by player, check for common occurrence
			
			if (last_three_choices[0] != last_three_choices[1] and
				last_three_choices[1] != last_three_choices[2] and
				last_three_choices[0] != last_three_choices[2]):
						last_choice = (choice_string_to_int(last_three_choices[1]) + 1) % 3
			if last_choice==-1:
				var choose_between = randi()%5
				if choose_between<=3:
					# Step 4: Player often chooses one with more win
					# This step is implemented based on win-loss-draw history
					var win_count = 0
					var loss_count = 0
					for result in win_loss_history:
						if result == "w":
							win_count += 1
						elif result == "l":
							loss_count += 1

					if win_count > loss_count:
						# Determine the player's most frequently winning move
						var win_move_counts = [0, 0, 0]
						for i in range(player_options.size() - 1):
							if win_loss_history[i] == "w":
								var player_choice = choice_string_to_int(player_options[i])
								win_move_counts[player_choice] += 1

						var most_frequent_win_move = 0
						for i in range(1, 3):
							if win_move_counts[i] > win_move_counts[most_frequent_win_move]:
								most_frequent_win_move = i
						
						# Choose the move that counters the player's most frequent winning move
						last_choice = (most_frequent_win_move + 1) % 3
						print("frequent move")
						return last_choice
				else:
					last_choice = randi() % 3
					print("random 1")
					return last_choice
			
			# Step 5: Scissors are picked more
			# This step is not implemented as it's not clear how to utilize this information
			
					
					
	# If none of the above conditions matched, choose randomly
	if last_choice == -1:
		last_choice = randi() % 3
	print("random 2")
	return last_choice








#extra functions 

func generate_random_except(excluded_number: int, min_value: int, max_value: int) -> int:
	var random_number = randi() % (max_value - min_value + 1) + min_value

	while random_number == excluded_number:
		random_number = randi() % (max_value - min_value + 1) + min_value

	return random_number
	



# Function to map words to their corresponding indices
func map_word_to_index(word: String) -> int:
	match word:
		"rock": return Choice.ROCK
		"paper": return Choice.PAPER
		"scissors": return Choice.SCISSORS
	return -1 # Default to -1 if word is not recognized

# Function to convert choice string to integer
func choice_string_to_int(choice_str: String) -> int:
	match choice_str:
		"rock": return 0
		"paper": return 1
		"scissors": return 2
	return -1

# Function to find the index of the maximum value in an array
func find_max_index(arr: Array) -> int:
	var max_value = arr[0]
	var max_index = 0
	for i in range(1, arr.size()):
		if arr[i] > max_value:
			max_value = arr[i]
			max_index = i
	return max_index
	
	
func check_series(player_options: Array, series: Array) -> int:
	if player_options.size() < series.size():
		return -1  # Not enough choices for a series check

	var last_choices = slice_array(player_options, player_options.size() - series.size(), player_options.size())

	# Convert series strings to corresponding integer values
	var series_values = []
	for choice_str in series:
		series_values.append(choice_string_to_int(choice_str))

	# Convert last choices to integer values
	var last_choices_values = []
	for choice_str in last_choices:
		last_choices_values.append(choice_string_to_int(choice_str))

	# Check if the last choices match the series in order
	for i in range(series.size()):
		if series_values[i] != last_choices_values[i]:
			return -1  # Series does not match, return -1

	# Series matches, return the missing choice (if any)
	var missing_choice = -1
	for choice_value in series_values:
		if choice_value not in last_choices_values:
			missing_choice = choice_value
			break

	return missing_choice



# Function to get elements from an array within a specified range and step
func slice_array(array: Array, start: int, end: int, step: int = 1) -> Array:
	var sliced_array = []

	# Adjust start and end indices if they are negative
	if start < 0:
		start = array.size() + start
	if end < 0:
		end = array.size() + end

	# Ensure start index is within array bounds
	start = clamp(start, 0, array.size() - 1)

	# Iterate through the array with the specified step
	for i in range(start, end, step):
		sliced_array.append(array[i])

	return sliced_array



func find_and_counter_pattern(player_choices: Array) -> int:
	if player_choices.size() < 6:
		return -1  # Not enough choices to analyze

	# Check if the pattern matches "r p r p r p" or "p s p s p s"
	var pattern_count = 0
	for i in range(player_choices.size() - 5):
		if (player_choices[i] == player_choices[i + 2] and
			player_choices[i] == player_choices[i + 4] and
			player_choices[i + 1] == player_choices[i + 3] and
			player_choices[i + 1] == player_choices[i + 5]):
			pattern_count += 1

	# Counter the pattern based on the parity of occurrences
	if pattern_count > 0:
		if pattern_count % 2 == 0:
			return choice_string_to_int(player_choices[player_choices.size() - 1])
		else:
			return (choice_string_to_int(player_choices[player_choices.size() - 1]) + 1) % 3

	return -1  # No pattern found

