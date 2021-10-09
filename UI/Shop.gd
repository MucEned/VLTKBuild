extends Control

var DataCenter = ResourceLoader.SaverAndLoader
var Ki = ResourceLoader.Ki
onready var shop = $ItemList
onready var warning = $Warning
onready var warning_content = $Warning/RichTextLabel

var selecting_item = 0

var shop_items = [
	{
		"name": "S.Energy Core",
		"value": 90,
		"cost": 200,
		"vpc": 0.45,
		"solution": 0
	},
	{
		"name": "Energy Core",
		"value": 50,
		"cost": 130,
		"vpc": 0.3846,
		"solution": 0
	},
	{
		"name": "Battery",
		"value": 30,
		"cost": 80,
		"vpc": 0.375,
		"solution": 0
	},
	{
		"name": "Small Battery",
		"value": 11,
		"cost": 30,
		"vpc": 0.3667,
		"solution": 0
	}
]

var BCSF = 0 # gia lon nhat tam thoi == Best cost so far

func _ready():
#	DataCenter.set_current_coin(DataCenter.get_current_coin() + DataCenter.special_coin)
#
	shop.add_item("S.Energy Core - Cost:200")
	shop.set_item_tooltip(0,"+ 90 ep/use once")
	shop.add_item("Energy Core - Cost:130")
	shop.set_item_tooltip(1,"+ 50 ep/use once")
	shop.add_item("Battery - Cost: 80")
	shop.set_item_tooltip(2,"+ 30 ep/use once")
	shop.add_item("Small Battery - Cost:30")
	shop.set_item_tooltip(3,"+ 11 ep/use once")
	
	if DataCenter.load_player_data().current_max_ki < 100:
		shop.add_item("Upgrade - Cost:500")
		shop.set_item_tooltip(4,"+ 10 max ep")
	
	shop.select(3)
	pass # Replace with function body.

func _on_ItemList_item_selected(index):
	selecting_item = index
	pass # Replace with function body.

func _on_BuyButton_pressed():
	buy(selecting_item, 1)

# warning-ignore:unused_argument
func buy(item, quantity):
	if item < 4:
		if DataCenter.get_current_coin() >= shop_items[item]["cost"] * quantity:
			Ki.set_ki(Ki.Ki_value + shop_items[item]["value"] * quantity)
			DataCenter.set_current_coin(DataCenter.get_current_coin() - shop_items[item]["cost"] * quantity)
	if item == 4:
		if DataCenter.get_current_coin() >= 500 and DataCenter.load_player_data().current_max_ki < 100:
			var old_data = DataCenter.load_player_data()
			old_data.current_max_ki += 10
			DataCenter.save_player_data(old_data)
			DataCenter.set_current_coin(DataCenter.get_current_coin() - 500)
			Ki.set_ki(Ki.Ki_value + 10)
		if DataCenter.load_player_data().current_max_ki == 100:
			shop.remove_item(4)


func _on_QuickBuyButton_pressed():
	BCSF = 0
	for i in shop_items.size():
		shop_items[i]["solution"] = 0
		
	var current_coin = DataCenter.get_current_coin()

	var LBC = current_coin * shop_items[0]["vpc"] # can tren = lower bound cost
	var AVIG = 0# Tong gia tri == All value i got
	var coin_remain = current_coin
	var x = [0,0,0,0]

	branch_and_bound(0, LBC, AVIG, coin_remain, x)
	update_warning_content()
	warning.visible = true

func update_best_solution(AVIG, x):
	if BCSF < AVIG:
		BCSF = AVIG
		for i in 4:
			shop_items[i]["solution"] = x[i]

func branch_and_bound(i, LBC, AVIG, coin_remain, x):
	var maximum_i_can_choose = coin_remain/shop_items[i]["cost"]
	
	for t in (maximum_i_can_choose + 1):
		var j = maximum_i_can_choose - t
		AVIG = AVIG + j * shop_items[i]["value"]
		coin_remain = coin_remain - j*shop_items[i]["cost"]
		if i != shop_items.size()-1:
			LBC = AVIG + coin_remain * shop_items[i+1]["vpc"]
		if LBC > BCSF:
			x[i] = j
			if i == shop_items.size() - 1 or coin_remain == 0.0:
				update_best_solution(AVIG, x)
			else:
				branch_and_bound(i+1, LBC, AVIG, coin_remain, x)
		x[i] = 0
		AVIG = AVIG - j * shop_items[i]["value"]
		coin_remain = coin_remain + j * shop_items[i]["cost"]

func update_warning_content():
	warning_content.clear()
	var poor_player = true
	var total_cost = 0
	var total_value = 0
	
	var content = "Your cart have:\n\n"
	for i in shop_items.size():
		if shop_items[i]["solution"] != 0:
			poor_player = false
			content += str(shop_items[i]["solution"]) + "    x    " + shop_items[i]["name"] + "\n\n"
			total_cost += shop_items[i]["cost"] * shop_items[i]["solution"]
			total_value += shop_items[i]["value"] * shop_items[i]["solution"]
	
	if not poor_player:
		content += "Total: " + str(total_cost) + " coins with: " + str(total_value) + " energy"
	else:
		content = "Poor you :(\n You can't buy any items :("
	warning_content.text = content

func _on_Accept_pressed():
	for i in shop_items.size():
		if shop_items[i]["solution"] != 0:
			buy(i,shop_items[i]["solution"])
			
	warning.visible = false
	pass # Replace with function body.

func _on_Cancel_pressed():
	warning.visible = false
	pass # Replace with function body.
