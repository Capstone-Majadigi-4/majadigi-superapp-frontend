import os
from appium import webdriver
from appium.options.common import AppiumOptions

def before_all(context):
    """
    Hook yang dijalankan sebelum seluruh test suite dimulai.
    Menginisialisasi driver Appium dengan Desired Capabilities untuk Android.
    """
    # Definisikan capabilities untuk emulator/device Android
    capabilities = {
        'platformName': 'Android',
        'automationName': 'UiAutomator2',
        'deviceName': 'emulator-5554', # Nama emulator default
        'appPackage': 'com.example.majadigi_superapp_frontend',
        'appActivity': 'com.example.majadigi_superapp_frontend.MainActivity',
        'noReset': False, # Mulai aplikasi dari kondisi bersih setiap test suite
        'newCommandTimeout': 300,
        # 'app': os.path.abspath('../build/app/outputs/flutter-apk/app-debug.apk') # Opsional jika ingin meng-install APK langsung
    }

    # Konversi dict ke AppiumOptions untuk kompatibilitas Appium 2.x
    options = AppiumOptions()
    options.load_capabilities(capabilities)

    # Inisialisasi koneksi ke Appium Server lokal (default port 4723)
    appium_server_url = 'http://localhost:4723'
    
    print("Menghubungkan ke Appium Server di: " + appium_server_url)
    try:
        context.driver = webdriver.Remote(appium_server_url, options=options)
        context.driver.implicitly_wait(10) # Timeout implisit 10 detik
    except Exception as e:
        print(f"ERROR: Gagal terhubung ke Appium Server. Pastikan Server Appium sudah aktif.")
        print(f"Detail Error: {e}")
        raise e

def after_scenario(context, scenario):
    """
    Hook yang dijalankan setelah setiap skenario selesai.
    Melakukan reset aplikasi agar state kembali bersih untuk skenario berikutnya.
    """
    if hasattr(context, 'driver'):
        print(f"Skenario selesai: '{scenario.name}'. Melakukan reset aplikasi...")
        context.driver.terminate_app('com.example.majadigi_superapp_frontend')
        context.driver.activate_app('com.example.majadigi_superapp_frontend')

def after_all(context):
    """
    Hook yang dijalankan setelah seluruh pengujian selesai.
    Menutup koneksi driver.
    """
    if hasattr(context, 'driver'):
        print("Menutup driver Appium...")
        context.driver.quit()
