# Superstore Sales Analysis using SQL

## Ringkasan Project

Project ini menganalisis data penjualan **Superstore** menggunakan MySQL untuk mengevaluasi performa penjualan, profitabilitas, customer, produk, wilayah, discount, serta tren penjualan dari waktu ke waktu.

Analisis dilakukan terhadap **10.194 baris data transaksi/order line** dari tahun **2023 sampai 2026**, yang terdiri dari **5.111 order unik**.

Project ini berfokus pada proses:

- Data Preparation
- Data Cleaning
- Data Quality Check
- Business KPI Analysis
- Category Analysis
- Discount Analysis
- Regional Analysis
- Customer Analysis
- Product Analysis
- Sales Trend Analysis
- Advanced SQL Analysis

**English Summary:**  
This project analyzes Superstore sales data using MySQL to evaluate sales performance, profitability, customer behavior, product performance, regional performance, discount impact, and sales trends.

---

# Tujuan Project

Project ini dibuat untuk menjawab beberapa pertanyaan bisnis:

- Bagaimana performa sales dan profit perusahaan secara keseluruhan?
- Category mana yang menghasilkan sales dan profit terbesar?
- Mengapa Furniture memiliki profit margin yang rendah?
- Bagaimana hubungan discount dengan profitability?
- Region mana yang memiliki performa terbaik?
- Bagaimana performa customer?
- Siapa customer dengan sales tertinggi?
- Siapa customer dengan profit tertinggi?
- Produk apa yang menghasilkan sales terbesar?
- Produk apa yang menghasilkan profit terbesar?
- Produk apa yang menghasilkan kerugian terbesar?
- Bagaimana perkembangan sales dari tahun ke tahun?
- Bagaimana perubahan sales dari bulan ke bulan?
- Produk apa yang memiliki ranking tertinggi di masing-masing category?
- Seberapa besar kontribusi setiap produk terhadap total company sales?

---

# Dataset

Dataset berasal dari workbook **Sample Superstore**.

Workbook asli memiliki tiga sheet:

```text
Orders
People
Returns
```

Namun, **project ini hanya menggunakan sheet `Orders`**.

Sheet `Orders` dipilih karena berisi data transaksi yang dibutuhkan untuk melakukan analisis:

- Sales
- Profit
- Customer
- Product
- Category
- Discount
- Region
- Order Date
- Quantity

Dataset yang digunakan memiliki:

- **10.194 baris data**
- **5.111 order unik**
- **804 customer unik**
- Periode data **2023–2026**

## Scope Dataset

Project ini merupakan **single-table sales analysis**.

Sheet berikut **tidak digunakan**:

- `People`
- `Returns`

Kedua sheet tersebut berada di luar scope project ini.

Dengan demikian, project ini **tidak melakukan analisis return maupun analisis data People/Regional Manager**.

Fokus utama project adalah menganalisis performa bisnis berdasarkan data transaksi pada sheet `Orders`.

---

# Kolom yang Digunakan

Beberapa kolom utama pada dataset Orders:

- Row ID
- Order ID
- Order Date
- Ship Date
- Ship Mode
- Customer ID
- Customer Name
- Segment
- Country/Region
- City
- State/Province
- Postal Code
- Region
- Product ID
- Category
- Sub-Category
- Product Name
- Sales
- Quantity
- Discount
- Profit

---

# Tools yang Digunakan

- MySQL 8.0
- MySQL Workbench
- Microsoft Excel
- Visual Studio Code
- SQL

---

# Data Preparation

Dataset awal berasal dari sheet:

`Orders`

pada workbook Sample Superstore.

Sheet Orders kemudian disimpan menjadi file:

`orders.csv`

File CSV tersebut kemudian di-import ke MySQL sebagai tabel:

`orders_raw`

> Petunjuk lengkap untuk meng-import dataset ke MySQL dapat dilihat di:
> [`00_import_instructions.md`](00_import_instructions.md)

Tabel raw dipertahankan agar data asli tetap tersedia dan tidak langsung dimodifikasi.

Setelah proses data cleaning, dibuat tabel:

`orders_clean`

Seluruh analisis bisnis kemudian dilakukan menggunakan tabel:

`orders_clean`

## Alur Data

```text
Sample Superstore Workbook
          ↓
      Orders Sheet
          ↓
      orders.csv
          ↓
      orders_raw
          ↓
     Data Cleaning
          ↓
      orders_clean
          ↓
   Business Analysis
```

---

# Data Cleaning

Proses data cleaning dilakukan menggunakan SQL.

## 1. Standardisasi Nama Kolom

Nama kolom diubah menjadi format yang lebih mudah digunakan dalam SQL.

Contoh:

```text
Order ID        → order_id
Order Date      → order_date
Ship Date       → ship_date
Customer ID     → customer_id
Customer Name   → customer_name
Postal Code     → postal_code
Product ID      → product_id
Sub-Category    → sub_category
Product Name    → product_name
```

---

## 2. Konversi Tanggal

Kolom:

`Order Date`

dan:

`Ship Date`

awalnya tersimpan sebagai text.

Keduanya dikonversi menjadi tipe data:

`DATE`

menggunakan fungsi:

```sql
STR_TO_DATE()
```

---

## 3. Konversi Data Numerik

Kolom berikut sebelumnya tersimpan sebagai text:

- Sales
- Discount
- Profit

Data dikonversi menggunakan:

```sql
REPLACE()
CAST()
```

Tipe data akhirnya:

```text
sales     → DECIMAL(12,4)
discount  → DECIMAL(5,4)
profit    → DECIMAL(12,4)
quantity  → INT
```

---

## 4. Postal Code

Postal Code tidak selalu terdiri dari angka.

Beberapa kode dapat memiliki format seperti:

```text
M7A
```

Karena itu Postal Code disimpan sebagai:

```text
VARCHAR(20)
```

dan bukan sebagai integer.

---

# Data Quality Check

Sebelum analisis bisnis dilakukan, dataset diperiksa untuk memastikan kualitas data.

Pengecekan meliputi:

- Missing Values
- Duplicate Row ID
- Invalid Shipping Date
- Sales Range
- Quantity Range
- Discount Range
- Profit Range

## Hasil Data Quality Check

### Total Data

```text
10.194 rows
```

### Missing Values

Tidak ditemukan missing value pada kolom penting:

```text
order_id
order_date
customer_id
product_id
sales
quantity
profit
```

### Duplicate Row ID

Tidak ditemukan duplicate berdasarkan:

`row_id`

### Validasi Tanggal

Tidak ditemukan kondisi:

```text
ship_date < order_date
```

Artinya tidak terdapat transaksi yang tercatat dikirim sebelum tanggal order.

### Numeric Range

```text
Minimum Sales      : 0.4440
Maximum Sales      : 22,638.4800

Minimum Quantity   : 1
Maximum Quantity   : 14

Minimum Discount   : 0%
Maximum Discount   : 80%

Minimum Profit     : -6,599.9780
Maximum Profit     : 8,399.9760
```

Profit negatif tidak dianggap sebagai data error karena transaksi dapat menghasilkan kerugian.

---

# Business Analysis

## 1. Overall Business KPIs

| KPI | Hasil |
|---|---:|
| Total Sales | 2,326,534.35 |
| Total Profit | 292,296.81 |
| Profit Margin | 12.56% |
| Total Quantity | 38,654 |
| Total Orders | 5,111 |
| Total Customers | 804 |
| Average Order Value | 455.20 |

### Insight

Bisnis menghasilkan lebih dari **2,3 juta total sales** dengan total profit sekitar **292 ribu**.

Overall Profit Margin:

**12,56%**

Average Order Value:

**455,20**

Secara keseluruhan bisnis menghasilkan profit positif.

---

## 2. Category Performance

| Category | Total Sales | Total Profit | Profit Margin |
|---|---:|---:|---:|
| Technology | 839,893.28 | 146,543.38 | 17.45% |
| Furniture | 754,747.76 | 19,730.00 | 2.61% |
| Office Supplies | 731,893.31 | 126,023.44 | 17.22% |

### Insight

**Technology** merupakan category dengan sales dan profit tertinggi.

Technology menghasilkan profit margin:

**17,45%**

Office Supplies juga memiliki profitability yang kuat dengan margin:

**17,22%**

Furniture memiliki sales yang cukup tinggi, tetapi profit margin hanya:

**2,61%**

Hal ini menunjukkan adanya masalah profitability pada Furniture.

---

## 3. Furniture Profitability Analysis

Untuk mengetahui penyebab rendahnya profitability Furniture, dilakukan analisis pada level Sub-Category.

| Sub-Category | Total Sales | Total Profit | Profit Margin |
|---|---:|---:|---:|
| Tables | 208,020.18 | -17,753.21 | -8.53% |
| Bookcases | 115,361.20 | -3,632.07 | -3.15% |
| Furnishings | 95,598.13 | 13,891.74 | 14.53% |
| Chairs | 335,768.25 | 27,223.53 | 8.11% |

### Insight

Dua Sub-Category menghasilkan profit negatif.

**Tables**

```text
Sales  : 208,020.18
Profit : -17,753.21
Margin : -8.53%
```

**Bookcases**

```text
Sales  : 115,361.20
Profit : -3,632.07
Margin : -3.15%
```

Tables merupakan penyumbang kerugian terbesar pada category Furniture.

---

## 4. Discount Analysis

Analisis dilanjutkan untuk melihat apakah discount memiliki hubungan dengan rendahnya profitability Furniture.

### Average Discount berdasarkan Sub-Category

| Sub-Category | Average Discount |
|---|---:|
| Tables | 25.81% |
| Bookcases | 21.53% |
| Chairs | 16.92% |
| Furnishings | 13.81% |

Tables dan Bookcases memiliki average discount tertinggi sekaligus menghasilkan total profit negatif.

### Profitability berdasarkan Discount Group

| Discount Group | Transactions | Total Sales | Total Profit | Profit Margin |
|---|---:|---:|---:|---:|
| No Discount | 880 | 260,155.06 | 59,476.99 | 22.86% |
| 1-10% | 78 | 47,217.39 | 7,181.80 | 15.21% |
| 11-20% | 688 | 250,951.87 | 8,027.49 | 3.20% |
| 21-30% | 224 | 100,191.18 | -10,786.83 | -10.77% |
| Above 30% | 331 | 96,232.26 | -44,169.46 | -45.90% |

### Insight

Profitability Furniture menurun ketika tingkat discount meningkat.

Transaksi tanpa discount menghasilkan Profit Margin:

**22,86%**

Discount **21–30%** menghasilkan:

**-10,77%**

Discount **Above 30%** menghasilkan:

**-45,90%**

Transaksi Furniture dengan discount di atas **20%** secara agregat menghasilkan profit negatif.

Hasil ini menunjukkan adanya **hubungan kuat antara tingkat discount yang tinggi dan rendahnya profitability Furniture**.

Analisis ini menunjukkan hubungan atau association dan tidak secara langsung membuktikan hubungan sebab-akibat.

---

## 5. Regional Performance

| Region | Total Sales | Total Profit | Profit Margin | Total Orders |
|---|---:|---:|---:|---:|
| West | 739,813.61 | 110,798.82 | 14.98% | 1,635 |
| East | 691,828.17 | 94,883.26 | 13.71% | 1,475 |
| Central | 503,170.67 | 39,865.31 | 7.92% | 1,179 |
| South | 391,721.91 | 46,749.43 | 11.93% | 822 |

### Insight

**West** merupakan region dengan performa terbaik berdasarkan:

- Sales
- Profit
- Profit Margin
- Total Orders

Central memiliki sales lebih tinggi daripada South tetapi menghasilkan profit yang lebih rendah.

Central memiliki Profit Margin terendah:

**7,92%**

Hal ini menunjukkan bahwa Central dapat menjadi region yang perlu dianalisis lebih lanjut.

---

## 6. Customer Analysis

Customer dianalisis berdasarkan:

- Total Sales
- Total Profit
- Total Orders

### Customer dengan Sales Tertinggi

**Sean Miller**

```text
Total Sales  : 25,043.05
Total Profit : -1,980.74
Total Orders : 5
```

Walaupun menghasilkan total sales tertinggi, customer tersebut menghasilkan total profit negatif.

### Customer dengan Profit Tertinggi

**Tamara Chand**

```text
Total Sales  : 19,052.22
Total Profit : 8,981.32
Total Orders : 5
```

### Insight

Sales yang tinggi tidak selalu menghasilkan profitability yang tinggi.

Customer performance sebaiknya dievaluasi berdasarkan:

**Sales dan Profitability**

bukan hanya total nilai pembelian.

---

## 7. Product Analysis

Produk dianalisis berdasarkan:

- Total Sales
- Total Profit
- Highest Loss

### Product dengan Sales Tertinggi

**Canon imageCLASS 2200 Advanced Copier**

```text
Total Sales  : 61,599.82
Total Profit : 25,199.93
```

Produk tersebut juga merupakan produk dengan profit tertinggi.

### Product dengan Kerugian Terbesar

**Cubify CubeX 3D Printer Double Head Print**

```text
Total Sales  : 11,099.96
Total Profit : -8,879.97
```

### Insight

Beberapa produk dengan sales tinggi tetap dapat menghasilkan profit negatif.

Hal ini menunjukkan bahwa:

**Sales volume saja tidak cukup untuk mengevaluasi product performance.**

Profitability juga harus menjadi bagian dari evaluasi.

---

## 8. Sales Trend Analysis

Analisis dilakukan untuk melihat perkembangan bisnis dari tahun ke tahun dan bulan ke bulan.

### Yearly Sales Performance

| Year | Total Sales | Total Profit | Total Orders |
|---|---:|---:|---:|
| 2023 | 494,040.21 | 51,684.30 | 995 |
| 2024 | 472,993.03 | 62,020.97 | 1,053 |
| 2025 | 613,933.58 | 82,665.20 | 1,340 |
| 2026 | 745,567.53 | 95,926.35 | 1,723 |

### Insight

Sales sedikit menurun pada 2024 dibandingkan 2023.

Walaupun sales menurun, profit tetap meningkat.

Pada 2025 dan 2026 terjadi pertumbuhan yang kuat.

**2026 merupakan tahun dengan sales, profit, dan jumlah order tertinggi.**

---

## 9. Month-over-Month Growth

Month-over-Month Growth digunakan untuk melihat perubahan sales dibandingkan bulan sebelumnya.

Perhitungan menggunakan SQL Window Function:

```sql
LAG()
```

Rumus:

```text
(Current Month Sales - Previous Month Sales)
------------------------------------------------ × 100
              Previous Month Sales
```

Nilai positif berarti sales meningkat dibanding bulan sebelumnya.

Nilai negatif berarti sales mengalami penurunan.

Salah satu pertumbuhan tertinggi terjadi pada:

**March 2023**

dengan:

**MoM Growth = 1,159.63%**

Nilai yang sangat tinggi tersebut dipengaruhi oleh sales February 2023 yang relatif rendah, sehingga menghasilkan efek **low base**.

---

## 10. Advanced SQL Analysis

Bagian terakhir project menggunakan beberapa teknik SQL intermediate seperti:

- Common Table Expression
- Window Functions
- RANK()
- PARTITION BY
- LAG()
- Running Total
- Cumulative Sales

### Product Ranking Within Each Category

Produk diberi ranking berdasarkan total sales di masing-masing category menggunakan:

```sql
RANK() OVER (
    PARTITION BY category
    ORDER BY total_sales DESC
)
```

Dengan cara ini, ranking dimulai kembali untuk masing-masing category.

Analisis menghasilkan:

**Top 5 Products by Sales within each Category**

dan:

**Top 5 Products by Profit within each Category**

### Product Sales Contribution

Analisis dilakukan untuk mengetahui kontribusi setiap produk terhadap total company sales.

Produk dengan sales terbesar:

**Canon imageCLASS 2200 Advanced Copier**

memberikan kontribusi sekitar:

**2,65% dari total company sales**

Sedangkan Top 10 Products berdasarkan sales secara kumulatif memberikan kontribusi sekitar:

**10,51% dari total sales**

### Insight

Sales perusahaan relatif tersebar di banyak produk.

Perusahaan tidak terlalu bergantung pada satu atau dua produk saja sebagai sumber utama sales.

---

# Business Recommendations

Berdasarkan hasil analisis, beberapa rekomendasi bisnis dapat diberikan.

## 1. Review Furniture Discount Strategy

Strategi discount Furniture perlu dievaluasi, khususnya pada:

- Tables
- Bookcases

Kedua Sub-Category tersebut menghasilkan total profit negatif.

## 2. Evaluate Discounts Above 20%

Kelompok transaksi Furniture dengan discount di atas 20% menghasilkan Profit Margin negatif.

Discount besar sebaiknya diberikan secara lebih selektif dengan mempertimbangkan profitability.

## 3. Investigate Tables and Bookcases

Perlu dilakukan analisis lebih lanjut terhadap:

- Pricing
- Cost Structure
- Discount Strategy
- Product Mix

untuk mengetahui penyebab kerugian pada Tables dan Bookcases.

## 4. Improve Central Region Profitability

Central menghasilkan sales yang cukup besar tetapi hanya memiliki Profit Margin:

**7,92%**

Region tersebut perlu dianalisis lebih lanjut untuk mengetahui penyebab rendahnya profitability.

## 5. Evaluate Customers Using Profitability

Customer dengan sales tinggi belum tentu menghasilkan profit tinggi.

Customer performance sebaiknya dianalisis menggunakan beberapa metric seperti:

- Sales
- Profit
- Profit Margin
- Order Frequency

## 6. Review Loss-Making Products

Produk dengan sales tinggi tetapi profit negatif perlu dievaluasi lebih lanjut.

Beberapa faktor yang dapat diperiksa:

- Discount
- Pricing
- Cost
- Product Strategy

## 7. Maintain Strong Categories

Technology dan Office Supplies memiliki profitability yang relatif kuat.

Strategi bisnis dapat mempertahankan dan mengembangkan performa kedua category tersebut.

---

# SQL Skills yang Digunakan

Project ini menggunakan konsep SQL mulai dari basic hingga intermediate.

## SQL Fundamentals

```text
SELECT
FROM
WHERE
GROUP BY
ORDER BY
HAVING
LIMIT
```

## Aggregate Functions

```text
SUM()
AVG()
MIN()
MAX()
COUNT()
COUNT(DISTINCT)
```

## Conditional Logic

```text
CASE WHEN
```

## Data Cleaning

```text
CAST()
REPLACE()
STR_TO_DATE()
```

## Date Functions

```text
YEAR()
MONTH()
MONTHNAME()
```

## Advanced SQL

```text
Common Table Expression (CTE)
LAG()
RANK()
PARTITION BY
Window Functions
Running Total
Cumulative Sales
Month-over-Month Growth
```

---

# Struktur Project

```text
Superstore_SQL_Portfolio/
│
├── README.md
│
├── dataset/
│   └── orders.csv
│
└── sql/
    ├── 01_database_setup.sql
    ├── 02_data_cleaning.sql
    ├── 03_data_quality_check.sql
    ├── 04_kpi_category_analysis.sql
    ├── 05_discount_analysis.sql
    ├── 06_region_analysis.sql
    ├── 07_customer_analysis.sql
    ├── 08_product_analysis.sql
    ├── 09_sales_trend_analysis.sql
    └── 10_advanced_analysis.sql
```

Project memiliki **10 file SQL**.

---

# SQL Files

### 01_database_setup.sql

Digunakan untuk:

- Membuat database
- Memilih database
- Memvalidasi jumlah data

### 02_data_cleaning.sql

Digunakan untuk:

- Membuat `orders_clean`
- Mengubah tipe data
- Membersihkan nama kolom
- Menyiapkan dataset untuk analisis

### 03_data_quality_check.sql

Digunakan untuk:

- Missing Value Check
- Duplicate Check
- Date Validation
- Numeric Range Validation

### 04_kpi_category_analysis.sql

Digunakan untuk:

- Overall KPI
- Category Performance
- Furniture Sub-Category Analysis

### 05_discount_analysis.sql

Digunakan untuk:

- Average Discount Analysis
- Discount Group Analysis
- Discount vs Profitability Analysis

### 06_region_analysis.sql

Digunakan untuk:

- Regional Sales
- Regional Profit
- Regional Profit Margin
- Regional Orders

### 07_customer_analysis.sql

Digunakan untuk:

- Customer Segment Analysis
- Top Customers by Sales
- Top Customers by Profit

### 08_product_analysis.sql

Digunakan untuk:

- Top Products by Sales
- Top Products by Profit
- Products with Highest Loss

### 09_sales_trend_analysis.sql

Digunakan untuk:

- Yearly Sales Trend
- Monthly Sales Trend
- Month-over-Month Growth
- Highest and Lowest Monthly Growth

### 10_advanced_analysis.sql

Digunakan untuk:

- Product Ranking by Category
- Product Profit Ranking
- Product Sales Contribution
- Cumulative Sales
- Window Function Analysis

---

# Cara Menjalankan Project

## 1. Siapkan MySQL

Gunakan:

- MySQL Server 8.0
- MySQL Workbench

## 2. Buat Database

```sql
CREATE DATABASE IF NOT EXISTS superstore_portfolio;
```

Kemudian:

```sql
USE superstore_portfolio;
```

## 3. Import Dataset

Import:

```text
dataset/orders.csv
```

ke dalam MySQL sebagai:

```text
orders_raw
```

## 4. Jalankan Data Cleaning

Jalankan:

```text
02_data_cleaning.sql
```

Script tersebut akan membuat:

```text
orders_clean
```

## 5. Jalankan Data Quality Check

```text
03_data_quality_check.sql
```

## 6. Jalankan Analisis

Analisis dapat dijalankan sesuai kebutuhan melalui:

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

# Scope dan Limitasi Project

Project ini **hanya menggunakan sheet `Orders`** dari workbook Sample Superstore.

Sheet berikut tidak digunakan:

```text
People
Returns
```

Karena itu, project ini belum mencakup:

- Returned Order Analysis
- Return Rate Analysis
- Relationship between Returns and Profit
- People / Regional Manager Analysis
- Multi-table JOIN Analysis antara Orders, Returns, dan People

Hal tersebut sengaja berada di luar scope karena project pertama ini difokuskan pada:

**Single-table Sales Analysis menggunakan SQL.**

Analisis multi-table dan SQL JOIN dapat dikembangkan pada project SQL berikutnya.

---

# Kesimpulan

Secara keseluruhan, bisnis Superstore menghasilkan profit positif dengan:

**Total Sales = 2,326,534.35**

**Total Profit = 292,296.81**

**Profit Margin = 12.56%**

Technology dan Office Supplies menunjukkan profitability yang relatif kuat.

Sebaliknya, Furniture memiliki Profit Margin yang jauh lebih rendah.

Analisis lebih lanjut menemukan bahwa Tables dan Bookcases menghasilkan total profit negatif.

Analisis discount juga menunjukkan bahwa transaksi Furniture dengan discount di atas 20% memiliki Profit Margin negatif.

Analisis customer dan product menunjukkan bahwa sales yang tinggi tidak selalu menghasilkan profit yang tinggi.

Dari sisi tren, performa bisnis meningkat kuat pada 2025 dan 2026, dengan 2026 menjadi tahun dengan sales, profit, dan jumlah order tertinggi.

Project ini menunjukkan bagaimana SQL dapat digunakan untuk:

- Menyiapkan data
- Membersihkan data
- Memvalidasi kualitas data
- Menghitung Business KPI
- Menganalisis profitability
- Menginvestigasi business problems
- Menganalisis customer dan product
- Menganalisis sales trend
- Menggunakan Window Functions
- Menghasilkan business insights
- Memberikan business recommendations

---

## Catatan

Project ini dibuat sebagai **project SQL portfolio pertama** dengan fokus pada analisis satu dataset transaksi (`Orders`).

Pengembangan berikutnya dapat mencakup penggunaan sheet `Returns` dan `People` untuk mempraktikkan:

```text
JOIN
Multi-table Analysis
Return Analysis
Regional Manager Analysis
```