# Ganti model ikan per kelas kelangkaan

Ikan yang tertangkap sekarang masih bentuk balok/bola buatan kode. Rencananya diganti dengan model ikan asli dari koleksi GitHub yang kamu kirim, dan tiap kelas punya ukuran berbeda.

## Model yang dipakai

Dari folder GitHub-mu (semua terbaca):

- common: Koi Carp Common
- rare: fish rare
- epic: Largemouth Bass epic
- legendary: legendaryfish, red octopus legendary (dipilih acak)
- mythic: bluesharkmythic, mythicfish, normal shark mythic (dipilih acak)

Semua file aslinya 19–58 MB, jauh terlalu berat untuk dimuat di game. Setiap model akan dikecilkan dulu (tekstur dan geometri dipadatkan) sampai kira-kira 1–3 MB per ikan, dengan tampilan yang tetap mirip. Kalau ada satu model yang tetap tidak bisa dikecilkan dengan wajar, aku pakai model lain dari kelas yang sama dan memberitahumu.

## Ukuran per kelas

Skala mengikuti permintaanmu:

- mythic: sangat besar
- legendary: besar, sedikit di bawah mythic
- epic: sedang
- rare: sedang, sedikit lebih kecil dari epic
- common: kecil

Ukuran juga sedikit menyesuaikan berat ikan yang tertangkap, jadi ikan berat terlihat lebih besar dari ikan ringan di kelas yang sama.

## Yang tidak disentuh

Cuaca, toko pancing, toko umpan, tas, harga jual, dan penyimpanan tangkapan tidak diubah. Monster Ancient Leviathan tetap memakai tampilan raksasa yang sekarang.

## Catatan teknis

- Unduh 8 GLB dari commit `a664f341` lewat URL raw, kompres dengan Draco + tekstur WebP/resize, simpan ke `public/models/` mengikuti pola nama file yang sudah ada.
- Modul baru `src/lib/fishModels.ts`: peta `Rarity -> { url, baseScale, rotationY, yOffset }` plus pemilih acak untuk legendary/mythic.
- `src/components/game/Fish.tsx`: `FishMesh` diubah agar memuat GLB via `useGLTF` (clone scene, animasi goyang ringan pada grup induk), dengan fallback ke mesh prosedural saat model belum termuat; dibungkus `Suspense` di dalam Canvas.
- `Angler.tsx` baris ~1191: kirim `rarity` dan `weightKg` dari `st.fish` ke `FishMesh`, ganti prop `color`/`scale` tetap. Pemilihan varian dikunci saat fase `reel` dimulai agar tidak berganti tiap frame.
- `useGLTF.preload` untuk kelima kelas agar tidak ada jeda saat ikan muncul.
- Verifikasi: build + screenshot Playwright dari satu siklus lempar-tarik.
