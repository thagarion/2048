extends Node

class_name ActionStorage

enum ActionType {Add = 0, Remove = 1, Change = 2} 

class Action:
	var type: ActionType
	var from: Vector2
	var to: Vector2
	var old_value: int
	var new_value: int

var steps = []
var actions = []
var max_size: int
var current_step = 0

func set_size(val: int):
	max_size = val + 1
	while steps.size() > max_size:
		steps.pop_front()

func add_step():
	steps.append([])
	if steps.size() > max_size:
		steps.pop_front()
	else:
		current_step += 1

func add(location: Vector2):
	var action = Action.new()
	action.type = ActionType.Add
	action.to = location
	steps[current_step].append(action)

func remove(location: Vector2):
	var action = Action.new()
	action.type = ActionType.Remove
	action.from = location
	steps[current_step].append(action)

func merge(location: Vector2):
	var action = Action.new()
	action.type = ActionType.Remove
	action.from = location
	steps[current_step].append(action)
