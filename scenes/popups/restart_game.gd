extends Panel

signal restart_yes
signal restart_no

func _on_yes_button_pressed():
	restart_yes.emit()

func _on_no_button_pressed():
	restart_no.emit()
