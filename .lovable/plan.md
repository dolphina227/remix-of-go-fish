# Ganti model ikan per tingkat kelangkaan

## Soal upload: sudah beres lewat GitHub
Link GitHub kamu berhasil dibaca. Semua model ikan sudah bisa diambil langsung dari sana, jadi tidak perlu upload lewat chat lagi. File yang ditemukan:

| Tingkat | File | Ukuran |
| --- | --- | --- |
| common | Koi_Carp_Common.glb (dari chat) | 19,9 MB |
| rare | fish rare.glb | 19,7 MB |
| epic | Largemouth Bas epic.glb | 19,5 MB |
| legendary | legendaryfish.glb, red octopus legendary.glb | 19,7 / 19,5 MB |
| mythic | bluesharkmythic.glb, normal shark mythic.glb, mythicfish.glb | 20,2 / 19,2 / 58 MB |

## Yang akan dikerjakan

1. **Unduh semua model dari GitHub** ke dalam proyek.

2. **Kecilkan ukuran file.** Total mentahnya sekitar 195 MB — terlalu berat untuk dimuat di game. Semua model dikompresi (geometri + tekstur) dengan target di bawah ~3 MB per ikan, tampilan tetap sama.

3. **Sistem model ikan per kelangkaan.** Daftar pemetaan common, rare, epic, legendary, mythic → model masing-masing. Ikan yang tersangkut di kail menampilkan model sesuai kelangkaan tangkapan, menggantikan ikan kotak-kotak buatan kode.

4. **Tingkat dengan lebih dari satu model** (legendary dan mythic) memakai semuanya sebagai variasi: model dipilih acak saat ikan tertangkap, jadi tangkapan langka terasa lebih bervariasi.

5. **Penyesuaian ukuran & arah hadap** tiap model supaya proporsional di tangan pemain dan menghadap arah yang benar.

Monster (Ancient Leviathan) tetap memakai tampilan raksasa yang sekarang, kecuali kamu ingin diganti dengan salah satu hiu mythic.

## Catatan teknis
- File disimpan di `public/models/` seperti model dunia lain, dikompresi Draco/WebP agar konsisten dengan aset yang sudah ada.
- Pemetaan baru di `src/lib/fishModels.ts`; `Fish.tsx` mendapat komponen pemuat GLB dengan Suspense + error boundary; `Angler.tsx` memilih model berdasarkan `rarity` dari `useGameStore`.
- Tidak menyentuh sistem cuaca, toko, tas, atau penyimpanan tangkapan.
