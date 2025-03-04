extends TileMapLayer

class_name DrawSnake

var P1_curves_pos: Array = []
var P1_curves_types: Array = []
var P1_body_types: Array = []
var tail_type = TILE_TAIL_RIGHT

const TILE_HEAD_RIGHT = Vector2i(1,0) 
const TILE_HEAD_LEFT = Vector2i(-1,0)
const TILE_HEAD_UP = Vector2i(0,-1) 
const TILE_HEAD_DOWN = Vector2i(0,1)
const TILE_BODY_HOR = Vector2i(1,0)
const TILE_BODY_VER = Vector2i(0,1)
const TILE_BODY_HOR2 = Vector2i(-1,0)
const TILE_BODY_VER2 = Vector2i(0,-1)
const TILE_CURVE_1 = Vector2i(-1,1)
const TILE_CURVE_2 = Vector2i(1,-1)
const TILE_CURVE_3 = Vector2i(-1,-1)
const TILE_CURVE_4 = Vector2i(1,1)
const TILE_TAIL_RIGHT = Vector2i(1,0) 
const TILE_TAIL_LEFT = Vector2i(-1,0)
const TILE_TAIL_UP = Vector2i(0,-1) 
const TILE_TAIL_DOWN = Vector2i(0,1)

func find_curves_and_straight(body: Array, block_size):
	var body_positions = body.duplicate(true)
	# Adiciona curvas corretamente
	if body_positions[0].x - block_size == body_positions[2].x and body_positions[0].y - block_size == body_positions[2].y:

		if body_positions[0].y - block_size == body_positions[1].y:
			P1_curves_pos.append(body_positions[1])  # Adiciona no final
			P1_curves_types.append(Vector2i(-1,+1))
			P1_body_types[0] = (Vector2i(-1,+1))
			
		if body_positions[0].x - block_size == body_positions[1].x:
			P1_curves_pos.append(body_positions[1])
			P1_curves_types.append(Vector2i(+1,-1))
			P1_body_types[0] = (Vector2i(+1,-1))

	if body_positions[0].x + block_size == body_positions[2].x and body_positions[0].y + block_size == body_positions[2].y:
		if body_positions[0].y + block_size == body_positions[1].y:
			P1_curves_pos.append(body_positions[1])
			P1_curves_types.append(Vector2i(+1,-1))
			P1_body_types[0] = (Vector2i(+1,-1))
		if body_positions[0].x + block_size == body_positions[1].x:
			P1_curves_pos.append(body_positions[1])
			P1_curves_types.append(Vector2i(-1,+1))
			P1_body_types[0] = (Vector2i(-1,+1))

	if body_positions[0].x + block_size == body_positions[2].x and body_positions[0].y - block_size == body_positions[2].y:
		if body_positions[0].x + block_size == body_positions[1].x:
			P1_curves_pos.append(body_positions[1])
			P1_curves_types.append(Vector2i(-1,-1))
			P1_body_types[0] = (Vector2i(-1,-1))
		else:
			P1_curves_pos.append(body_positions[1])
			P1_curves_types.append(Vector2i(+1,+1))
			P1_body_types[0] = (Vector2i(+1,+1))

	if body_positions[0].x - block_size == body_positions[2].x and body_positions[0].y + block_size == body_positions[2].y:
		if body_positions[0].x - block_size == body_positions[1].x:
			P1_curves_pos.append(body_positions[1])
			P1_curves_types.append(Vector2i(+1,+1))
			P1_body_types[0] = (Vector2i(+1,+1))
		else:
			P1_curves_pos.append(body_positions[1])
			P1_curves_types.append(Vector2i(-1,-1))
			P1_body_types[0] = (Vector2i(-1,-1))

	# Remove curva mais antiga se a cauda alcançar
	if P1_curves_pos.size() > 0:
		var tail_pos = body_positions[body_positions.size() - 1]
		if tail_pos == P1_curves_pos[0]:  # Agora verificando corretamente a curva mais antiga
			P1_curves_pos.pop_front()
			P1_curves_types.pop_front()
			print(P1_curves_pos, "curva removida")
			print(body_positions.size() - 1, "rabo")
			print("apagado")

func initialize_body_types(body_size, initial_direction):
	P1_body_types.clear()
	for i in range(body_size):
		P1_body_types.append(initial_direction)  
	print_debug_state("Inicializando os tipos do corpo")

func update_body_types(body: Array,direction):
	var body_positions = body.duplicate(true)
	while P1_body_types.size() < body_positions.size():
		if P1_body_types.size() < body_positions.size():
			print("parte adicionada")
			P1_body_types.push_back(P1_body_types[P1_body_types.size()-1])

	for i in range(P1_body_types.size()- 3, -1, -1):
		P1_body_types[i+1] = P1_body_types[i]

	P1_body_types[0] = direction

	var cont = P1_body_types.size()-1
	var cont2 = body_positions[cont-2]
	var cont1 = body_positions[cont-1]  # Penúltima posição
	var cont0 = body_positions[cont]  # Última posição (onde a cauda estará)

	print_debug_state("Tipos de corpo atualizados: " + str(P1_body_types))
	match P1_body_types[cont-2]:
		TILE_CURVE_1:  # ↘ Curva de cima para a direita
			if cont1.x > cont0.x:
				tail_type = TILE_TAIL_RIGHT
				print("tipo 1 cur" , tail_type)
			elif cont1.y > cont0.y:
				tail_type = TILE_TAIL_DOWN
				print("tipo 2 cur" , tail_type) #
			elif cont1.y < cont0.y:
				tail_type = TILE_TAIL_UP #
				print("tipo 3 cur", tail_type) #
			elif cont2.x < cont0.x:
				tail_type = TILE_TAIL_LEFT #
				print("tipo 4 cur" , tail_type) 
			else:
				print("excessao cur")

		TILE_CURVE_2:  # ↙ Curva de cima para a esquerda
			if cont1.x < cont0.x:
				tail_type = TILE_TAIL_LEFT
				print("tipo 1 cur2" , tail_type)
			elif cont1.y > cont0.y:
				tail_type = TILE_TAIL_DOWN  #
				print("tipo 2 cur2" , tail_type)
			elif cont2.x > cont0.x :
				tail_type = TILE_TAIL_RIGHT
				print("tipo 3 cur2" , tail_type)
			elif cont2.x < cont0.x:
				tail_type = TILE_TAIL_UP
				print("tipoe 5 cur2 zigzag" , tail_type)
			else:
				
				print("excessao cur2")

		TILE_CURVE_3:  # ↖ Curva de baixo para a esquerda	
			if cont1.x < cont0.x:
				tail_type = TILE_TAIL_LEFT
				print("tipo 1 cur3" , tail_type)
			elif cont1.x > cont0.x:
				tail_type = TILE_TAIL_RIGHT
				print("tipo 2 cur3" , tail_type)
			elif cont1.y > cont0.y:
				tail_type = TILE_TAIL_DOWN
				print("tipo 3 cur3" , tail_type)
			elif cont2.x > cont0.x:
				tail_type = TILE_TAIL_UP
				print("tipo 4 cur3 zigzag" , tail_type)
			else:
				print("excessao cur3")

		TILE_CURVE_4:  # ↗ Curva de baixo para a direita
			if cont1.x > cont0.x:
				tail_type = TILE_TAIL_RIGHT
				print("tipo 1 cur4" , tail_type)
			elif cont1.x < cont0.x:
				tail_type = TILE_TAIL_LEFT #
				print("tipo 2 cur4" , tail_type)
			elif cont1.y < cont0.y:
				tail_type = TILE_TAIL_UP
				print("tipo 3 cur4", tail_type)
			elif cont2.x < cont0.x:
				tail_type = TILE_TAIL_DOWN
				print("tipo 4 cur4")
			else:
				print("excessao cur4")

		TILE_BODY_HOR:
			if cont1.x > cont0.x:
				tail_type = TILE_TAIL_RIGHT #
				print("tipo 1 hor", tail_type)
			elif cont1.y > cont0.y:
				tail_type = TILE_TAIL_DOWN #
				print("tipo 2 hor", tail_type)
			elif cont1.y < cont0.y:
				tail_type = TILE_TAIL_UP
				print("tipo 3 hor" , tail_type)
			else:
				print("excessao hor")

		TILE_BODY_VER:
			if cont1.x > cont0.x:
				tail_type = TILE_TAIL_RIGHT ##
				print("tipo 1 ver", tail_type)
			elif cont1.x < cont0.x:
				tail_type = TILE_TAIL_LEFT ##
				print("tipo 2 ver", tail_type)
			elif cont1.y > cont0.y:
				tail_type = TILE_TAIL_DOWN
				print("tipo 3 ver")
			elif cont0.y < cont2.y:
				tail_type = TILE_TAIL_DOWN
				print("tipo 4 ver")
			else:
				tail_type = TILE_HEAD_DOWN
				print("excessao ver")

		TILE_BODY_HOR2:
			if cont1.y > cont0.y:
				tail_type = TILE_TAIL_DOWN ##
				print("tipo 1 hor2", tail_type)
			elif cont1.y < cont0.y:
				tail_type = TILE_TAIL_UP #
				print("tipo 2 hor2", tail_type)
			elif cont1.x < cont0.x:
				tail_type = TILE_TAIL_LEFT #
				print("tipo 3 hor2", tail_type)
			else:
				print("excessao hor2")
				

		TILE_BODY_VER2:
			if cont1.x < cont0.x:
				tail_type = TILE_TAIL_LEFT #
				print("tipo 1 ver2", tail_type)
			elif cont1.x > cont0.x:
				tail_type = TILE_TAIL_RIGHT #
				print("tipo 2 ver2", tail_type)
			elif cont0.y > cont1.y:
				tail_type = TILE_HEAD_UP #
				print("tipe 2 ver3" ,tail_type) 
				
			elif cont0.y < cont2.y:
				tail_type = TILE_HEAD_DOWN
			else:
				tail_type = TILE_HEAD_UP
				print("excessao ver2")

	P1_body_types[cont] = tail_type

func print_debug_state(msg):
		print("\n=== DEBUG: " + msg + " ===")
		print("P1_body_types:", P1_body_types)
		print("P1_curves_pos:", P1_curves_pos)
		print("P1_curves_types:", P1_curves_types)
		pass

func apply_tile_set(body: Array):
	var body_positions = body.duplicate(true)
	var tile_id = Vector2i.ZERO  # Inicializa corretamente
	var id_alternative = 0
	clear()


	for i in range(body_positions.size() - 1):
		var pos = body_positions[i] / 32  # Deve ser Vector2i
		tile_id = Vector2i.ZERO  # Inicializa corretamente
		id_alternative = 0
		
		match P1_body_types[i]:
			TILE_BODY_HOR:
				tile_id = Vector2i(0,1)
			TILE_BODY_VER:
				tile_id = Vector2i(1,1)
			TILE_BODY_HOR2:
				tile_id = Vector2i(0,1)
			TILE_BODY_VER2:
				tile_id = Vector2i(1,1)
			TILE_CURVE_1:
				tile_id = Vector2i(0,2)
			TILE_CURVE_2:
				tile_id = Vector2i(1,2)
			TILE_CURVE_3:
				tile_id = Vector2i(2,2)
			TILE_CURVE_4:
				tile_id = Vector2i(3,2)
		set_cell(pos, 0, tile_id, id_alternative)  

	match P1_body_types[body_positions.size() - 1]:
		TILE_TAIL_RIGHT:
			tile_id = Vector2i(2,1)
			id_alternative = 1
		TILE_TAIL_LEFT:
			tile_id = Vector2i(2,1)
			id_alternative = 0
		TILE_TAIL_UP:
			tile_id = Vector2i(3,1)
			id_alternative = 0
		TILE_TAIL_DOWN:
			tile_id = Vector2i(3,1)
			id_alternative = 1
	set_cell(body_positions[body_positions.size() - 1] / 32, 0, tile_id, id_alternative)

	id_alternative = 0
	match P1_body_types[0]:
		TILE_HEAD_RIGHT:
			tile_id = Vector2i(1,0) 
		TILE_HEAD_LEFT:
			tile_id = Vector2i(0,0)
		TILE_HEAD_UP:
			tile_id = Vector2i(3,0)
		TILE_HEAD_DOWN:
			tile_id = Vector2i(2,0)
	set_cell(body_positions[0] / 32, 0, tile_id, id_alternative)
