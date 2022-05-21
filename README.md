# ETL-Process
## Table Design <p></p>
### VIDEOSTART_RAW 

| COLUMN_NAME | DATA_TYPE          | PK  | NULLABLE |DATA_DEFAULT | COLUMN_ID | COMMENTS         |
| ----------- | -----------        |  -- | ---------|  -----------| ----------|-----------       |
| DATETIME    | VARCHAR2(30 BYTE)  | N   |Yes       |null         | 1         |Data from raw file|
| VIDEOTITLE  | VARCHAR2(200 BYTE) | N   |Yes       |null         | 2         |Data from raw file|
| EVENTS      | VARCHAR2(150 BYTE) | N   |Yes       |null         | 3         |Data from raw file|
<p></p>

###  VIDEOSTART_DLT

| COLUMN_NAME | DATA_TYPE          | PK  | NULLABLE |DATA_DEFAULT | COLUMN_ID | COMMENTS         |
| ----------- | -----------        |  -- | ---------|  -----------| ----------|-----------       |
| DATETIME    | TIMESTAMP(6)       | N   |Yes       |null         | 1         |Data reformatted from <br /> VIDEOSTART_RAW. DATETIME|
| PLATFORM    | VARCHAR2(200 BYTE) | N   |Yes       |null         | 2         |Data derived from <br />VIDEOSTART_RAW. VIDEOTITLE|
| SITE        | VARCHAR2(200 BYTE) | N   |Yes       |null         | 3         |Data derived from <br />VIDEOSTART_RAW. VIDEOTITLE|
| VIDEO       | VARCHAR2(200 BYTE) | N   |Yes       |null         | 4        |Data derived from <br />VIDEOSTART_RAW. VIDEOTITLE|
<p></p>

### FACTVIDEOSTART

| COLUMN_NAME | DATA_TYPE          | PK  | NULLABLE |DATA_DEFAULT | COLUMN_ID | COMMENTS         |
| ----------- | -----------        |  -- | ---------|  -----------| ----------|-----------       |
| DATETIME_SKEY    | VARCHAR2(12 BYTE)     | N   |Yes       |null         | 1         |Data reformatted from <br /> DIMDATE. DATETIME_SKEY|
| PLATFORM_SKEY    | NUMBER(38,0) | N   |Yes       |null         | 2         |Data derived from <br /> DIMPLATFORM. PLATFORM_SKEY|
| SITE_SKEY        | NUMBER(38,0) | N   |Yes       |null         | 3         |Data derived from <br />DIMSITE. SITE_SKEY|
| VIDEO_SKEY       | NUMBER(38,0) | N   |Yes       |null         | 4        |Data derived from <br />DIMVIDEO. VIDEO_SKEY|
| DB_INSERT_TIMESTAMP       | TIMESTAMP (6) | N   |Yes       |null         | 5        |TIMESTAMP when inserting the data|
<p></p>

### DIMDATE_DLT

| COLUMN_NAME | DATA_TYPE          | PK  | NULLABLE |DATA_DEFAULT | COLUMN_ID | COMMENTS         |
| ----------- | -----------        |  -- | ---------|  -----------| ----------|-----------       |
| DATETIME    | VARCHAR2(12 BYTE)     | N   |No       |null         | 1         |Data reformatted from <br /> VIDEOSTART_DLT. DATETIME|
<p></p>

### DIMPLATFORM_DLT

| COLUMN_NAME | DATA_TYPE          | PK  | NULLABLE |DATA_DEFAULT | COLUMN_ID | COMMENTS         |
| ----------- | -----------        |  -- | ---------|  -----------| ----------|-----------       |
| PLATFORM   | VARCHAR2(200 BYTE)     | N   |No       |null         | 1         |Data reformatted from <br /> VIDEOSTART_DLT. PLATFORM|
<p></p>

### DIMSITE_DLT

| COLUMN_NAME | DATA_TYPE          | PK  | NULLABLE |DATA_DEFAULT | COLUMN_ID | COMMENTS         |
| ----------- | -----------        |  -- | ---------|  -----------| ----------|-----------       |
| SITE   | VARCHAR2(200 BYTE)     | N   |No       |null         | 1         |Data reformatted from <br /> VIDEOSTART_DLT. SITE|
<p></p>

### DIMVIDEO_DLT

| COLUMN_NAME | DATA_TYPE          | PK  | NULLABLE |DATA_DEFAULT | COLUMN_ID | COMMENTS         |
| ----------- | -----------        |  -- | ---------|  -----------| ----------|-----------       |
| VIDEO   | VARCHAR2(200 BYTE)     | N   |No       |null         | 1         |Data reformatted from <br /> VIDEOSTART_DLT. VIDEO|
<p></p>

### DIMDATE

| COLUMN_NAME | DATA_TYPE          | PK  | NULLABLE |DATA_DEFAULT | COLUMN_ID | COMMENTS         |
| ----------- | -----------        |  -- | ---------|  -----------| ----------|-----------       |
| DATETIME_SKEY   | NUMBER(38,0     | Y   |No       |        | 1         |Data reformatted from <br /> DIMDATE_DTL. DATETIME|
<p></p>

### DIMPLATFORM

| COLUMN_NAME | DATA_TYPE          | PK  | NULLABLE |DATA_DEFAULT | COLUMN_ID | COMMENTS         |
| ----------- | -----------        |  -- | ---------|  -----------| ----------|-----------       |
| PLATFORM_SKEY   | NUMBER(38,0)     | Y   |No       |        | 1         | |
| PLATFORM   | VARCHAR2(200 BYTE)    | N   |No       |    null    | 2         |Data reformatted from <br /> DIMPLATFORM_DLT. PLATFORM|
<p></p>

### DIMSITE

| COLUMN_NAME | DATA_TYPE          | PK  | NULLABLE |DATA_DEFAULT | COLUMN_ID | COMMENTS         |
| ----------- | -----------        |  -- | ---------|  -----------| ----------|-----------       |
| SITE_SKEY   | NUMBER(38,0)     | Y   |No       |        | 1         | |
| SITE   | VARCHAR2(200 BYTE)    | N   |No       |    null    | 2         |Data reformatted from <br /> DIMSITE_DLT. SITE|
<p></p>

### DIMVIDEO

| COLUMN_NAME | DATA_TYPE          | PK  | NULLABLE |DATA_DEFAULT | COLUMN_ID | COMMENTS         |
| ----------- | -----------        |  -- | ---------|  -----------| ----------|-----------       |
| VIDEO_SKEY   | NUMBER(38,0)     | Y   |No       |        | 1         | |
| VIDEO   | VARCHAR2(200 BYTE)    | N   |No       |    null    | 2         |Data reformatted from <br /> DIMVIDEO_DLT. VIDEO|
<p></p>


## Process Design