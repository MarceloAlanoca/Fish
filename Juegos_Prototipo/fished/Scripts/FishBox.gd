extends Node2D

# ===========================================================
# 🏃 VELOCITY DE PECES
# ===========================================================
var VelP = {
	# -------- Layer 1 --------
	"AtunVelocity": 450,
	"SalmonVelocity": 500,
	"PayasoVelocity": 350,
	"BarracudaVelocity": 525,
	"LenguadoVelocity": 375,
	"BordoVelocity": 500,
	"BettaVelocity": 475,
	"UnionVelocity": 500,

	# -------- Layer 2 --------
	"BallenaVelocity": 300,
	"OrcaVelocity": 500,
	"CrocodiloVelocity": 550,
	"MarcianoVelocity": 450,
	"DelfinVelocity": 600,

	# -------- Layer 3 --------
	"CoralVelocity": 250,
	"AzulDoradoVelocity": 500,
	"CamaronPistolaVelocity": 650,
	"LoboMarinoVelocity": 550,
	"PavoVelocity": 450,
	"RemoVelocity": 600,
	"RetroGloboVelocity": 475,

	# -------- Layer 4 --------
	"CebraVelocity": 700,
	"AbisalDemonioVelocity": 800,
	"GotaVelocity": 850,
	"KrakenVelocity": 950,
	"LuciernagaVelocity": 650,
	"DientonVelocity": 750,
	"AntenaVelocity": 800,

	# -------- Layer 5 --------
	"CaracolAzulVelocity": 250,
	"BabosoVelocity": 350,
	"MolestoVelocity": 400,
	"AnguilaElectricaVelocity": 900,
	"AbominableVelocity": 750,

	# -------- Otros / Especiales --------
	"PinguinoVelocity": 450,
	"PomniVelocity": 500,
	"PezArgentinaVelocity": 400,
	"PezMolestoVelocity": 450,
	"PezBabosoVelocity": 350,
	"CofreVelocity": 0,
	"PiedraVelocity": 0
}

# ===========================================================
# 📏 DISTANCIA MÁXIMA DE RECORRIDO
# ===========================================================
var Dist = {
	# -------- Layer 1 --------
	"DistAtun": 500,
	"DistSalmon": 400,
	"DistPayaso": 450,
	"DistBarracuda": 700,
	"DistLenguado": 450,
	"DistBordo": 600,
	"DistBetta": 500,
	"DistUnion": 550,

	# -------- Layer 2 --------
	"DistBallena": 1250,
	"DistOrca": 900,
	"DistCrocodilo": 850,
	"DistMarciano": 700,
	"DistDelfin": 1000,

	# -------- Layer 3 --------
	"DistCoral": 400,
	"DistAzulDorado": 700,
	"DistCamaronPistola": 600,
	"DistLoboMarino": 900,
	"DistPavo": 650,
	"DistRemo": 850,
	"DistRetroGlobo": 700,

	# -------- Layer 4 --------
	"DistCebra": 900,
	"DistAbisalDemonio": 1100,
	"DistGota": 800,
	"DistKraken": 1200,
	"DistLuciernaga": 700,
	"DistDienton": 950,
	"DistAntena": 1000,

	# -------- Layer 5 --------
	"DistCaracolAzul": 300,
	"DistBaboso": 400,
	"DistMolesto": 450,
	"DistAnguilaElectrica": 1100,
	"DistAbominable": 1000,

	# -------- Otros / Especiales --------
	"DistPinguino": 800,
	"DistPomni": 650,
	"DistPezArgentina": 500,
	"DistPiedra": 50,
	"DistCofre": 50
}

# ===========================================================
# 💰 PRECIOS (Bitcoin_Pez)
# ===========================================================
var Bitcoin_Pez = {
	# -------- Layer 1 --------
	"Atun": 400,
	"Salmon": 250,
	"Payaso": 400,
	"Barracuda": 550,
	"Lenguado": 350,
	"Bordo": 400,
	"Betta": 500,
	"Union": 500,

	# -------- Layer 2 --------
	"Ballena": 1500,
	"Orca": 1000,
	"Crocodilo": 800,
	"Marciano": 1650,
	"Delfin": 850,

	# -------- Layer 3 --------
	"Coral": 3500,
	"AzulDorado": 1000,
	"CamaronPistola": 2000,
	"LoboMarino": 2500,
	"Pavo": 2500,
	"Remo": 3500,
	"RetroGlobo": 3000,

	# -------- Layer 4 --------
	"Cebra": 3500,
	"AbisalDemonio": 5000,
	"Gota": 5000,
	"Kraken": 9000,
	"Luciernaga": 4500,
	"Dienton": 4000,
	"Antena": 5000,

	# -------- Layer 5 --------
	"CaracolAzul": 6000,
	"Baboso": 5500,
	"Molesto": 6500,
	"AnguilaElectrica": 6500,
	"Abominable": 7000,

	# -------- Otros / Especiales --------
	"Pinguino": 850,
	"Pomni": 950,
	"PezArgentina": 600,
	"PezBaboso": 550,
	"PezMolesto": 650,
	"Cofre": 2500,
	"Piedra": 10
}
