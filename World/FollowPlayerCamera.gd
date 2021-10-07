extends Camera2D

var shake = 0
export (int) var Left_Limit_Ready = 0
export (int) var Right_Limit_Ready = 0
export (int) var Top_Limit_Ready = 0
export (int) var Bottom_Limit_Ready = 0

onready var timer = $Timer

func _ready():
# warning-ignore:return_value_discarded
	Events.connect("add_screenshake", self, "_on_Events_add_screenshake")
	
	limit_bottom = Bottom_Limit_Ready
	limit_top = Top_Limit_Ready
	limit_left = Left_Limit_Ready
	limit_right = Right_Limit_Ready

# warning-ignore:unused_argument
func _process(delta):
	offset_h = rand_range(-shake, shake)
	offset_v = rand_range(-shake, shake)

func screenshake(amount, duration):
	shake = amount
	timer.wait_time = duration
	timer.start()

func _on_Timer_timeout():
	shake = 0
	
func _on_Events_add_screenshake(amount, duration):
	screenshake(amount, duration)

# warning-ignore:unused_argument
func _on_CameraFree_body_entered(body):
	limit_bottom = 578
	limit_top = 0
	limit_left = Right_Limit_Ready
	limit_right = 9999999
