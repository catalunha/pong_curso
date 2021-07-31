extends Node2D

const BALL_SPEED = 150
const PLAYER_SPEED = 80

var screen_size
var player_size

var ball_position
var ball_direction
var ball_speed = BALL_SPEED

var player_left_goal = 0
var player_rigth_goal = 0

func _ready():
	print('Hello Pong...')
	screen_size = get_viewport_rect().size
	$BallSprite.position = screen_size * 0.5
	ball_position = $BallSprite.position
	ball_direction = Vector2(1,-1)
	randomize()
	player_size = $PlayerLeftSprite.get_texture().get_size()
	$HUDNode/PlayerLeftGoalLabel.text = '0'
	$HUDNode/PlayerRigthGoalLabel.text = '0'

func _process(delta):
	# Ball recebe valores iniciais ou atualizados
	ball_position = ball_position + ball_direction * ball_speed * delta

	# a Ball toca no top e embaixo e volta ao jogo
	if (ball_position.y < 0 or ball_position.y > screen_size.y):
		ball_touch_up_down()

	# a Ball toca as laterais esq e dir e reinicia a partida. (E marca gol [nao implementado] )
	if (ball_position.x < 0 or ball_position.x > screen_size.x):
		ball_touch_left_right()

	# Movimentar PlayerRight
	player_right_moving(delta)

	# Movimentar PlayerLeft
	player_left_moving(delta)

	# Cria rect2 envolta dos player para controle de bordas
	var player_left_rect2 = Rect2($PlayerLeftSprite.position-player_size/2,player_size)
	var player_right_rect2 = Rect2($PlayerRightSprite.position-player_size/2,player_size)

	# Bola bate no player da esquerda ou da direita
	if(player_left_rect2.has_point(ball_position) or player_right_rect2.has_point(ball_position)):
		ball_touch_player()

	# Ball recebe valores atualizados
	$BallSprite.position = ball_position



func player_right_moving(delta):
	var player_right_position = $PlayerRightSprite.position
	if (Input.is_action_pressed("ui_up") and player_right_position.y > 0):
		player_right_position.y = player_right_position.y - PLAYER_SPEED * delta
	if (Input.is_action_pressed("ui_down") and player_right_position.y < screen_size.y):
		player_right_position.y = player_right_position.y + PLAYER_SPEED * delta
	$PlayerRightSprite.position = player_right_position

func player_left_moving(delta):
	var player_left_position = $PlayerLeftSprite.position
	if (Input.is_action_pressed("ui_key_w") and player_left_position.y > 0):
		player_left_position.y = player_left_position.y - PLAYER_SPEED * delta
	if (Input.is_action_pressed("ui_key_s") and player_left_position.y < screen_size.y):
		player_left_position.y = player_left_position.y + PLAYER_SPEED * delta
	$PlayerLeftSprite.position = player_left_position

func ball_touch_up_down():
	ball_direction.y = -1 * ball_direction.y

func ball_touch_left_right():
	if ball_position.x < 0:
		ball_touch_left_goal()
	if ball_position.x > screen_size.x:
		ball_touch_right_goal()
	ball_position = screen_size * 0.5
	ball_direction = Vector2(randf()*2.0-1.0,0).normalized()
	ball_speed = BALL_SPEED

func ball_touch_left_goal():
	player_rigth_goal = player_rigth_goal + 1
	$HUDNode/PlayerRigthGoalLabel.text = str(player_rigth_goal)

func ball_touch_right_goal():
	player_left_goal = player_left_goal + 1
	$HUDNode/PlayerLeftGoalLabel.text = str(player_left_goal)

func ball_touch_player():
	ball_direction.x = ball_direction.x * -1
	ball_direction.y = randf()*2.0-1.0
	ball_direction = ball_direction.normalized()
	ball_speed = ball_speed * 1.10
