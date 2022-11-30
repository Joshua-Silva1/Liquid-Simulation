extends Node2D

onready var simulation_size : Vector2 = Vector2(60, 60)
onready var dragging_left : bool = false
onready var dragging_right : bool = false
onready var dragging_mid : bool = false

func _ready():
	randomize()
	for x in simulation_size.x:
		for y in simulation_size.y:
			# set up blank tileset
			$TileMap.set_cell(x, y, 2)

func _unhandled_input(event):
	if event.is_action_pressed("right_click"): # place block
		dragging_left = false
		dragging_mid = false
		dragging_right = true
	if event.is_action_released("right_click"):
		dragging_right = false
	
	if event.is_action_pressed("left_click"): # place water
		dragging_right = false
		dragging_mid = false
		dragging_left = true
	if event.is_action_released("left_click"):
		dragging_left = false
	
	if event.is_action_pressed("middle_click"): # clear tile
		dragging_right = false
		dragging_left = false
		dragging_mid = true
	if event.is_action_released("middle_click"):
		dragging_mid = false
	
	var mouse_target = $TileMap.world_to_map(get_global_mouse_position() * 4)
	if !is_valid_tile(mouse_target):
		return
	if dragging_right:
		$TileMap.set_cellv(mouse_target, 1)
	elif dragging_left:
		$TileMap.set_cellv(mouse_target, 0)
	elif dragging_mid:
		$TileMap.set_cellv(mouse_target, 2)

func is_valid_tile(tile):
	if tile.x < 0 or tile.x >= simulation_size.x:
		return false
	if tile.y < 0 or tile.y >= simulation_size.y:
		return false
	return true

func _physics_process(_delta):
	for x in simulation_size.x:
			for y in simulation_size.y:
			# if tile is water, apply physics
				if $TileMap.get_cell(x, y) == 0:
					#water_logic(x, y)
				
					# check tile below
					if $TileMap.get_cell(x, y+1) == 2: # if below is blank
						$TileMap.set_cell(x, y, 2) # set old tile as blank
						$TileMap.set_cell(x, y+1, 0) # set new tile as water
					
					# randomly check each side
					else: # if below is not blank
						# left
						if randf() > 0.5:
							if $TileMap.get_cell(x-1, y) == 2: # if left is blank
								$TileMap.set_cell(x, y, 2) # set old tile as blank
								$TileMap.set_cell(x-1, y, 0) # set new tile as water
						#right
						else:
							if $TileMap.get_cell(x+1, y) == 2: # if right is blank
								$TileMap.set_cell(x, y, 2) # set old tile as blank
								$TileMap.set_cell(x+1, y, 0) # set new tile as water
				update()
