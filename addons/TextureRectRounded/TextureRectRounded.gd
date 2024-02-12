@tool
class_name TextureRectRounded
extends Panel

@export var corner_detail: int = 8:
	set(new_value):
		corner_detail = new_value
		_update_panel_values()
		

@export var radius_bottom_left: int = 8:
	set(new_value):
		radius_bottom_left = new_value
		_update_panel_values()


@export var radius_bottom_right: int = 8:
	set(new_value):
		radius_bottom_right = new_value
		_update_panel_values()


@export var radius_top_left: int = 8:
	set(new_value):
		radius_top_left = new_value
		_update_panel_values()


@export var radius_top_right: int = 8:
	set(new_value):
		radius_top_right = new_value
		_update_panel_values()


@export var texture: Texture2D = null:
	set(new_value):
		texture = new_value
		texture_rect.texture = texture


@export var anti_aliasing: bool = false:
	set(new_value):
		anti_aliasing = new_value
		_update_panel_values()


@export var expand_mode: TextureRect.ExpandMode = TextureRect.ExpandMode.EXPAND_IGNORE_SIZE:
	set(new_value):
		expand_mode = new_value
		texture_rect.expand_mode = expand_mode


@export var stretch_mode: TextureRect.StretchMode = TextureRect.StretchMode.STRETCH_SCALE:
	set(new_value):
		stretch_mode = new_value
		texture_rect.stretch_mode = stretch_mode


@export var flip_h: bool = false:
	set(new_value):
		flip_h = new_value
		texture_rect.flip_h = flip_h


@export var flip_v: bool = false:
	set(new_value):
		flip_h = new_value
		texture_rect.flip_v = flip_v


var stylebox = StyleBoxFlat.new()
var texture_rect = TextureRect.new()

func _ready():
	clip_children = CanvasItem.CLIP_CHILDREN_ONLY
	
	add_theme_stylebox_override("panel", stylebox)
	_update_panel_values()
	
	texture_rect.expand_mode = expand_mode
	texture_rect.set_anchors_and_offsets_preset(Control.PRESET_FULL_RECT)
	add_child(texture_rect)


func _update_panel_values():
	stylebox.corner_radius_bottom_left = radius_bottom_left
	stylebox.corner_radius_bottom_right = radius_bottom_right
	stylebox.corner_radius_top_left = radius_top_left
	stylebox.corner_radius_top_right = radius_top_right
	stylebox.anti_aliasing = anti_aliasing
	stylebox.corner_detail = corner_detail
