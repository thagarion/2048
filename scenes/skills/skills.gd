extends VBoxContainer

func update_skill_count(skill: String, val: int):
	match skill:
		"Remove":
			$HBoxContainer/RemoveButton.update_count(val)
		"Undo":
			$HBoxContainer/UndoButton.update_count(val)
		"Swap":
			$HBoxContainer/SwapButton.update_count(val)

func disable_and_hide():
	for node in $HBoxContainer.get_children():
		node.disable_and_hide()

func enable_and_show():
	for node in $HBoxContainer.get_children():
		node.enable_and_show()
