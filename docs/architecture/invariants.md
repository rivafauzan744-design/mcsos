# Invariants MCSOS 260502 — Baseline M0

Dokumen ini mendefinisikan kondisi atau aturan tetap (*invariants*) yang wajib dipenuhi sepanjang siklus pengembangan MCSOS. Pelanggaran terhadap invariant dianggap sebagai kegagalan dalam tata kelola teknis.

---

## 1. Repository Invariants
1.  **Filesystem**: Repository utama wajib berada di dalam native filesystem Linux WSL (bukan `/mnt/c/`).
2.  **Artifact Location**: Seluruh artefak hasil build (*generated artifacts*) harus ditempatkan di dalam direktori `build/` atau lokasi yang terdokumentasi.
3.  **Git Tracking**: Seluruh kode sumber (*source code*), dokumen, dan skrip validasi wajib dikomit ke dalam repositori Git.
4.  **Exclusion Policy**: File hasil build yang berukuran besar (ISO, Image, Object file, Log penuh) **dilarang** dikomit ke Git kecuali dinyatakan secara eksplisit sebagai *fixture* pengujian.

---

## 2. Toolchain Invariants
1.  **Traceability**: Setiap sesi praktikum wajib mencatat versi perangkat lunak yang digunakan ke dalam `build/meta/toolchain-versions.txt`.
2.  **Explicit Targeting**: Kompilator target harus dinyatakan secara eksplisit; kernel dilarang keras menggunakan ABI host secara implisit.
3.  **Verification**: Objek hasil *smoke test* wajib diperiksa menggunakan perangkat audit seperti `readelf`, `objdump`, atau alat setara lainnya.
4.  **Policy Documentation**: Flag *freestanding* dan kebijakan *red-zone* harus sudah terdokumentasi dengan jelas sebelum kode kernel utama diimplementasikan.

---

## 3. Documentation Invariants
1.  **Verifiability**: Setiap persyaratan (*requirement*) wajib memiliki metode verifikasi yang jelas dan terukur.
2.  **Risk Management**: Setiap risiko yang teridentifikasi wajib memiliki strategi mitigasi atau pemicu (*trigger*) untuk dilakukan tinjauan (*review*).
3.  **Security-First**: *Threat model* harus tersedia sejak fase M0 dan diperbarui secara berkala setiap kali subsistem baru ditambahkan.
4.  **Evidence-Based Status**: Label kesiapan (*readiness label*) hanya boleh diberikan berdasarkan bukti teknis yang nyata.

---

## 4. Evidence Invariants
1.  **Audit Trail**: Klaim "berhasil" wajib didukung oleh output perintah, log, checksum, tangkapan layar (*screenshot*), hash commit, atau artefak lain yang dapat diperiksa ulang.
2.  **Error Integrity**: Pesan kesalahan (*error*) tidak boleh dihapus dari laporan; setiap kegagalan harus diklasifikasikan dan dianalisis penyebabnya.
3.  **Rollback Documentation**: Setiap langkah pengembalian ke versi sebelumnya (*rollback*) harus terdokumentasi dengan alasan yang jelas.
