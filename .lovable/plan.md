# Ganti model ikan per tingkat kelangkaan

## Jawaban soal upload GLB yang selalu gagal
Masalah yang terlihat pada screenshot adalah **unggahan batch 6 file gagal dan seluruh batch dibuang**. File koi Common (~20 MB) yang dikirim sendirian sudah masuk dengan selamat, jadi format GLB-nya diterima.

Gunakan urutan alternatif ini:
1. Kirim **satu GLB per pesan**, jangan enam sekaligus. Tunggu sampai file terlihat terkirim sebelum mengirim berikutnya.
2. Jika satu file tertentu tetap gagal, unggah file itu ke Google Drive, Dropbox, atau GitHub Release, aktifkan akses publik, lalu kirim link unduhnya di chat. Saya dapat mengambil file langsung dari link tersebut.
3. Jangan ubah ke ZIP bila hasil ZIP masih mendekati 20 MB; itu tidak menyelesaikan batas unggahan.

## Yang akan dikerjakan

1. **Pasang model koi (common)** yang sudah kamu kirim ke dalam proyek, dengan pengecilan ukuran file dulu (kompresi geometri + tekstur) supaya game tetap ringan saat dimuat. Target di bawah ~3 MB per ikan.

2. **Sistem model ikan per kelangkaan.** Satu daftar pemetaan: common, rare, epic, legendary, mythic → file model masing‑masing. Ikan yang tersangkut di kail akan menampilkan model sesuai kelangkaan tangkapan, bukan lagi ikan kotak-kotak buatan kode.

3. **Cadangan aman.** Untuk tingkat yang modelnya belum kamu kirim, ikan lama tetap dipakai dengan warna khas tiap tingkat, jadi game tidak pernah kosong atau error. Begitu file berikutnya dikirim lewat chat, tinggal ditambahkan ke daftar tanpa mengubah kode lain.

4. **Penyesuaian ukuran & arah hadap** tiap model (skala dan putaran) supaya ikan tampil proporsional di tangan pemain dan menghadap arah yang benar.

Monster (Ancient Leviathan) tetap memakai tampilan raksasa yang sekarang, kecuali kamu ingin diganti juga.

## Yang perlu kamu lakukan
Kirim satu per satu lewat chat: rare, epic, legendary, mythic. Jika salah satunya masih gagal saat dikirim sendiri, kirim link publik file tersebut.

## Catatan teknis
- File disimpan di `public/models/` seperti model dunia lain, dikompresi Draco/WebP agar konsisten dengan aset yang sudah ada.
- Pemetaan baru di `src/lib/fishModels.ts`; `Fish.tsx` mendapat komponen pemuat GLB dengan Suspense + error boundary; `Angler.tsx` memilih model berdasarkan `rarity` dari `useGameStore`.
- Tidak menyentuh sistem cuaca, toko, tas, atau penyimpanan tangkapan.
