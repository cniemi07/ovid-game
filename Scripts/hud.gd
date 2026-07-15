extends CanvasLayer

const HEART_SIZE: int = 20
const HEART_FULL = preload("res://Assets/Images/UI/HeartFull.png")
const HEART_HALF = preload("res://Assets/Images/UI/HeartHalf.png")
const HEART_EMPTY = preload("res://Assets/Images/UI/HeartEmpty.png")

@onready var fade_overlay: ColorRect = $FadeOverlay
@onready var hearts_container: HBoxContainer = $Hearts

func _update_health(new_health:int)->void:
	var hearts = hearts_container.get_children()
	var max_hearts = len(hearts)
	var full = int(new_health / HEART_SIZE)
	var half = 1 if (new_health % HEART_SIZE) > 0 else 0
	var empty = max_hearts - (full + half)
	
	#update full hearts
	for i in full:
		hearts[i].texture = HEART_FULL
	if half:
		hearts[full].texture = HEART_HALF
	for i in empty:
		hearts[(len(hearts)-1)-i].texture = HEART_EMPTY
	
func fade(to_alpha: float)->void:
	var tween:= create_tween()
	tween.tween_property(fade_overlay, "modulate:a", to_alpha, 1.75)
	await tween.finished
	
var player = null

func set_player(p) -> void:
	player = p
	if player:
		player.health_changed.connect(_update_health)
		_update_health(player.health)  # initialize hearts immediately
