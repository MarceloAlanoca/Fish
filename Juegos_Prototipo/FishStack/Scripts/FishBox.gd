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
	"BagreVelocity": 500,
	"RojoVelocity": 550,
	"PiñaVelocity": 300,

	# -------- Layer 2 --------
	"BallenaVelocity": 300,
	"OrcaVelocity": 500,
	"CrocodiloVelocity": 550,
	"MarcianoVelocity": 450,
	"DelfinVelocity": 600,
	"CirujanoVelocity": 400,
	"EspadaVelocity": 1000,
	"OutcomeMemoriesVelocity": 750,
	"GloboVelocity": 750,
	"PulpoVelocity": 600,
	"DoradoVelocity": 500,
	"MechaVelocity": 600,
	"PezArgentinaVelocity": 400,

	# -------- Layer 3 --------
	"CoralVelocity": 250,
	"AzulDoradoVelocity": 500,
	"CamaronPistolaVelocity": 650,
	"LoboMarinoVelocity": 550,
	"PavoVelocity": 450,
	"RemoVelocity": 600,
	"RetroGloboVelocity": 475,
	"EspañaVelocity": 500,
	"HuecoVelocity": 400,
	"MocoAtomicoVelocity": 450,
	"VladimirVelocity": 500,
	"PomniVelocity": 500,
	"PiedraVelocity": 20,

	# -------- Layer 4 --------
	"CebraVelocity": 700,
	"AbisalDemonioVelocity": 800,
	"GotaVelocity": 850,
	"KrakenVelocity": 950,
	"LuciernagaVelocity": 650,
	"DientonVelocity": 750,
	"AntenaVelocity": 800,
	"EsqueletoVelocity": 200,
	"MegalodonVelocity": 400,
	"NahuelitoVelocity": 500,

	# -------- Layer 5 --------
	"CaracolAzulVelocity": 250,
	"BabosoVelocity": 350,
	"MolestoVelocity": 400,
	"AnguilaElectricaVelocity": 900,
	"AbominableVelocity": 750,
	"BloopVelocity": 350,
	"ChtuluVelocity": 300,

	# -------- Otros / Especiales --------
	"PinguinoVelocity": 450,
	"CofreVelocity": 0,
	"LeviananVelocity": 150
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
	"DistBagre": 550,
	"DistRojo": 450,
	"DistPiña": 300,

	# -------- Layer 2 --------
	"DistBallena": 1250,
	"DistOrca": 900,
	"DistCrocodilo": 850,
	"DistMarciano": 700,
	"DistDelfin": 1000,
	"DistCirujano": 800,
	"DistEspada": 2000,
	"DistOutcomeMemories": 2500,
	"DistGlobo": 700,
	"DistPulpo": 600,
	"DistDorado": 650,
	"DistMecha": 900,
	"DistPezArgentina": 500,

	# -------- Layer 3 --------
	"DistCoral": 400,
	"DistAzulDorado": 700,
	"DistCamaronPistola": 600,
	"DistLoboMarino": 900,
	"DistPavo": 650,
	"DistRemo": 850,
	"DistRetroGlobo": 700,
	"DistEspaña": 700,
	"DistHueco": 500,
	"DistMocoAtomico": 550,
	"DistVladimir": 700,
	"DistPomni": 650,
	"DistPiedra": 50,

	# -------- Layer 4 --------
	"DistCebra": 900,
	"DistAbisalDemonio": 1100,
	"DistGota": 800,
	"DistKraken": 1200,
	"DistLuciernaga": 700,
	"DistDienton": 950,
	"DistAntena": 1000,
	"DistEsqueleto": 400,
	"DistMegalodon": 2000,
	"DistNahuelito": 800,

	# -------- Layer 5 --------
	"DistCaracolAzul": 300,
	"DistBaboso": 400,
	"DistMolesto": 450,
	"DistAnguilaElectrica": 1100,
	"DistAbominable": 1000,
	"DistBloop": 2000,
	"DistChtulu": 2500,

	# -------- Otros / Especiales --------
	"DistPinguino": 800,
	"DistCofre": 50,
	"DistLevianan": 3000
}

# ===========================================================
# 💰 PRECIOS (Bitcoin_Pez)
# ===========================================================
var Bitcoin_Pez = {
	# -------- Layer 1 --------
	"Atun": 400,
	"Salmon": 550,
	"Payaso": 600,
	"Barracuda": 400,
	"Lenguado": 350,
	"Bordo": 420,
	"Betta": 500,
	"Union": 530,
	"Bagre": 600,
	"Rojo": 350,
	"Piña": 300,

	# -------- Layer 2 --------
	"Ballena": 1200,
	"Orca": 1500,
	"Crocodilo": 800,
	"Marciano": 1750,
	"Delfin": 920,
	"Cirujano": 800,
	"Espada": 1200,
	"Globo": 800,
	"PezArgentina": 5400,
	"OutcomeMemories": 6000,
	"Pulpo": 860,
	"Dorado": 2000,
	"Mecha": 1500,

	# -------- Layer 3 --------
	"Coral": 3500,
	"AzulDorado": 1000,
	"CamaronPistola": 2000,
	"LoboMarino": 2500,
	"Pavo": 2500,
	"Remo": 3500,
	"RetroGlobo": 3000,
	"Piedra": 800,
	"Pomni": 7500,
	"España": 1500,
	"Hueco": 1700,
	"MocoAtomico": 1800,
	"Vladimir": 2500,

	# -------- Layer 4 --------
	"Cebra": 3500,
	"AbisalDemonio": 5000,
	"Gota": 5000,
	"Kraken": 9000,
	"Luciernaga": 4500,
	"Dienton": 4000,
	"Antena": 5000,
	"Esqueleto": 3000,
	"Nahuelito": 15000,
	"Megalodon": 20000,

	# -------- Layer 5 --------
	"CaracolAzul": 7000,
	"Baboso": 6000,
	"Molesto": 7500,
	"AnguilaElectrica": 7500,
	"Abominable": 9000,
	"Bloop": 35000,
	"Chtulu": 30000,

	# -------- Otros / Especiales --------
	"Pinguino": 850,
	"Cofre": 2500,
	"Levianan": 45000
}
