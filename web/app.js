let resource = "goku_antiafk";
let allowCancel = false;
let secondsLeft = 0;

const $ = (s) => document.querySelector(s);
const overlay = $("#overlay");
const title = $("#title");
const desc = $("#desc");
const servername = $("#servername");
const captcha = $("#captcha");
const timer = $("#timer");
const input = $("#input");
const confirmBtn = $("#confirm");
const cancelBtn = $("#cancel");
const panel = $("#panel");

window.addEventListener("message", (e) => {
  const data = e.data || {};
  if (data.action === "open") {
    resource = data.resource || resource;
    allowCancel = !!data.allowCancel;
    secondsLeft = Number(data.seconds) || 0;
    overlay.classList.remove("hidden");
    panel.className = data.panelStyle || "modern";
    title.textContent = data.title || "ANTI‑AFK";
    desc.textContent = data.desc || "";
    servername.textContent = data.serverName || "";
    confirmBtn.textContent = data.button || "Confirm";
    cancelBtn.classList.toggle("hidden", !allowCancel);

    // Colors
    if (data.colors) {
      document.documentElement.style.setProperty("--primary", data.colors.primary || "#F13D3D");
      document.documentElement.style.setProperty("--secondary", data.colors.secondary || "#7B2222");
      document.documentElement.style.setProperty("--bg", data.colors.background || "rgba(10,10,10,0.92)");
      document.documentElement.style.setProperty("--text", data.colors.text || "#FFFFFF");
    }

    // Captcha
    captcha.textContent = data.code || "";
    captcha.dataset.text = data.code || "";
    captcha.className = `captcha ${data.captchaStyle || "default"}`;

    // Timer
    timer.textContent = secondsLeft + "s";
    input.value = "";
    input.focus();
  }
  if (data.action === "tick") {
    secondsLeft = data.seconds || 0;
    timer.textContent = secondsLeft + "s";
  }
  if (data.action === "close") {
    overlay.classList.add("hidden");
  }
});

confirmBtn.addEventListener("click", () => {
  fetch(`https://${resource}/submit`, {
    method: "POST",
    headers: { "Content-Type": "application/json; charset=utf-8" },
    body: JSON.stringify({ value: input.value })
  });
});
input.addEventListener("keydown", (e) => {
  if (e.key === "Enter") confirmBtn.click();
});
cancelBtn.addEventListener("click", () => {
  fetch(`https://${resource}/cancel`, { method: "POST" });
});
