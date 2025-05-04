class_name Boss
extends CharacterBody3D

@export var movement_speed: float = 5.0
@export var hero: Hero

@onready var nav_agent: NavigationAgent3D = $NavigationAgent3D
@onready var health: Health = $Health

@onready var states: Dictionary[Script, BossStage] = {
	BossChasing: %Chasing,
	BossBombs: %Bombs,
	BossWaiting: %Waiting
}

# 1. Chasing to hero + Attack around
# 2. Spawn bombs to enemies (2-3 bombs)
# 3. Wait 2-3 sec

var previous_stage: Script
var current_stage: BossStage

func _ready() -> void:
	if hero != null:
		initialize(hero)

func initialize(hero: Hero) -> void:
	self.hero = hero
	switch_to(BossWaiting)

func switch_to(type: Script) -> void:
	if current_stage != null:
		current_stage.stop()
	previous_stage = type
	var next_stage = states[type]
	current_stage = next_stage
	next_stage.start()

func _process(delta: float) -> void:
	if current_stage == null:
		return
	
	current_stage.process(delta)

func _process_movement(delta: float) -> void:
	var next_position := nav_agent.get_next_path_position()
	global_position = global_position.move_toward(next_position, delta * movement_speed)
	next_position.y = 0
	look_at(next_position)

func hud_set_active(is_active: bool) -> void:
	$CanvasLayer.visible = is_active
