extends CharacterBody2D


var speed = 10
var direction = Vector2.RIGHT

func _ready():
	direction = Vector2.RIGHT.rotated(global_rotation)
func _process(delta):
	velocity = direction * speed
	var collision = move_and_collide(velocity)
	
	if collision:
		queue_free()




	
	
