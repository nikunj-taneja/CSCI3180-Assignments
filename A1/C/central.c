#include<stdio.h>
#include<stdlib.h>
#include<string.h>
#include<math.h>

#define MASTER_FILE_PATH            "test/master.txt"
#define TRANS711_FILE_PATH          "test/trans711.txt"
#define TRANS713_FILE_PATH          "test/trans713.txt"
#define SORTED711_FILE_PATH         "test/transSorted711.txt"
#define SORTED713_FILE_PATH         "test/transSorted713.txt"
#define MERGED_TXN_FILE_PATH        "test/transSorted.txt"
#define UPDATED_MASTER_FILE_PATH    "test/updatedMaster.txt"
#define NEG_REPORT_FILE_PATH        "test/negReport.txt"

#define NAME_SIZE          20
#define ACC_SIZE           16
#define PWD_SIZE           6
#define BALANCE_SIZE       16
#define AMOUNT_SIZE        7
#define TIMESTAMP_SIZE     5
#define MAX_INPUT_SIZE     128
#define MASTER_LINE_SIZE   60
#define TXN_LINE_SIZE      30


char* itoa(int num, char* buffer, int base) {
    int curr = 0;
 
    if (num == 0) {
        // Base case
        buffer[curr++] = '0';
        buffer[curr] = '\0';
        return buffer;
    }
 
    int num_digits = 0;
 
    if (num < 0) {
        if (base == 10) {
            num_digits ++;
            buffer[curr] = '-';
            curr ++;
            // Make it positive and finally add the minus sign
            num *= -1;
        }
        else
            // Unsupported base. Return NULL
            return NULL;
    }
 
    num_digits += (int)floor(log(num) / log(base)) + 1;
 
    // Go through the digits one by one
    // from left to right
    while (curr < num_digits) {
        // Get the base value. For example, 10^2 = 1000, for the third digit
        int base_val = (int) pow(base, num_digits-1-curr);
 
        // Get the numerical value
        int num_val = num / base_val;
 
        char value = num_val + '0';
        buffer[curr] = value;
 
        curr ++;
        num -= base_val * num_val;
    }
    buffer[curr] = '\0';
    return buffer;
}

////////////////////////////////////////////////
// SORT FUNCTION
// global variable
int MAX_TRAN = 10;

void read_str(char input_line[], char output_line[], int start_index, int length) {
    strncpy(output_line, input_line + start_index, length);
    output_line[length] = '\0';
}

struct transaction {
    char transac_account[20];
    char op_transac[5];
    double amounts;
    int timestamp;
};

struct transaction * process_one_transaction(char line[]) {
    struct transaction * result_transaction = (struct transaction *) malloc(sizeof(struct transaction));

    char temp_str[30];

    // transaction account
    read_str(line, temp_str, 0, 16);
    strcpy(result_transaction->transac_account , temp_str);

    // operation
    read_str(line, temp_str, 16, 1);
    strcpy(result_transaction->op_transac , temp_str);

    // integer
    read_str(line, temp_str, 17, 5);
    int integer = atoi(temp_str);

    //float
    read_str(line, temp_str, 22, 2);
    int floating = atoi(temp_str);
    result_transaction->amounts = (double) integer + (double) floating/(double)100;

    // timestamp
    read_str(line, temp_str, 24, 5);
    result_transaction->timestamp = atoi(temp_str);

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
    //struct transaction ** all_transactions = (struct transaction **) malloc(sizeof(struct transaction *) * MAX_TRAN);
    //for (int i = 0; i < MAX_TRAN * 2; i++) all_transactions[i] = NULL;
    int transaction_index = 0, temp_index = 0;
    while (transaction_i[transaction_index] != NULL) {
        temp_index = transaction_index;
        while (transaction_i[temp_index] != NULL){
            if (strcmp(transaction_i[temp_index]->transac_account,transaction_i[transaction_index]->transac_account)<0){
                swap(transaction_i[temp_index], transaction_i[transaction_index]);
            }
            else{
                if (strcmp(transaction_i[temp_index]->transac_account,transaction_i[transaction_index]->transac_account)==0){
                    if (transaction_i[temp_index]->timestamp < transaction_i[transaction_index]->timestamp){
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
    int integer, floating, positive;
    double amounts;
    char timestamp_str[10];
    char integer_str[10];
    char floating_str[10];
    int timestamp;
    while(transactions[transaction_index] != NULL){

        fprintf(fp, "%.16s%.1s", transactions[transaction_index]->transac_account, transactions[transaction_index]->op_transac);
        if(transactions[transaction_index]->amounts < 0){
            positive = 0;
        }
        amounts = fabs(transactions[transaction_index]->amounts);

        integer = (int) amounts;
        itoa(integer, integer_str, 10);

        if (!positive){
            for (int i=0; i<5-strlen(integer_str)-1;i++){
                fprintf(fp, "%s", " ");
            }
            fprintf(fp, "%s", "-");
        }
        else{
            for (int i=0; i<5-strlen(integer_str);i++){
                fprintf(fp, "%s", "0");
            }
        }
        fprintf(fp, "%s", integer_str);

        floating = (int) (amounts - integer)*100;
        itoa(floating, floating_str, 10);
        fprintf(fp, "%s", floating_str);
        for (int i=0; i<2-strlen(floating_str);i++){
            fprintf(fp, "%s", "0");
        }
        timestamp = transactions[transaction_index]->timestamp;
        itoa(timestamp, timestamp_str, 10);
        for (int i=0; i<5-strlen(timestamp_str);i++){
            fprintf(fp, "%s", "0");
        }
        fprintf(fp, "%s\n", timestamp_str);
        transaction_index += 1;
    }
    fclose(fp);
}

void sort_transaction(char path[], char sort_path[]) {
    struct transaction ** transactions = get_transactions(path);
    struct transaction ** transactions_sort = sort_transactions(transactions);
    save_transactions(transactions_sort, sort_path);
}
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
    fseek(fp_updated_master, 0, SEEK_SET);
    printf("reading updated master...\n");
    while (getline(&master_line, &master_line_size, fp_updated_master) != -1) {
        MasterRecord* rec = construct_master_record(master_line);
        printf("%lld\n", rec->balance);
        if (rec->balance < 0) {
            char *balance_str = format_balance(rec->balance, BALANCE_SIZE);
            fprintf(fp_neg_report, "Name: %s Account Number: %s Balance: %s\r\n", rec->name, rec->acc, balance_str);
            fprintf(stdout, "Name: %s Account Number: %s Balance: %s\r\n", rec->name, rec->acc, balance_str);
            free(balance_str);
        }
        free(rec);
    }

    // free any remaining allocated memory and close any open files
    free(master_line);
    fclose(fp_neg_report);
    fclose(fp_updated_master);
}

void update_single_record(char* acc, long long int delta, char* updated_master) {
    // open updatedMaster.txt in r+ mode for editing
    FILE* fp_updated_master = fopen(updated_master, "r+");
    if (fp_updated_master == NULL) {
        perror(updated_master);
        exit(1);
    }

    int found = 0;
    size_t num_chars = 0, master_line_size = MASTER_LINE_SIZE;
    char *master_line = (char *) malloc(sizeof(char) * (MASTER_LINE_SIZE+1));
    
    while (!found) {
        num_chars = getline(&master_line, &master_line_size, fp_updated_master);
        MasterRecord* master_rec = construct_master_record(master_line);
        
        if (strcmp(master_rec->acc, acc) == 0) {
            fseek(fp_updated_master, -num_chars, SEEK_CUR);
            long long int updated_balance = master_rec->balance + delta;
            char *balance_str = format_balance(updated_balance, BALANCE_SIZE);
            fprintf(fp_updated_master, "%s%s%s%s\r\n", master_rec->name, master_rec->acc, master_rec->pwd, balance_str);
            found = 1;
            free(balance_str);
        }
        free(master_rec);
    }

    free(master_line);
    fclose(fp_updated_master);
}

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
    size_t txn_line_chars, master_line_chars;
    char *txn_line = (char *) malloc(sizeof(char) * txn_line_size);
    char *master_line = (char *) malloc(sizeof(char) * master_line_size);

    char *cur_acc = malloc(sizeof(char) * (ACC_SIZE+1));
    char *prev_acc = malloc(sizeof(char) * (ACC_SIZE+1));

    TransactionRecord* txn_rec;

    long long int delta = 0;

    int first_line = 1;

    // copy all the lines from old master.txt to updatedMaster.txt
    while (getline(&master_line, &master_line_size, fp_master) != -1) {
        fprintf(fp_updated_master, "%s", master_line);
    }
    fclose(fp_master);
    fclose(fp_updated_master);

    // read transactions one-by-one and update stale records in updatedMaster.txt
    txn_line_chars = getline(&txn_line, &txn_line_size, fp_txn);
    
    while (txn_line_chars != -1) {
        txn_rec = construct_txn_record(txn_line);
        strncpy(cur_acc, txn_line, ACC_SIZE);
        cur_acc[ACC_SIZE] = '\0';
        if (first_line) {
            first_line = 0;
        } else if (strcmp(cur_acc, prev_acc) != 0) {
            update_single_record(prev_acc, delta, updated_master);
            delta = 0;
        }

        // process current transaction
        if (txn_rec->op == 'D')
            delta += txn_rec->amount;
        else
            delta -= txn_rec->amount;
        
        // mark current account as previous
        strncpy(prev_acc, txn_line, ACC_SIZE);

        // read next line
        txn_line_chars = getline(&txn_line, &txn_line_size, fp_txn);
    }

    if (delta != 0) {
        update_single_record(prev_acc, delta, updated_master);
    }

    fclose(fp_txn);
    free(txn_line);
    free(master_line);
    free(cur_acc);
    free(prev_acc);
}

int main() {
    sort_transaction(TRANS711_FILE_PATH, SORTED711_FILE_PATH);
    sort_transaction(TRANS713_FILE_PATH, SORTED713_FILE_PATH);
    merge_transactions(SORTED711_FILE_PATH, SORTED713_FILE_PATH, MERGED_TXN_FILE_PATH);
    update_master(MERGED_TXN_FILE_PATH, MASTER_FILE_PATH, UPDATED_MASTER_FILE_PATH);
    report_negative_balance_accs(UPDATED_MASTER_FILE_PATH, NEG_REPORT_FILE_PATH);
    return 0;
}
