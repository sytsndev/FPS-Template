class_name CameraManager
extends Camera3D


func change_fov(new_fov: float):
	self.set_fov(new_fov)


func smooth_change_fov(new_fov: float, duration: float = 0.25) -> void:
	var fov_tween = create_tween()
	fov_tween.tween_property(self, "fov", new_fov, duration) \
		.set_trans(Tween.TRANS_SINE) \
		.set_ease(Tween.EASE_OUT)


func rot_camera(rot: Vector3):
	rotation = rot


func smooth_rot_camera(rot: Vector3, duration: float = 0.10):
	var rot_tween = create_tween()
	rot_tween.tween_property(self, "rotation", rot, duration) \
		.set_trans(Tween.TRANS_SINE) \
		.set_ease(Tween.EASE_OUT)
