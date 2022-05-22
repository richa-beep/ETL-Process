# ETL-Process
## Table Design <p></p>
### VIDEOSTART_RAW 

| COLUMN_NAME | DATA_TYPE          | PK  | NULLABLE |DATA_DEFAULT | COLUMN_ID | COMMENTS         |
| ----------- | -----------        |  -- | ---------|  -----------| ----------|-----------       |
| DATETIME    | VARCHAR(30)  | N   |Yes       |null         | 1         |Data from raw file|
| VIDEOTITLE  | VARCHAR(200) | N   |Yes       |null         | 2         |Data from raw file|
| EVENTS      | VARCHAR(150) | N   |Yes       |null         | 3         |Data from raw file|
<p></p>

###  VIDEOSTART_DLT

| COLUMN_NAME | DATA_TYPE          | PK  | NULLABLE |DATA_DEFAULT | COLUMN_ID | COMMENTS         |
| ----------- | -----------        |  -- | ---------|  -----------| ----------|-----------       |
| DATETIME    | TIMESTAMP(6)       | N   |Yes       |null         | 1         |Data reformatted from <br /> VIDEOSTART_RAW. DATETIME|
| PLATFORM    |  VARCHAR(200) | N   |Yes       |null         | 2         |Data derived from <br />VIDEOSTART_RAW. VIDEOTITLE|
| SITE        |  VARCHAR(200) | N   |Yes       |null         | 3         |Data derived from <br />VIDEOSTART_RAW. VIDEOTITLE|
| VIDEO       |  VARCHAR(200) | N   |Yes       |null         | 4        |Data derived from <br />VIDEOSTART_RAW. VIDEOTITLE|
<p></p>

### FACTVIDEOSTART

| COLUMN_NAME | DATA_TYPE          | PK  | NULLABLE |DATA_DEFAULT | COLUMN_ID | COMMENTS         |
| ----------- | -----------        |  -- | ---------|  -----------| ----------|-----------       |
| DATETIME_SKEY    | VARCHAR(12)     | N   |Yes       |null         | 1         |Data reformatted from <br /> DIMDATE. DATETIME_SKEY|
| PLATFORM_SKEY    | INT | N   |Yes       |null         | 2         |Data derived from <br /> DIMPLATFORM. PLATFORM_SKEY|
| SITE_SKEY        | INT | N   |Yes       |null         | 3         |Data derived from <br />DIMSITE. SITE_SKEY|
| VIDEO_SKEY       | INT | N   |Yes       |null         | 4        |Data derived from <br />DIMVIDEO. VIDEO_SKEY|
| DB_INSERT_TIMESTAMP       | TIMESTAMP (6) | N   |Yes       |null         | 5        |TIMESTAMP when inserting the data|
<p></p>

### DIMDATE_DLT

| COLUMN_NAME | DATA_TYPE          | PK  | NULLABLE |DATA_DEFAULT | COLUMN_ID | COMMENTS         |
| ----------- | -----------        |  -- | ---------|  -----------| ----------|-----------       |
| DATETIME    | VARCHAR(12)     | N   |No       |null         | 1         |Data reformatted from <br /> VIDEOSTART_DLT. DATETIME|
<p></p>

### DIMPLATFORM_DLT

| COLUMN_NAME | DATA_TYPE          | PK  | NULLABLE |DATA_DEFAULT | COLUMN_ID | COMMENTS         |
| ----------- | -----------        |  -- | ---------|  -----------| ----------|-----------       |
| PLATFORM   | VARCHAR(200)     | N   |No       |null         | 1         |Data reformatted from <br /> VIDEOSTART_DLT. PLATFORM|
<p></p>

### DIMSITE_DLT

| COLUMN_NAME | DATA_TYPE          | PK  | NULLABLE |DATA_DEFAULT | COLUMN_ID | COMMENTS         |
| ----------- | -----------        |  -- | ---------|  -----------| ----------|-----------       |
| SITE   | VARCHAR(200)     | N   |No       |null         | 1         |Data reformatted from <br /> VIDEOSTART_DLT. SITE|
<p></p>

### DIMVIDEO_DLT

| COLUMN_NAME | DATA_TYPE          | PK  | NULLABLE |DATA_DEFAULT | COLUMN_ID | COMMENTS         |
| ----------- | -----------        |  -- | ---------|  -----------| ----------|-----------       |
| VIDEO   | VARCHAR(200)     | N   |No       |null         | 1         |Data reformatted from <br /> VIDEOSTART_DLT. VIDEO|
<p></p>

### DIMDATE

| COLUMN_NAME | DATA_TYPE          | PK  | NULLABLE |DATA_DEFAULT | COLUMN_ID | COMMENTS         |
| ----------- | -----------        |  -- | ---------|  -----------| ----------|-----------       |
| DATETIME_SKEY   | INT     | Y   |No       |        | 1         |Data reformatted from <br /> DIMDATE_DTL. DATETIME|
<p></p>

### DIMPLATFORM

| COLUMN_NAME | DATA_TYPE          | PK  | NULLABLE |DATA_DEFAULT | COLUMN_ID | COMMENTS         |
| ----------- | -----------        |  -- | ---------|  -----------| ----------|-----------       |
| PLATFORM_SKEY   | INT     | Y   |No       |        | 1         | |
| PLATFORM   | VARCHAR(200)    | N   |No       |    null    | 2         |Data reformatted from <br /> DIMPLATFORM_DLT. PLATFORM|
<p></p>

### DIMSITE

| COLUMN_NAME | DATA_TYPE          | PK  | NULLABLE |DATA_DEFAULT | COLUMN_ID | COMMENTS         |
| ----------- | -----------        |  -- | ---------|  -----------| ----------|-----------       |
| SITE_SKEY   | INT     | Y   |No       |        | 1         | |
| SITE   | VARCHAR(200)    | N   |No       |    null    | 2         |Data reformatted from <br /> DIMSITE_DLT. SITE|
<p></p>

### DIMVIDEO

| COLUMN_NAME | DATA_TYPE          | PK  | NULLABLE |DATA_DEFAULT | COLUMN_ID | COMMENTS         |
| ----------- | -----------        |  -- | ---------|  -----------| ----------|-----------       |
| VIDEO_SKEY   | INT     | Y   |No       |        | 1         | |
| VIDEO   | VARCHAR(200)    | N   |No       |    null    | 2         |Data reformatted from <br /> DIMVIDEO_DLT. VIDEO|
<p></p>


# Process Design

### 1. Load raw videostarts file into VIDEOSTART_RAW
 &nbsp;&nbsp;&nbsp;&nbsp;a. Use AWS Crawler to load raw data into datalog then use Athena queries table <p></p>
 &nbsp;&nbsp;&nbsp;&nbsp;b. Data auditing: 
 &nbsp;&nbsp;&nbsp;&nbsp;
 ```SQL
SELECT Max(Length(datetime)),
       Max(Length(videotitle)),
       Max(Length(events))
FROM   videostart_raw; 
 ```
 <br />
 &nbsp;&nbsp;&nbsp;&nbsp;c. Identify the type of PLATFORM and SITE
 &nbsp;&nbsp;&nbsp;&nbsp; 

```SQL
SELECT DISTINCT Substring_index(videotitle, '|', 1) AS platform
FROM   videostart_raw; 
```
&nbsp;&nbsp;&nbsp;&nbsp; d. The sql script to create the table<p></p>
&nbsp;&nbsp;&nbsp;&nbsp; [1_create_tables.sql](https://github.com/richa-beep/ETL-Process/blob/main/1_create_tables.sql)

### 2.Clean data in Intermediate tables
&nbsp;&nbsp;&nbsp;&nbsp;[2_clean_delta_table.sql](https://github.com/richa-beep/ETL-Process/blob/main/2_clean_delta_table.sql)

### 3.Wash data in VIDEOSTART_RAW and load into VIDEOSTART_DLT
&nbsp;&nbsp;&nbsp;&nbsp;[3_wash_data.sql](https://github.com/richa-beep/ETL-Process/blob/main/3_wash_data.sql)

### 4.Populate DIMDATE_DLT, DIMPLATFORM_DLT, DIMSITE_DLT and DIMVIDEO_DLT
&nbsp;&nbsp;&nbsp;&nbsp;[4_populate_dim_dlt.sql](https://github.com/richa-beep/ETL-Process/blob/main/4_populate_dim_dlt.sql)

### 5.Insert delta data into staging tables - DIMDATE, DIMPLATFORM, DIMSITE and DIMVIDEO
&nbsp;&nbsp;&nbsp;&nbsp; [5_insert_dim.sql](https://github.com/richa-beep/ETL-Process/blob/main/5_insert_dim.sql)

### 6.Use VIDEOSTART_DLT, DIMDATE, DIMPLATFORM, DIMSITE and DIMVIDEO to generate output data and append the data into fact table – VIDEOSTART
&nbsp;&nbsp;&nbsp;&nbsp;[6_append_fact.sql](https://github.com/richa-beep/ETL-Process/blob/main/6_append_fact.sql)

<p></p>

# On-going process workflow
![On-going process workflow](https://github.com/richa-beep/ETL-Process/blob/main/Workflow.png)

# NOTE:

1.SKEY stands for surrogate key.

2.The current design is Dimension Type One.

3.If the source dimension data contains not only the PK but also some attributes, and we want to track the changes of attributes, we should use Dimension Type Two.

One sample of Dimension Type Two

Data from 06/04/2017:
| Product_ID | Product_Name          | Price  | Location |
| ----------- | -----------        |  -- | ---------|
| P001   | Iphone6    | 750 |No       |   Townhall Shop     | 
| P003   | Iphone7   | 1000   |No       |    Townhall Shop   | 

Data in dimension table:
| Product_SKEY | Product_ID         | Product_Name  | Price |Location | Current_Flag | Start_Date         |End_Date        |
| ----------- | -----------        |  -- | ---------|  -----------| ----------|-----------       |-----------       |
| 111  | P001    | Iphone6  |800       |    Townhall Shop    | *Y*        |*31/12/2016* |*31/12/2016* |
| 112  | P002    | Iphone6Plus   |900       |    Townhall Shop    | Y        |31/12/2016       |31/12/2016 |

Add new product (P003) and update product (P001) in dimension table:
| Product_SKEY | Product_ID         | Product_Name  | Price |Location | Current_Flag | Start_Date         |End_Date        |
| ----------- | -----------        |  -- | ---------|  -----------| ----------|-----------       |-----------       |
| 111  | *P001*    | Iphone6  |800       |    Townhall Shop    | *N*       |31/12/2016 |*05/04/2017* |
| 112  | P002    | Iphone6Plus   |900       |    Townhall Shop    | Y        |31/12/2016       |31/12/2016 |
| 113  | **P003**    | Iphone7  |1000       |    Townhall Shop    | **Y**        |**06/04/2017** |**31/12/9999** |
| 114  | *P001*    | Iphone6   |750       |    Townhall Shop    | *Y*         |*06/04/2017*       |*31/12/9999* |

*Italic part* is update, and **bold part** is insertion.
When there is a new record coming in, we generate a new record with new SKEY, Current_Flag = ‘Y’, Start_Date = Current_Date, End_Date = 31/12/9999
When there is a updated record coming in, we also generate a new record with new SKEY Current_Flag = ‘Y’, Start_Date = Current_Date, End_Date = 31/12/9999; and at same time we need to update the old record in dimension table with Current_Flag = ‘N’, End_Date = Current_Date – 1

Therefore, when we populate new records into fact table, we need to put a filter such as Current_Flag = ‘Y’ in order to get the correct SKEY; if we want to track the history data in dimension table for certain days or certain period, we need to put a time range filter such as EVENT_DATE(or CONTACT_DATE) between Start_Date and End_Date

For example, if in fact table we see a transaction like customer purchased product(P001) on 01/04/2017, by looking at product dimension table, we could find the price that customer paid at that moment was 800 not 750, although 750 is the current price of P001