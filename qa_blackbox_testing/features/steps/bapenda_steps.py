from behave import given, when, then
from selenium.webdriver.common.by import By
from selenium.webdriver.support.ui import WebDriverWait
from selenium.webdriver.support import expected_conditions as EC
import time
from auth_steps import find_element_by_text, click_element_by_text

# --- BACKGROUND STEPS ---

@given('pengguna sudah login ke dashboard utama')
def step_impl(context):
    time.sleep(2) 
    nik_field = context.driver.find_element(By.XPATH, "//android.widget.EditText[1]")
    nik_field.clear()
    nik_field.send_keys("3578010203040001")
    pwd_field = context.driver.find_element(By.XPATH, "//android.widget.EditText[2]")
    pwd_field.clear()
    pwd_field.send_keys("KataSandi123!")
    click_element_by_text(context.driver, "Masuk")
    
    time.sleep(3)
    assert find_element_by_text(context.driver, "Majadigi") is not None

@given('dashboard menampilkan banner peringatan "Jatuh Tempo Pajak" untuk kendaraan "{plat_nomor}"')
def step_impl(context, plat_nomor):
    assert find_element_by_text(context.driver, "Jatuh Tempo Pajak") is not None
    assert find_element_by_text(context.driver, plat_nomor) is not None


# --- SCENARIO 1: CHECK BILL ---

@given('pengguna menekan mini app "Bapenda" pada dashboard')
def step_impl(context):
    click_element_by_text(context.driver, "Bapenda")
    time.sleep(2)

@when('pengguna memilih kendaraan "{plat_nomor}" di daftar kendaraan')
def step_impl(context, plat_nomor):
    click_element_by_text(context.driver, plat_nomor)
    time.sleep(2)

@then('aplikasi harus menampilkan halaman Rincian Kendaraan')
def step_impl(context):    
    assert find_element_by_text(context.driver, "Informasi Kendaraan") is not None

@then('menampilkan merk "{merk}" tipe "{tipe}"')
def step_impl(context, merk, tipe):
    assert find_element_by_text(context.driver, merk) is not None
    assert find_element_by_text(context.driver, tipe) is not None

@then('menampilkan status pembayaran "{status}"')
def step_impl(context, status):    
    assert find_element_by_text(context.driver, status) is not None


# --- SCENARIO 2: PAY BILL ---

@given('pengguna berada di halaman Rincian Kendaraan "{plat_nomor}"')
def step_impl(context, plat_nomor):    
    assert find_element_by_text(context.driver, "Informasi Kendaraan") is not None
    assert find_element_by_text(context.driver, plat_nomor) is not None

@when('pengguna menekan tombol "Bayar Sekarang"')
def step_impl(context):
    click_element_by_text(context.driver, "Bayar Sekarang")
    time.sleep(2)

@when('pengguna memilih metode pembayaran "{metode}"')
def step_impl(context, metode):
    click_element_by_text(context.driver, metode)
    time.sleep(1)

@when('pengguna menekan tombol "Konfirmasi Pembayaran"')
def step_impl(context):
    click_element_by_text(context.driver, "Konfirmasi Pembayaran")
    time.sleep(3) # Tunggu pemrosesan pembayaran mockup

@then('aplikasi harus memproses pembayaran hingga sukses')
def step_impl(context):
    assert find_element_by_text(context.driver, "Pembayaran Berhasil") is not None

@then('menampilkan halaman Sukses Pembayaran dengan QR Code E-TBPKB')
def step_impl(context):
    assert find_element_by_text(context.driver, "Lihat E-TBPKB") is not None
    click_element_by_text(context.driver, "Lihat E-TBPKB")
    time.sleep(2)
    assert find_element_by_text(context.driver, "E-TBPKB DIGITAL") is not None

@when('pengguna kembali ke halaman Dashboard Utama')
def step_impl(context):
    back_button = context.driver.find_element(By.XPATH, "//android.widget.ImageButton or //android.widget.ImageView[1]")
    back_button.click()
    time.sleep(1)
    back_button.click()
    time.sleep(2)

@then('banner peringatan "Jatuh Tempo Pajak" harus hilang dari layar')
def step_impl(context):
    context.driver.implicitly_wait(1)
    elements = context.driver.find_elements(By.XPATH, "//*[contains(@text, 'Jatuh Tempo Pajak')]")
    context.driver.implicitly_wait(10) 
    assert len(elements) == 0, "Banner peringatan pajak masih muncul di dashboard!"
