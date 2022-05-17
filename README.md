# ETL-Process
## Table Design
#### VIDEOSTART_RAW

| COLUMN_NAME  | DATA_TYPE          | PK           | NULLABLE    |DATA_DEFAULT   | COLUMN_ID   | COMMENTS |
| -----------  | -----------        |  ----------- | ----------- |  -----------  | ----------- |----------- |
| DATETIME     | VARCHAR2(30 BYTE)  | N            |Yes          |null           | 1           |Data from raw file|
| VIDEOTITLE   | VARCHAR2(200 BYTE) | N            |Yes          |null           | 2           |Data from raw file|
| EVENTS       | VARCHAR2(150 BYTE  | N            |Yes          |null           | 3           |Data from raw file|