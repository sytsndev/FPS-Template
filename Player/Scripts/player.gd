class_name Player extends CharacterBody3D

var speed := 10.0
var gravity := -40.0
var jump_gravity := -20.0
var jump_impulse := 10.0

var is_paused: bool = false

@export var neck: Node3D
@export var camera: Camera3D
@export var player_res: PlayerRes
