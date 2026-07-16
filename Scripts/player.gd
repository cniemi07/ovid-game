extends CharacterBody2D

signal died
const SPEED = 300.0
var alive: bool = true
var max_health: int  
var health: int  
var strength = 20
var is_attacking = false
var hitbox_offset: Vector2
var last_direction: Vector2 = Vector2.RIGHT

@onready var animated_sprite_2d: AnimatedSprite2D = $AnimatedSprite2D
@onready var swing: AudioStreamPlayer2D = $Swing
@onready var hitbox: Area2D = $Hitbox
@onready var damaged: AudioStreamPlayer2D = $Damaged
@onready var invincibility_frame: Timer = $invincibilityFrame

func _ready() -> void:
	#load health from singleton
	health = PlayerStats.health
	max_health = PlayerStats.max_health
	#initialize hitbox offset
	hitbox_offset = hitbox.position
	
	
func _physics_process(_delta: float) -> void:
	#disable hitbox  until attack
	hitbox.monitoring = false
	if alive:
		if Input.is_action_just_pressed("attack") and not is_attacking:
			attack()
			
		if is_attacking:
			velocity = Vector2.ZERO
			return
		
			
			
				
		process_movement()
		process_animation()
		move_and_slide()	
	
#----------------------------------
# 		MOVEMENT & ANIMATION
#----------------------------------


func process_movement() -> void:
			
	# Get the input direction and handle the movement/deceleration.
	# As good practice, you should replace UI actions with custom gameplay actions.
	var direction := Input.get_vector("left", "right", "up", "down")
	if direction != Vector2.ZERO:
		velocity = direction * SPEED
		last_direction = direction
		update_hitbox_offset()
	else:
		velocity = Vector2.ZERO
	
func process_animation()-> void:
	if is_attacking:
		return
	if velocity != Vector2.ZERO:
		play_animation("run", last_direction)
	else:
		play_animation("idle", last_direction)
func play_animation(prefix: String, dir: Vector2) -> void:
	if dir.x != 0:
		animated_sprite_2d.flip_h = dir.x < 0
		animated_sprite_2d.play(prefix + "Right")
	elif dir.y < 0:
		animated_sprite_2d.play(prefix + "Up")
	elif  dir.y > 0:
		animated_sprite_2d.play(prefix + "Down")
#----------------------------------
# 		 ATTACKING
#----------------------------------
func attack() ->  void:
	
	
	
	hitbox.monitoring = true
	is_attacking = true
	swing.play()
	play_animation("attack", last_direction)



func _on_animated_sprite_2d_animation_finished() -> void:
	if  is_attacking:
		is_attacking = false
#------------------------------------
#			   HITBOX
#------------------------------------
func update_hitbox_offset() -> void:
	var x = hitbox_offset.x
	var y = hitbox_offset.y
	
	match last_direction:	
		Vector2.LEFT:
			hitbox.position = Vector2(-x, y)
		Vector2.RIGHT:
			hitbox.position = Vector2(x, y)
		Vector2.UP:
			hitbox.position = Vector2(y, -x)
		Vector2.DOWN:
			hitbox.position = Vector2(-y, x)


func _on_hitbox_body_entered(body: Node2D) -> void:
	if is_attacking  and body.name.begins_with("Slime") :
		body.take_damage(strength, position)
		
signal health_changed(new_health: int)
 
func heal(amount: int) -> void:
	print("heal called, current health: ", health, " adding: ", amount)

	health += amount
	if health >= max_health:
		health=max_health
	PlayerStats.health = health
	emit_signal("health_changed", health)
	
func take_damage(damage:int)->void:
	if alive:
		if invincibility_frame.time_left > 0:
			return
		health -= damage
		health_changed.emit(health)
		PlayerStats.health =  health
		if health <= 0:
			die()
		damaged.play()
		invincibility_frame.start()
func die()->void:
	animated_sprite_2d.play("death")
	alive = false
	await animated_sprite_2d.animation_finished
	died.emit()
