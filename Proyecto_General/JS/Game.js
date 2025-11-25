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

