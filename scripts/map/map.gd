class_name Map
extends Control

signal chosen(Encounter)

@export var dotted_line_scene: PackedScene

@onready var back_button: Button = %BackButton
@onready var ice_cream_isaac: Encounter = $IceCreamIsaac
@onready var muffin_max: Encounter = $MuffinMax
@onready var donut_daisy: Encounter = $DonutDaisy


func _ready() -> void:
	back_button.pressed.connect(_on_back_button_pressed)
	
	for encounter in get_all_encounters():
		encounter.pressed.connect(_on_encounter_pressed)
	
	_create_connections()


func enable(is_win: bool) -> void:
	visible = !visible
	
	if visible:
		%map_open.play()	
	else:
		%map_select.play()
	#for encounter in get_all_encounters():
		#encounter.disabled = !is_win


func disable(character: Character):
	for encounter in get_all_encounters():
		if encounter.character_data == character.character_data:
			encounter.disabled = true


func _on_back_button_pressed() -> void:
	visible = false
	%map_select.play()


func _on_encounter_pressed(encounter: Encounter) -> void:
	chosen.emit(encounter)


func get_all_encounters() -> Array[Encounter]:
	var encounters: Array[Encounter] = []
	for child in get_children():
		if child is Encounter:
			encounters.append(child)
	return encounters


func _create_connections() -> void:	
	var encounters = get_all_encounters()	
	var drawn_pairs = {}  # Dictionary to track unique connections, keyed by tuples of node positions	
	for encounter in encounters:
		for connection in encounter.connections:
			# Get the start and end positions
			var pos1 = encounter.get_center_position()
			var pos2 = connection.get_center_position()
			var pair = [pos1, pos2]
			pair.sort()  # Sort to prevent reverse duplicates
			
			# Check if this pair has already been drawn
			if not drawn_pairs.has(pair):
				# Generate random points to simulate a trail
				var points = _generate_trail_points(pos1, pos2, 10)  # 10 intermediate points for the trail
				
				# Create the dotted line
				var line2D := dotted_line_scene.instantiate()
				add_child(line2D)
				for point in points:
					line2D.add_point(point)
				
				# Mark the pair as drawn
				drawn_pairs[pair] = true


func _generate_trail_points(start: Vector2, end: Vector2, num_points: int) -> Array:
	var points = []
	var random_offset_range = 15  # How much random offset can be applied to each intermediate point
	for i in range(num_points):
		# Interpolate between the start and end positions
		var t = float(i) / (num_points - 1)
		var interp_point = start.lerp(end, t)  # Use lerp to interpolate between start and end
		
		# Add random noise to the intermediate point
		var offset = Vector2(randf_range(-random_offset_range, random_offset_range), randf_range(-random_offset_range, random_offset_range))
		points.append(interp_point + offset)
	
	# Add the final position to the points list
	points.append(end)
	return points
