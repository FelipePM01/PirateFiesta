extends Node2D

@export var Focus: Node
const max_power=400
const power_multiplier=10
const cannonball_distance=100
const cannonball_impulse=50
@onready var cannonball=null
@onready var mode="move"
@onready var load_cannonball=preload("res://Scenes/cannonball.tscn")
@onready var playerlist=[$"../characters/Character1",$"../characters/Character2"]
@onready var playerid=0
# Called when the node enters the scene tree for the first time.
func _process(delta: float) -> void:
	$Line2D.clear_points()
	$Line2D.add_point(Focus.position)
	$Line2D.add_point(get_global_mouse_position())
	var green=lerp(1,0,min(Focus.position.distance_to(get_global_mouse_position()),max_power)/max_power)
	var red=lerp(0,1,min(Focus.position.distance_to(get_global_mouse_position()),max_power)/max_power)
	$Line2D.default_color=Color(red,green,0)
	if mode=="fire" and cannonball:
		cannonball.position=((-get_global_mouse_position()+Focus.position).normalized()*cannonball_distance)+Focus.position

func _physics_process(delta: float) -> void:
	if Input.is_action_just_pressed("shot"):
		$Line2D.visible=true
		if  mode=="fire":
			cannonball=load_cannonball.instantiate()
			get_parent().get_node("projectiles").add_child(cannonball)
		
			
	if Input.is_action_just_released("shot"):
		shot(min(max_power,Focus.position.distance_to(get_global_mouse_position())))
		$Line2D.visible=false
		cannonball=null
		

	

func shot(power:float) ->void:
	if mode=="move" and $"../Timer".is_stopped():
		Focus.apply_central_impulse((get_global_mouse_position()-Focus.position).normalized()*(-power*power_multiplier))
		mode="fire"
		$"../CanvasLayer/Control/Label".text="Fire!!!"
		
	if mode=="fire" and cannonball:
		cannonball.freeze=false
		cannonball.apply_impulse((cannonball.position-Focus.position).normalized()*(power)*cannonball_impulse)
		mode="move"
		$"../Timer".start()
		
	


func _on_timer_timeout() -> void:
	playerid=(playerid+1)%2
	Focus=playerlist[playerid]
	playerlist[playerid].get_node("Camera2D").make_current()
	if playerid==0:
		$"../CanvasLayer/Control/Label".text="Blue Pirate, Get That Bastard!"
	else:
		$"../CanvasLayer/Control/Label".text="Red Pirate, Get That Crybaby!"
