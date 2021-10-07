extends CanvasLayer

onready var shop = $Shop

func _ready():
	pass # Replace with function body.


# warning-ignore:unused_argument
func _on_CameraFree_body_entered(body):
	shop.visible = false
