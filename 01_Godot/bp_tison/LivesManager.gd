extends CanvasLayer

# Referencie na UI a časovače
@onready var winner_menu = get_node("/root/Main/CanvasLayer/WinnerMenu")
@onready var regen_timer_player1 = $RegenTimerPlayer1
@onready var regen_timer_player2 = $RegenTimerPlayer2
@onready var score_label_1 = $ScoreLabel1
@onready var score_label_2 = $ScoreLabel2
@onready var game_timer_label = $GameTimerLabel
@onready var game_timer = $GameTimer

# Zoznam aktuálnych srdiečok (životov) hráčov
var player1_lives = []
var player2_lives = []

# Skóre pre oboch hráčov
var player1_score: int = 0
var player2_score: int = 0

const MAX_LIVES = 4                # Maximálny počet životov
var total_seconds = 120            # Dĺžka zápasu v sekundách (2 minúty)
var game_over = false              # Indikácia, či už hra skončila

# Počet životov, ktoré čakajú na regeneráciu
var pending_regen_player1 = 0
var pending_regen_player2 = 0

func _ready():
	# Naplnenie zoznamov aktuálnych životov pre oboch hráčov
	for heart in $Player1Lives.get_children():
		player1_lives.append(heart)

	for heart in $Player2Lives.get_children():
		player2_lives.append(heart)

	# Nastavenie regenerácie – život sa obnoví po 10 sekundách
	regen_timer_player1.wait_time = 10
	regen_timer_player1.one_shot = true

	regen_timer_player2.wait_time = 10
	regen_timer_player2.one_shot = true

	# Zobrazenie počiatočného skóre a času
	score_label_1.text = "Score: %d" % player1_score
	score_label_2.text = "Score: %d" % player2_score
	game_timer_label.text = format_time(total_seconds)

# Pomocná funkcia na formátovanie času do mm:ss
func format_time(seconds: int) -> String:
	@warning_ignore("integer_division")
	var mins = seconds / 60
	var secs = seconds % 60
	return "%02d:%02d" % [mins, secs]

# Odobratie života danému hráčovi
func remove_life(player: int):
	if player == 1 and player1_lives.size() > 0:
		var heart = player1_lives.pop_back()
		heart.queue_free()

		# Pripočítaj skóre hráčovi 2 (útočník)
		player2_score += 1
		score_label_2.text = "Score: %d" % player2_score

		if player1_lives.size() == 0:
			# Hráč 1 prehral – vyhlás víťaza
			winner_menu.show_winner("Player 2")
		else:
			# Pridaj život do fronty na regeneráciu
			pending_regen_player1 += 1
			if regen_timer_player1.is_stopped():
				regen_timer_player1.start()

	elif player == 2 and player2_lives.size() > 0:
		var heart = player2_lives.pop_back()
		heart.queue_free()

		player1_score += 1
		score_label_1.text = "Score: %d" % player1_score

		if player2_lives.size() == 0:
			winner_menu.show_winner("Player 1")
		else:
			pending_regen_player2 += 1
			if regen_timer_player2.is_stopped():
				regen_timer_player2.start()

# Časovač pre hráča 1 – pokus o doplnenie jedného života
func _on_regen_timer_player_1_timeout() -> void:
	if pending_regen_player1 > 0 and player1_lives.size() < MAX_LIVES:
		var heart = TextureRect.new()
		heart.texture = preload("res://assets/HP.png")
		heart.stretch_mode = TextureRect.STRETCH_KEEP_ASPECT_CENTERED
		heart.custom_minimum_size = Vector2(32, 32)

		$Player1Lives.add_child(heart)
		player1_lives.append(heart)

		pending_regen_player1 -= 1

	# Ak sú ešte životy v poradí, spusti časovač znova
	if pending_regen_player1 > 0:
		regen_timer_player1.start()

# Časovač pre hráča 2 – pokus o doplnenie jedného života
func _on_regen_timer_player_2_timeout() -> void:
	if pending_regen_player2 > 0 and player2_lives.size() < MAX_LIVES:
		var heart = TextureRect.new()
		heart.texture = preload("res://assets/HP.png")
		heart.stretch_mode = TextureRect.STRETCH_KEEP_ASPECT_CENTERED
		heart.custom_minimum_size = Vector2(32, 32)

		$Player2Lives.add_child(heart)
		player2_lives.append(heart)

		pending_regen_player2 -= 1

	if pending_regen_player2 > 0:
		regen_timer_player2.start()

# Každú sekundu aktualizuj časovač hry
func _on_game_timer_timeout():
	if game_over:
		return

	total_seconds -= 1
	game_timer_label.text = format_time(total_seconds)

	if total_seconds <= 0:
		game_timer.stop()
		game_over = true
		decide_winner_by_score()

# Vyhodnotenie víťaza na základe skóre po uplynutí času
func decide_winner_by_score():
	if player1_score > player2_score:
		winner_menu.show_winner("Player 1")
	elif player2_score > player1_score:
		winner_menu.show_winner("Player 2")
	else:
		winner_menu.show_winner("Nobody")  # Remíza

	get_tree().paused = true
