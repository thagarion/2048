extends Container

var value = 0

const speed = 50
var is_moving = false
var move_to : Vector2

func _ready():
	pass

func _process(delta):
	if is_moving:
		position = lerp(position, move_to, delta * speed)
		if abs(position.x - move_to.x) <= 0.1 and abs(position.y - move_to.y) <= 0.1:
			position = move_to
			is_moving = false

func set_icon(image: Texture):
	$Icon.texture = image

func move_up(steps: int):
	move_to = Vector2(position.x, position.y - size.y * steps)
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
