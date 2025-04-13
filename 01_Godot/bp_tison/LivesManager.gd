extends CanvasLayer
@onready var winner_menu = get_node("/root/Main/CanvasLayer/WinnerMenu")

var player1_lives = []
var player2_lives = []


func _ready():
	# Získaj všetky srdcia pre Player1
	for heart in $Player1Lives.get_children():
		player1_lives.append(heart)

	# Získaj všetky srdcia pre Player2
	for heart in $Player2Lives.get_children():
		player2_lives.append(heart)

func remove_life(player: int):
	if player == 1 and player1_lives.size() > 0:
		var heart = player1_lives.pop_back()
		heart.queue_free()

		if player1_lives.size() == 0:
			winner_menu.show_winner("Player 2")

	elif player == 2 and player2_lives.size() > 0:
		var heart = player2_lives.pop_back()
		heart.queue_free()

		if player2_lives.size() == 0:
			winner_menu.show_winner("Player 1")
