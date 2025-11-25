window.addEventListener("message", (event) => {
    if (event.data.type === "USER_DATA") {
        console.log("🔥 Web recibió USER ID:", event.data.userID);

        // Enviar a Godot
        if (typeof window.sendUserIDToGodot === "function") {
            window.sendUserIDToGodot(event.data.userID);
        } else {
            console.error("❌ Godot no cargó sendUserIDToGodot");
        }
    }
});

const iframe = document.getElementById("gameFrame");
const fullscreenBtn = document.getElementById("fullscreenBtn");
const soundBtn = document.getElementById("soundBtn");
let soundMuted = false;

// Pantalla completa
fullscreenBtn.addEventListener("click", () => {
  if (iframe.requestFullscreen) {
    iframe.requestFullscreen();
  } else if (iframe.webkitRequestFullscreen) {
    iframe.webkitRequestFullscreen();
  } else if (iframe.msRequestFullscreen) {
    iframe.msRequestFullscreen();
  }
});

// Sonido (mute / unmute)
soundBtn.addEventListener("click", () => {
  soundMuted = !soundMuted;
  soundBtn.textContent = soundMuted ? "🔇" : "🔊";
  // Enviar mensaje al iframe si tu juego soporta audio controlado desde fuera
  iframe.contentWindow.postMessage({ mute: soundMuted }, "*");
});

