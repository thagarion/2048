extends VBoxContainer

func disable():
	for node in $HBoxContainer.get_children():
		node.disable()

func enable():
	for node in $HBoxContainer.get_children():
		node.enable()

func update_skill_count(skill: String, val: int):
	match skill:
		"Remove":
			$HBoxContainer/RemoveButton.update_count(val)
		"Undo":
			$HBoxContainer/UndoButton.update_count(val)
		"Switch":
			$HBoxContainer/SwitchButton.update_count(val)
