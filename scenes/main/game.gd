extends Container

signal score_signal(value)
signal game_over_sigmal

var Tile = preload("res://scenes/main/tile.tscn")

var tiles = []
const field_size = 4
const tiles_at_start = 2

enum Move {Up, Down, Left, Right}

var should_create_tile = false
var wait_moving = false
var swiping = false
const swiping_length = 30
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
	if !wait_moving:
		if Input.is_action_just_pressed("move rigth"):
			move(Move.Right)
		if Input.is_action_just_pressed("move left"):
			move(Move.Left)
		if Input.is_action_just_pressed("move up"):
			move(Move.Up)
		if Input.is_action_just_pressed("move down"):
			move(Move.Down)
	else:
		wait_moving = is_tiles_moving()
		if !wait_moving && create_tile:
			create_random_tile()
			should_create_tile = false

func _on_gui_input(event):
	if !wait_moving:
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
							move(Move.Right)
						else:
							move(Move.Left)
					else:
						if swipe_direction.y > 0:
							move(Move.Down)
						else:
							move(Move.Up)

func create_tile(i: int, j: int):
	var tile = Tile.instantiate()
	tiles[i][j] = tile
	add_child(tile)
	tile.position = Vector2(i*tile.size.x, j*tile.size.y)

func create_random_tile():
	var available = []
	var score = 0
	for i in range(field_size):
		for j in range(field_size):
			if tiles[i][j] == null:
				available.append(Vector2(i, j))
			else:
				score += tiles[i][j].get_score()
	if available.size() > 0:
		var index = randi() % available.size()
		create_tile(available[index].x, available[index].y)
	else:
		game_over_sigmal.emit()
	score_signal.emit(score)

func move(direction: Move):
	wait_moving = true
	var moved = false
	if direction == Move.Up:
		for x in range(field_size):
			for y in range(1, field_size):
				if tiles[x][y] != null:
					move_up(x, y)
					moved = true
	elif direction == Move.Down:
		for x in range(field_size):
			for y in range(field_size - 2, -1, -1):
				if tiles[x][y] != null:
					move_down(x, y)
					moved = true
	elif direction == Move.Left:
		for y in range(field_size):
			for x in range(1, field_size):
				if tiles[x][y] != null:
					move_left(x, y)
					moved = true
	elif direction == Move.Right:
		for y in range(field_size):
			for x in range(field_size - 2, -1, -1):
				if tiles[x][y] != null:
					move_right(x, y)
					moved = true
	if moved:
		should_create_tile = true

func move_up(x : int, y : int):
	while y > 0 and tiles[x][y - 1] == null:
		tiles[x][y].move(x, y - 1)
		tiles[x][y - 1] = tiles[x][y]
		tiles[x][y] = null
		y -= 1
	if y > 0 and tiles[x][y - 1].get_value() == tiles[x][y].get_value():
		tiles[x][y].move(x, y - 1)
		tiles[x][y].queue_free()
		tiles[x][y - 1].level_up()
		tiles[x][y] = null

func move_down(x : int, y : int):
	while y < field_size - 1 and tiles[x][y + 1] == null:
		tiles[x][y].move(x, y + 1)
		tiles[x][y + 1] = tiles[x][y]
		tiles[x][y] = null
		y += 1
	if y > 0 and y < field_size - 1 and tiles[x][y + 1].get_value() == tiles[x][y].get_value():
		tiles[x][y].move(x, y + 1)
		tiles[x][y].queue_free()
		tiles[x][y + 1].level_up()
		tiles[x][y] = null

func move_right(x : int, y : int):
	while x < field_size - 1 and tiles[x + 1][y] == null:
		tiles[x][y].move(x + 1, y)
		tiles[x + 1][y] = tiles[x][y]
		tiles[x][y] = null
		x += 1
	if x > 0 and x < field_size - 1 and tiles[x + 1][y].get_value() == tiles[x][y].get_value():
		tiles[x][y].move(x + 1, y)
		tiles[x][y].queue_free()
		tiles[x + 1][y].level_up()
		tiles[x][y] = null

func move_left(x : int, y : int):
	while x > 0 and tiles[x - 1][y] == null:
		tiles[x][y].move(x - 1, y)
		tiles[x - 1][y] = tiles[x][y]
		tiles[x][y] = null
		x -= 1
	if x > 0 and tiles[x - 1][y].get_value() == tiles[x][y].get_value():
		tiles[x][y].move(x - 1, y)
		tiles[x][y].queue_free()
		tiles[x - 1][y].level_up()
		tiles[x][y] = null

func is_tiles_moving() -> bool:
	for lines in tiles:
		for item in lines:
			if item != null && item.moving():
				return true
	return false
