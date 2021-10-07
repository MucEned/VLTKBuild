extends ColorRect

var paused = false setget set_pause
var Ki = ResourceLoader.Ki

var MainInstances = ResourceLoader.MainInstances

func set_pause(value):
	paused = value
	get_tree().paused = paused
	visible = paused 

# warning-ignore:unused_argument
func _process(delta):
	if Input.is_action_just_pressed("pause"):
		self.paused = not paused

func _ready():
	pass # Replace with function body.

func _on_QuitButton_pressed():
	get_tree().quit()

func _on_RestartButton_pressed():
	self.paused = false
# warning-ignore:return_value_discarded
	Ki.init_ki()
	get_tree().reload_current_scene()

func _on_ResumeButton_pressed():
	self.paused = false
