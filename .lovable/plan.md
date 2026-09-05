# Ganti model ikan per tingkat kelangkaan

## Jawaban soal upload GLB yang selalu gagal
Upload lewat editor di dalam game memang sering gagal untuk file sebesar ini. Cara lain yang **sudah terbukti berhasil**: kirim file GLB langsung ke chat ini — file koi kamu (~20 MB) barusan masuk dengan selamat lewat chat dan sudah bisa saya pasang. Jadi kirim saja 4 file sisanya (rare, epic, legendary, mythic) lewat chat, maksimal 10 file per pesan, bisa sekaligus atau satu-satu.

## Yang akan dikerjakan

1. **Pasang model koi (common)** yang sudah kamu kirim ke dalam proyek, dengan pengecilan ukuran file dulu (kompresi geometri + tekstur) supaya game tetap ringan saat dimuat. Target di bawah ~3 MB per ikan.

2. **Sistem model ikan per kelangkaan.** Satu daftar pemetaan: common, rare, epic, legendary, mythic → file model masing‑masing. Ikan yang tersangkut di kail akan menampilkan model sesuai kelangkaan tangkapan, bukan lagi ikan kotak-kotak buatan kode.

3. **Cadangan aman.** Untuk tingkat yang modelnya belum kamu kirim, ikan lama tetap dipakai dengan warna khas tiap tingkat, jadi game tidak pernah kosong atau error. Begitu file berikutnya dikirim lewat chat, tinggal ditambahkan ke daftar tanpa mengubah kode lain.

4. **Penyesuaian ukuran & arah hadap** tiap model (skala dan putaran) supaya ikan tampil proporsional di tangan pemain dan menghadap arah yang benar.

Monster (Ancient Leviathan) tetap memakai tampilan raksasa yang sekarang, kecuali kamu ingin diganti juga.

## Yang perlu kamu lakukan
Kirim empat file GLB lagi lewat chat: rare, epic, legendary, mythic.

## Catatan teknis
- File disimpan di `public/models/` seperti model dunia lain, dikompresi Draco/WebP agar konsisten dengan aset yang sudah ada.
- Pemetaan baru di `src/lib/fishModels.ts`; `Fish.tsx` mendapat komponen pemuat GLB dengan Suspense + error boundary; `Angler.tsx` memilih model berdasarkan `rarity` dari `useGameStore`.
- Tidak menyentuh sistem cuaca, toko, tas, atau penyimpanan tangkapan.
