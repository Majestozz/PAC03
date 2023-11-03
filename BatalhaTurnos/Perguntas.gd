extends Control 

# Define a pergunta, as opções de resposta e a resposta correta.
var pergunta = "Qual é a capital da França?"
var opcoes_resposta = ["Berlim", "Madrid", "Paris"]
var resposta_correta = "Paris"

func _ready():
	# Chame a função para fazer a pergunta quando o jogo iniciar.
	fazer_pergunta()

func fazer_pergunta():
	# Embaralhe as opções de resposta para que a correta não seja sempre a mesma.
	opcoes_resposta.shuffle()

	# Exiba a pergunta e as opções de resposta na tela.
	print(pergunta)
	for i in range(opcoes_resposta.size()):
		print(str(i + 1) + ". " + opcoes_resposta[i])

	# Armazene a resposta correta em uma variável para verificar mais tarde.
	var resposta_correta_idx = opcoes_resposta.find(resposta_correta)

	# Agora você pode verificar a resposta do jogador comparando o índice da opção selecionada.
	# Por exemplo, se o jogador escolher a opção 2 (Madrid):
	var resposta_do_jogador = 2

	if resposta_do_jogador - 1 == resposta_correta_idx:
		print("Resposta correta!")
		# Faça o que quiser quando o jogador acertar a pergunta.
	else:
		print("Resposta incorreta. Tente novamente.")
		# Faça o que quiser quando o jogador errar a pergunta.
