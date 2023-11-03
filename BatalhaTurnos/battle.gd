extends Control

signal textbox_closed

@export var enemy: Resource = null

var current_player_health = 0
var current_enemy_health = 0
var is_defending = false


func _ready():
	set_health($EnemyContainer/ProgressBar, enemy.health, enemy.health)
	set_health($PlayerPanel/PlayerData/ProgressBar, State.current_health, State.max_health)
	$EnemyContainer/Enemy.texture = enemy.texture
	
	current_player_health = State.current_health
	current_enemy_health = enemy.health
	
	$Perguntas.hide()
	$TextBox.hide()
	$ActionsPanel.hide()
	
	display_text("Um %s !" % enemy.name.to_upper())
	await self.textbox_closed
	$ActionsPanel.show()

func set_health(progress_bar, health, max_health):
	progress_bar.value = health
	progress_bar.max_value = max_health
	progress_bar.get_node("Label").text = "HP: %d/%d" % [health, max_health]

func _input(event):
	if (Input.is_action_just_pressed("ui_accept") or Input.is_mouse_button_pressed(MOUSE_BUTTON_LEFT)) and $TextBox.visible:
		$TextBox.hide()
		emit_signal("textbox_closed")

func display_text(text):
	$ActionsPanel.hide()
	$TextBox.show()
	$TextBox/Label.text = text

func enemy_turn():
	display_text("%s Inimigo te ataca!!" % enemy.name)
	await self.textbox_closed
	if is_defending:
		is_defending = false
		$AnimationPlayer.play("mini_shake")
		await $AnimationPlayer.animation_finished
		display_text("You defended successfully!")
		await self.textbox_closed
	else:
		current_player_health = max(0, current_player_health - enemy.damage)
		set_health($PlayerPanel/PlayerData/ProgressBar, current_player_health, State.max_health)
		$AnimationPlayer.play("shake")
		await $AnimationPlayer.animation_finished
		display_text("%s Causou %d de Dano!" % [enemy.name, enemy.damage])
		await self.textbox_closed
	$ActionsPanel.show()


func _on_ataque_pressed():
	display_text("Você Prepara sua Flecha")
	await self.textbox_closed
	
	
	current_enemy_health = max(0, current_enemy_health - State.damage)
	set_health($EnemyContainer/ProgressBar, current_enemy_health, enemy.health)

	$AnimationPlayer.play("enemy_damaged")
	await $AnimationPlayer.animation_finished
	
	
	display_text("Você Acertou uma Flecha e causou %d de Dano!" % State.damage)
	await self.textbox_closed
	
	if current_enemy_health == 0:
		display_text("%s was defeated!" % enemy.name)
		await self.textbox_closed
		
		$AnimationPlayer.play("enemy_died")
		await $AnimationPlayer.animation_finished
		
		await get_tree().create_timer(0.25).timeout
		get_tree().quit()

	enemy_turn()


func _on_defender_pressed():
	is_defending = true
	
	display_text("You prepare defensively!")
	await self.textbox_closed
	
	await get_tree().create_timer(0.25).timeout
	
	enemy_turn()
