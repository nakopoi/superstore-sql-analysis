# Data Import Instructions

Dokumen ini menjelaskan cara menyiapkan dan meng-import dataset yang digunakan pada project **Superstore Sales Analysis using SQL**.

Project ini hanya menggunakan sheet:

**`Orders`**

dari workbook Sample Superstore.

Sheet berikut **tidak digunakan** dalam project ini:

* `People`
* `Returns`

---

# 1. Dataset

Dataset yang digunakan berada pada:

`dataset/orders.csv`

File `orders.csv` berasal dari sheet **Orders** pada workbook Sample Superstore.

Dataset memiliki:

* **10.194 baris data transaksi/order line**
* **5.111 order unik**
* Periode data **2023–2026**

---

# 2. Karakteristik File CSV

File `orders.csv` memiliki format berikut:

```text
Delimiter          : ;
Encoding           : UTF-8
Date Format        : DD/MM/YYYY
Decimal Separator  : ,
Header             : Baris pertama
```

Contoh data numerik:

```text
Sales     : 16,448
Discount  : 0,2
Profit    : 5,5512
```

Karena menggunakan koma sebagai decimal separator, beberapa kolom numerik sementara di-import sebagai `TEXT`.

Data tersebut akan dikonversi menjadi tipe numerik pada proses Data Cleaning.

---

# 3. Persiapan MySQL

Project ini menggunakan:

* MySQL 8.0
* MySQL Workbench

Sebelum melakukan import dataset, jalankan:

`sql/01_database_setup.sql`

Script tersebut akan membuat database:

```sql
CREATE DATABASE IF NOT EXISTS superstore_portfolio;
```

dan memilih database:

```sql
USE superstore_portfolio;
```

---

# 4. Import Dataset Menggunakan MySQL Workbench

Buka MySQL Workbench.

Pada panel:

```text
SCHEMAS
```

pilih:

```text
superstore_portfolio
```

Pastikan schema tersebut aktif.

Kemudian:

1. Klik kanan `superstore_portfolio`.
2. Pilih **Table Data Import Wizard**.
3. Pilih file:

`dataset/orders.csv`

4. Pilih:

**Create new table**

5. Gunakan nama tabel:

`orders_raw`

---

# 5. Tipe Data Saat Import

Gunakan tipe data berikut untuk kolom penting:

| Column         | Import Data Type |
| -------------- | ---------------- |
| Row ID         | INT              |
| Order ID       | TEXT             |
| Order Date     | TEXT             |
| Ship Date      | TEXT             |
| Ship Mode      | TEXT             |
| Customer ID    | TEXT             |
| Customer Name  | TEXT             |
| Segment        | TEXT             |
| Country/Region | TEXT             |
| City           | TEXT             |
| State/Province | TEXT             |
| Postal Code    | VARCHAR(20)      |
| Region         | TEXT             |
| Product ID     | TEXT             |
| Category       | TEXT             |
| Sub-Category   | TEXT             |
| Product Name   | TEXT             |
| Sales          | TEXT             |
| Quantity       | INT              |
| Discount       | TEXT             |
| Profit         | TEXT             |

---

# 6. Mengapa Beberapa Kolom Menggunakan TEXT?

Kolom:

```text
Order Date
Ship Date
Sales
Discount
Profit
```

sengaja disimpan sebagai `TEXT` pada tabel raw.

Hal ini dilakukan karena format data asli masih menggunakan format lokal.

Contoh tanggal:

```text
03/01/2023
```

Contoh angka:

```text
16,448
0,2
5,5512
```

Pada proses Data Cleaning, data tersebut akan dikonversi menjadi:

```text
Order Date  → DATE
Ship Date   → DATE
Sales       → DECIMAL
Discount    → DECIMAL
Profit      → DECIMAL
```

---

# 7. Postal Code

Postal Code harus menggunakan tipe:

```text
VARCHAR(20)
```

dan bukan `INT`.

Hal ini karena beberapa Postal Code dapat mengandung huruf.

Contoh:

```text
M7A
```

Jika Postal Code menggunakan tipe `INT`, data seperti ini dapat menghasilkan warning saat proses import.

---

# 8. Delimiter CSV

File `orders.csv` menggunakan:

```text
;
```

sebagai delimiter.

Contoh header:

```text
Row ID;Order ID;Order Date;Ship Date;Ship Mode;...
```

Pastikan MySQL membaca:

```text
FIELDS TERMINATED BY ';'
```

dan bukan menggunakan koma sebagai delimiter.

---

# 9. Validasi Hasil Import

Setelah proses import selesai, jalankan:

```sql
SELECT COUNT(*) AS total_rows
FROM orders_raw;
```

Expected result:

```text
10194
```

Jika hasilnya:

```text
10194
```

maka seluruh dataset telah berhasil di-import.

---

# 10. Jika Table Data Import Wizard Hanya Meng-import Sebagian Data

Pada beberapa environment MySQL Workbench, Table Data Import Wizard dapat meng-import hanya sebagian dataset.

Jika jumlah data bukan:

```text
10194
```

tabel dapat dikosongkan terlebih dahulu:

```sql
TRUNCATE TABLE orders_raw;
```

Kemudian gunakan:

```sql
LOAD DATA LOCAL INFILE
```

untuk melakukan import.

---

# 11. Mengaktifkan LOCAL INFILE

Periksa status:

```sql
SHOW VARIABLES LIKE 'local_infile';
```

Jika hasilnya:

```text
OFF
```

aktifkan menggunakan:

```sql
SET GLOBAL local_infile = ON;
```

Kemudian cek kembali:

```sql
SHOW VARIABLES LIKE 'local_infile';
```

Expected result:

```text
local_infile    ON
```

---

# 12. Pengaturan MySQL Workbench untuk LOCAL INFILE

Jika muncul error seperti:

```text
Error Code: 2068
LOAD DATA LOCAL INFILE file request rejected
due to restrictions on access
```

buka:

```text
Database
→ Manage Connections
→ Local instance MySQL80
→ Advanced
```

Pada bagian:

```text
Others
```

tambahkan:

```text
OPT_LOCAL_INFILE=1
```

Simpan pengaturan tersebut kemudian reconnect ke MySQL Server.

---

# 13. Import Menggunakan LOAD DATA LOCAL INFILE

Gunakan query berikut.

Ganti:

```text
PATH_TO_PROJECT
```

dengan lokasi project pada komputer masing-masing.

Contoh:

```sql
LOAD DATA LOCAL INFILE 'PATH_TO_PROJECT/dataset/orders.csv'
INTO TABLE orders_raw
CHARACTER SET utf8mb4
FIELDS TERMINATED BY ';'
OPTIONALLY ENCLOSED BY '"'
LINES TERMINATED BY '\r\n'
IGNORE 1 LINES;
```

Contoh path Windows:

```text
C:/Users/USERNAME/Documents/Superstore_SQL_Portfolio/dataset/orders.csv
```

Gunakan `/` pada path agar lebih mudah dibaca oleh MySQL.

---

# 14. Validasi Ulang Setelah Import

Jalankan kembali:

```sql
SELECT COUNT(*) AS total_rows
FROM orders_raw;
```

Expected result:

```text
10194
```

Pastikan proses import tidak menghasilkan warning yang berkaitan dengan Postal Code atau tipe data lainnya.

---

# 15. Data Cleaning

Setelah tabel:

`orders_raw`

berhasil dibuat dengan **10.194 rows**, jalankan:

`sql/02_data_cleaning.sql`

Script tersebut akan membuat tabel:

`orders_clean`

---

# 16. Transformasi yang Dilakukan pada Data Cleaning

Beberapa transformasi utama:

### Order Date

Dari:

```text
03/01/2023
```

menjadi:

```text
2023-01-03
```

dan disimpan sebagai tipe:

```text
DATE
```

---

### Sales

Dari:

```text
16,448
```

menjadi:

```text
16.4480
```

dan disimpan sebagai:

```text
DECIMAL(12,4)
```

---

### Discount

Dari:

```text
0,2
```

menjadi:

```text
0.2000
```

dan disimpan sebagai:

```text
DECIMAL(5,4)
```

---

### Profit

Dari:

```text
5,5512
```

menjadi:

```text
5.5512
```

dan disimpan sebagai:

```text
DECIMAL(12,4)
```

---

# 17. Validasi orders_clean

Setelah menjalankan:

`02_data_cleaning.sql`

cek jumlah data:

```sql
SELECT COUNT(*) AS total_clean_rows
FROM orders_clean;
```

Expected result:

```text
10194
```

---

# 18. Data Quality Check

Setelah Data Cleaning selesai, jalankan:

`sql/03_data_quality_check.sql`

Script tersebut melakukan pengecekan:

* Missing Values
* Duplicate Row ID
* Invalid Shipping Dates
* Sales Range
* Quantity Range
* Discount Range
* Profit Range

Expected validation:

```text
Total Rows                : 10194
Important Missing Values  : 0
Duplicate Row ID          : 0
Invalid Shipping Dates    : 0
```

---

# 19. Urutan Menjalankan Project

Urutan workflow project:

```text
1. 01_database_setup.sql
          ↓
2. Import dataset/orders.csv
          ↓
3. orders_raw
          ↓
4. 02_data_cleaning.sql
          ↓
5. orders_clean
          ↓
6. 03_data_quality_check.sql
          ↓
7. Business Analysis
```

Setelah Data Quality Check selesai, analisis dapat dilanjutkan menggunakan:

```text
04_kpi_category_analysis.sql
05_discount_analysis.sql
06_region_analysis.sql
07_customer_analysis.sql
08_product_analysis.sql
09_sales_trend_analysis.sql
10_advanced_analysis.sql
```

---

# Scope Project

Project ini hanya menggunakan:

**Orders**

dan tidak menggunakan:

```text
People
Returns
```

Karena itu project tidak mencakup:

* Return Analysis
* Return Rate
* Regional Manager Analysis
* Multi-table JOIN dengan People dan Returns

Fokus project adalah:

**Single-table Sales Analysis menggunakan SQL.**
