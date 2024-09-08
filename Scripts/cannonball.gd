extends RigidBody2D

@export var damage=100
@export var impulse=5000
@onready var affected_objects=[]
# Called when the node enters the scene tree for the first time.

func _on_body_entered(body: Node) -> void:
	for obj in affected_objects:
		if obj.has_method("apply_central_impulse"):
			obj.apply_central_impulse((obj.position-position).normalized()*impulse)
		if obj.has_method("damage"):
			obj.damage(damage)
	queue_free()

func _on_explosion_body_entered(body: Node2D) -> void:
	affected_objects.append(body)


func _on_explosion_body_exited(body: Node2D) -> void:
	affected_objects.erase(body)
	
