extends Container

var tiles = []
var Tile = preload("res://scenes/tile.tscn")

const field_size = 4
const tiles_at_start = 2

var swiping = false
const swiping_length = 30
const swiping_threshold = 10
var swiping_start_position: Vector2
var swiping_current_position: Vector2

func _ready():
	for i in range(field_size):
		tiles.append([])
		for j in range(field_size):
			tiles[i].append(null)

	var tiles_count = 0
	while tiles_count < tiles_at_start:
		var i = randi() % field_size
		var j = randi() % field_size
		if tiles[i][j] == null:
			create_tile(i, j)
			tiles_count += 1

func _process(_delta):
	if Input.is_action_just_pressed("move rigth"):
		move_right()
	if Input.is_action_just_pressed("move left"):
		move_left()
	if Input.is_action_just_pressed("move up"):
		move_up()
	if Input.is_action_just_pressed("move down"):
		move_down()

func _on_gui_input(event):
	if event is InputEventScreenTouch:
		if event.is_pressed():
			swiping_start_position = event.position
		elif event.is_released():
			var final_position = event.position
			var swipe_distance = final_position - swiping_start_position
			var swipe_direction = swipe_distance.normalized()
			if swipe_distance.length() > swiping_length:
				if abs(swipe_direction.x) > abs(swipe_direction.y):
					if swipe_direction.x > 0:
						move_right()
					else:
						move_left()
				else:
					if swipe_direction.y > 0:
						move_down()
					else:
						move_up()

func create_tile(i: int, j: int):
	var tile = Tile.instantiate()
	tiles[i][j] = tile
	add_child(tile)
	tile.position = Vector2(i*tile.size.x, j*tile.size.y)

func create_random_tile():
	var available = []
	for i in range(field_size):
		for j in range(field_size):
			if tiles[i][j] == null:
				available.append(Vector2(i, j))
	if available.size() > 0:
		var index = randi() % available.size()
		create_tile(available[index].x, available[index].y)

func move_up():
	var moved = 0
	for i in range(field_size):
		for j in range(1, field_size):
			if tiles[i][j] != null:
				var index = 0
				while index < field_size and tiles[i][index] != null:
					index += 1
				var steps = j - index
				if steps > 0:
					tiles[i][j].move_up(steps)
					tiles[i][index] = tiles[i][j]
					tiles[i][j] = null 
					moved += 1
	if moved > 0:
		create_random_tile()

func move_down():
	var moved = 0
	for i in range(field_size):
		for j in range(field_size, 0, -1):
			if tiles[i][j-1] != null:
				var index = field_size - 1
				while index >= 0 and tiles[i][index] != null:
					index -= 1
				var steps = index - (j - 1)
				if steps > 0:
					tiles[i][j-1].move_down(steps)
					tiles[i][index] = tiles[i][j-1]
					tiles[i][j-1] = null 
					moved += 1
	if moved > 0:
		create_random_tile()

func move_right():
	var moved = 0
	for i in range(field_size, 0, -1):
		for j in range(field_size):
			if tiles[i-1][j] != null:
				var index = field_size - 1
				while index >= 0 and tiles[index][j] != null:
					index -= 1
				var steps = index - (i - 1)
				if steps > 0:
					tiles[i-1][j].move_right(steps)
					tiles[index][j] = tiles[i-1][j]
					tiles[i-1][j] = null 
					moved += 1
	if moved > 0:
		create_random_tile()

func move_left():
	var moved = 0
	for i in range(1, field_size):
		for j in range(field_size):
			if tiles[i][j] != null:
				var index = 0
				while index < field_size and tiles[index][j] != null:
					index += 1
				var steps = i - index
				if steps > 0:
					tiles[i][j].move_left(steps)
					tiles[index][j] = tiles[i][j]
					tiles[i][j] = null 
					moved += 1
	if moved > 0:
		create_random_tile()
