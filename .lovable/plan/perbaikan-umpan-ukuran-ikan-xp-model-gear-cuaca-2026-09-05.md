# Perbaikan Umpan, Ukuran Ikan, XP, Model Gear & Cuaca

## Temuan penting (sudah dicek)

Seluruh tabel katalog game di database **kosong** (0 baris untuk ikan, joran, umpan, bobot rarity, cuaca, dan konfigurasi). Itulah sebab utama "ganti umpan tidak berubah apa-apa": daftar umpan pemain dibangun dari tabel katalog yang kosong, jadi pemasangan umpan tidak pernah benar-benar tersimpan/berlaku dan permainan jatuh ke nilai cadangan bawaan yang sama untuk semua umpan. Ini terjadi karena proyek di-remix ke instance backend baru tanpa isi data.

## Yang akan dikerjakan

### 1. Isi ulang data katalog (perbaikan umpan)
Satu perubahan database yang mengisi kembali: jenis ikan, bobot kemunculan tiap rarity, daftar joran, daftar umpan (dengan pengali peluang per rarity yang berbeda nyata tiap tingkat), mutasi, efek cuaca, siklus cuaca, dan konfigurasi umum. Setelah itu memasang Uncommon Bait benar-benar mengubah peluang tangkapan, tampilan di tangan, dan tanda "terpasang" di toko — begitu pula tingkat di atasnya.

### 2. Ukuran ikan
Skala tiap rarity dikalikan sesuai permintaan: common 10x, epic 15x, rare 20x, legendary 30x, mythic 50x (dipakai persis seperti angka yang diberikan, walau rare jadi lebih besar dari epic).

### 3. Gambar ikan di tas
Ikon ikan di tas tidak lagi gambar stiker buatan. Tiap model ikan dirender sekali di latar belakang menjadi gambar kecil, disimpan sementara, lalu dipakai sebagai ikon slot tas — jadi yang tampil persis bentuk ikan aslinya.

### 4. XP dan level
Naik satu level butuh 500 XP, berlaku terus tanpa batas level (level 2 di 500, level 3 di 1.000, dan seterusnya). Diubah di tampilan sekaligus di database supaya angka level pemain konsisten.

### 5. Model joran unik per tingkat
Enam joran dibuat bentuknya berbeda, bukan sekadar beda warna: dari joran kayu sederhana, joran serat dengan ring logam, joran ramping bergaris, joran berukir dengan permata, joran emas berhias, sampai joran mythic dengan bilah melayang dan efek cahaya. Bentuk berbeda ini tampil di tangan pemain dan di kartu toko.

### 6. Model umpan unik per tingkat
Sama untuk umpan: dari cacing sederhana, umpan serangga, umpan ikan kecil bersirip, umpan kristal, umpan berpendar dengan cincin berputar, sampai umpan mythic berbentuk inti api dengan partikel. Tampil di ujung kail dan di kartu toko.

### 7. Kabut cuaca
Nilai kabut disetel sesuai daftar: cerah 0, berawan 5, berkabut 15, hujan 4, badai 8. Angka ini dipakai sebagai satuan kabut dalam game dan dikonversi ke kepadatan kabut layar secara proporsional, sehingga berkabut jelas paling tebal dan cerah benar-benar bersih.

## Catatan teknis

- Migrasi mengisi `fish_species`, `rarity_base_weights`, `rod_tiers`, `bait_tiers` (`rarity_multiplier` berbeda tiap tier), `mutations`, `weather_effects`, `weather_cycle_config`, `game_config`; plus `level_for_xp`/`xp_for_rarity` diubah ke kurva 500 XP/level.
- `src/lib/fishModels.ts`: skala `length` per rarity dikalikan faktor baru; `weightScale` tetap.
- Ikon tas: util baru (mis. `src/lib/fishThumbnails.ts`) merender GLB per rarity ke `WebGLRenderer` offscreen sekali, hasil data URL di-cache; `Hotbar.tsx` memakainya dengan fallback ke `FishThumbnail` lama saat model belum siap.
- `src/lib/xp.ts`: `xpForLevel(n) = 500 * (n - 1)`, `levelForXp` = `floor(xp/500)+1`, tanpa batas.
- `src/lib/rodLooks.ts` + bagian rod di `Angler.tsx`/`RodShop.tsx`: tambah field bentuk (`shape`) per tier dan komponen geometri per bentuk.
- `src/lib/baitLooks.ts` + `Angler.tsx`/`BaitShop.tsx`: sama, komponen umpan per tier.
- `src/hooks/useWeather.ts`: `fogDensity` = nilai/1000 (cerah 0, berawan 0.005, berkabut 0.015, hujan 0.004, badai 0.008); `Weather.tsx` sudah menganimasikan nilainya, tidak berubah.
- Verifikasi: typecheck plus screenshot Playwright untuk ukuran ikan, ikon tas, dan tiap cuaca.
