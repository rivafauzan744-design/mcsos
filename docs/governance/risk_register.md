# Risk Register MCSOS 260502 — M0

Dokumen ini mencatat risiko teknis dan operasional yang dapat menghambat pencapaian Milestone 0. Setiap risiko dievaluasi berdasarkan probabilitas dan dampak untuk menentukan prioritas mitigasi.

| ID | Risiko | Probabilitas | Dampak | Strategi Mitigasi | Owner | Trigger Review |
|:---|:---|:---:|:---:|:---|:---|:---|
| **R-M0-001** | WSL tidak aktif atau masih menggunakan WSL 1. | Medium | High | Verifikasi via `wsl --list --verbose`; konversi wajib ke WSL 2. | Toolchain Eng. | Versi pada `wsl -l -v` bukan "2". |
| **R-M0-002** | Repository berada di jalur mount `/mnt/c/`. | High | Medium | Migrasi total ke `~/src/mcsos`; aktifkan peringatan pada skrip cek. | Koordinator | `pwd` mengandung string `/mnt/c/`. |
| **R-M0-003** | Binari QEMU tidak ditemukan di sistem. | Medium | High | Instalasi paket `qemu-system-x86`; dokumentasikan versi binari. | Toolchain Eng. | `command -v` untuk QEMU gagal. |
| **R-M0-004** | Jalur file firmware OVMF berbeda antar distro. | Medium | Medium | Gunakan `find /usr/share` untuk lokalisasi; hindari hardcode jalur. | Toolchain Eng. | `OVMF_CODE.fd` tidak terdeteksi. |
| **R-M0-005** | Kompilator menghasilkan target Host (bukan freestanding). | Medium | High | Gunakan flag `--target`; wajibkan inspeksi manual via `readelf`. | Verification Eng. | Header `Machine` bukan "X86-64". |
| **R-M0-006** | Requirement tidak bersifat *testable* (kabur). | Medium | Medium | Implementasi matriks verifikasi wajib untuk setiap poin kebutuhan. | Documentation Eng. | Requirement tanpa bukti (*evidence*). |
| **R-M0-007** | Ketidaksinkronan antar branch tim pengembang. | Medium | Medium | Terapkan kebijakan *pull-before-commit* dan review branch rutin. | Koordinator | Terjadi konflik merge yang berulang. |
| **R-M0-008** | Penghapusan log error dari laporan progres. | Medium | Medium | Laporan wajib mencantumkan analisis *failure mode* secara jujur. | Semua Anggota | Log error tidak ditemukan di laporan. |
| **R-M0-009** | Build bergantung pada versi paket yang tidak tercatat. | Medium | High | Jalankan `make meta` secara otomatis sebelum proses submisi. | Verification Eng. | File metadata kosong atau usang. |
| **R-M0-010** | *Scope creep*: M0 melebar ke implementasi kernel. | Medium | Medium | Patuhi dokumen *non-goals*; tunda kode fungsional hingga M1. | Koordinator | Ada kode kernel tanpa kontrak desain. |
