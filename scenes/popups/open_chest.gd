extends Panel

func open(item):
	show()
	$VBoxContainer/MarginContainer/GiftTextureRect.texture = item.texture
	$VBoxContainer/NameLabel.text = item.name
	$VBoxContainer/DescriptionLabel.text = item.description
	$AnimationPlayer.play("open")
