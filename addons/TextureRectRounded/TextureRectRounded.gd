@tool
class_name TextureRectRounded
extends TextureRect

@export var radius_bottom_left: int = 120:
	set(new_value):
		radius_bottom_left = new_value
		_set_corner_radius()

@export var radius_bottom_right: int = 120:
	set(new_value):
		radius_bottom_right = new_value
		_set_corner_radius()

@export var radius_top_left: int = 120:
	set(new_value):
		radius_top_left = new_value
		_set_corner_radius()

@export var radius_top_right: int = 120:
	set(new_value):
		radius_top_right = new_value
		_set_corner_radius()


func _ready():
	var shader_material = load(
		"res://addons/TextureRectRounded/TextureRectRoundedShaderMaterial.tres"
	)
	set_material(shader_material)
	resized.connect(self._on_resized)


func _set_corner_radius():
	# the factor is used to maintain the same corner_radius independent of the aspect ratio
	var tex_size: Vector2 = texture.get_size()
	var factor: float = (
		tex_size.x / tex_size.y if tex_size.x > tex_size.y else tex_size.y / tex_size.x
	)
	material.set_shader_parameter("corner_radius_bl", radius_bottom_left * factor)
	material.set_shader_parameter("corner_radius_br", radius_bottom_right * factor)
	material.set_shader_parameter("corner_radius_tl", radius_top_left * factor)
	material.set_shader_parameter("corner_radius_tr", radius_top_right * factor)


func _on_resized():
	_update_shader_params()


func _update_shader_params(_stretch_mode = stretch_mode):
	var start := Vector2(0.0, 0.0)
	var end := Vector2(1.0, 1.0)
	if _stretch_mode == StretchMode.STRETCH_KEEP_ASPECT_COVERED and texture != null:
		var tex_size: Vector2 = texture.get_size()
		var scale_size: Vector2 = Vector2(size.x / tex_size.x, size.y / tex_size.y)
		var scale: float = scale_size.x if scale_size.x > scale_size.y else scale_size.y
		var scaled_tex_size: Vector2 = tex_size * scale
		start = (((scaled_tex_size - size) / scale).abs() / 2.0) / tex_size
		end = (size / scale) / tex_size + start

	var shader_material: ShaderMaterial = material
	shader_material.set_shader_parameter("left_bound", start.x)
	shader_material.set_shader_parameter("right_bound", end.x)
	shader_material.set_shader_parameter("top_bound", start.y)
	shader_material.set_shader_parameter("bottom_bound", end.y)


func _set(property: StringName, value: Variant) -> bool:
	if property == "stretch_mode":
		_update_shader_params.call_deferred(value)
	elif property == "texture":
		_update_shader_params.call_deferred()
		_set_corner_radius.call_deferred()
	return false
