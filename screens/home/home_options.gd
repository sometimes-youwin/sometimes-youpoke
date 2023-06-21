extends MenuBar

signal option_selected(item: StringName)

const AppOptions := {
	SETTINGS = &"Settings",
	ABOUT = &"About",
	QUIT = &"Quit"
}

const ProjectOptions := {
	NEW = &"New",
	OPEN = &"Open",
	OPEN_RECENT = &"Open Recent",
}

const ToolboxOptions := {
	ADD = &"Add",
	IMPORT = &"Import",
	IMPORT_RECENT = &"Open Recent"
}

const PokeOptions := {
	NEW = &"New",
	CLONE = &"Clone"
}

const MENU_SPACER := "_menu_spacer_"

@onready
var _app: PopupMenu = %App

@onready
var _project: PopupMenu = %Project
@onready
var _recent_projects: PopupMenu = %RecentProjects

@onready
var _toolbox: PopupMenu = %Toolbox
@onready
var _recent_toolboxes: PopupMenu = %RecentToolboxes

@onready
var _poke: PopupMenu = %Poke

#-----------------------------------------------------------------------------#
# Builtin functions
#-----------------------------------------------------------------------------#

func _ready() -> void:
	for val in [
		AppOptions.SETTINGS,
		AppOptions.ABOUT,
		MENU_SPACER,
		AppOptions.QUIT
	]:
		match val:
			MENU_SPACER:
				_app.add_separator()
			_:
				_app.add_item(val)
	
	for val in [
		ProjectOptions.NEW,
		MENU_SPACER,
		ProjectOptions.OPEN,
		ProjectOptions.OPEN_RECENT
	]:
		match val:
			ProjectOptions.OPEN_RECENT:
				_project.add_submenu_item(ProjectOptions.OPEN_RECENT, _recent_projects.name)
			MENU_SPACER:
				_project.add_separator()
			_:
				_project.add_item(val)
	
	for val in [
		ToolboxOptions.ADD,
		MENU_SPACER,
		ToolboxOptions.IMPORT,
		ToolboxOptions.IMPORT_RECENT
	]:
		match val:
			ToolboxOptions.IMPORT_RECENT:
				_toolbox.add_submenu_item(ToolboxOptions.IMPORT_RECENT, _recent_toolboxes.name)
			MENU_SPACER:
				_toolbox.add_separator()
			_:
				_toolbox.add_item(val)
	
	for val in [
		PokeOptions.NEW,
		PokeOptions.CLONE
	]:
		match val:
			_:
				_poke.add_item(val)
	
	for pm in [_app, _project, _toolbox, _poke]:
		pm.index_pressed.connect(func(idx: int) -> void:
			option_selected.emit(pm.get_item_text(idx)))
	
	_recent_projects.about_to_popup.connect(func() -> void:
		_recent_projects.clear()
		Logger.nyi()
	)
	_recent_toolboxes.about_to_popup.connect(func() -> void:
		_recent_toolboxes.clear()
		Logger.nyi()
	)

#-----------------------------------------------------------------------------#
# Private functions
#-----------------------------------------------------------------------------#

#-----------------------------------------------------------------------------#
# Public functions
#-----------------------------------------------------------------------------#
