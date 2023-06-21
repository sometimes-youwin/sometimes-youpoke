extends MarginContainer

@onready
var _display: RichTextLabel = %Display

#-----------------------------------------------------------------------------#
# Builtin functions
#-----------------------------------------------------------------------------#

func _ready() -> void:
	var entry_container := %EntryContainer
	var flip_visibility := func() -> void:
		_display.visible = not _display.visible
		entry_container.visible = not entry_container.visible
	
	_display.gui_input.connect(func(event: InputEvent) -> void:
		if not event is InputEventMouseButton or not event.double_click:
			return
		
		flip_visibility.call()
	)
	
	var ok_button := %OkButton
	var name_entry := %NameEntry
	name_entry.text_changed.connect(func(text: String) -> void:
		if text.is_empty():
			ok_button.disabled = true
			return
		
		
	)
	var set_new_name := func(text: String) -> void:
		set_project_name(text)
		name_entry.text = _display.text
		flip_visibility.call()
	name_entry.text_submitted.connect(set_new_name)
	ok_button.pressed.connect(func() -> void:
		set_new_name.call(name_entry.text)
	)

#-----------------------------------------------------------------------------#
# Private functions
#-----------------------------------------------------------------------------#

#-----------------------------------------------------------------------------#
# Public functions
#-----------------------------------------------------------------------------#

func set_project_name(text: String) -> void:
	_display.text = text
