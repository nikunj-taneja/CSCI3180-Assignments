       IDENTIFICATION DIVISION.
       PROGRAM-ID.   ATMS.
       AUTHOR.       NIKUNJ TANEJA.

       ENVIRONMENT DIVISION.
       INPUT-OUTPUT SECTION.
       FILE-CONTROL.
           SELECT MASTER-FILE ASSIGN TO "master.txt"
               ORGANIZATION IS LINE SEQUENTIAL.
           SELECT TRANS711-FILE ASSIGN TO "trans711.txt"
               ORGANIZATION IS LINE SEQUENTIAL.
           SELECT TRANS713-FILE ASSIGN TO "trans713.txt"
               ORGANIZATION IS LINE SEQUENTIAL.
              
       DATA DIVISION.
       FILE SECTION.
       FD MASTER-FILE.
       01  MASTER-RECORD.
           05 ACC-NAME PIC X(20).
           05 ACC      PIC 9(16).
           05 PWD      PIC 9(6).
           05 SIG      PIC X.
           05 BAL      PIC 9(15).

       FD TRANS711-FILE.
       01 TRANS711-RECORD.
           05 ACC-711  PIC X(16).
           05 OP-711   PIC A.
           05 AMT-711  PIC 9(7).
           05 TS-711   PIC 9(5).

       FD TRANS713-FILE.
       01 TRANS713-RECORD.
           05 ACC-713  PIC X(16).
           05 OP-713   PIC A.
           05 AMT-713  PIC 9(7).
           05 TS-713   PIC 9(5).

       WORKING-STORAGE SECTION.
       01 ATM-INPUT PIC X(10).
       01 ACC-INPUT PIC X(50).
       01 PWD-INPUT PIC X(10).
       01 SERVICE-INPUT PIC X(10).
       01 AMT-INPUT PIC S9(5)V9(2) VALUE 00000.00.
       01 CONTINUE-INPUT PIC X(10).

       PROCEDURE DIVISION.
       
       MAIN-PARAGRAPH.
           DISPLAY "##############################################".
           DISPLAY "##         Gringotts Wizarding Bank         ##".
           DISPLAY "##                 Welcome                  ##".
           DISPLAY "##############################################".
           GO TO ATM-PROMPT.

       ATM-PROMPT.
           DISPLAY "=> PLEASE CHOOSE THE ATM".
           DISPLAY "=> PRESS 1 FOR ATM 711".
           DISPLAY "=> PRESS 2 FOR ATM 713".
       
           ACCEPT ATM-INPUT FROM SYSIN

           IF ATM-INPUT NOT = 1 AND ATM-INPUT NOT = 2 THEN 
           DISPLAY "=> INVALID INPUT"
           GO TO ATM-PROMPT
           END-IF.
       
           GO TO ACC-PWD-PROMPT.

       ACC-PWD-PROMPT.
           DISPLAY "=> ACCOUNT"
           ACCEPT ACC-INPUT FROM SYSIN
           DISPLAY "=> PASSWORD"
           ACCEPT PWD-INPUT FROM SYSIN
           OPEN INPUT MASTER-FILE.
           GO TO USER-AUTH.                                                 
       
       USER-AUTH.
           READ MASTER-FILE AT END 
           DISPLAY "=> INCORRECT ACCOUNT/PASSWORD"
           CLOSE MASTER-FILE
           GO TO ACC-PWD-PROMPT.

           IF ACC = ACC-INPUT AND PWD = PWD-INPUT THEN 
           CLOSE MASTER-FILE
           GO TO SERVICE-PROMPT
           END-IF.

           GO TO USER-AUTH.

       SERVICE-PROMPT.
           DISPLAY "=> PLEASE CHOOSE YOUR SERVICE"
           DISPLAY "=> PRESS D FOR DEPOSIT"
           DISPLAY "=> PRESS W FOR WITHDRAWAL"
           DISPLAY "=> PRESS T FOR TRANSFER"
       
           ACCEPT SERVICE-INPUT FROM SYSIN

           IF SERVICE-INPUT = "D" THEN GO TO DEPOSIT-HANDLER
           END-IF.

           IF SERVICE-INPUT = "W" THEN GO TO WITHDRAWAL-HANDLER
           END-IF.

           IF SERVICE-INPUT = "T" THEN GO TO TRANSFER-HANDLER
           END-IF.
           
           DISPLAY "=> INVALID INPUT".
           GO TO SERVICE-PROMPT.

       DEPOSIT-HANDLER.
           DISPLAY "=> AMOUNT"
           ACCEPT AMT-INPUT FROM SYSIN
           IF AMT-INPUT < 0 THEN
           DISPLAY "INCORRECT AMOUNT"
           GO TO DEPOSIT-HANDLER
           END-IF.
      *    TODO: IMPLEMENT DEPOSIT-HANDLER

           GO TO CONTINUE-PROMPT.

       WITHDRAWAL-HANDLER.
           DISPLAY "=> AMOUNT"
           ACCEPT AMT-INPUT FROM SYSIN
           IF AMT-INPUT < 0 THEN
           DISPLAY "INCORRECT AMOUNT"
           GO TO DEPOSIT-HANDLER
           END-IF.

      * TODO: IMPLEMENT WITHDRAWAL-HANDLER

           GO TO CONTINUE-PROMPT.

       TRANSFER-HANDLER.
           DISPLAY "=> AMOUNT"
           ACCEPT AMT-INPUT FROM SYSIN
           IF AMT-INPUT < 0 THEN
           DISPLAY "INCORRECT AMOUNT"
           GO TO DEPOSIT-HANDLER
           END-IF.

      * TODO: IMPLEMENT TRANSFER-HANDLER

           GO TO CONTINUE-PROMPT.

       CONTINUE-PROMPT.
           DISPLAY "=> CONTINUE?".
           DISPLAY "=> N FOR NO".
           DISPLAY "=> Y FOR YES".
           ACCEPT CONTINUE-INPUT FROM SYSIN.
           IF CONTINUE-INPUT = "N" THEN
           STOP RUN
           END-IF.
           
           IF CONTINUE-INPUT = "Y" THEN
           GO TO ATM-PROMPT
           END-IF. 

           DISPLAY "=> INVALID INPUT".                 
           GO TO CONTINUE-PROMPT.



       
       

       

       
       
