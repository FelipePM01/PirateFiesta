extends RigidBody2D

@export var frame=18
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	$Sprite2D.frame=frame


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func damage(dano : int) ->void:
	get_tree().quit()
