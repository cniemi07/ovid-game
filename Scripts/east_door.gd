extends Area2D

const FILE_START = "res://Scenes/Levels/level_"
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func _on_body_entered(body: Node2D) -> void:
	if body.is_in_group("Player"):
		print("collided wtih playa")
		
		#get next level path 
		var current_scene_file = get_tree().current_scene.scene_file_path
		var next_level_number = current_scene_file.to_int() + 1
		var next_level_path = FILE_START + str(next_level_number) + ".tscn"
		print(next_level_path)
		#change scene
		get_tree().change_scene_to_file.call_deferred(next_level_path)
	else:
		return
