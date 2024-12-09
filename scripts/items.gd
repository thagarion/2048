extends Node

class_name Items

class Item:
	var name: String
	var texture :Texture
	var description: String

static var skills = []
static var textures = []
static var packs = {}
static var backgrounds = {}

static var random = RandomNumberGenerator.new()

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
	
	var texture_packs_dir = DirAccess.open("res://textures/packs")
	if texture_packs_dir:
		for pack_name in texture_packs_dir.get_directories():
			packs[pack_name] = []
			for file_name in DirAccess.open("res://textures/packs/" + pack_name).get_files():
				if file_name.ends_with(".png"):
					var texture = load("res://textures/packs/" + pack_name + "/" + file_name)
					if !file_name.begins_with("background"):
						var item = Item.new()
						item.name = "Tile #" + file_name.get_basename()
						item.texture = texture
						item.description = str(pack_name.get_basename()).capitalize() + " set"
						textures.append(item)
						packs[pack_name].append(texture)
					else:
						backgrounds[pack_name] = texture

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
	return packs.get(pack_name)

static func get_background(pack_name: String) -> Texture:
	return backgrounds.get(pack_name)
