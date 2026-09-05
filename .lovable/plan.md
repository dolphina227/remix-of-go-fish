# Ganti model ikan per tingkat kelangkaan

## Masalah upload
Upload lewat editor di dalam game gagal untuk file GLB besar (file koi yang kamu kirim berukuran ~20 MB). Jalan keluarnya: kirim file GLB langsung ke chat ini — seperti yang barusan kamu lakukan — lalu file dipasang langsung ke proyek. Ini melewati sepenuhnya jalur upload yang bermasalah.

## Yang akan dikerjakan

1. **Pasang model koi (common)** yang sudah kamu kirim ke dalam proyek, dengan pengecilan ukuran file dulu (kompresi geometri + tekstur) supaya game tidak berat saat dimuat. Target di bawah ~3 MB per ikan.

2. **Sistem model ikan per kelangkaan.** Membuat satu daftar pemetaan: common, rare, epic, legendary, mythic → file model masing‑masing. Ikan yang sedang tersangkut di kail akan menampilkan model sesuai kelangkaan tangkapan, bukan lagi ikan kotak-kotak buatan kode.

3. **Cadangan aman.** Untuk tingkat yang modelnya belum kamu kirim, ikan lama tetap dipakai dengan warna khas tiap tingkat, jadi game tidak pernah kosong atau error. Begitu kamu kirim file berikutnya, tinggal ditambahkan ke daftar tanpa mengubah kode lain.

4. **Penyesuaian ukuran & arah hadap** tiap model (skala dan putaran) supaya ikan tampil proporsional di tangan pemain dan menghadap arah yang benar.

Monster (Ancient Leviathan) tetap memakai tampilan raksasa yang sekarang, kecuali kamu ingin diganti juga.

## Yang perlu kamu kirim
Empat file GLB lagi lewat chat: rare, epic, legendary, mythic. Boleh sekaligus (maks 10 file per pesan) atau satu-satu — tiap kali dikirim langsung saya pasang.

## Catatan teknis
- File disimpan di `public/models/` seperti model dunia lain, dikompresi Draco/WebP agar konsisten dengan aset yang sudah ada.
- Pemetaan baru di `src/lib/fishModels.ts`; `Fish.tsx` mendapat komponen pemuat GLB dengan Suspense + error boundary; `Angler.tsx` memilih model berdasarkan `rarity` dari `useGameStore`.
- Tidak menyentuh sistem cuaca, toko, tas, atau penyimpanan tangkapan.
