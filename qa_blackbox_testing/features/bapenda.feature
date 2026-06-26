# language: id
Fitur: Pajak Daerah Bapenda
  Sebagai wajib pajak pemilik kendaraan
  Saya ingin melihat tagihan pajak dan membayarnya secara online
  Agar kewajiban pajak saya terpenuhi dan peringatan pajak di dashboard hilang

  Latar Belakang:
    Mengingat pengguna sudah login ke dashboard utama
    Dan dashboard menampilkan banner peringatan "Jatuh Tempo Pajak" untuk kendaraan "L 1234 AB"

  Skenario: Memeriksa Rincian Tagihan Pajak Kendaraan
    Mengingat pengguna menekan mini app "Bapenda" pada dashboard
    Ketika pengguna memilih kendaraan "L 1234 AB" di daftar kendaraan
    Maka aplikasi harus menampilkan halaman Rincian Kendaraan
    Dan menampilkan merk "HONDA" tipe "VARIO 150"
    Dan menampilkan status pembayaran "Belum Bayar"

  Skenario: Membayar Pajak Kendaraan Melalui VA Bank
    Mengingat pengguna berada di halaman Rincian Kendaraan "L 1234 AB"
    Ketika pengguna menekan tombol "Bayar Sekarang"
    Dan pengguna memilih metode pembayaran "Virtual Account Bank Jatim"
    Dan pengguna menekan tombol "Konfirmasi Pembayaran"
    Maka aplikasi harus memproses pembayaran hingga sukses
    Dan menampilkan halaman Sukses Pembayaran dengan QR Code E-TBPKB
    Ketika pengguna kembali ke halaman Dashboard Utama
    Maka banner peringatan "Jatuh Tempo Pajak" harus hilang dari layar
