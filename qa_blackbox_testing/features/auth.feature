# language: id
Fitur: Otentikasi Pengguna (Login & Register)
  Sebagai pengguna baru atau lama
  Saya ingin mendaftar dan masuk ke dalam aplikasi
  Agar saya dapat mengakses layanan superapp Majadigi

  Skenario: Pendaftaran Akun Baru Berhasil
    Mengingat pengguna membuka halaman Register
    Ketika pengguna mengisi nama "Agus Prasetyo"
    Dan pengguna mengisi NIK "3578010203040001"
    Dan pengguna mengisi nomor HP "081234567890"
    Dan pengguna mengisi alamat "Jl. Sukarno Hatta No. 10, Malang"
    Dan pengguna mengisi password "KataSandi123!"
    Dan pengguna menekan tombol "Daftar"
    Maka aplikasi harus menampilkan halaman Onboarding Pemilihan Layanan

  Skenario: Masuk Aplikasi Berhasil dengan Akun Terdaftar
    Mengingat pengguna membuka halaman Login
    Ketika pengguna mengisi NIK dengan "3578010203040001"
    Dan pengguna mengisi password dengan "KataSandi123!"
    Dan pengguna menekan tombol "Masuk"
    Maka aplikasi harus menampilkan halaman Dashboard Utama
    Dan bagian "Favorit" menampilkan modul pilihan onboarding secara dinamis

  Skenario: Masuk Aplikasi Gagal karena Password Salah
    Mengingat pengguna membuka halaman Login
    Ketika pengguna mengisi NIK dengan "3578010203040001"
    Dan pengguna mengisi password dengan "SalahSandi123"
    Dan pengguna menekan tombol "Masuk"
    Maka aplikasi harus menampilkan pesan kesalahan "NIK atau password salah"
