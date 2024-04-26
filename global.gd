extends Node


var red_option ="rock"
var blue_option="rock"
var red_score=0
var blue_score=0
var matches=0
var total_time=3
var total_scores=5
var difficulty="easy"  #easy(player wins or draw some time loose)win chance 100%,medium(normal game),hard(some algorithm),asian(disable foward view and looses 100%)
var blue_recent_options=[]
var blue_win_history=[]
var blue_win_history_full=[]
var red_recent_options=[]



func reload():
	red_option ="rock"
	blue_option="rock"
	red_score=0
	blue_score=0
	matches=0
