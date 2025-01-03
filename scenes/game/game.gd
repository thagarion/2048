extends Container

const Storage = preload("res://scenes/game/action_storage.gd")

signal score_signal(value)
signal skill(name: String)

var Tile = preload("res://scenes/game/tile.tscn")

var tiles = []
const field_size = 4
const tiles_at_start = 2
var pack_name : String

enum Move {Up, Down, Left, Right}

var should_create_tile = false
var wait_moving = false
var moving_disabled = false

var swiping = false
const swiping_length = 15
var swiping_start_position: Vector2
var swiping_current_position: Vector2

var is_remove = false
var is_swap = false
var swap_tile = null

var actions = ActionStorage.new()

func _ready():
	for i in range(field_size):
		tiles.append([])
		for j in range(field_size):
			tiles[i].append(null)
	$GameOver.z_index = 1

func _process(_delta):
	if !moving_disabled:
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
			if !wait_moving && should_create_tile:
				create_random_tile()
				should_create_tile = false

func _on_gui_input(event):
	if !moving_disabled && !wait_moving:
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

func _on_button_pressed():
	start_game()

func _on_tile_selected(tile: Node):
	for i in range(field_size):
		for j in range(field_size):
			if tile == tiles[i][j]:
				if is_remove:
					tiles[i][j].queue_free()
					tiles[i][j] = null
					%SkillButtons.update_skill_count("Remove", -1)
					close_selection()
					return
				if is_swap:
					if swap_tile == null:
						swap_tile = Vector2(i, j)
						return
					elif Vector2(i, j) != swap_tile:
						var temp = tiles[swap_tile.x][swap_tile.y]
						tiles[i][j].move(swap_tile.x, swap_tile.y)
						tiles[swap_tile.x][swap_tile.y] = tiles[i][j]
						temp.move(i, j)
						tiles[i][j] = temp
						is_swap = false
						%SkillButtons.update_skill_count("Swap", -1)
						close_selection()
						return

func _on_remove_button_remove():
	if get_tiles_count() >= 2:
		moving_disable(true)
		%SelectTilePopUp.show()
		%SkillButtons.disable_and_hide()
		%Score.disable_and_hide()
		z_index = 1
		is_remove = true
		for i in range(field_size):
			for j in range(field_size):
				if tiles[i][j] != null:
					tiles[i][j].input_disable(false)

func _on_swap_button_swap():
	if get_tiles_count() >= 2:
		moving_disable(true)
		%SelectTilePopUp.show()
		%SkillButtons.disable_and_hide()
		%Score.disable_and_hide()
		z_index = 1
		is_swap = true
		for i in range(field_size):
			for j in range(field_size):
				if tiles[i][j] != null:
					tiles[i][j].input_disable(false)

func get_tiles_count() -> int:
	var result = 0
	for i in range(field_size):
			for j in range(field_size):
				if tiles[i][j] != null:
					result += 1
	return result

func set_pack(pack: String):
	pack_name = pack

func close_selection():
	is_remove = false
	is_swap = false
	swap_tile = null
	z_index = 0
	%SelectTilePopUp.hide()
	%SkillButtons.enable_and_show()
	%Score.enable_and_show()
	moving_disable(false)
	for i in range(field_size):
		for j in range(field_size):
			if tiles[i][j] != null:
				tiles[i][j].input_disable(true)

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
	if available.size() == 1 && is_game_over():
		$GameOver.show()
		moving_disable(true)
	score_signal.emit(score)

func create_tile(i: int, j: int):
	var tile = Tile.instantiate()
	tile.set_pack(pack_name)
	tiles[i][j] = tile
	$Tiles.add_child(tile)
	tile.set_location(i, j)
	tile.connect("tile_selected", _on_tile_selected)
	actions.add(Vector2(i, j))

func start_game():
	$GameOver.hide()
	for i in range(field_size):
		for j in range(field_size):
			if tiles[i][j] != null:
				tiles[i][j].queue_free()
				tiles[i][j] = null
	var tiles_count = 0
	while tiles_count < tiles_at_start:
		var i = randi() % field_size
		var j = randi() % field_size
		if tiles[i][j] == null:
			create_tile(i, j)
			tiles_count += 1
	moving_disable(false)
	score_signal.emit(0)

func is_game_over() -> bool:
	for i in range(field_size):
		for j in range(field_size):
			if tiles[i][j] == null:
				return false
			if i > 0 && tiles[i-1][j] != null && tiles[i][j].get_value() == tiles[i-1][j].get_value():
				return false
			if i < field_size - 1 && tiles[i + 1][j] != null && tiles[i][j].get_value() == tiles[i + 1][j].get_value():
				return false
			if j > 0 && tiles[i][j - 1] != null && tiles[i][j].get_value() == tiles[i][j - 1].get_value():
				return false
			if j < field_size - 1 && tiles[i][j + 1] != null && tiles[i][j].get_value() == tiles[i][j + 1].get_value():
				return false
	return true

func move(direction: Move):
	wait_moving = true
	var moved = false
	if direction == Move.Up:
		for x in range(field_size):
			for y in range(1, field_size):
				if tiles[x][y] != null:
					if move_up(x, y):
						moved = true
	elif direction == Move.Down:
		for x in range(field_size):
			for y in range(field_size - 2, -1, -1):
				if tiles[x][y] != null:
					if move_down(x, y):
						moved = true
	elif direction == Move.Left:
		for y in range(field_size):
			for x in range(1, field_size):
				if tiles[x][y] != null:
					if move_left(x, y):
						moved = true
	elif direction == Move.Right:
		for y in range(field_size):
			for x in range(field_size - 2, -1, -1):
				if tiles[x][y] != null:
					if move_right(x, y):
						moved = true
	if moved:
		should_create_tile = true
	actions.add_step()

func move_up(x : int, y : int) -> bool:
	var result = false
	var from = Vector2(x, y)
	var to: Vector2
	while y > 0 and tiles[x][y - 1] == null:
		tiles[x][y].move(x, y - 1)
		to = Vector2(x, y - 1)
		tiles[x][y - 1] = tiles[x][y]
		tiles[x][y] = null
		y -= 1
		result = true
	if result:
		actions.move(from, to)
	if y > 0 and tiles[x][y - 1].get_value() == tiles[x][y].get_value():
		tiles[x][y].move(x, y - 1)
		actions.move(Vector2(x, y), Vector2(x, y - 1))
		tiles[x][y].queue_free()
		actions.remove(Vector2(x, y))
		tiles[x][y - 1].level_up()
		actions.change(Vector2(x, y - 1), tiles[x][y - 1].get_value())
		tiles[x][y] = null
		result = true
	return result

func move_down(x : int, y : int) -> bool:
	var result = false
	var from = Vector2(x, y)
	var to: Vector2
	while y < field_size - 1 and tiles[x][y + 1] == null:
		tiles[x][y].move(x, y + 1)
		to = Vector2(x, y + 1)
		tiles[x][y + 1] = tiles[x][y]
		tiles[x][y] = null
		y += 1
		result = true
	if result:
		actions.move(from, to)
	if y >= 0 and y < field_size - 1 and tiles[x][y + 1].get_value() == tiles[x][y].get_value():
		tiles[x][y].move(x, y + 1)
		actions.move(Vector2(x, y), Vector2(x, y + 1))
		tiles[x][y].queue_free()
		actions.remove(Vector2(x, y))
		tiles[x][y + 1].level_up()
		actions.change(Vector2(x, y + 1), tiles[x][y + 1].get_value())
		tiles[x][y] = null
		result = true
	return result

func move_right(x : int, y : int) -> bool:
	var result = false
	var from = Vector2(x, y)
	var to: Vector2
	while x < field_size - 1 and tiles[x + 1][y] == null:
		tiles[x][y].move(x + 1, y)
		to = Vector2(x + 1, y)
		tiles[x + 1][y] = tiles[x][y]
		tiles[x][y] = null
		x += 1
		result = true
	if result:
		actions.move(from, to)
	if x >= 0 and x < field_size - 1 and tiles[x + 1][y].get_value() == tiles[x][y].get_value():
		tiles[x][y].move(x + 1, y)
		actions.move(Vector2(x, y), Vector2(x + 1, y))
		tiles[x][y].queue_free()
		actions.remove(Vector2(x, y))
		tiles[x + 1][y].level_up()
		actions.change(Vector2(x + 1, y), tiles[x + 1][y].get_value())
		tiles[x][y] = null
		result = true
	return result

func move_left(x : int, y : int) -> bool:
	var result = false
	var from = Vector2(x, y)
	var to: Vector2
	while x > 0 and tiles[x - 1][y] == null:
		tiles[x][y].move(x - 1, y)
		to = Vector2(x - 1, y)
		tiles[x - 1][y] = tiles[x][y]
		tiles[x][y] = null
		x -= 1
		result = true
	if result:
		actions.move(from, to)
	if x > 0 and tiles[x - 1][y].get_value() == tiles[x][y].get_value():
		tiles[x][y].move(x - 1, y)
		actions.move(Vector2(x, y), Vector2(x - 1, y))
		tiles[x][y].queue_free()
		actions.remove(Vector2(x, y))
		tiles[x - 1][y].level_up()
		actions.change(Vector2(x - 1, y), tiles[x - 1][y].get_value())
		tiles[x][y] = null
		result = true
	return result

func is_tiles_moving() -> bool:
	for lines in tiles:
		for item in lines:
			if item != null && item.moving():
				return true
	return false

func moving_disable(val: bool):
	moving_disabled = val
	if moving_disabled:
		$Tiles.mouse_filter = MOUSE_FILTER_IGNORE
	else:
		$Tiles.mouse_filter = MOUSE_FILTER_PASS
