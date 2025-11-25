extends CharacterBody2D

# ===========================================================
# 📦 ACCESO AL FISHBOX
# ===========================================================
var Box = load("res://Scripts/FishBox.gd")
var Box_Vel = Box.new()

# ===========================================================
# 🐟 DATOS DEL PEZ (solo cambiá esto)
# ===========================================================
@export var nombre_real := "España"      # Debe coincidir EXACTO con FishBox
@export var calidad := "Exotico"         # Comun | Raro | Exotico | Especial
@export var vel_progresion := 1.0


# ===========================================================
# ⚙️ VARIABLES DINÁMICAS (se cargan del FishBox)
# ===========================================================
var velocidad: float = 0.0
var direccion: Vector2 = Vector2(1, 0)
var distancia_maxima: float = 0.0
var distancia_recorrida: float = 0.0
var detenido := false


func _ready() -> void:
	# --- Registro ---
	add_to_group("peces")
	name = nombre_real
	set_meta("nombre_real", nombre_real)

	# --- Cargar velocidad y distancia desde el FishBox ---
	# Ej: Pez "Rojo" utiliza "RojoVelocity" y "DistRojo"
	velocidad = Box_Vel.VelP.get(nombre_real + "Velocity", 200)
	distancia_maxima = Box_Vel.Dist.get("Dist" + nombre_real, 500)

	# --- Dirección aleatoria inicial ---
	if randf() > 0.5:
		direccion = -direccion

	_mirar()


func _physics_process(delta: float) -> void:
	if detenido:
		return

	# Movimiento
	var mov = direccion * velocidad * delta
	position += mov
	distancia_recorrida += velocidad * delta

	# Cambio de sentido al alcanzar distancia máxima
	if distancia_recorrida >= distancia_maxima:
		direccion = -direccion
		distancia_recorrida = 0
		_mirar()


# ===========================================================
# 🔄 MIRAR EN DIRECCIÓN
# ===========================================================
func _mirar() -> void:
	if $Sprite2D:
		$Sprite2D.flip_h = direccion.x < 0


# ===========================================================
# ⛔ DETENER PEZ (al pescarlo)
# ===========================================================
func detener_movimiento() -> void:
	detenido = true
	velocidad = 0
	set_physics_process(false)
