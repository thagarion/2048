extends Node

class_name ActionStorage

enum ActionType {Add = 0, Remove = 1, Change = 2, Move = 4} 

class Action:
	var type: ActionType
	var from: Vector2
	var to: Vector2
	var old_value: int
	var new_value: int

var steps = []
var actions = []
var max_size
var current_step = 0

func _init():
	steps.append([])

func get_size() -> int:
	return steps.size()

func set_size(val: int):
	max_size = val + 1
	while steps.size() > max_size:
		steps.pop_front()

func get_last() -> Array:
	return steps.pop_back()

func add_step():
	if steps.size() >= max_size:
		steps.pop_front()
		steps.append([])
	else:
		current_step += 1
		steps.append([])

func add(location: Vector2):
	var action = Action.new()
	action.type = ActionType.Add
	action.to = location
	steps[current_step].append(action)

func remove(location: Vector2, value: int):
	var action = Action.new()
	action.type = ActionType.Remove
	action.from = location
	action.old_value = value
	steps[current_step].append(action)

func change(location: Vector2, value: int):
	var action = Action.new()
	action.type = ActionType.Change
	action.from = location
	action.new_value = value
	action.old_value = value - 1
	steps[current_step].append(action)	

func move(location1: Vector2, location2: Vector2):
	var action = Action.new()
	action.type = ActionType.Move
	action.from = location1
	action.to = location2
	steps[current_step].append(action)
