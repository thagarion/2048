extends Node

class_name Items

class Item:
	var name: String
	var texture :Texture
	var description: String

static var skills = []

func _ready():
	var item_remove = Item.new()
	item_remove.name = "Remove"
	item_remove.texture = load("res://textures/skills/remove.png")
	item_remove.description = "Removed one tile"
	skills.append(item_remove)
	
	var item_undo = Item.new()
	item_undo.name = "Undo"
	item_undo.texture = load("res://textures/skills/undo.png")
	item_undo.description = "Undo last step"
	skills.append(item_undo)
	
	var item_switch = Item.new()
	item_switch.name = "Undo"
	item_switch.texture = load("res://textures/skills/switch.png")
	item_switch.description = "Undo last step"
	skills.append(item_switch)

static func get_random_skill() -> Item:
	return skills.pick_random()
