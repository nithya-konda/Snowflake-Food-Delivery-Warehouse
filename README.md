# 🍽️ Snowflake Food Delivery Analytics Warehouse

> End-to-End Snowflake Data Warehouse for Food Delivery Analytics built using a Medallion Architecture (Raw → Curated → Enriched), Dimensional Modeling, SQL Transformations, and an Interactive Streamlit Dashboard.

---

## 📖 Project Overview

This project demonstrates the design and implementation of a modern cloud-native Data Warehouse for a Food Delivery platform using **Snowflake**.

The solution follows an end-to-end analytics pipeline starting from raw CSV ingestion, progressing through data cleansing and dimensional modeling, and culminating in interactive business dashboards built with Streamlit.

The project showcases industry-standard Data Engineering concepts including:

- Medallion Architecture
- Dimensional Modeling
- Star Schema Design
- Incremental Data Processing
- Streams & Tasks
- Analytical SQL Views
- Interactive Dashboarding

---

# 🏗 High Level Architecture

<p align="center">
<img src="Architecture/1. Architecture.png" width="900">
</p>

---

# 🔄 End-to-End Data Flow

<p align="center">
<img src="Architecture/2. Dataflow.png" width="900">
</p>

---

# ⭐ Star Schema

<p align="center">
<img src="Architecture/3. Star Schema.png" width="900">
</p>

---

# 📊 Dashboard

<p align="center">
<img src="Dashboard/Dashboard Snapshot.png" width="900">
</p>

The Streamlit dashboard provides interactive business insights including:

- Revenue KPIs
- Order KPIs
- Monthly Revenue Trend
- Revenue Growth Analysis
- Top Performing Restaurants
- Year-wise Analysis
- Month-wise Analysis

---

# 🛠 Technology Stack

| Category | Technology |
|-----------|------------|
| Cloud Data Warehouse | Snowflake |
| Programming | SQL, Python |
| Dashboard | Streamlit |
| Visualization | Altair |
| Data Processing | Snowpark |
| Data Modeling | Star Schema |
| Architecture | Medallion Architecture |
| Source | CSV Files |

---

# 🏛 Database Architecture

```
FOOD_DELIVERY_DB

│
├── RAW_SCH
│      ├── Landing Tables
│      ├── CSV Stage
│      └── Raw Data
│
├── CURATED_SCH
│      ├── Cleaned Tables
│      ├── Streams
│      └── SQL Transformations
│
└── ENRICHED_SCH
       ├── Dimension Tables
       ├── Fact Table
       ├── Analytical Views
       └── Dashboard Queries
```

---

# 📂 Repository Structure

```
Snowflake-Food-Delivery-Warehouse
│
├── Architecture
│   ├── 1. Architecture.png
│   ├── 2. Dataflow.png
│   └── 3. Star Schema.png
│
├── Dashboard
│   ├── Dashboard Snapshot.png
│   ├── streamlit_app.py
│   ├── snowflake.yml
│   └── pyproject.toml
│
├── SQL Scripts
│   ├── 1. CreateDB_and_Schema.sql
│   ├── 2. Location.sql
│   ├── 3. Restaurant.sql
│   ├── 4. Customer.sql
│   ├── 5. Customer_Address.sql
│   ├── 6. Menu.sql
│   ├── 7. Delivery_Agent_Dimension.sql
│   ├── 8. Delivery.sql
│   ├── 9. Orders.sql
│   ├── 10. Order_Item.sql
│   ├── 11. Date_Dim.sql
│   ├── 12. Order_Item_Fact.sql
│   └── 13. Final_View.sql
│
└── README.md
```

---

# 🧱 Data Warehouse Layers

## 🔹 RAW Layer

- Stores ingested CSV files
- Minimal transformations
- Landing tables
- Internal Snowflake Stage

---

## 🔹 CURATED Layer

- Data cleansing
- Standardization
- Incremental processing
- SQL Transformations
- Streams

---

## 🔹 ENRICHED Layer

Business-ready warehouse containing:

### Dimension Tables

- DATE_DIM
- CUSTOMER_DIM
- CUSTOMER_ADDRESS_DIM
- MENU_DIM
- RESTAURANT_DIM
- RESTAURANT_LOCATION_DIM
- DELIVERY_AGENT_DIM

### Fact Table

- ORDER_ITEM_FACT

### Analytical Views

- VW_YEARLY_REVENUE_KPIS
- VW_MONTHLY_REVENUE_KPIS
- VW_MONTHLY_REVENUE_BY_RESTAURANT

---

# 📈 Dashboard Features

✔ Revenue Dashboard

✔ Interactive Year Filter

✔ Interactive Month Filter

✔ Overall KPIs

✔ Yearly KPIs

✔ Revenue Comparison

✔ Monthly Revenue Bar Chart

✔ Monthly Revenue Line Chart

✔ Top 10 Restaurants

---

# 📊 Key Metrics

The dashboard analyzes

- Total Revenue
- Total Orders
- Average Revenue per Order
- Average Revenue per Item
- Maximum Order Value
- Monthly Revenue Trends
- Restaurant Performance

---

# 🚀 How to Run

### Clone Repository

```bash
git clone https://github.com/<your-username>/Snowflake-Food-Delivery-Warehouse.git
```

---

### Create Database

Run

```
1. CreateDB_and_Schema.sql
```

---

### Execute SQL Scripts

Run SQL scripts sequentially.

```
2 → 13
```

---

### Launch Dashboard

Deploy the Streamlit application within Snowflake.

```
Dashboard/
```

---

# 🎯 Learning Outcomes

This project demonstrates practical implementation of:

- Snowflake Data Warehousing
- ETL Pipeline Development
- Medallion Architecture
- Dimensional Modeling
- Star Schema Design
- Streams & Tasks
- SQL-based Data Transformation
- Business KPI Development
- Streamlit Dashboarding

---

# 👩‍💻 Author

**Nithya Konda**

Software Engineer | Data Engineering Enthusiast

LinkedIn:
https://www.linkedin.com/in/nithyakonda05

GitHub:
https://github.com/nithya-konda

---
