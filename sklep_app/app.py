from flask import Flask, render_template, request, redirect, url_for
import pyodbc

app = Flask(__name__)

# Konfiguracja połączenia z bazą danych SQL Server
server = r'DESKTOP-MR4THBO\SQLEXPRESS01'
connection_string = f'DRIVER={{ODBC Driver 17 for SQL Server}};SERVER={server};DATABASE=Sklep;Trusted_Connection=yes;'

def get_db_connection():
    try:
        conn = pyodbc.connect(connection_string)
        return conn
    except Exception as e:
        print(f"Error connecting to the database: {e}")
        return None

@app.route('/')
def index():
    return render_template('index.html')

@app.route('/klienci')
def lista_klientow():
    conn = get_db_connection()
    if conn:
        cursor = conn.cursor()
        cursor.execute('SELECT Id_klienta, Imie, Nazwisko, email, Telefon, AdresKlienta FROM klienci')
        klienci = cursor.fetchall()
        conn.close()
        return render_template('lista_klientow.html', klienci=klienci)
    else:
        return "Error connecting to the database."

@app.route('/pracownicy')
def lista_pracownikow():
    conn = get_db_connection()
    if conn:
        cursor = conn.cursor()
        cursor.execute('SELECT Id_pracownika, login_pracownika, Imie_pracownika FROM pracownicy')
        pracownicy = cursor.fetchall()
        conn.close()
        return render_template('lista_pracownikow.html', pracownicy=pracownicy)
    else:
        return "Error connecting to the database."

@app.route('/zamowienia')
def lista_zamowien():
    conn = get_db_connection()
    if conn:
        cursor = conn.cursor()
        cursor.execute('SELECT Id_zamowienia, Id_klienta, ZamowionyProdukt, WartoscZamowienia, StatusZamowienia FROM zamowienia')
        zamowienia = cursor.fetchall()
        conn.close()
        return render_template('lista_zamowien.html', zamowienia=zamowienia)
    else:
        return "Error connecting to the database."

@app.route('/dodaj_zamowienie', methods=['GET', 'POST'])
def dodaj_zamowienie():
    if request.method == 'POST':
        id_klienta = request.form['id_klienta']
        zamowiony_produkt = request.form['zamowiony_produkt']
        wartosc_zamowienia = request.form['wartosc_zamowienia']
        status_zamowienia = request.form['status_zamowienia']
        
        conn = get_db_connection()
        if conn:
            try:
                cursor = conn.cursor()
                cursor.execute('SELECT Id_klienta FROM klienci WHERE Id_klienta = ?', (id_klienta,))
                if cursor.fetchone() is None:
                    # If the client does not exist, insert a new client with default values
                    cursor.execute('INSERT INTO klienci (Id_klienta, Imie, Nazwisko, email, Telefon, AdresKlienta) VALUES (?, ?, ?, ?, ?, ?)',
                                   (id_klienta, 'DefaultName', 'DefaultSurname', 'email@example.com', '000000000', 'DefaultAddress'))
                
                cursor.execute('SELECT MAX(Id_zamowienia) FROM zamowienia')
                max_id = cursor.fetchone()[0]
                if max_id is None:
                    max_id = 0
                id_zamowienia = max_id + 1
                
                cursor.execute('INSERT INTO zamowienia (Id_zamowienia, Id_klienta, ZamowionyProdukt, WartoscZamowienia, StatusZamowienia) VALUES (?, ?, ?, ?, ?)',
                               (id_zamowienia, id_klienta, zamowiony_produkt, wartosc_zamowienia, status_zamowienia))
                conn.commit()
                return render_template('dodaj_zamowienie.html', success=True)
            except Exception as e:
                print(f"Error executing query: {e}")
                return render_template('dodaj_zamowienie.html', error=True)
            finally:
                conn.close()
        else:
            return render_template('dodaj_zamowienie.html', error=True)
    return render_template('dodaj_zamowienie.html')

@app.route('/dodaj_pracownika', methods=['GET', 'POST'])
def dodaj_pracownika():
    if request.method == 'POST':
        imie_pracownika = request.form['imie_pracownika']
        login_pracownika = request.form['login_pracownika']

        conn = get_db_connection()
        if conn:
            try:
                cursor = conn.cursor()
                cursor.execute('INSERT INTO pracownicy (Imie_pracownika, login_pracownika) VALUES (?, ?)',
                               (imie_pracownika, login_pracownika))
                conn.commit()
                return render_template('dodaj_pracownika.html', success=True)
            except Exception as e:
                print(f"Error executing query: {e}")
                return render_template('dodaj_pracownika.html', error=True)
            finally:
                conn.close()
        else:
            return render_template('dodaj_pracownika.html', error=True)
    return render_template('dodaj_pracownika.html')

if __name__ == '__main__':
    app.run(debug=True)
