# MCSOS Toolchain and Environment Invariants

Dokumen ini mendefinisikan aturan baku (invariants) yang harus dipenuhi oleh lingkungan pengembangan MCSOS untuk menjamin konsistensi dan stabilitas build.

---

## 🏗️ M1: Infrastructure Invariants

Aturan-aturan berikut wajib terpenuhi pada akhir fase Milestone 1 (M1):

1. **Filesystem Isolation**
   Repositori MCSOS wajib berada di dalam **Linux Native Filesystem** (EXT4). Tidak diperbolehkan menjalankan build dari direktori `/mnt/*` (Windows Mount) karena masalah performa dan kompatibilitas permission.

2. **Artifact Hygiene**
   Seluruh file hasil kompilasi dan metadata wajib berada di dalam direktori `build/`. Direktori ini harus masuk dalam `.gitignore` dan dilarang dikomit ke Git.

3. **Traceability**
   Semua perangkat lunak pembangun (build tools) harus tersedia melalui `$PATH` di WSL dan versinya tercatat otomatis dalam `build/meta/toolchain-versions.txt`.

4. **Binary Integrity**
   Artifact yang dihasilkan harus bertipe **ELF64 x86_64** dan dihasilkan dengan mode **freestanding**.

5. **Symbolic Resolution**
   Proof ELF tidak boleh memiliki *undefined symbols*. Semua simbol harus tuntas saat proses linking.

6. **Freestanding Strictness**
   Kompilasi kernel/proof dilarang bergantung pada komponen host berikut:
   * Hosted libc
   * Startup objects (crt0)
   * Dynamic linker
   * Exception runtime
   * Stack protector runtime

7. **Emulation Readiness**
   **QEMU x86_64**, machine **q35**, dan **OVMF** (UEFI) harus terdeteksi dengan benar sebelum Milestone 2 (M2) dimulai.

8. **Change Audit**
   Setiap perubahan toolchain atau versi distro Linux harus dicatat dalam readiness review untuk menjaga reproduktifitas.

---
