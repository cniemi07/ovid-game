extends Node2D
@onready var hud = $HUD

var level: int = 1
var current_level_root:Node = null

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	#current_level_root = get_node("LevelRoot")
	_load_level(level)

	
	
	
#--------------------
#  LEVEL MANAGEMENT
#--------------------
func _load_level(level_number: int) -> void:
	if current_level_root:
		current_level_root.queue_free()
	var level_path = "res://Scenes/Levels/level_%s.tscn" % level_number
	current_level_root = load(level_path).instantiate()
	add_child(current_level_root)
	current_level_root.name = "LevelRoot"
	_setup_level(current_level_root)
	
	
func _setup_level(level_root: Node) -> void:
	#connect player
	var player = level_root.get_node("Player")
	player.died.connect(_on_player_death)
	hud.set_player(player)
	var exit = level_root.get_node_or_null("Exit")
	
	if exit:
		exit.body_entered.connect(_on_exit_body_entered)

func _on_exit_body_entered(body: Node2D) -> void:
	if body.name == "Player":
		level += 1
		call_deferred("_load_level", level)
func _on_player_death()->void:
	await get_tree().create_timer(1.75).timeout
	await hud.fade(1.0)
	level = 1
	PlayerStats.reset()
	_load_level(level)
	await hud.fade(0)
