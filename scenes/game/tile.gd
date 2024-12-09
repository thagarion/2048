extends Container

signal tile_selected(node: Node)

var value = 0
var colors = []
var icons = []

const speed = 30
var is_moving = false
var move_to : Vector2
var input_disabled = true
var pack : String

#func _init():
	#for i in range(0, 11):
		#colors.append(1.0/11.0*(i+1))
		#icons.append(load("res://textures/default/" + str(i) + ".png"))
	#scale = Vector2(0, 0)

func _ready():
	$AnimationPlayer.play("add_tile")
	#$Icon.texture = icons[value]
	#$Icon.modulate = Color.from_hsv(colors[value], 1, 0.6, 1)
	#$Background.modulate = Color.from_hsv(colors[value], 0.5, 1, 1)
	#$Border.modulate = Color.from_hsv(colors[value], 1, 0.6, 1)

func _process(delta):
	if is_moving:
		position = lerp(position, move_to, delta * speed)
		if abs(position.x - move_to.x) <= 0.1 and abs(position.y - move_to.y) <= 0.1:
			position = move_to
			is_moving = false

func _on_gui_input(event):
	if !input_disabled:
		if event is InputEventScreenTouch:
			tile_selected.emit(self)

func set_pack(pack_name: String):
	pack = pack_name
	$Texture.texture = Items.get_pack(pack)[value]

func move(x: int, y: int):
	move_to = Vector2(x * size.x, y * size.y)
	is_moving = true

func move_down(steps: int):
	move_to = Vector2(position.x, position.y + size.y * steps)
	is_moving = true

func move_left(steps: int):
	move_to = Vector2(position.x - size.x * steps, position.y)
	is_moving = true

func move_right(steps: int):
	move_to = Vector2(position.x + size.x * steps, position.y)
	is_moving = true

func level_up():
	value += 1
	$AnimationPlayer.play("add_tile")
	$Texture.texture = Items.get_pack(pack)[value]
	#$Icon.texture = icons[value]
	#$Icon.modulate = Color.from_hsv(colors[value], 1, 0.6, 1)
	#$Background.modulate = Color.from_hsv(colors[value], 0.5, 1, 1)
	#$Border.modulate = Color.from_hsv(colors[value], 1, 0.6, 1)

func get_value() -> int:
	return value

func moving() -> bool:
	return is_moving

func get_score() -> int:
	return 2 ** (value + 1) * (value + 1)

func input_disable(val: bool):
	input_disabled = val
