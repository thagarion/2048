extends MarginContainer

signal restart
signal switch
signal undo
signal remove

@export var Icon: Texture
@export var ButtonColor: float
@export_enum("Undo", "Remove", "Switch", "Restart") var Type: String

func _ready():
	var color = ButtonColor / 360.0
	$Icon.texture = Icon
	$Icon.modulate = Color.from_hsv(color, 1, 0.6, 1)

func _on_button_pressed():
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
	$Button.disabled = value

