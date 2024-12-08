extends Panel

func open(item):
	show()
	$VBoxContainer/MarginContainer/GiftTextureRect.texture = item.texture
	$AnimationPlayer.play("open")
