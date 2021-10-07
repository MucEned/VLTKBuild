extends Label

var DataCenter = ResourceLoader.SaverAndLoader

func _ready():
	DataCenter.connect("current_coin_changed", self, "_on_current_coin_changed")
	text = str(DataCenter.get_current_coin())
	pass # Replace with function body.

func _on_current_coin_changed(value):
	text = str(value)
# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
