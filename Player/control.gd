extends Control


@export var wall_run_timer: Label
@export var wall_run: PlayerState


func _process(delta: float) -> void:
	wall_run_timer.text = str(wall_run.wall_run_timer)
