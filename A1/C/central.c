/*

* CSCI3180 Principles of Programming Languages *
* --- Declaration --- *
* I declare that the assignment here submitted is original except for source
* material explicitly acknowledged. I also acknowledge that I am aware of
* University policy and regulations on honesty in academic work, and of the
* disciplinary guidelines and procedures applicable to breaches of such policy
* and regulations, as contained in the website
* http://www.cuhk.edu.hk/policy/academichonesty/ *
* Assignment 1
* Name : Taneja Nikunj
* Student ID : 1155123371
* Email Addr : ntaneja9@cse.cuhk.edu.hk

*/


#include<stdio.h>
#include<stdlib.h>
#include<string.h>
#include<math.h>

#define MASTER_FILE_PATH            "master.txt"
#define TRANS711_FILE_PATH          "trans711.txt"
#define TRANS713_FILE_PATH          "trans713.txt"
#define SORTED711_FILE_PATH         "transSorted711.txt"
#define SORTED713_FILE_PATH         "transSorted713.txt"
#define MERGED_TXN_FILE_PATH        "transSorted.txt"
#define UPDATED_MASTER_FILE_PATH    "updatedMaster.txt"
#define NEG_REPORT_FILE_PATH        "negReport.txt"

#define NAME_SIZE          20
#define ACC_SIZE           16
#define PWD_SIZE           6
#define BALANCE_SIZE       16
#define AMOUNT_SIZE        7
#define TIMESTAMP_SIZE     5
#define MAX_INPUT_SIZE     128
#define MASTER_LINE_SIZE   60
#define TXN_LINE_SIZE      30


////////////////////////////////////////////////
// begin sort.c
void read_str(char input_line[], char output_line[], int start_index, int length) {
    strncpy(output_line, input_line + start_index, length);
    output_line[length] = '\0';
}

// global variable
int MAX_TRAN = 10;

struct transaction {
    char transac_account[20];
    char others[15];
    char timestamp[10];
};

struct transaction * process_one_transaction(char line[]) {
    struct transaction * result_transaction = (struct transaction *) malloc(sizeof(struct transaction));
    
    char temp_str[30];

    // transaction account
    read_str(line, temp_str, 0, 16);
    strcpy(result_transaction->transac_account , temp_str);

    // operation
    read_str(line, temp_str, 16, 8);
    strcpy(result_transaction->others , temp_str);

    // timestamp 
    read_str(line, temp_str, 24, 5);
    strcpy(result_transaction->timestamp , temp_str);

    return result_transaction;
}

struct transaction ** get_transactions(char stat_path[]){
    struct transaction ** all_transactions = (struct transaction **) malloc(sizeof(struct transaction *) * MAX_TRAN);
    FILE * fp = fopen(stat_path, "r");
    for (int i = 0; i < MAX_TRAN; i++) all_transactions[i] = NULL;
    char line[60];
    int cnt = 0;
    while (fgets(line, 60, fp) != NULL) {
        all_transactions[cnt] = process_one_transaction(line);
        cnt += 1;

        if (cnt == MAX_TRAN) {
            // allocate more space
            MAX_TRAN *= 2;
            struct transaction ** all_transactions_temp;
            all_transactions_temp = realloc(all_transactions, sizeof(struct transaction *) * MAX_TRAN);
            all_transactions = all_transactions_temp;
        }
    }
    return all_transactions;

}

void swap(struct transaction *a , struct transaction *b)
{
    struct transaction temp ;
    temp = *a ;
    *a = *b ;
    *b = temp ;
    return ;
}

struct transaction ** sort_transactions(struct transaction ** transaction_i){

    int transaction_index = 0, temp_index = 0;
    while (transaction_i[transaction_index] != NULL) {
        temp_index = transaction_index;
        while (transaction_i[temp_index] != NULL){
            if (strcmp(transaction_i[temp_index]->transac_account,transaction_i[transaction_index]->transac_account)<0){
                swap(transaction_i[temp_index], transaction_i[transaction_index]);
            }
            else{
                if (strcmp(transaction_i[temp_index]->transac_account,transaction_i[transaction_index]->transac_account)==0){
                    if (strcmp(transaction_i[temp_index]->timestamp,transaction_i[transaction_index]->timestamp)<0){
                        swap(transaction_i[temp_index], transaction_i[transaction_index]);
                    }
                }
            }
            temp_index += 1;

        }
        transaction_index += 1;
    }
    return transaction_i;
}

void save_transactions(struct transaction ** transactions, char save_path[]){
    FILE * fp = fopen(save_path, "w");
    int transaction_index = 0;
    while(transactions[transaction_index] != NULL){
        fprintf(fp, "%.16s%.8s%.5s", transactions[transaction_index]->transac_account, transactions[transaction_index]->others, transactions[transaction_index]->timestamp);
        fprintf(fp, "%s", "\n");
        transaction_index += 1;
    }
    fclose(fp);
}

void sort_transaction(char path[], char sort_path[]){
    struct transaction ** transactions = get_transactions(path);
    struct transaction ** transactions_sort = sort_transactions(transactions);
    save_transactions(transactions_sort, sort_path);
}
// end sort.c
/////////////////////////////////////////////// 


typedef struct {
    char acc[ACC_SIZE+1];
    char op;
    long long int amount;
    int timestamp;
} TransactionRecord;

typedef struct {
    char name[NAME_SIZE+1];
    char acc[ACC_SIZE+1];
    char pwd[PWD_SIZE+1];
    long long int balance;
} MasterRecord;

long long int to_int(char* str, int size) {
    long long int num = 0;
    int start_idx = 0;

    if (size == BALANCE_SIZE)
        start_idx++;

    for (int i = start_idx; i < size; i++) {
        int digit = (int) (str[i] - '0');
        num *= 10;
        num += digit;
    }

    if (str[0] == '-')
        num *= -1;
    
    return num;
}

// Accepts a string and formats it 
// to size with leading 0's
char* format_balance(long long int num, int size) {
    // initialize a null-terminated string of all 0's
    char* str = (char *) malloc(sizeof(char) * (size+1));
    memset(str, '0', size);
    str[size] = '\0';

    if (num >= 0)
        str[0] = '+';
    else {
        str[0] = '-';
        num = -num;
    }
    
    // fill the string from the end
    int idx = size-1;
    while (num > 0) {
        str[idx] = (char) ((num % 10) + '0');
        num /= 10;
        idx -= 1;
    }

    return str;
}


// Constructs a transaction record by parsing its string representation
TransactionRecord* construct_txn_record(char *line) {
    TransactionRecord* record = (TransactionRecord *) malloc(sizeof(TransactionRecord));
    char *amount_str = (char *) malloc(sizeof(char) * (AMOUNT_SIZE+1));
    char *timestamp_str = (char *) malloc(sizeof(char) * (TIMESTAMP_SIZE+1));
    int pos = 0;
    strncpy(record->acc, line, ACC_SIZE);
    record->acc[ACC_SIZE] = '\0';
    pos += ACC_SIZE;
    record->op = line[pos++];
    strncpy(amount_str, line+pos, AMOUNT_SIZE);
    amount_str[AMOUNT_SIZE] = '\0';
    record->amount = to_int(amount_str, AMOUNT_SIZE);
    pos += AMOUNT_SIZE;
    strncpy(timestamp_str, line+pos, TIMESTAMP_SIZE);
    timestamp_str[TIMESTAMP_SIZE] = '\0';
    record->timestamp = atoi(timestamp_str);
    free(timestamp_str);
    return record;
}

// Constructs a master record by parsing its string representation
MasterRecord* construct_master_record(char *line) {
    MasterRecord* record = (MasterRecord *) malloc(sizeof(MasterRecord));
    char *balance_str = (char *) malloc(sizeof(char) * (BALANCE_SIZE+1));
    int pos = 0;
    strncpy(record->name, line, NAME_SIZE);
    record->name[NAME_SIZE] = '\0';
    pos += NAME_SIZE;
    strncpy(record->acc, line+pos, ACC_SIZE);
    record->acc[ACC_SIZE] = '\0';
    pos += ACC_SIZE;
    strncpy(record->pwd, line+pos, PWD_SIZE);
    record->pwd[PWD_SIZE] = '\0';
    pos += PWD_SIZE;
    strncpy(balance_str, line+pos, BALANCE_SIZE);
    balance_str[BALANCE_SIZE] = '\0';
    record->balance = to_int(balance_str, BALANCE_SIZE);
    return record;
}

// Merges two sorted transactions files and writes the result to a new file
void merge_transactions(char* infile1, char* infile2, char* outfile) {
    FILE* fp_in1 = fopen(infile1, "r");
    FILE* fp_in2 = fopen(infile2, "r");
    FILE* fp_out = fopen(outfile, "w");

    size_t line_size = TXN_LINE_SIZE;
    char *line1 = (char *) malloc(sizeof(char) * line_size);
    char *line2 = (char *) malloc(sizeof(char) * line_size);

    size_t line1_chars = 0, line2_chars = 0;
    
    if (fp_in1 && fp_in2 && fp_out) {
        // read a line from both files and compare to determine which one to write
        line1_chars = getline(&line1, &line_size, fp_in1);
        line2_chars = getline(&line2, &line_size, fp_in2);
        while (line1_chars != -1 && line2_chars != -1) {
            TransactionRecord *rec1, *rec2;
            rec1 = construct_txn_record(line1);
            rec2 = construct_txn_record(line2);
            int cmp = strcmp(rec1->acc, rec2->acc);
            if (cmp < 0) {
                fprintf(fp_out, "%s", line1);
                line1_chars = getline(&line1, &line_size, fp_in1);
            }
            else if (cmp == 0) {
                if (rec1->timestamp < rec2->timestamp) {
                    fprintf(fp_out, "%s", line1);
                    line1_chars = getline(&line1, &line_size, fp_in1);
                } else {
                    fprintf(fp_out, "%s", line2);
                    line2_chars = getline(&line2, &line_size, fp_in2);
                }
            } else {
                fprintf(fp_out, "%s", line2);
                line2_chars = getline(&line2, &line_size, fp_in2);
            }
            free(rec1);
            free(rec2);
        }

        // write any remaining lines from infile1
        while (line1_chars != -1) {
            fprintf(fp_out, "%s", line1);
            line1_chars = getline(&line1, &line_size, fp_in1);
        }
        
        // write any remaining lines from infile2
        while (line2_chars != -1) {
            fprintf(fp_out, "%s", line2);
            line2_chars = getline(&line2, &line_size, fp_in2);
        }

        // free any allocated memory and close all files
        free(line1);
        free(line2);
        fclose(fp_in1);
        fclose(fp_in2);
        fclose(fp_out);
    } else {
        perror("Invalid file path for one or more input files");
        exit(1);
    }
}

// Generates negReport.txt given the path to updatedMaster.txt
void report_negative_balance_accs(char* updated_master, char* neg_report) {
    // open updatedMaster.txt in read mode
    FILE* fp_updated_master = fopen(updated_master, "r");
    if (fp_updated_master == NULL) {
        perror(updated_master);
        exit(1);
    }

    // open negReport.txt in write mode
    FILE* fp_neg_report = fopen(neg_report, "w");
    if (fp_neg_report == NULL) {
        perror(neg_report);
        exit(1);
    }

    size_t num_chars = 0, master_line_size = MASTER_LINE_SIZE;
    char *master_line = (char *) malloc(sizeof(char) * (MASTER_LINE_SIZE+1));

    // read updated master line by line and report negative balances
    while (getline(&master_line, &master_line_size, fp_updated_master) != -1) {
        MasterRecord* rec = construct_master_record(master_line);
        if (rec->balance < 0) {
            char *balance_str = format_balance(rec->balance, BALANCE_SIZE);
            fprintf(fp_neg_report, "Name: %s Account Number: %s Balance: %s\n", rec->name, rec->acc, balance_str);
            free(balance_str);
        }
        free(rec);
    }

    // free any remaining allocated memory and close any open files
    free(master_line);
    fclose(fp_neg_report);
    fclose(fp_updated_master);
}

// Updates the records in master.txt using transSorted.txt
void update_master(char* txn, char* master, char* updated_master) {
    FILE* fp_txn = fopen(txn, "r");
    if (fp_txn == NULL) {
        perror(txn);
        exit(1);
    }

    FILE* fp_master = fopen(master, "r");
    if (fp_master == NULL) {
        perror(master);
        exit(1);
    }

    FILE* fp_updated_master = fopen(updated_master, "w");
    if (fp_updated_master == NULL) {
        perror(updated_master);
        exit(1);
    }

    size_t txn_line_size = TXN_LINE_SIZE;
    size_t master_line_size = MASTER_LINE_SIZE;
    int txn_line_chars, master_line_chars;
    char *txn_line = (char *) malloc(sizeof(char) * txn_line_size);
    char *master_line = (char *) malloc(sizeof(char) * master_line_size);

    char *cur_acc = malloc(sizeof(char) * (ACC_SIZE+1));
    char *prev_acc = malloc(sizeof(char) * (ACC_SIZE+1));

    long long int delta = 0;

    int first_line = 1, updated = 0;

    // try to read a line from txn file
    txn_line_chars = getline(&txn_line, &txn_line_size, fp_txn);
    if (txn_line_chars > 0) {
        // parse the txn line
        TransactionRecord* txn_rec = construct_txn_record(txn_line);
        
        // init currect and previous account variables
        strncpy(cur_acc, txn_line, ACC_SIZE);
        cur_acc[ACC_SIZE] = '\0';
        strncpy(prev_acc, txn_line, ACC_SIZE);
        prev_acc[ACC_SIZE] = '\0';

        // init delta
        if (txn_rec->op == 'D')
            delta += txn_rec->amount;
        else
            delta -= txn_rec->amount;

        free(txn_rec);
    }
    
    while (getline(&master_line, &master_line_size, fp_master) != -1) {
        MasterRecord* master_rec = construct_master_record(master_line);
        updated = 0;

        if (strcmp(cur_acc, master_rec->acc) == 0) {
            // read all transactions related to current account and update the record
            do {
                // try to read a line from txn file
                txn_line_chars = getline(&txn_line, &txn_line_size, fp_txn);
                if (txn_line_chars < 0) {
                    // EOF
                    if (delta != 0) {
                        // update record and write to updated master file
                        long long int updated_balance = master_rec->balance + delta;
                        char *balance_str = format_balance(updated_balance, BALANCE_SIZE);
                        fprintf(fp_updated_master, "%s%s%s%s\n", master_rec->name, master_rec->acc, master_rec->pwd, balance_str);
                        free(balance_str);

                        // reset delta
                        delta = 0;

                        // mark account as updated
                        updated = 1;
                    } else {
                        fprintf(fp_updated_master, "%s", master_line);
                    }
                    break;
                }

                // parse the txn line
                TransactionRecord* txn_rec = construct_txn_record(txn_line);

                // copy the previous account before updating current account
                strncpy(prev_acc, cur_acc, ACC_SIZE);
                prev_acc[ACC_SIZE] = '\0';
                
                // update current account
                strncpy(cur_acc, txn_line, ACC_SIZE);
                cur_acc[ACC_SIZE] = '\0';
                
                // check if all relevant transactions have been processed yet
                if (strcmp(prev_acc, cur_acc) != 0) {
                    // update record and write to updated master file
                    long long int updated_balance = master_rec->balance + delta;
                    char *balance_str = format_balance(updated_balance, BALANCE_SIZE);
                    fprintf(fp_updated_master, "%s%s%s%s\n", master_rec->name, master_rec->acc, master_rec->pwd, balance_str);
                    free(balance_str);

                    // reset delta
                    delta = 0;

                    // mark account as updated
                    updated = 1;
                }
                
                // process current transaction for next update
                if (txn_rec->op == 'D')
                    delta += txn_rec->amount;
                else
                    delta -= txn_rec->amount;
                
                free(txn_rec);
                
            } while (!updated);

        } else {
            // write the line to updated master file as is
            fprintf(fp_updated_master, "%s", master_line);
        }
        free(master_rec);
    }
    
    fclose(fp_master);
    fclose(fp_updated_master);
    fclose(fp_txn);
}

int main() {
    sort_transaction(TRANS711_FILE_PATH, SORTED711_FILE_PATH);
    sort_transaction(TRANS713_FILE_PATH, SORTED713_FILE_PATH);
    merge_transactions(SORTED711_FILE_PATH, SORTED713_FILE_PATH, MERGED_TXN_FILE_PATH);
    update_master(MERGED_TXN_FILE_PATH, MASTER_FILE_PATH, UPDATED_MASTER_FILE_PATH);
    report_negative_balance_accs(UPDATED_MASTER_FILE_PATH, NEG_REPORT_FILE_PATH);
    return 0;
}
