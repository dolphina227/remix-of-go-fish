# Ganti model ikan per tingkat kelangkaan

## Jawaban soal upload GLB yang selalu gagal
Screenshot kamu menunjukkan error "File upload failed — Failed to upload 6 files. Removing failed uploads." Artinya **batch 6 file ditolak sekaligus**. File Koi Common (~20 MB) yang dikirim sendirian sudah masuk, jadi format GLB-nya diterima.

Tiga cara yang bisa dipakai (urut dari termudah):

**A. Satu GLB per pesan (paling mudah)**
Kirim satu file saja tiap pesan, jangan enam sekaligus. Tunggu sampai muncul di chat baru kirim berikutnya.

**B. Lewat link GitHub (bisa!)**
1. Buat repo publik gratis di GitHub (atau pakai repo yang sudah ada), lalu `Add file → Upload files` di browser dan unggah keempat GLB.
2. Buka file di GitHub, klik tombol **Raw** → salin URL-nya. Bentuknya seperti:
   `https://raw.githubusercontent.com/USERNAME/REPO/main/Koi_Carp_Rare.glb`
3. Kirim keempat link itu ke chat dalam satu pesan. Saya unduh langsung pakai `curl` dan pasang ke proyek.

Alternatif: taruh file sebagai **Release** (`Releases → Draft a new release → Attach binaries`), lalu kirim link unduhnya:
`https://github.com/USERNAME/REPO/releases/download/TAG/Koi_Carp_Rare.glb`

**C. Google Drive / Dropbox**
Unggah, setel akses publik ("Anyone with the link"), kirim link-nya. (GitHub biasanya lebih andal untuk file binary besar.)

Catatan: jangan ZIP — kalau ZIP-nya tetap sekitar 20 MB batasnya tetap kena.

## Yang akan dikerjakan

1. **Pasang model koi (common)** yang sudah kamu kirim ke dalam proyek, dengan pengecilan ukuran file dulu (kompresi geometri + tekstur) supaya game tetap ringan saat dimuat. Target di bawah ~3 MB per ikan.

2. **Sistem model ikan per kelangkaan.** Satu daftar pemetaan: common, rare, epic, legendary, mythic → file model masing‑masing. Ikan yang tersangkut di kail akan menampilkan model sesuai kelangkaan tangkapan, bukan lagi ikan kotak-kotak buatan kode.

3. **Cadangan aman.** Untuk tingkat yang modelnya belum kamu kirim, ikan lama tetap dipakai dengan warna khas tiap tingkat, jadi game tidak pernah kosong atau error. Begitu file berikutnya dikirim lewat chat, tinggal ditambahkan ke daftar tanpa mengubah kode lain.

4. **Penyesuaian ukuran & arah hadap** tiap model (skala dan putaran) supaya ikan tampil proporsional di tangan pemain dan menghadap arah yang benar.

Monster (Ancient Leviathan) tetap memakai tampilan raksasa yang sekarang, kecuali kamu ingin diganti juga.

## Yang perlu kamu lakukan
Kirim 4 file sisanya (rare, epic, legendary, mythic) lewat salah satu cara di atas. Kalau pakai GitHub, kirim 4 link raw dalam satu pesan saja.

## Catatan teknis
- File disimpan di `public/models/` seperti model dunia lain, dikompresi Draco/WebP agar konsisten dengan aset yang sudah ada.
- Pemetaan baru di `src/lib/fishModels.ts`; `Fish.tsx` mendapat komponen pemuat GLB dengan Suspense + error boundary; `Angler.tsx` memilih model berdasarkan `rarity` dari `useGameStore`.
- Tidak menyentuh sistem cuaca, toko, tas, atau penyimpanan tangkapan.
