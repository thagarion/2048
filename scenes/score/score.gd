extends VBoxContainer

signal chest_open

var prev_value = 0
var max_value = 100

func _ready():
	$ProgressBarContainer/ProgressBar.max_value = max_value

func _on_game_score_signal(value):
	$NumbersContainer/ScoreNumber.text = str(value)
	update_value(value)
	prev_value = value

func _on_chest_texture_rect_gui_input(event):
	if event is InputEventScreenTouch:
		if $ProgressBarContainer/ProgressBar.value >= max_value:
			$ProgressBarContainer/ChestAnimation.stop()
			$ProgressBarContainer/ChestAnimation.play("RESET")
			update_value(0)
			chest_open.emit()

func update_value(value):
	var diff = value - prev_value
	if diff > 0:
		$NumbersContainer/AddScoreNumber.text = "+" + str(diff)
		$NumbersContainer/ScoreAnimation.stop()
		$NumbersContainer/ScoreAnimation.play("display")

	$ProgressBarContainer/ProgressBar.value += diff
	$ProgressBarContainer/ProgressBar/Label.text = str($ProgressBarContainer/ProgressBar.value) + "/" + str(max_value)
	if $ProgressBarContainer/ProgressBar.value >= max_value:
		if !$ProgressBarContainer/ChestAnimation.is_playing():
			$ProgressBarContainer/ChestAnimation.play("shake")
