# Panduan QA Automation Black Box Testing - Majadigi Superapp

Repositori ini berisi framework pengujian **Black Box Automation Testing** khusus untuk **QA (Quality Assurance) Engineer**. Framework ini menggunakan pendekatan **BDD (Behavior-Driven Development)** sehingga skenario pengujian ditulis dalam bahasa manusia yang mudah dipahami oleh dosen penguji maupun tim bisnis.

---

## 🛠️ Tech Stack & Dependencies

1. **Bahasa Pemrograman**: Python 3.8+
2. **Framework BDD**: `behave` (Gherkin parser untuk Python)
3. **Driver Otomasi**: Appium (menggunakan `Appium-Python-Client`)
4. **Target Platform**: Android Emulator (dapat dikonfigurasi ke iOS Simulator)
5. **Driver Device**: UiAutomator2 (Android)

---

## 📋 Prasyarat Instalasi (Prerequisites)

Sebelum menjalankan pengujian, pastikan Anda telah menginstal komponen-komponen berikut di komputer Anda:

### 1. Python 3
*   Unduh dan instal dari [python.org](https://www.python.org/downloads/).
*   Pastikan opsi **"Add Python to PATH"** dicentang saat proses instalasi.

### 2. Node.js & Appium Server
*   Unduh dan instal Node.js dari [nodejs.org](https://nodejs.org/).
*   Instal Appium Server secara global melalui Command Prompt / Terminal:
    ```bash
    npm install -g appium
    ```
*   Instal driver **UiAutomator2** untuk Android:
    ```bash
    appium driver install uiautomator2
    ```

### 3. Android SDK & Emulator
*   Instal Android Studio dan pastikan **Android SDK** serta emulator (AVD) sudah terkonfigurasi.
*   Tambahkan variable environment `ANDROID_HOME` yang mengarah ke lokasi SDK Anda.

---

## 🚀 Setup & Instalasi Framework Testing

1. Buka terminal/command prompt dan masuk ke folder testing ini:
   ```bash
   cd qa_blackbox_testing
   ```

2. Buat Python Virtual Environment (opsional namun direkomendasikan):
   ```bash
   python -m venv venv
   # Untuk Windows:
   .\venv\Scripts\activate
   # Untuk macOS/Linux:
   source venv/bin/activate
   ```

3. Instal seluruh dependencies Python yang dibutuhkan:
   ```bash
   pip install -r requirements.txt
   ```

---

## 📱 Konfigurasi & Persiapan Pengujian

### 1. Build APK Debug Aplikasi
Jalankan perintah ini di root project Flutter untuk membuat berkas `.apk` yang akan diuji:
```bash
flutter build apk --debug
```
Hasil build `.apk` akan tersimpan di: `build/app/outputs/flutter-apk/app-debug.apk`.

### 2. Konfigurasi Device di `environment.py`
Buka berkas [features/environment.py](file:///d:/majadigi-superapp-frontend/qa_blackbox_testing/features/environment.py) dan sesuaikan konfigurasi emulator Anda di bagian `capabilities`:
*   `deviceName`: Sesuaikan dengan nama emulator Anda (jalankan `adb devices` untuk melihat daftar emulator aktif).
*   `appPackage`: Default `com.example.majadigi_superapp_frontend`.
*   `appActivity`: Default `com.example.majadigi_superapp_frontend.MainActivity`.

---

## 🏃 Menjalankan Pengujian

1. **Jalankan Emulator Android** Anda terlebih dahulu.
2. **Aktifkan Appium Server** di terminal terpisah:
   ```bash
   appium
   ```
3. **Jalankan Test Suite** menggunakan Behave:
   ```bash
   # Masuk ke folder qa_blackbox_testing jika belum
   cd qa_blackbox_testing
   
   # Jalankan semua skenario pengujian
   behave
   
   # Jalankan skenario fitur tertentu saja (misal: otentikasi)
   behave features/auth.feature
   
   # Jalankan skenario fitur perpajakan
   behave features/bapenda.feature
   ```

---

## 📂 Struktur Folder Testing

```text
qa_blackbox_testing/
├── features/
│   ├── steps/
│   │   ├── auth_steps.py       # Pemetaan kode Python untuk fitur login/register
│   │   └── bapenda_steps.py    # Pemetaan kode Python untuk fitur Bapenda
│   ├── environment.py          # Setup & Teardown Driver Appium (Hooks)
│   ├── auth.feature            # Skenario BDD Gherkin (Login & Register)
│   └── bapenda.feature         # Skenario BDD Gherkin (Cek & Bayar Pajak)
├── README.md                   # Dokumentasi panduan ini
└── requirements.txt            # Daftar library Python dependencies
```

---

## 💡 Cara Membaca & Menulis Skenario BDD (Gherkin)

Skenario ditulis dalam format BDD Gherkin di dalam file `.feature`. 
Contoh di dalam [auth.feature](file:///d:/majadigi-superapp-frontend/qa_blackbox_testing/features/auth.feature):
```gherkin
  Skenario: Pendaftaran Akun Baru Berhasil
    Mengingat pengguna membuka halaman Register
    Ketika pengguna mengisi nama "Agus Prasetyo"
    Dan pengguna mengisi NIK "3578010203040001"
    Dan pengguna menekan tombol "Daftar"
    Maka aplikasi harus menampilkan halaman Onboarding Pemilihan Layanan
```

Kalimat-kalimat tersebut didefinisikan ke dalam kode otomasi Python di folder `steps/` menggunakan decorator `@given`, `@when`, dan `@then`. Contoh:
```python
@when('pengguna mengisi nama "{nama}"')
def step_impl(context, nama):
    name_field = context.driver.find_element(By.XPATH, "//android.widget.EditText[1]")
    name_field.clear()
    name_field.send_keys(nama)
```
QA Engineer cukup menambahkan skenario baru di file `.feature` dan mencocokkannya dengan elemen UIAutomator2 di dalam file `steps/`.
