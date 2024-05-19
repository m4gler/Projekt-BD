USE [Sklep]
GO
/****** Object:  Table [dbo].[zamowienia]    Script Date: 19.05.2024 09:34:27 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[zamowienia](
	[Id_zamowienia] [int] NOT NULL,
	[Id_klienta] [int] NOT NULL,
	[ZamowionyProdukt] [varchar](50) NOT NULL,
	[WartoscZamowienia] [money] NOT NULL,
	[StatusZamowienia] [varchar](50) NOT NULL,
	[termin] [date] NULL,
	[DataNadania] [date] NULL,
	[DataDostarczenia] [date] NULL,
	[Termin_dostawy] [date] NULL,
	[Id_Produktu] [int] NULL,
	[Id_Dzialu] [int] NULL,
PRIMARY KEY CLUSTERED 
(
	[Id_zamowienia] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[klienci]    Script Date: 19.05.2024 09:34:27 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[klienci](
	[Id_klienta] [int] NOT NULL,
	[Imie] [nvarchar](50) NULL,
	[Nazwisko] [nvarchar](50) NULL,
	[email] [varchar](100) NULL,
	[Telefon] [varchar](11) NULL,
	[AdresKlienta] [nvarchar](50) NULL,
PRIMARY KEY CLUSTERED 
(
	[Id_klienta] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[produkty]    Script Date: 19.05.2024 09:34:27 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[produkty](
	[Id_Produktu] [int] NOT NULL,
	[RodzajeProduktow] [varchar](255) NULL,
	[rozmiar] [decimal](10, 2) NULL,
	[marka] [varchar](50) NULL,
	[DostepnoscProduktu] [varchar](50) NULL,
	[Cena] [money] NULL,
	[Opis] [text] NULL,
	[Opinie] [text] NULL,
PRIMARY KEY CLUSTERED 
(
	[Id_Produktu] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
/****** Object:  View [dbo].[View_SzczegolyZamowien]    Script Date: 19.05.2024 09:34:27 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE VIEW [dbo].[View_SzczegolyZamowien] AS
SELECT 
    z.Id_zamowienia,
    k.Imie,
    k.Nazwisko,
    k.Telefon,
    p.marka,
    p.RodzajeProduktow,
    p.Opis,
    z.ZamowionyProdukt,
    z.WartoscZamowienia,
    z.StatusZamowienia,
    z.DataNadania,
    z.DataDostarczenia
FROM zamowienia z
JOIN klienci k ON z.Id_klienta = k.ID_klienta
JOIN produkty p ON z.Id_Produktu = p.Id_Produktu;
GO
/****** Object:  View [dbo].[View_DostepnoscProduktow]    Script Date: 19.05.2024 09:34:27 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
--CREATE VIEW View_SzczegolyZamowien AS
--SELECT 
--    z.Id_zamowienia,
--    k.Imie,
--    k.Nazwisko,
--    k.Telefon,
--    p.marka,
--    p.RodzajeProduktow,
--    p.Opis,
--    z.ZamowionyProdukt,
--    z.WartoscZamowienia,
--    z.StatusZamowienia,
--    z.DataNadania,
--    z.DataDostarczenia
--FROM zamowienia z
--JOIN klienci k ON z.Id_klienta = k.ID_klienta
--JOIN produkty p ON z.Id_Produktu = p.Id_Produktu;





CREATE VIEW [dbo].[View_DostepnoscProduktow] AS
SELECT 
    Id_Produktu,
    RodzajeProduktow,
    rozmiar,
    marka,
    DostepnoscProduktu,
    Cena,
    COUNT(*) AS IloscDostepna
FROM produkty
WHERE DostepnoscProduktu = 'Dostępny'
GROUP BY Id_Produktu, RodzajeProduktow, rozmiar, marka, DostepnoscProduktu, Cena;

GO
/****** Object:  View [dbo].[View_AnalizaPrzychodow]    Script Date: 19.05.2024 09:34:27 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
--CREATE VIEW View_SzczegolyZamowien AS
--SELECT 
--    z.Id_zamowienia,
--    k.Imie,
--    k.Nazwisko,
--    k.Telefon,
--    p.marka,
--    p.RodzajeProduktow,
--    p.Opis,
--    z.ZamowionyProdukt,
--    z.WartoscZamowienia,
--    z.StatusZamowienia,
--    z.DataNadania,
--    z.DataDostarczenia
--FROM zamowienia z
--JOIN klienci k ON z.Id_klienta = k.ID_klienta
--JOIN produkty p ON z.Id_Produktu = p.Id_Produktu;





--CREATE VIEW View_DostepnoscProduktow AS
--SELECT 
--    Id_Produktu,
--    RodzajeProduktow,
--    rozmiar,
--    marka,
--    DostepnoscProduktu,
--    Cena,
--    COUNT(*) AS IloscDostepna
--FROM produkty
--WHERE DostepnoscProduktu = 'Dostępny'
--GROUP BY Id_Produktu, RodzajeProduktow, rozmiar, marka, DostepnoscProduktu, Cena;


CREATE VIEW [dbo].[View_AnalizaPrzychodow] AS
SELECT 
    p.RodzajeProduktow,
    SUM(z.WartoscZamowienia) AS SumaPrzychodow,
    COUNT(z.Id_zamowienia) AS LiczbaZamowien,
    AVG(z.WartoscZamowienia) AS SredniaWartoscZamowienia
FROM zamowienia z
JOIN produkty p ON z.Id_Produktu = p.Id_Produktu
GROUP BY p.RodzajeProduktow;
GO
/****** Object:  Table [dbo].[adresy]    Script Date: 19.05.2024 09:34:27 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[adresy](
	[Id_adresu] [int] NOT NULL,
	[ulica] [varchar](100) NULL,
	[numer] [varchar](10) NULL,
	[miasto] [varchar](50) NULL,
	[kod_pocztowy] [varchar](10) NULL,
	[kraj] [varchar](50) NULL,
PRIMARY KEY CLUSTERED 
(
	[Id_adresu] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[dzialy]    Script Date: 19.05.2024 09:34:27 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[dzialy](
	[Id_Dzialu] [int] NOT NULL,
	[nazwa_dzialu] [varchar](100) NULL,
	[opis] [varchar](255) NULL,
PRIMARY KEY CLUSTERED 
(
	[Id_Dzialu] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[pracownicy]    Script Date: 19.05.2024 09:34:27 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[pracownicy](
	[Id_pracownika] [int] NULL,
	[AdresPracownika] [int] NULL,
	[login_pracownika] [varchar](50) NULL,
	[haslo_pracownika] [varchar](50) NULL,
	[Imie_pracownika] [varchar](50) NULL,
	[Data_zatrudnienia] [date] NULL,
	[Id_Dzialu] [int] NULL,
	[id_adresu] [int] NULL
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[przychody]    Script Date: 19.05.2024 09:34:27 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[przychody](
	[id_przychodu] [int] NOT NULL,
	[przychody_miesieczne] [money] NULL,
	[przychody_roczne] [money] NULL,
	[Przychody_z_Zamowienia] [money] NULL,
	[Id_Zamowienia] [int] NULL,
	[ZamowienieId] [int] NULL,
PRIMARY KEY CLUSTERED 
(
	[id_przychodu] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[wydatki]    Script Date: 19.05.2024 09:34:27 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[wydatki](
	[id_wydatku] [int] NOT NULL,
	[wydatki_miesieczne] [money] NULL,
	[wydatki_roczne] [money] NULL,
	[wydatki_na_produkty] [money] NULL,
	[Id_Produktu] [int] NULL,
PRIMARY KEY CLUSTERED 
(
	[id_wydatku] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
INSERT [dbo].[adresy] ([Id_adresu], [ulica], [numer], [miasto], [kod_pocztowy], [kraj]) VALUES (1, N'Warszawska', N'10', N'Warszawa', N'00-001', N'Polska')
INSERT [dbo].[adresy] ([Id_adresu], [ulica], [numer], [miasto], [kod_pocztowy], [kraj]) VALUES (2, N'Gdańska', N'24', N'Gdańsk', N'80-001', N'Polska')
INSERT [dbo].[adresy] ([Id_adresu], [ulica], [numer], [miasto], [kod_pocztowy], [kraj]) VALUES (3, N'Krakowska', N'56', N'Kraków', N'30-001', N'Polska')
INSERT [dbo].[adresy] ([Id_adresu], [ulica], [numer], [miasto], [kod_pocztowy], [kraj]) VALUES (4, N'Wrocławska', N'78', N'Wrocław', N'50-001', N'Polska')
INSERT [dbo].[adresy] ([Id_adresu], [ulica], [numer], [miasto], [kod_pocztowy], [kraj]) VALUES (5, N'Poznańska', N'34', N'Poznań', N'60-001', N'Polska')
INSERT [dbo].[adresy] ([Id_adresu], [ulica], [numer], [miasto], [kod_pocztowy], [kraj]) VALUES (6, N'Łódzka', N'12', N'Łódź', N'90-001', N'Polska')
INSERT [dbo].[adresy] ([Id_adresu], [ulica], [numer], [miasto], [kod_pocztowy], [kraj]) VALUES (7, N'Szczecińska', N'90', N'Szczecin', N'70-001', N'Polska')
INSERT [dbo].[adresy] ([Id_adresu], [ulica], [numer], [miasto], [kod_pocztowy], [kraj]) VALUES (8, N'Lubelska', N'18', N'Lublin', N'20-001', N'Polska')
INSERT [dbo].[adresy] ([Id_adresu], [ulica], [numer], [miasto], [kod_pocztowy], [kraj]) VALUES (9, N'Bydgoska', N'40', N'Bydgoszcz', N'85-001', N'Polska')
INSERT [dbo].[adresy] ([Id_adresu], [ulica], [numer], [miasto], [kod_pocztowy], [kraj]) VALUES (10, N'Białostocka', N'65', N'Białystok', N'15-001', N'Polska')
GO
INSERT [dbo].[dzialy] ([Id_Dzialu], [nazwa_dzialu], [opis]) VALUES (1, N'Sprzedaż', N'Dział odpowiedzialny za sprzedaż produktów')
INSERT [dbo].[dzialy] ([Id_Dzialu], [nazwa_dzialu], [opis]) VALUES (2, N'Marketing', N'Dział odpowiedzialny za promocję i reklamę')
INSERT [dbo].[dzialy] ([Id_Dzialu], [nazwa_dzialu], [opis]) VALUES (3, N'Obsługa klienta', N'Dział odpowiedzialny za obsługę klientów i wsparcie')
GO
INSERT [dbo].[klienci] ([Id_klienta], [Imie], [Nazwisko], [email], [Telefon], [AdresKlienta]) VALUES (1, N'Jan', N'Kowalski', NULL, NULL, NULL)
INSERT [dbo].[klienci] ([Id_klienta], [Imie], [Nazwisko], [email], [Telefon], [AdresKlienta]) VALUES (2, N'Anna', N'Nowak', NULL, NULL, NULL)
INSERT [dbo].[klienci] ([Id_klienta], [Imie], [Nazwisko], [email], [Telefon], [AdresKlienta]) VALUES (3, N'Piotr', N'Wiśniewski', NULL, NULL, NULL)
INSERT [dbo].[klienci] ([Id_klienta], [Imie], [Nazwisko], [email], [Telefon], [AdresKlienta]) VALUES (4, N'Maria', N'Kaczmarek', NULL, NULL, NULL)
INSERT [dbo].[klienci] ([Id_klienta], [Imie], [Nazwisko], [email], [Telefon], [AdresKlienta]) VALUES (5, N'Krzysztof', N'Jankowski', NULL, NULL, NULL)
INSERT [dbo].[klienci] ([Id_klienta], [Imie], [Nazwisko], [email], [Telefon], [AdresKlienta]) VALUES (6, N'Barbara', N'Lewandowska', NULL, NULL, NULL)
INSERT [dbo].[klienci] ([Id_klienta], [Imie], [Nazwisko], [email], [Telefon], [AdresKlienta]) VALUES (7, N'Tomasz', N'Kamiński', NULL, NULL, NULL)
INSERT [dbo].[klienci] ([Id_klienta], [Imie], [Nazwisko], [email], [Telefon], [AdresKlienta]) VALUES (8, N'Małgorzata', N'Wójcik', NULL, NULL, NULL)
INSERT [dbo].[klienci] ([Id_klienta], [Imie], [Nazwisko], [email], [Telefon], [AdresKlienta]) VALUES (9, N'Michał', N'Kowalczyk', NULL, NULL, NULL)
INSERT [dbo].[klienci] ([Id_klienta], [Imie], [Nazwisko], [email], [Telefon], [AdresKlienta]) VALUES (10, N'Agnieszka', N'Kowalska', NULL, NULL, NULL)
GO
INSERT [dbo].[pracownicy] ([Id_pracownika], [AdresPracownika], [login_pracownika], [haslo_pracownika], [Imie_pracownika], [Data_zatrudnienia], [Id_Dzialu], [id_adresu]) VALUES (1, 1, N'jank', N'pass123', N'Jan', CAST(N'2021-06-01' AS Date), 1, 1)
INSERT [dbo].[pracownicy] ([Id_pracownika], [AdresPracownika], [login_pracownika], [haslo_pracownika], [Imie_pracownika], [Data_zatrudnienia], [Id_Dzialu], [id_adresu]) VALUES (2, 2, N'annan', N'pass124', N'Anna', CAST(N'2021-07-01' AS Date), 2, 2)
INSERT [dbo].[pracownicy] ([Id_pracownika], [AdresPracownika], [login_pracownika], [haslo_pracownika], [Imie_pracownika], [Data_zatrudnienia], [Id_Dzialu], [id_adresu]) VALUES (3, 3, N'piotrw', N'pass125', N'Piotr', CAST(N'2021-08-01' AS Date), 3, 3)
INSERT [dbo].[pracownicy] ([Id_pracownika], [AdresPracownika], [login_pracownika], [haslo_pracownika], [Imie_pracownika], [Data_zatrudnienia], [Id_Dzialu], [id_adresu]) VALUES (4, 4, N'mariak', N'pass126', N'Maria', CAST(N'2021-09-01' AS Date), 1, 4)
INSERT [dbo].[pracownicy] ([Id_pracownika], [AdresPracownika], [login_pracownika], [haslo_pracownika], [Imie_pracownika], [Data_zatrudnienia], [Id_Dzialu], [id_adresu]) VALUES (5, 5, N'krzysj', N'pass127', N'Krzysztof', CAST(N'2021-10-01' AS Date), 2, 5)
INSERT [dbo].[pracownicy] ([Id_pracownika], [AdresPracownika], [login_pracownika], [haslo_pracownika], [Imie_pracownika], [Data_zatrudnienia], [Id_Dzialu], [id_adresu]) VALUES (6, 6, N'barbal', N'pass128', N'Barbara', CAST(N'2021-11-01' AS Date), 3, 6)
INSERT [dbo].[pracownicy] ([Id_pracownika], [AdresPracownika], [login_pracownika], [haslo_pracownika], [Imie_pracownika], [Data_zatrudnienia], [Id_Dzialu], [id_adresu]) VALUES (7, 7, N'tomask', N'pass129', N'Tomasz', CAST(N'2021-12-01' AS Date), 1, 7)
INSERT [dbo].[pracownicy] ([Id_pracownika], [AdresPracownika], [login_pracownika], [haslo_pracownika], [Imie_pracownika], [Data_zatrudnienia], [Id_Dzialu], [id_adresu]) VALUES (8, 8, N'malgow', N'pass130', N'Małgorzata', CAST(N'2022-01-01' AS Date), 2, 8)
INSERT [dbo].[pracownicy] ([Id_pracownika], [AdresPracownika], [login_pracownika], [haslo_pracownika], [Imie_pracownika], [Data_zatrudnienia], [Id_Dzialu], [id_adresu]) VALUES (9, 9, N'michak', N'pass131', N'Michał', CAST(N'2022-02-01' AS Date), 3, 9)
INSERT [dbo].[pracownicy] ([Id_pracownika], [AdresPracownika], [login_pracownika], [haslo_pracownika], [Imie_pracownika], [Data_zatrudnienia], [Id_Dzialu], [id_adresu]) VALUES (10, 10, N'agnieszk', N'pass132', N'Agnieszka', CAST(N'2022-03-01' AS Date), 1, 10)
GO
INSERT [dbo].[produkty] ([Id_Produktu], [RodzajeProduktow], [rozmiar], [marka], [DostepnoscProduktu], [Cena], [Opis], [Opinie]) VALUES (1, N'Buty', CAST(42.00 AS Decimal(10, 2)), N'Nike', N'Dostępny', 250.0000, N'Buty sportowe Nike Air Max', N'Bardzo wygodne i stylowe')
INSERT [dbo].[produkty] ([Id_Produktu], [RodzajeProduktow], [rozmiar], [marka], [DostepnoscProduktu], [Cena], [Opis], [Opinie]) VALUES (2, N'Buty', CAST(38.00 AS Decimal(10, 2)), N'Adidas', N'Dostępny', 220.0000, N'Buty do biegania Adidas', N'Idealne do długich dystansów')
INSERT [dbo].[produkty] ([Id_Produktu], [RodzajeProduktow], [rozmiar], [marka], [DostepnoscProduktu], [Cena], [Opis], [Opinie]) VALUES (3, N'Buty', CAST(44.00 AS Decimal(10, 2)), N'Puma', N'Dostępny', 200.0000, N'Buty męskie casual', N'Dobrze wykonane i komfortowe')
INSERT [dbo].[produkty] ([Id_Produktu], [RodzajeProduktow], [rozmiar], [marka], [DostepnoscProduktu], [Cena], [Opis], [Opinie]) VALUES (4, N'Odzież', CAST(44.00 AS Decimal(10, 2)), N'Levis', N'Dostępny', 180.0000, N'Klasyczne jeansy Levis', N'Trwałe i modne')
INSERT [dbo].[produkty] ([Id_Produktu], [RodzajeProduktow], [rozmiar], [marka], [DostepnoscProduktu], [Cena], [Opis], [Opinie]) VALUES (5, N'Odzież', CAST(41.00 AS Decimal(10, 2)), N'Calvin Klein', N'Dostępny', 160.0000, N'T-shirt Calvin Klein', N'Wysoka jakość materiału')
INSERT [dbo].[produkty] ([Id_Produktu], [RodzajeProduktow], [rozmiar], [marka], [DostepnoscProduktu], [Cena], [Opis], [Opinie]) VALUES (6, N'Odzież', CAST(39.00 AS Decimal(10, 2)), N'Hugo Boss', N'Dostępny', 300.0000, N'Kurtka zimowa Hugo Boss', N'Ciepła i stylowa')
INSERT [dbo].[produkty] ([Id_Produktu], [RodzajeProduktow], [rozmiar], [marka], [DostepnoscProduktu], [Cena], [Opis], [Opinie]) VALUES (7, N'Buty', CAST(41.00 AS Decimal(10, 2)), N'Lacoste', N'Dostępny', 230.0000, N'Sneakersy Lacoste', N'Modne i wygodne')
INSERT [dbo].[produkty] ([Id_Produktu], [RodzajeProduktow], [rozmiar], [marka], [DostepnoscProduktu], [Cena], [Opis], [Opinie]) VALUES (8, N'Odzież', CAST(45.00 AS Decimal(10, 2)), N'Tommy Hilfiger', N'Dostępny', 250.0000, N'Sweter Tommy Hilfiger', N'Elegancki i ciepły')
INSERT [dbo].[produkty] ([Id_Produktu], [RodzajeProduktow], [rozmiar], [marka], [DostepnoscProduktu], [Cena], [Opis], [Opinie]) VALUES (9, N'Odzież', CAST(43.00 AS Decimal(10, 2)), N'Ralph Lauren', N'Dostępny', 270.0000, N'Koszula Polo Ralph Lauren', N'Klasyczny design, wysoka jakość')
INSERT [dbo].[produkty] ([Id_Produktu], [RodzajeProduktow], [rozmiar], [marka], [DostepnoscProduktu], [Cena], [Opis], [Opinie]) VALUES (10, N'Buty', CAST(39.00 AS Decimal(10, 2)), N'Converse', N'Dostępny', 150.0000, N'Trampki Converse All Star', N'Ikoniczne i komfortowe')
GO
INSERT [dbo].[zamowienia] ([Id_zamowienia], [Id_klienta], [ZamowionyProdukt], [WartoscZamowienia], [StatusZamowienia], [termin], [DataNadania], [DataDostarczenia], [Termin_dostawy], [Id_Produktu], [Id_Dzialu]) VALUES (1, 1, N'Buty sportowe Nike Air Max', 250.0000, N'Zrealizowane', CAST(N'2023-04-01' AS Date), CAST(N'2023-03-20' AS Date), CAST(N'2023-04-01' AS Date), CAST(N'2023-04-02' AS Date), 1, NULL)
INSERT [dbo].[zamowienia] ([Id_zamowienia], [Id_klienta], [ZamowionyProdukt], [WartoscZamowienia], [StatusZamowienia], [termin], [DataNadania], [DataDostarczenia], [Termin_dostawy], [Id_Produktu], [Id_Dzialu]) VALUES (2, 2, N'Buty do biegania Adidas', 220.0000, N'W realizacji', CAST(N'2023-04-02' AS Date), CAST(N'2023-03-21' AS Date), NULL, CAST(N'2023-04-03' AS Date), 2, NULL)
INSERT [dbo].[zamowienia] ([Id_zamowienia], [Id_klienta], [ZamowionyProdukt], [WartoscZamowienia], [StatusZamowienia], [termin], [DataNadania], [DataDostarczenia], [Termin_dostawy], [Id_Produktu], [Id_Dzialu]) VALUES (3, 3, N'Buty męskie casual Puma', 200.0000, N'Zrealizowane', CAST(N'2023-04-03' AS Date), CAST(N'2023-03-22' AS Date), CAST(N'2023-04-03' AS Date), CAST(N'2023-04-04' AS Date), 3, NULL)
INSERT [dbo].[zamowienia] ([Id_zamowienia], [Id_klienta], [ZamowionyProdukt], [WartoscZamowienia], [StatusZamowienia], [termin], [DataNadania], [DataDostarczenia], [Termin_dostawy], [Id_Produktu], [Id_Dzialu]) VALUES (4, 4, N'Klasyczne jeansy Levis', 180.0000, N'W realizacji', CAST(N'2023-04-04' AS Date), CAST(N'2023-03-23' AS Date), NULL, CAST(N'2023-04-05' AS Date), 4, NULL)
INSERT [dbo].[zamowienia] ([Id_zamowienia], [Id_klienta], [ZamowionyProdukt], [WartoscZamowienia], [StatusZamowienia], [termin], [DataNadania], [DataDostarczenia], [Termin_dostawy], [Id_Produktu], [Id_Dzialu]) VALUES (5, 5, N'T-shirt Calvin Klein', 160.0000, N'Zrealizowane', CAST(N'2023-04-05' AS Date), CAST(N'2023-03-24' AS Date), CAST(N'2023-04-05' AS Date), CAST(N'2023-04-06' AS Date), 5, NULL)
INSERT [dbo].[zamowienia] ([Id_zamowienia], [Id_klienta], [ZamowionyProdukt], [WartoscZamowienia], [StatusZamowienia], [termin], [DataNadania], [DataDostarczenia], [Termin_dostawy], [Id_Produktu], [Id_Dzialu]) VALUES (6, 6, N'Kurtka zimowa Hugo Boss', 300.0000, N'W realizacji', CAST(N'2023-04-06' AS Date), CAST(N'2023-03-25' AS Date), NULL, CAST(N'2023-04-07' AS Date), 6, NULL)
INSERT [dbo].[zamowienia] ([Id_zamowienia], [Id_klienta], [ZamowionyProdukt], [WartoscZamowienia], [StatusZamowienia], [termin], [DataNadania], [DataDostarczenia], [Termin_dostawy], [Id_Produktu], [Id_Dzialu]) VALUES (7, 7, N'Sneakersy Lacoste', 230.0000, N'Zrealizowane', CAST(N'2023-04-07' AS Date), CAST(N'2023-03-26' AS Date), CAST(N'2023-04-07' AS Date), CAST(N'2023-04-08' AS Date), 7, NULL)
INSERT [dbo].[zamowienia] ([Id_zamowienia], [Id_klienta], [ZamowionyProdukt], [WartoscZamowienia], [StatusZamowienia], [termin], [DataNadania], [DataDostarczenia], [Termin_dostawy], [Id_Produktu], [Id_Dzialu]) VALUES (8, 8, N'Sweter Tommy Hilfiger', 250.0000, N'W realizacji', CAST(N'2023-04-08' AS Date), CAST(N'2023-03-27' AS Date), NULL, CAST(N'2023-04-09' AS Date), 8, NULL)
INSERT [dbo].[zamowienia] ([Id_zamowienia], [Id_klienta], [ZamowionyProdukt], [WartoscZamowienia], [StatusZamowienia], [termin], [DataNadania], [DataDostarczenia], [Termin_dostawy], [Id_Produktu], [Id_Dzialu]) VALUES (9, 9, N'Koszula Polo Ralph Lauren', 270.0000, N'Zrealizowane', CAST(N'2023-04-09' AS Date), CAST(N'2023-03-28' AS Date), CAST(N'2023-04-09' AS Date), CAST(N'2023-04-10' AS Date), 9, NULL)
INSERT [dbo].[zamowienia] ([Id_zamowienia], [Id_klienta], [ZamowionyProdukt], [WartoscZamowienia], [StatusZamowienia], [termin], [DataNadania], [DataDostarczenia], [Termin_dostawy], [Id_Produktu], [Id_Dzialu]) VALUES (10, 10, N'Trampki Converse All Star', 150.0000, N'W realizacji', CAST(N'2023-04-10' AS Date), CAST(N'2023-03-29' AS Date), NULL, CAST(N'2023-04-11' AS Date), 10, NULL)
GO
ALTER TABLE [dbo].[pracownicy]  WITH CHECK ADD  CONSTRAINT [fk_adres_pracownika] FOREIGN KEY([id_adresu])
REFERENCES [dbo].[adresy] ([Id_adresu])
GO
ALTER TABLE [dbo].[pracownicy] CHECK CONSTRAINT [fk_adres_pracownika]
GO
ALTER TABLE [dbo].[pracownicy]  WITH CHECK ADD  CONSTRAINT [FK_pracownicy_dzialy] FOREIGN KEY([Id_Dzialu])
REFERENCES [dbo].[dzialy] ([Id_Dzialu])
GO
ALTER TABLE [dbo].[pracownicy] CHECK CONSTRAINT [FK_pracownicy_dzialy]
GO
ALTER TABLE [dbo].[przychody]  WITH CHECK ADD  CONSTRAINT [FK_przychody_zamowienia] FOREIGN KEY([Id_Zamowienia])
REFERENCES [dbo].[zamowienia] ([Id_zamowienia])
GO
ALTER TABLE [dbo].[przychody] CHECK CONSTRAINT [FK_przychody_zamowienia]
GO
ALTER TABLE [dbo].[wydatki]  WITH CHECK ADD  CONSTRAINT [fk_wydatki_produkty] FOREIGN KEY([Id_Produktu])
REFERENCES [dbo].[produkty] ([Id_Produktu])
GO
ALTER TABLE [dbo].[wydatki] CHECK CONSTRAINT [fk_wydatki_produkty]
GO
ALTER TABLE [dbo].[zamowienia]  WITH CHECK ADD FOREIGN KEY([Id_klienta])
REFERENCES [dbo].[klienci] ([Id_klienta])
GO
ALTER TABLE [dbo].[zamowienia]  WITH CHECK ADD  CONSTRAINT [FK_zamowienia_dzialy] FOREIGN KEY([Id_Dzialu])
REFERENCES [dbo].[dzialy] ([Id_Dzialu])
GO
ALTER TABLE [dbo].[zamowienia] CHECK CONSTRAINT [FK_zamowienia_dzialy]
GO
ALTER TABLE [dbo].[zamowienia]  WITH CHECK ADD  CONSTRAINT [fk_zamowienia_klienci] FOREIGN KEY([Id_klienta])
REFERENCES [dbo].[klienci] ([Id_klienta])
GO
ALTER TABLE [dbo].[zamowienia] CHECK CONSTRAINT [fk_zamowienia_klienci]
GO
ALTER TABLE [dbo].[zamowienia]  WITH CHECK ADD  CONSTRAINT [FK_zamowienia_produkty] FOREIGN KEY([Id_Produktu])
REFERENCES [dbo].[produkty] ([Id_Produktu])
GO
ALTER TABLE [dbo].[zamowienia] CHECK CONSTRAINT [FK_zamowienia_produkty]
GO
/****** Object:  StoredProcedure [dbo].[AktualizujStatusZamowienia]    Script Date: 19.05.2024 09:34:27 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[AktualizujStatusZamowienia]
    @Id_zamowienia int,
    @NowyStatus varchar(50)
AS
BEGIN
    UPDATE zamowienia
    SET StatusZamowienia = @NowyStatus
    WHERE Id_zamowienia = @Id_zamowienia;
END;
GO
/****** Object:  StoredProcedure [dbo].[DodajZamowienie]    Script Date: 19.05.2024 09:34:27 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[DodajZamowienie]
    @Id_klienta int,
    @ZamowionyProdukt varchar(50),
    @WartoscZamowienia money,
    @StatusZamowienia varchar(50),
    @Termin date,
    @Id_Dzialu int
AS
BEGIN
    INSERT INTO zamowienia (Id_klienta, ZamowionyProdukt, WartoscZamowienia, StatusZamowienia, termin, Id_Dzialu)
    VALUES (@Id_klienta, @ZamowionyProdukt, @WartoscZamowienia, @StatusZamowienia, @Termin, @Id_Dzialu);
END;
GO
/****** Object:  Trigger [dbo].[AktualizujDateDostarczenia]    Script Date: 19.05.2024 09:34:27 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE TRIGGER [dbo].[AktualizujDateDostarczenia]
ON [dbo].[zamowienia]
AFTER UPDATE
AS
BEGIN
    IF UPDATE(StatusZamowienia)
    BEGIN
        UPDATE zamowienia
        SET DataDostarczenia = GETDATE()
        FROM zamowienia
        JOIN inserted i ON zamowienia.Id_zamowienia = i.Id_zamowienia
        WHERE i.StatusZamowienia = 'Dostarczone' AND zamowienia.StatusZamowienia != 'Dostarczone';
    END
END;
GO
ALTER TABLE [dbo].[zamowienia] ENABLE TRIGGER [AktualizujDateDostarczenia]
GO
