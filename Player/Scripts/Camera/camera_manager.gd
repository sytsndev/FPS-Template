class_name CameraManager
extends Camera3D


func change_fov(new_fov: float):
	self.set_fov(new_fov)


func smooth_change_fov(new_fov: float, duration: float = 0.25) -> void:
	var fov_tween = create_tween()
	fov_tween.tween_property(self, "fov", new_fov, duration) \
		.set_trans(Tween.TRANS_SINE) \
		.set_ease(Tween.EASE_OUT)
