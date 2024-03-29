      * CSCI3180 Principles of Programming Languages *
      * --- Declaration --- *
      * I declare that the assignment here submitted is original except 
      * for source material explicitly acknowledged. I also acknowledge 
      * that I am aware of University policy and regulations on honesty 
      * in academic work, and of the disciplinary guidelines and procedures 
      * applicable to breaches of such policy and regulations, as contained in 
      * the website http://www.cuhk.edu.hk/policy/academichonesty/ *
      * Assignment 1
      * Name : Taneja Nikunj
      * Student ID : 1155123371
      * Email Addr : ntaneja9@cse.cuhk.edu.hk
       
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
           05 NAME-LABEL PIC X(6).
           05 NAME-NEG   PIC X(20).
           05 ACC-LABEL  PIC X(17).
           05 ACC-NEG    PIC 9(16).
           05 BAL-LABEL  PIC X(10).
           05 SIG-NEG    PIC X(1).
           05 BAL-NEG    PIC 9(15).


       WORKING-STORAGE SECTION.
       01 PREV-ACC PIC 9(16).
       01 DELTA PIC S9(20) VALUES 0.
       01 NEW-BAL PIC S9(20) VALUES 0.
       

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

           OPEN INPUT TRANS711-SORTED.
           OPEN INPUT TRANS713-SORTED.
           OPEN OUTPUT TRANS-SORTED.
           READ TRANS711-SORTED AT END GO TO HANDLE-REMAINING-713.
           READ TRANS713-SORTED AT END GO TO HANDLE-REMAINING-711.
           GO TO MERGE-FILES.
           
       MERGE-FILES.
           IF ACC-711-SORTED < ACC-713-SORTED THEN
           SET ACC-SORTED TO ACC-711-SORTED
           MOVE OP-711-SORTED TO OP-SORTED
           SET AMT-SORTED TO AMT-711-SORTED
           SET TS-SORTED TO TS-711-SORTED
           WRITE TRANS-SORTED-RECORD
           GO TO READ-TRANS711-SORTED
           END-IF.
           
           IF ACC-711-SORTED > ACC-713-SORTED THEN
           SET ACC-SORTED TO ACC-713-SORTED
           MOVE OP-713-SORTED TO OP-SORTED
           SET AMT-SORTED TO AMT-713-SORTED
           SET TS-SORTED TO TS-713-SORTED
           WRITE TRANS-SORTED-RECORD
           GO TO READ-TRANS713-SORTED
           END-IF.
           
           IF TS-711-SORTED < TS-713-SORTED THEN
           SET ACC-SORTED TO ACC-711-SORTED
           MOVE OP-711-SORTED TO OP-SORTED
           SET AMT-SORTED TO AMT-711-SORTED
           SET TS-SORTED TO TS-711-SORTED
           WRITE TRANS-SORTED-RECORD
           GO TO READ-TRANS711-SORTED
           END-IF.
           
           IF TS-711-SORTED > TS-713-SORTED THEN
           SET ACC-SORTED TO ACC-713-SORTED
           MOVE OP-713-SORTED TO OP-SORTED
           SET AMT-SORTED TO AMT-713-SORTED
           SET TS-SORTED TO TS-713-SORTED
           WRITE TRANS-SORTED-RECORD
           GO TO READ-TRANS713-SORTED
           END-IF.

       READ-TRANS711-SORTED.
           READ TRANS711-SORTED AT END GO TO HANDLE-REMAINING-713.
           GO TO MERGE-FILES.

       READ-TRANS713-SORTED.
           READ TRANS713-SORTED AT END GO TO HANDLE-REMAINING-711.
           GO TO MERGE-FILES.

       HANDLE-REMAINING-711.
           SET ACC-SORTED TO ACC-711-SORTED.
           MOVE OP-711-SORTED TO OP-SORTED.
           SET AMT-SORTED TO AMT-711-SORTED.
           SET TS-SORTED TO TS-711-SORTED.
           WRITE TRANS-SORTED-RECORD.
           READ TRANS711-SORTED AT END GO TO UPDATE-MASTER.
           GO TO HANDLE-REMAINING-711.
       
       HANDLE-REMAINING-713.
           SET ACC-SORTED TO ACC-713-SORTED.
           MOVE OP-713-SORTED TO OP-SORTED.
           SET AMT-SORTED TO AMT-713-SORTED.
           SET TS-SORTED TO TS-713-SORTED.
           WRITE TRANS-SORTED-RECORD.
           READ TRANS713-SORTED AT END GO TO UPDATE-MASTER.
           GO TO HANDLE-REMAINING-713.

       UPDATE-MASTER.
           CLOSE TRANS-SORTED.
           CLOSE TRANS711-SORTED.
           CLOSE TRANS713-SORTED.

           OPEN INPUT TRANS-SORTED.
           OPEN INPUT MASTER-FILE.
           OPEN OUTPUT UPDATED-MASTER-FILE.

           READ TRANS-SORTED AT END GO TO COPY-MASTER-RECORDS.
           SET PREV-ACC TO ACC-SORTED.
      *     IF OP-SORTED = 'D' THEN 
      *     COMPUTE DELTA = AMT-SORTED 
      *     GO TO PROCESS-MASTER-RECORD
      *     END-IF.
      *     COMPUTE DELTA = -AMT-SORTED.
           GO TO PROCESS-MASTER-RECORD.
       
       PROCESS-MASTER-RECORD.
           READ MASTER-FILE AT END GO TO GENERATE-NEG-REPORT.

           IF ACC = ACC-SORTED THEN
           DISPLAY "BEFORE"
           DISPLAY DELTA
           GO TO PROCESS-ACC-TRANSACTIONS
           END-IF.

           MOVE ACC-NAME TO ACC-NAME-UPDATED.
           SET ACC-UPDATED TO ACC.
           SET PWD-UPDATED TO PWD.
           MOVE SIG TO SIG-UPDATED.
           SET BAL-UPDATED TO BAL.
           WRITE UPDATED-MASTER-RECORD.
           GO TO PROCESS-MASTER-RECORD.

       PROCESS-ACC-TRANSACTIONS.
      *    CURRENT TXN IS OF THE SAME ACCOUNT
           IF PREV-ACC = ACC-SORTED THEN
           IF OP-SORTED = 'D' THEN
           COMPUTE DELTA = DELTA + AMT-SORTED
           READ TRANS-SORTED AT END GO TO COPY-MASTER-RECORDS
           GO TO PROCESS-ACC-TRANSACTIONS                               
           END-IF
           COMPUTE DELTA = DELTA - AMT-SORTED
           READ TRANS-SORTED AT END GO TO COPY-MASTER-RECORDS
           GO TO PROCESS-ACC-TRANSACTIONS                               
           END-IF.
      
      *    CURRENT TXN IS NOT OF THE SAME ACCOUNT
           DISPLAY "UPDATING".
           DISPLAY PREV-ACC.
           SET PREV-ACC TO ACC-SORTED.
           MOVE ACC-NAME TO ACC-NAME-UPDATED.
           SET ACC-UPDATED TO ACC.
           SET PWD-UPDATED TO PWD.
           MOVE SIG TO SIG-UPDATED.
           COMPUTE NEW-BAL = BAL + DELTA.
           SET BAL-UPDATED TO NEW-BAL.
           IF NEW-BAL < 0 THEN
           MOVE '-' TO SIG-UPDATED
           COMPUTE BAL-UPDATED = -NEW-BAL
           END-IF.
           DISPLAY BAL-UPDATED.
           DISPLAY DELTA.
           WRITE UPDATED-MASTER-RECORD.

      *    PROCESS THE CURRENT TXN AND MOVE TO NEXT MASTER RECORD
      *     IF OP-SORTED = 'D' THEN
      *     COMPUTE DELTA = AMT-SORTED
      *     GO TO PROCESS-MASTER-RECORD
      *     END-IF.
      *     COMPUTE DELTA = -AMT-SORTED.
           COMPUTE DELTA = 0.
           GO TO PROCESS-MASTER-RECORD.
           

       COPY-MASTER-RECORDS.
      *    CHECK FOR ANY UNPROCESSED TXNS
           COMPUTE NEW-BAL = BAL.
           IF DELTA NOT = 0 THEN
           COMPUTE NEW-BAL = BAL + DELTA
           COMPUTE DELTA = 0
           END-IF.
           MOVE ACC-NAME TO ACC-NAME-UPDATED.
           SET ACC-UPDATED TO ACC.
           SET PWD-UPDATED TO PWD.
           MOVE SIG TO SIG-UPDATED.
           SET BAL-UPDATED TO NEW-BAL.
           IF NEW-BAL < 0 THEN
           MOVE '-' TO SIG-UPDATED
           COMPUTE BAL-UPDATED = -NEW-BAL
           END-IF.
           WRITE UPDATED-MASTER-RECORD.
           READ MASTER-FILE AT END GO TO GENERATE-NEG-REPORT.
           GO TO COPY-MASTER-RECORDS.
       
       GENERATE-NEG-REPORT.
           CLOSE MASTER-FILE.
           CLOSE TRANS-SORTED.
           CLOSE UPDATED-MASTER-FILE.

           OPEN INPUT UPDATED-MASTER-FILE.
           OPEN OUTPUT NEG-REPORT.
           GO TO CHECK-BALANCE.
       
       CHECK-BALANCE.
           READ UPDATED-MASTER-FILE AT END GO TO CENTRAL-END.
           IF SIG-UPDATED = '-' THEN
           MOVE "Name: " TO NAME-LABEL
           MOVE " Account Number: " TO ACC-LABEL
           MOVE " Balance: " TO BAL-LABEL 
           MOVE '-' TO SIG-NEG                         
           MOVE ACC-NAME-UPDATED TO NAME-NEG
           MOVE " Account Number: " TO ACC-LABEL
           SET ACC-NEG TO ACC-UPDATED
           MOVE " Balance: " TO BAL-LABEL
           SET BAL-NEG TO BAL-UPDATED
           WRITE NEG-REPORT-RECORD
           END-IF.
           GO TO CHECK-BALANCE.
       
       CENTRAL-END.
           CLOSE UPDATED-MASTER-FILE.
           CLOSE NEG-REPORT.
           STOP RUN.
