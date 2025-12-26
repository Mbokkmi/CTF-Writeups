# 🔐 Git + SSH Setup (Arch Linux / Hyprland)

## 🎯 Purpose

Secure and clean GitHub authentication using SSH (ed25519) on Arch Linux.
This setup avoids HTTPS passwords/tokens and is adapted to Wayland (Hyprland).

---

## 🖥️ Environment

- OS: Arch Linux
- WM: Hyprland (Wayland)
- Shell: bash
- Kernel: linux-zen
- Git hosting: GitHub

---

## 1️⃣ Git identity configuration

```bash
git config --global user.name "Mbokkmi"
git config --global user.email "mbowbemtech@gmail.com"

