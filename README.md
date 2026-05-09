# MCSOS 260502

MCSOS 260502 adalah proyek sistem operasi pendidikan bertahap yang menargetkan arsitektur **x86_64**. Proyek ini dikembangkan di lingkungan **Windows 11 x64** melalui **WSL 2** dengan fokus pada lingkungan pengembangan yang *reproducible*.

---

## 🚀 Status Proyek: Milestone 0 (M0)
Saat ini proyek berada pada fase **Baseline**, yang mencakup:
*   Penyusunan *requirements* dan *governance*.
*   Konfigurasi lingkungan pengembangan yang konsisten.
*   Penyediaan *smoke testing* awal.

## 🛠 Spesifikasi Teknis
*   **Arsitektur Target:** `x86_64`
*   **Emulator:** QEMU System x86_64
*   **Firmware:** UEFI (via OVMF)
*   **Bahasa Pemrograman:** Freestanding C17 & Assembly x86_64 minimal
*   **Model Kernel:** *Monolithic educational kernel* dengan batasan modular internal

## 💻 Cara Menjalankan
Pastikan semua dependensi (seperti yang ada di `Cuplikan layar 2026-05-09 163141.png`) telah terinstal, lalu gunakan perintah berikut:

### 1. Inisialisasi Metadata
Membangun struktur folder dan file administratif.
```bash
make meta
make check
make smoke
