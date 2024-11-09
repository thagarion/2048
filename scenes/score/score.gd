extends HBoxContainer

func _on_game_score_signal(value):
	$ScoreNumber.text = str(value)
