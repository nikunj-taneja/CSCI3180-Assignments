       IDENTIFICATION DIVISION.
       PROGRAM-ID.   CENTRAL.
       AUTHOR.       NIKUNJ TANEJA.

       ENVIRONMENT DIVISION.
       INPUT-OUTPUT SECTION.
       FILE-CONTROL.
           SELECT MASTER-FILE ASSIGN TO "master.txt"
               ORGANIZATION IS LINE SEQUENTIAL.
           SELECT UPDATED-MASTER-FILE ASSIGN TO "updatedMaster.txt"
               ORGANIZATION IS LINE SEQUENTIAL.
           SELECT TRANS711-FILE ASSIGN TO "trans711.txt"
               ORGANIZATION IS LINE SEQUENTIAL.
           SELECT TRANS713-FILE ASSIGN TO "trans713.txt"
               ORGANIZATION IS LINE SEQUENTIAL.
           SELECT TRANS711-SORTED ASSIGN TO "transSorted711.txt"
               ORGANIZATION IS LINE SEQUENTIAL.
           SELECT TRANS713-SORTED ASSIGN TO "transSorted713.txt"
               ORGANIZATION IS LINE SEQUENTIAL. 
           SELECT TRANS-SORTED ASSIGN TO "transSorted.txt"
               ORGANIZATION IS LINE SEQUENTIAL.
           SELECT NEG-REPORT ASSIGN TO "negReport.txt"
               ORGANIZATION IS LINE SEQUENTIAL.
           SELECT TMP-FILE ASSIGN TO tmp. 
           
              
       DATA DIVISION.
       FILE SECTION.
       SD TMP-FILE.
       01 TMP-RECORD.
           05 ACC-TMP  PIC 9(16).
           05 OP-TMP   PIC A.
           05 AMT-TMP  PIC 9(7).
           05 TS-TMP   PIC 9(5).

       FD MASTER-FILE.
       01  MASTER-RECORD.
           05 ACC-NAME PIC X(20).
           05 ACC      PIC 9(16).
           05 PWD      PIC 9(6).
           05 SIG      PIC X.
           05 BAL      PIC 9(15).

       FD UPDATED-MASTER-FILE.
       01  UPDATED-MASTER-RECORD.
           05 ACC-NAME-UPDATED PIC X(20).
           05 ACC-UPDATED      PIC 9(16).
           05 PWD-UPDATED      PIC 9(6).
           05 SIG-UPDATED      PIC X.
           05 BAL-UPDATED      PIC 9(15).

       FD TRANS711-FILE.
       01 TRANS711-RECORD.
           05 ACC-711  PIC 9(16).
           05 OP-711   PIC A.
           05 AMT-711  PIC 9(7).
           05 TS-711   PIC 9(5).

       FD TRANS713-FILE.
       01 TRANS713-RECORD.
           05 ACC-713  PIC 9(16).
           05 OP-713   PIC A.
           05 AMT-713  PIC 9(7).
           05 TS-713   PIC 9(5).

       FD TRANS711-SORTED.
       01 TRANS711-SORTED-RECORD.
           05 ACC-711-SORTED  PIC 9(16).
           05 OP-711-SORTED   PIC A.
           05 AMT-711-SORTED  PIC 9(7).
           05 TS-711-SORTED   PIC 9(5).

       FD TRANS713-SORTED.
       01 TRANS713-SORTED-RECORD.
           05 ACC-713-SORTED  PIC 9(16).
           05 OP-713-SORTED   PIC A.
           05 AMT-713-SORTED  PIC 9(7).
           05 TS-713-SORTED   PIC 9(5). 

       FD TRANS-SORTED.
       01 TRANS-SORTED-RECORD.
           05 ACC-SORTED  PIC 9(16).
           05 OP-SORTED   PIC A.
           05 AMT-SORTED  PIC 9(7).
           05 TS-SORTED   PIC 9(5). 

       FD NEG-REPORT.
       01 NEG-REPORT-RECORD.
           05 NAME-LABEL PIC X(6) VALUE "Name: ".
           05 NAME-NEG   PIC X(20).
           05 ACC-LABEL  PIC X(17) VALUE " Account Number: ".
           05 ACC-NEG    PIC 9(16).
           05 BAL-LABEL  PIC X(10) VALUE " Balance: ".
           05 SIG-NEG    PIC X(1) VALUE "-".
           05 BAL-NEG    PIC 9(15).


       WORKING-STORAGE SECTION.
       01 ATM-INPUT PIC X(10).
       01 ACC-INPUT PIC X(50).
       01 TARGET-ACC-INPUT PIC X(50).
       01 PWD-INPUT PIC X(10).
       01 SERVICE-INPUT PIC X(10).
       01 AMT-INPUT PIC S9(6)V9(2) VALUE 00000.00.
       01 AMT-INTEGER PIC 9(7).
       01 CONTINUE-INPUT PIC X(10).
       01 TXN-TIMESTAMP PIC 9(5) VALUE 00000.
       

       PROCEDURE DIVISION.

       MAIN-PARAGRAPH.
           SORT TMP-FILE 
           ON ASCENDING KEY ACC-TMP 
           ON ASCENDING KEY TS-TMP
           USING TRANS711-FILE GIVING TRANS711-SORTED.

           SORT TMP-FILE 
           ON ASCENDING KEY ACC-TMP 
           ON ASCENDING KEY TS-TMP
           USING TRANS713-FILE GIVING TRANS713-SORTED.

           GO TO MERGE-FILES.

       MERGE-FILES.
      * TODO: IMPLEMENT MERGE
           STOP RUN.
