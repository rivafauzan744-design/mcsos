# System Requirements MCSOS 260502 — Baseline M0

## Scope
Dokumen ini menetapkan persyaratan (*requirements*) awal untuk proyek MCSOS 260502. Pada fase Milestone 0 (M0), persyaratan difokuskan pada standarisasi lingkungan pengembangan, tata kelola proyek (*governance*), dan penyediaan bukti teknis (*evidence*). Persyaratan fungsional kernel akan diperinci pada milestone berikutnya.

| ID | Requirement | Rationale | Verification Evidence |
|:---|:---|:---|:---|
| **REQ-M0-001** | Repository MCSOS wajib berada di filesystem native Linux (WSL), bukan `/mnt/c/`. | Menghindari konflik perizinan (*permission*), perbedaan *case-sensitivity*, dan degradasi performa I/O. | Output `pwd` dan `tools/check_env.sh`. |
| **REQ-M0-002** | Semua perangkat lunak (*tool*) wajib harus terdeteksi oleh skrip validasi. | Menjamin proses *build* tidak bergantung pada alat manual yang tidak terdokumentasi. | Output `bash tools/check_env.sh`. |
| **REQ-M0-003** | Versi *toolchain* harus dicatat pada file `build/meta/toolchain-versions.txt`. | Menjamin keterlacakan (*traceability*) dan keberulangan (*reproducibility*) lingkungan pengembangan. | Isi file metadata toolchain. |
| **REQ-M0-004** | Repository harus mengikuti struktur folder: `docs`, `tools`, `smoke`, dan `build`. | Standarisasi manajemen artefak dan kemudahan navigasi proyek. | Output `tree -a -L 3`. |
| **REQ-M0-005** | *Smoke test* harus menghasilkan objek ELF64 x86-64 *relocatable*. | Validasi awal bahwa *toolchain* telah menargetkan arsitektur yang benar. | Output `readelf -h`. |
| **REQ-M0-006** | Proyek wajib mendefinisikan asumsi (*assumptions*) dan batasan (*non-goals*). | Mencegah perluasan lingkup (*scope creep*) dan ekspektasi fitur yang tidak realistis. | File `docs/requirements/assumptions_and_nongoals.md`. |
| **REQ-M0-007** | Proyek wajib memiliki ADR (*Architecture Decision Record*) awal. | Memastikan keputusan teknis fundamental didokumentasikan beserta alasannya. | File `docs/adr/ADR-0001-toolchain-and-boot-baseline.md`. |
| **REQ-M0-008** | Proyek harus memiliki model ancaman (*threat model*) awal. | Mengintegrasikan prinsip keamanan sejak fase desain paling awal (*Security from Phase 0*). | File `docs/security/threat_model.md`. |
| **REQ-M0-009** | Proyek wajib mengelola daftar risiko teknis dan operasional. | Mitigasi kendala pengembangan secara proaktif melalui manajemen risiko. | File `docs/governance/risk_register.md`. |
| **REQ-M0-010** | Proyek harus memiliki matriks verifikasi. | Menjamin setiap persyaratan memiliki metode pengujian dan bukti validasi yang jelas. | File `docs/testing/verification_matrix.md`. |
| **REQ-M0-011** | Seluruh perubahan fase M0 harus disimpan dalam repositori Git. | Menjaga integritas riwayat perubahan untuk keperluan audit dan penilaian. | Output `git log --oneline`. |
| **REQ-M0-012** | Laporan M0 harus mencakup log, perintah, tangkapan layar, dan analisis kegagalan. | Penekanan pada evaluasi berbasis bukti teknis (*evidence-first assessment*). | File `docs/reports/M0-laporan.md`. |
