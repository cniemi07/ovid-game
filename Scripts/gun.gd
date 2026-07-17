extends Node2D

@export var bullet: PackedScene
@export var bullet_count: int = 1

@export_range(0, 360) var arc: float = 0
@export_range(0, 20) var fire_rate: float = 2.0
@export_range(0, 1000) var kickback: float = 200.0

@onready var muzzle: Marker2D = $Marker2D
@onready var Gunshot: AudioStreamPlayer2D = $Gunshot


var can_shoot = true
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	#print("gun processing")
	look_at(get_global_mouse_position())
	
	rotation_degrees = wrap(rotation_degrees, 0, 360)
	if rotation_degrees > 90 and rotation_degrees < 270:
		scale.y = -1
	else:
		scale.y = 1
	if Input.is_action_just_pressed("Shoot"):
		shoot()
		
func shoot()->void:
	#print(arc)
	#print(bullet_count)
	if can_shoot:
		can_shoot = false
		var recoil_dir = (global_position - get_global_mouse_position()).normalized()
		get_parent().get_parent().apply_kickback(recoil_dir * kickback)

		for i in bullet_count:
			Gunshot.play()
			var bullet_instance = bullet.instantiate()
			if bullet_count == 1:
				bullet_instance.rotation =  global_rotation
			else:
				var arc_rad = deg_to_rad(arc)
				var increment = arc_rad / (bullet_count - 1)
				bullet_instance.global_rotation = (
					global_rotation + 
					increment * i -
					arc_rad / 2
				)
			
			bullet_instance.global_position =  muzzle.global_position
			get_tree().root.add_child(bullet_instance)
		await get_tree().create_timer(1/fire_rate).timeout
	
		can_shoot = true
