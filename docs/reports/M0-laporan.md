# Laporan Praktikum M0 — Baseline Requirements, Governance, dan Lingkungan Pengembangan

## 1. Sampul
*   **Judul Praktikum**: Praktikum M0 — Baseline Requirements, Governance, dan Lingkungan Pengembangan Reproducible MCSOS 260502
*   **Nama Mahasiswa / Kelompok**: [Isi Nama]
*   **NIM**: [Isi NIM]
*   **Kelas**: [Isi Kelas]
*   **Dosen**: Muhaemin Sidiq, S.Pd., M.Pd.
*   **Program Studi**: Pendidikan Teknologi Informasi, Institut Pendidikan Indonesia
*   **Tanggal**: [Isi Tanggal]

---

## 2. Tujuan
Menjelaskan capaian teknis dan konseptual pada fase M0, termasuk standarisasi lingkungan pengembangan, verifikasi toolchain freestanding, dan pembentukan tata kelola proyek berbasis bukti (*evidence-first*).

## 3. Dasar Teori Ringkas
Jelaskan secara singkat konsep berikut:
*   **Host vs Target**: Perbedaan mesin pengembang dan mesin target sistem operasi.
*   **WSL 2**: Arsitektur virtualisasi yang menyediakan kernel Linux native di Windows.
*   **Cross-compilation**: Proses membangun binari untuk arsitektur yang berbeda dari host.
*   **ELF Object**: Format file standar untuk executable dan object pada sistem UNIX-like.
*   **QEMU & OVMF**: Peran emulator sistem dan firmware UEFI dalam proses booting.
*   **Evidence-first Engineering**: Prinsip di mana setiap klaim teknis harus didukung bukti otentik.

## 4. Lingkungan Pengembangan
Tabel di bawah mencatat spesifikasi perangkat lunak yang digunakan dalam praktikum ini:

| Komponen | Versi / Output |
|:---|:---|
| Windows | [Contoh: Windows 11 Pro 23H2] |
| WSL Distro | [Contoh: Ubuntu 22.04.4 LTS] |
| Kernel Linux WSL | [Output `uname -r`] |
| Git | [Output `git --version`] |
| Clang | [Output `clang --version`] |
| LLD | [Output `ld.lld --version`] |
| binutils/readelf | [Output `readelf -v`] |
| NASM | [Output `nasm -v`] |
| QEMU | [Output `qemu-system-x86_64 --version`] |
| GDB | [Output `gdb --version`] |
| Python | [Output `python3 --version`] |

> **Lampiran Metadata**: Isi file `build/meta/toolchain-versions.txt` harus disertakan di sini.

## 5. Desain Baseline
Jelaskan secara naratif mengenai:
1.  Struktur repository (Folder `docs`, `tools`, `smoke`, `build`).
2.  Dokumentasi dasar (Assumptions, Non-goals).
3.  Model ancaman awal (*Threat Model*).

## 6. Langkah Kerja
Uraikan urutan perintah yang dijalankan (misalnya: penyiapan Makefile, pembuatan skrip verifikasi, kompilasi smoke test) beserta alasan teknis di balik langkah tersebut.

## 7. Hasil Uji (Verification Matrix)
| Pengujian | Perintah Verifikasi | Hasil yang Teramati | Status (Pass/Fail) |
|:---|:---|:---|:---:|
| **WSL Version** | `wsl --list --verbose` | | |
| **Tool Check** | `bash tools/check_env.sh` | | |
| **Metadata Integrity** | `cat build/meta/toolchain-versions.txt` | | |
| **Smoke Compilation** | `make smoke` | | |
| **ELF Header Audit** | `readelf -h build/smoke/freestanding.o` | | |
| **Git Status** | `git status` | | |

## 8. Analisis Kegagalan
Jelaskan kendala atau error yang ditemukan selama praktikum (misal: error GDB timeout), penyebab akarnya, langkah perbaikan, dan bukti bahwa perbaikan tersebut berhasil.

## 9. Keamanan dan Reliability
Analisis risiko terhadap:
*   **Supply-chain**: Keamanan sumber toolchain.
*   **Repository Path**: Dampak penggunaan `/mnt/c/` vs filesystem native.
*   **Log Integrity**: Pentingnya menjaga keaslian data output build.

## 10. Failure Modes dan Rollback
| Failure Mode | Gejala Teramati | Diagnosis | Tindakan Perbaikan |
|:---|:---|:---|:---|
| **WSL Version Mismatch** | Lambat / Permission Error | Menggunakan WSL 1 | `wsl --set-version <distro> 2` |
| **Tool Missing** | `Command not found` | Paket belum terinstal | `sudo apt install <package>` |
| **Target Mismatch** | Machine: host default | Flag `--target` tidak aktif | Periksa variabel `CFLAGS` |

## 11. Kesimpulan
Ringkasan apakah M0 sudah memenuhi syarat untuk lanjut ke M1 (Booting). Sertakan syarat utama masuk ke M1: lingkungan terverifikasi dan toolchain mampu menghasilkan objek freestanding.

## 12. Lampiran
*   Output lengkap `tools/check_env.sh`.
*   Isi file `build/meta/toolchain-versions.txt`.
*   Tangkapan layar (Screenshot) verifikasi QEMU/GDB.
*   **Commit Hash Terakhir**: [Isi Hash]

## 13. Referensi
*Gunakan format IEEE (Contoh: [1] Author, "Title," Journal, Year).*
