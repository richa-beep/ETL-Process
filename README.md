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
&nbsp;&nbsp;&nbsp;&nbsp; d. The sql script to create the table