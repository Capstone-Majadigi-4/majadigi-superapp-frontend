from behave import given, when, then
from selenium.webdriver.common.by import By
from selenium.webdriver.support.ui import WebDriverWait
from selenium.webdriver.support import expected_conditions as EC
import time

# --- UTILITIES FOR LOCATING ELEMENTS ---
def find_element_by_text(driver, text, timeout=10):
    """Mencari elemen teks di Flutter (yang di-expose ke Android UIAutomator2)"""
    xpath = f"//*[contains(@text, '{text}') or @content-desc='{text}']"
    return WebDriverWait(driver, timeout).until(
        EC.presence_of_element_located((By.XPATH, xpath))
    )

def click_element_by_text(driver, text):
    element = find_element_by_text(driver, text)
    element.click()

# --- STEPS FOR REGISTRATION ---

@given('pengguna membuka halaman Register')
def step_impl(context):
    time.sleep(2)

    click_element_by_text(context.driver, "Daftar Sekarang")

@when('pengguna mengisi nama "{nama}"')
def step_impl(context, nama):

    name_field = context.driver.find_element(By.XPATH, "//android.widget.EditText[1]")
    name_field.clear()
    name_field.send_keys(nama)

@when('pengguna mengisi NIK "{nik}"')
def step_impl(context, nik):
    nik_field = context.driver.find_element(By.XPATH, "//android.widget.EditText[2]")
    nik_field.clear()
    nik_field.send_keys(nik)

@when('pengguna mengisi nomor HP "{nomor_hp}"')
def step_impl(context, nomor_hp):
    hp_field = context.driver.find_element(By.XPATH, "//android.widget.EditText[3]")
    hp_field.clear()
    hp_field.send_keys(nomor_hp)

@when('pengguna mengisi alamat "{alamat}"')
def step_impl(context, alamat):
    alamat_field = context.driver.find_element(By.XPATH, "//android.widget.EditText[4]")
    alamat_field.clear()
    alamat_field.send_keys(alamat)

@when('pengguna mengisi password "{password}"')
def step_impl(context, password):
    pwd_field = context.driver.find_element(By.XPATH, "//android.widget.EditText[5]")
    pwd_field.clear()
    pwd_field.send_keys(password)

@when('pengguna menekan tombol "{tombol}"')
def step_impl(context, tombol):
    click_element_by_text(context.driver, tombol)

@then('aplikasi harus menampilkan halaman Onboarding Pemilihan Layanan')
def step_impl(context):
    assert find_element_by_text(context.driver, "Pilih Layanan") is not None


@given('pengguna membuka halaman Login')
def step_impl(context):
    time.sleep(2)
    assert find_element_by_text(context.driver, "Masuk") is not None

@when('pengguna mengisi NIK dengan "{nik}"')
def step_impl(context, nik):
    nik_field = context.driver.find_element(By.XPATH, "//android.widget.EditText[1]")
    nik_field.clear()
    nik_field.send_keys(nik)

@when('pengguna mengisi password dengan "{password}"')
def step_impl(context, password):
    pwd_field = context.driver.find_element(By.XPATH, "//android.widget.EditText[2]")
    pwd_field.clear()
    pwd_field.send_keys(password)

@then('aplikasi harus menampilkan halaman Dashboard Utama')
def step_impl(context):
    time.sleep(3)
    assert find_element_by_text(context.driver, "Majadigi") is not None

@then('bagian "{favorit}" menampilkan modul pilihan onboarding secara dinamis')
def step_impl(context, favorit):
    favorit_header = find_element_by_text(context.driver, favorit)
    assert favorit_header is not None

@then('aplikasi harus menampilkan pesan kesalahan "{pesan}"')
def step_impl(context, pesan):
    error_element = find_element_by_text(context.driver, pesan)
    assert error_element is not None
