extends MarginContainer

signal restart
signal switch
signal undo
signal remove

@export var Icon: Texture
@export var ButtonColor: float
@export_enum("Undo", "Remove", "Switch", "Restart") var Type: String

var count = 0
var color = 0.0

func _ready():
	color = ButtonColor / 360.0
	$Panel/VBoxContainer/ButtonMarginContainer/Icon.texture = Icon
	$Panel/VBoxContainer/ButtonMarginContainer/Icon.modulate = Color.from_hsv(color, 1, 0.6, 1)
	$Panel/VBoxContainer/ButtonMarginContainer/Button.modulate = Color.from_hsv(color, 1, 0.6, 1)
	update_count(3)
	if Type == "Restart":
		$Panel/VBoxContainer/LabelMarginContainer.hide()

func _on_button_pressed():
	if Type == "Restart" || count > 0:
		match Type:
			"Undo":
				undo.emit()
			"Switch":
				switch.emit()
			"Remove":
				remove.emit()
			"Restart":
				restart.emit()

func button_disable(value: bool):
	$Panel/VBoxContainer/ButtonMarginContainer/Button.disabled = value

func update_count(val: int):
	if Type == "Restart":
		return
	count += val
	$Panel/VBoxContainer/LabelMarginContainer/Label.text = str(count)
	if count > 0:
		button_disable(false)
		$Panel/VBoxContainer/ButtonMarginContainer/Button.modulate = Color.from_hsv(color, 1, 0.6, 1)
	else:
		button_disable(true)
		$Panel/VBoxContainer/ButtonMarginContainer/Button.modulate = Color.from_hsv(0, 0, 1, 1)
