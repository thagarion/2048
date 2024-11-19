extends VBoxContainer

func disable():
	for node in $HBoxContainer.get_children():
		node.disable()

func enable():
	for node in $HBoxContainer.get_children():
		node.enable()

func remove_update_count(val: int):
	$HBoxContainer/RemoveButton.update_count(val)
