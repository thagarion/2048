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
	$Icon.texture = Icon
	$Icon.modulate = Color.from_hsv(color, 1, 0.6, 1)
	$Button.modulate = Color.from_hsv(color, 1, 0.6, 1)
	update_count()

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

func _on_game_skill(skill: String):
	if skill == Type:
		count -= 1
		update_count()

func button_disable(value: bool):
	$Button.disabled = value

func update_count():
	if Type == "Restart":
		return
	if count > 0:
		$MarginContainer/Label.text = str(count)
		button_disable(false)
		$Button.modulate = Color.from_hsv(color, 1, 0.6, 1)
	else:
		button_disable(true)
		$Button.modulate = Color.from_hsv(0, 0, 1, 1)
