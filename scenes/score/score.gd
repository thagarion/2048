extends VBoxContainer

var prev_value = 0

func _on_game_score_signal(value):
	$NumbersContainer/ScoreNumber.text = str(value)
	var diff = value - prev_value
	if diff > 0:
		$NumbersContainer/AddScoreNumber.text = "+" + str(diff)
		$AnimationPlayer.stop()
		$AnimationPlayer.play("display")
	prev_value = value
