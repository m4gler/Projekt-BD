from flask import Flask, render_template, request, redirect, url_for
import pyodbc

app = Flask(__name__)

server = r'DESKTOP-9RRMPQC\SQLEXPRESS'  
database = 'Sklep'  
driver = '{ODBC Driver 17 for SQL Server}'  

conn_string = f'DRIVER={driver};SERVER={server};DATABASE={database};Trusted_Connection=yes;'

@app.route('/')
def index():
    return render_template('index.html')

@app.route('/products')
def products():
    conn = pyodbc.connect(conn_string)
    cursor = conn.cursor()
    cursor.execute("SELECT * FROM produkty")
    products = cursor.fetchall()
    products_list = [{'Id_Produktu': row.Id_Produktu, 'RodzajeProduktow': row.RodzajeProduktow, 'rozmiar': row.rozmiar, 'marka': row.marka, 'DostepnoscProduktu': row.DostepnoscProduktu, 'Cena': row.Cena, 'Opis': row.Opis, 'Opinie': row.Opinie} for row in products]
    conn.close()
    return render_template('products.html', products=products_list)

@app.route('/orders')
def orders():
    conn = pyodbc.connect(conn_string)
    cursor = conn.cursor()
    cursor.execute("SELECT * FROM zamowienia")
    orders = cursor.fetchall()
    orders_list = [{'Id_zamowienia': row.Id_zamowienia, 'Id_klienta': row.Id_klienta, 'ZamowionyProdukt': row.ZamowionyProdukt, 'WartoscZamowienia': row.WartoscZamowienia, 'StatusZamowienia': row.StatusZamowienia, 'termin': row.termin, 'DataNadania': row.DataNadania, 'DataDostarczenia': row.DataDostarczenia, 'Termin_dostawy': row.Termin_dostawy, 'Id_Produktu': row.Id_Produktu, 'Id_Dzialu': row.Id_Dzialu} for row in orders]
    conn.close()
    return render_template('orders.html', orders=orders_list)

@app.route('/customers')
def customers():
    conn = pyodbc.connect(conn_string)
    cursor = conn.cursor()
    cursor.execute("SELECT * FROM klienci")
    customers = cursor.fetchall()
    customers_list = [{'Id_klienta': row.Id_klienta, 'Imie': row.Imie, 'Nazwisko': row.Nazwisko, 'email': row.email, 'Telefon': row.Telefon, 'AdresKlienta': row.AdresKlienta} for row in customers]
    conn.close()
    return render_template('customers.html', customers=customers_list)

@app.route('/api/products', methods=['POST', 'PUT', 'DELETE'])
def manage_products():
    conn = pyodbc.connect(conn_string)
    cursor = conn.cursor()

    if request.method == 'POST':
        new_product = request.form
        cursor.execute("INSERT INTO produkty (RodzajeProduktow, rozmiar, marka, DostepnoscProduktu, Cena, Opis, Opinie) VALUES (?, ?, ?, ?, ?, ?, ?)",
                       new_product['RodzajeProduktow'], new_product['rozmiar'], new_product['marka'],
                       new_product['DostepnoscProduktu'], new_product['Cena'], new_product['Opis'],
                       new_product['Opinie'])
        conn.commit()
        conn.close()
        return redirect(url_for('products'))

    if request.method == 'PUT':
        updated_product = request.form
        cursor.execute("UPDATE produkty SET RodzajeProduktow = ?, rozmiar = ?, marka = ?, DostepnoscProduktu = ?, Cena = ?, Opis = ?, Opinie = ? WHERE Id_Produktu = ?",
                       updated_product['RodzajeProduktow'], updated_product['rozmiar'], updated_product['marka'],
                       updated_product['DostepnoscProduktu'], updated_product['Cena'], updated_product['Opis'],
                       updated_product['Opinie'], updated_product['Id_Produktu'])
        conn.commit()
        conn.close()
        return redirect(url_for('products'))

    if request.method == 'DELETE':
        product_id = request.form.get('id')
        cursor.execute("DELETE FROM produkty WHERE Id_Produktu = ?", product_id)
        conn.commit()
        conn.close()
        return redirect(url_for('products'))

@app.route('/api/orders', methods=['POST', 'PUT', 'DELETE'])
def manage_orders():
    conn = pyodbc.connect(conn_string)
    cursor = conn.cursor()

    if request.method == 'POST':
        new_order = request.form
        cursor.execute("INSERT INTO zamowienia (Id_klienta, ZamowionyProdukt, WartoscZamowienia, StatusZamowienia, termin, Id_Produktu, Id_Dzialu) VALUES (?, ?, ?, ?, ?, ?, ?)",
                       new_order['Id_klienta'], new_order['ZamowionyProdukt'], new_order['WartoscZamowienia'],
                       new_order['StatusZamowienia'], new_order['termin'], new_order['Id_Produktu'],
                       new_order['Id_Dzialu'])
        conn.commit()
        conn.close()
        return redirect(url_for('orders'))

    if request.method == 'PUT':
        updated_order = request.form
        cursor.execute("UPDATE zamowienia SET Id_klienta = ?, ZamowionyProdukt = ?, WartoscZamowienia = ?, StatusZamowienia = ?, termin = ?, Id_Produktu = ?, Id_Dzialu = ? WHERE Id_zamowienia = ?",
                       updated_order['Id_klienta'], updated_order['ZamowionyProdukt'], updated_order['WartoscZamowienia'],
                       updated_order['StatusZamowienia'], updated_order['termin'], updated_order['Id_Produktu'],
                       updated_order['Id_Dzialu'], updated_order['Id_zamowienia'])
        conn.commit()
        conn.close()
        return redirect(url_for('orders'))

    if request.method == 'DELETE':
        order_id = request.form.get('id')
        cursor.execute("DELETE FROM zamowienia WHERE Id_zamowienia = ?", order_id)
        conn.commit()
        conn.close()
        return redirect(url_for('orders'))

@app.route('/api/customers', methods=['POST', 'PUT', 'DELETE'])
def manage_customers():
    conn = pyodbc.connect(conn_string)
    cursor = conn.cursor()

    if request.method == 'POST':
        new_customer = request.form
        cursor.execute("INSERT INTO klienci (Imie, Nazwisko, email, Telefon, AdresKlienta) VALUES (?, ?, ?, ?, ?)",
                       new_customer['Imie'], new_customer['Nazwisko'], new_customer['email'],
                       new_customer['Telefon'], new_customer['AdresKlienta'])
        conn.commit()
        conn.close()
        return redirect(url_for('customers'))

    if request.method == 'PUT':
        updated_customer = request.form
        cursor.execute("UPDATE klienci SET Imie = ?, Nazwisko = ?, email = ?, Telefon = ?, AdresKlienta = ? WHERE Id_klienta = ?",
                       updated_customer['Imie'], updated_customer['Nazwisko'], updated_customer['email'],
                       updated_customer['Telefon'], updated_customer['AdresKlienta'], updated_customer['Id_klienta'])
        conn.commit()
        conn.close()
        return redirect(url_for('customers'))

    if request.method == 'DELETE':
        customer_id = request.form.get('id')
        cursor.execute("DELETE FROM klienci WHERE Id_klienta = ?", customer_id)
        conn.commit()
        conn.close()
        return redirect(url_for('customers'))

if __name__ == '__main__':
    app.run(debug=True)
