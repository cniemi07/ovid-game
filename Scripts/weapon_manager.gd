extends Node2D


@onready var weapons =  get_children()
var weapon_num = 0

func _ready() -> void:
	var i = 1
	for weapon in weapons:
		toggle_weapon(weapon, false)
	toggle_weapon(weapons[weapon_num], true)
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if Input.is_action_just_pressed("swap_weapon"):
		toggle_weapon(weapons[weapon_num], false)
		weapon_num = (weapon_num + 1) % weapons.size()
		toggle_weapon(weapons[weapon_num], true)
		
func toggle_weapon(weapon, active: bool)->void:
	if active == false:
		weapon.set_process(false)
		weapon.hide()
	else: 
		weapon.set_process(true)
		weapon.show()
