extends Node2D

func _ready():
	pass

func _process(_delta):
	if Input.is_action_just_pressed("restart"):
		restart()

func _on_restart_button_restart():
	restart()

func _on_restart_game_pop_up_restart_no():
	%Game.moving_disable(false)
	%RestartGamePopUp.hide()

func _on_restart_game_pop_up_restart_yes():
	%Game.start_game()
	%Game.moving_disable(false)
	%RestartGamePopUp.hide()

func restart():
	%Game.moving_disable(true)
	%RestartGamePopUp.show()


