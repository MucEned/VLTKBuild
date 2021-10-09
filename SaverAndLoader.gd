extends Resource
class_name SaverAndLoader

#127
const SAVE_DIR = "user://saves/"
var player_save_path = SAVE_DIR + "ủplayer.dat"
var game_save_path = SAVE_DIR + "ủgame.dat"

var player_default = {
	"bell": false,
	"current_max_ki": 50,
	"weapons": [false,false,false]
}

var game_default = {
	"highest_score": 0,
	"coin": 0
}

var game_cheat = {
	"highest_score": 0,
	"coin": 999999
}

var special_coin = 127

var current_coin = 0
signal current_coin_changed(value)

func reinit():
	save_player_data(player_default)
	save_game_data(game_default)

func debug_func():
	save_player_data(player_default)

func cheat():
	save_game_data(game_cheat)

func get_current_coin():
	current_coin = load_game_data()["coin"]
	return current_coin
	
func set_current_coin(value):
	current_coin = value
	emit_signal("current_coin_changed", current_coin)
	var temp_data = load_game_data()
	temp_data["coin"] = current_coin
	save_data(game_save_path, temp_data)

func save_player_data(data):
	save_data(player_save_path, data)

func load_player_data():
	return load_data(player_save_path, player_default)
			
func save_game_data(data):
	save_data(game_save_path, data)
	
func load_game_data():
	return load_data(game_save_path, game_default)

func load_data(save_path, default_data):
	var data
	var file = File.new()
	if file.file_exists(save_path):
		var res = file.open(save_path, File.READ)
		if res == OK:
			data = file.get_var()
			file.close()
			return data
	else:
		save_player_data(default_data)
		return default_data

func save_data(save_path, data):
	var new_data = data

	var dir = Directory.new()
	if !dir.dir_exists(SAVE_DIR):
		dir.make_dir_recursive(SAVE_DIR)
	
	var file = File.new()
	var res = file.open(save_path, File.WRITE)
	if res == OK:
		file.store_var(new_data)
		file.close()
