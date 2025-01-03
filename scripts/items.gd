extends Node

class_name Items

class Item:
	var name: String
	var texture: Texture
	var description: String
	var is_skill: bool

static var skills = []
static var textures = []
static var packs = {}
static var backgrounds = {}

static var random = RandomNumberGenerator.new()

func _init():
	var item_remove = Item.new()
	item_remove.name = "Remove"
	item_remove.texture = load("res://textures/skills/remove-card.png")
	item_remove.description = "Remove one tile"
	item_remove.is_skill = true
	skills.append(item_remove)
	
	var item_undo = Item.new()
	item_undo.name = "Undo"
	item_undo.texture = load("res://textures/skills/undo-card.png")
	item_undo.description = "Undo last step"
	item_undo.is_skill = true
	skills.append(item_undo)
	
	var item_swap = Item.new()
	item_swap.name = "Swap"
	item_swap.texture = load("res://textures/skills/swap-card.png")
	item_swap.description = "Swap tiles"
	item_swap.is_skill = true
	skills.append(item_swap)
	
	var texture_packs_dir = DirAccess.open("res://textures/packs")
	if texture_packs_dir:
		for pack_name in texture_packs_dir.get_directories():
			packs[pack_name] = []
			packs[pack_name].resize(11)
			for index in range(0, 11):
				var item = Item.new()
				item.name = "Tile #" + str(index)
				item.texture = load("res://textures/packs/" + pack_name + "/" + str(index) + ".png")
				item.description = str(pack_name.get_basename()).capitalize() + " set"
				textures.append(item)
				packs[pack_name][index] = item
			backgrounds[pack_name] = load("res://textures/packs/" + pack_name + "/" + "background.png")

static func get_random_item() -> Item:
	random.randomize()
	var random_value = random.randf_range(0.0, 100.0)
	if random_value < 50.0:
		return skills.pick_random()
	else:
		return textures.pick_random()

static func get_random_pack() -> String:
	return packs.keys().pick_random()

static func get_pack(pack_name: String) -> Array:
	return packs[pack_name]

static func get_background(pack_name: String) -> Texture:
	return backgrounds[pack_name]
