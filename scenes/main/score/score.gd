extends HBoxContainer

func _on_game_score_signal(value):
	$ScoreNUmber.text = str(value)
