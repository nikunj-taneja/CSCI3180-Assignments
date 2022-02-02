#include<stdio.h>
#include<stdlib.h>
#include<string.h>

#define MASTER_FILE_PATH    "master.txt"
#define TRANS711_FILE_PATH  "trans711.txt"
#define TRANS713_FILE_PATH  "trans713.txt"

#define NAME_SIZE          20
#define ACC_SIZE           16
#define PWD_SIZE           6
#define BALANCE_SIZE       16
#define AMOUNT_SIZE        7
#define TIMESTAMP_SIZE     5
#define MAX_INPUT_SIZE     128
#define MASTER_LINE_SIZE   60

#define ATM_PROMPT         1
#define ACCOUNT_PROMPT     2
#define PASSWORD_PROMPT    3
#define SERVICE_PROMPT     4
#define TARGET_ACC_PROMPT  5
#define CONTINUE_PROMPT    6

#define DEPOSIT            0
#define WITHDRAWAL         1
#define TRANSFER           2

#define SUCCESS            0
#define FAILURE           -1

#define INVALID_INPUT      1
#define INCORRECT_ACC_PWD  2
#define NEG_BALANCE        3
#define TARGET_ACC_DNE     4
#define TRANSFER_SELF      5
#define INSUFF_BALANCE     6

typedef struct {
    char name[NAME_SIZE+1];
    char acc[ACC_SIZE+1];
    char pwd[PWD_SIZE+1];
    char balance[BALANCE_SIZE+1];
} MasterRecord;

void create_empty_files() {
    FILE* trans711 = fopen(TRANS711_FILE_PATH, "w");
    FILE* trans713 = fopen(TRANS713_FILE_PATH, "w");
    fclose(trans711);
    fclose(trans713);
}

void print_welcome_msg() {
    printf("##############################################\n");
    printf("##         Gringotts Wizarding Bank         ##\n");
    printf("##                 Welcome                  ##\n");
    printf("##############################################\n");
}

int handle_err(int err) {
    switch (err)
    {
    case INVALID_INPUT:
        printf("=> INVALID INPUT\n");
        break;
    
    case INCORRECT_ACC_PWD:
        printf("=> INCORRECT ACCOUNT/PASSWORD\n");
        break;
    
    case NEG_BALANCE:
        printf("=> NEGATIVE REMAINS TRANSACTION ABORT\n");
        break;
    
    case TARGET_ACC_DNE:
        printf("=> TARGET ACCOUNT DOES NOT EXIST\n");
        break;

    case TRANSFER_SELF:
        printf("=> YOU CANNOT TRANSFER TO YOURSELF\n");
        break;

    case INSUFF_BALANCE:
        printf("=> INSUFFICIENT BALANCE\n");
        break;
    }
    
    return err;
}

long long int to_int(char* balance_str) {
    long long int balance = 0;
    for (int i = 1; i < BALANCE_SIZE; i++) {
        int digit = (int) (balance_str[i] - '0');
        balance *= 10;
        balance += digit;
    }
    if (balance_str[0] == '-')
        balance *= -1;
    return balance;
}

char* format_to_string(long long int num, int size) {
    // initialize a null-terminated string of all 0's
    char* str = (char *) malloc(sizeof(char) * (size+1));
    memset(str, '0', size);
    str[size] = '\0';
    
    // fill the string from the end
    int idx = size-1;
    while (num > 0) {
        str[idx] = (char) ((num % 10) + '0');
        num /= 10;
        idx -= 1;
    }

    return str;
}

MasterRecord* construct_master_record(char *line) {
    MasterRecord* record = (MasterRecord *) malloc(sizeof(MasterRecord));
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
    strncpy(record->balance, line+pos, BALANCE_SIZE);
    record->balance[BALANCE_SIZE] = '\0';
    return record;
}

int authenticate_user(char* acc, char* pwd) {
    int ret;
    int found = 0;
    
    FILE *fp;
    fp = fopen(MASTER_FILE_PATH, "r");
    size_t line_size = MASTER_LINE_SIZE;
    char *line = (char *) malloc(sizeof(char) * line_size);
    
    if (fp) {
        while ((getline(&line, &line_size, fp) != -1) && !found) {
            MasterRecord* record = construct_master_record(line);
            if (strcmp(record->acc, acc) == 0 && strcmp(record->pwd, pwd) == 0) {
                if (record->balance[0] == '-')
                    ret = handle_err(NEG_BALANCE);
                else
                    ret = SUCCESS;
                found = 1;
            }
            free(record);
        }
        free(line);
        fclose(fp);
        if (!found)
            return handle_err(INCORRECT_ACC_PWD);
        return ret;
    } else {
        perror("master.txt");
        exit(1);
    }
}

int validate_target_acc(char* receiver, char* sender) {
    // check if receiver is same as sender
    if (strcmp(receiver, sender) == 0)
        return handle_err(TRANSFER_SELF);

    // check if receiver is registered
    int found = 0;
    
    FILE *fp;
    fp = fopen(MASTER_FILE_PATH, "r");
    size_t line_size = MASTER_LINE_SIZE;
    char *line = (char *) malloc(sizeof(char) * line_size);
    
    if (fp) {
        while ((getline(&line, &line_size, fp) != -1) && !found) {
            MasterRecord* record = construct_master_record(line);
            if (strcmp(record->acc, receiver) == 0)
                found = 1;
            free(record);
        }
        free(line);
        fclose(fp);
        if (!found)
            return handle_err(TARGET_ACC_DNE);
        return SUCCESS;
    } else {
        perror("master.txt");
        exit(1);
    }
}

int check_balance(long long int amount, char* acc) {
    int ret;
    int found = 0;

    FILE *fp;
    fp = fopen(MASTER_FILE_PATH, "r");
    size_t line_size = MASTER_LINE_SIZE;
    char *line = (char *) malloc(sizeof(char) * line_size);
    
    if (fp) {
        while ((getline(&line, &line_size, fp) != -1) && !found) {
            MasterRecord* record = construct_master_record(line);
            if (strcmp(record->acc, acc) == 0) {
                found = 1;
                double balance = to_int(record->balance);
                if (amount > balance)
                    ret = FAILURE;
                else
                    ret = SUCCESS;
            }
            free(record);
        }
        free(line);
        fclose(fp);
        return ret;
    } else {
        perror("master.txt");
        exit(1);
    }
}

int validate_input(char* input, int prompt_id) {
    switch (prompt_id)
    {
    case ATM_PROMPT:
        if (!(strcmp(input, "1") == 0 || strcmp(input, "2") == 0))
            return handle_err(INVALID_INPUT);
        break;
    
    case SERVICE_PROMPT:
        if (!(strcmp(input, "W") == 0 || strcmp(input, "D") == 0 || strcmp(input, "T") == 0))
            return handle_err(INVALID_INPUT);
        break;

    case CONTINUE_PROMPT:
        if ((strcmp(input, "N") == 0) || (strcmp(input, "n") == 0))
            return FAILURE;
        if (!((strcmp(input, "Y") == 0) || (strcmp(input, "y") == 0)))
            return handle_err(INVALID_INPUT);
    }
    
    return SUCCESS;
}

long long int get_amount() {
    double amount;
    printf("=> AMOUNT\n");
    scanf("%lf", &amount);
    return (long long int) (amount*100);
}

int validate_amount(long long int amount, int service_code, char* acc) {
    switch (service_code)
    {
    case DEPOSIT:
        if (amount < 0)
            return handle_err(INVALID_INPUT);
        break;
    
    case TRANSFER:
    case WITHDRAWAL:
        if (amount < 0)
            return handle_err(INVALID_INPUT);
        if (check_balance(amount, acc) != SUCCESS)
            return handle_err(INSUFF_BALANCE);
        break;
    }
    
    return SUCCESS;
}

char* prompt_user(int prompt_id) {
    char* input = (char *) malloc(sizeof(char) * MAX_INPUT_SIZE);
    
    switch (prompt_id) {
    case ATM_PROMPT:
        printf("=> PLEASE CHOOSE THE ATM\n");
        printf("=> PRESS 1 FOR ATM 711\n");
        printf("=> PRESS 2 FOR ATM 713\n");
        break;
    
    case ACCOUNT_PROMPT:
        printf("=> ACCOUNT\n");
        break;
    
    case PASSWORD_PROMPT:
        printf("=> PASSWORD\n");
        break;
    
    case SERVICE_PROMPT:
        printf("=> PLEASE CHOOSE YOUR SERVICE\n");
        printf("=> PRESS D FOR DEPOSIT\n");
        printf("=> PRESS W FOR WITHDRAWAL\n");
        printf("=> PRESS T FOR TRANSFER\n");
        break;

    case TARGET_ACC_PROMPT:
        printf("=> TARGET ACCOUNT\n");
        break;
    
    case CONTINUE_PROMPT:
        printf("=> CONTINUE?\n");
        printf("=> N FOR NO\n");
        printf("=> Y FOR YES\n");
        break;
    }
    
    scanf("%s", input);
    return input;
}

int get_service_code(char* service) {
    if (strcmp(service, "D") == 0)
        return DEPOSIT;
    if (strcmp(service, "T") == 0)
        return TRANSFER;
    return WITHDRAWAL;
}

int handle_service(int service, char* atm, char* acc, int timestamp) {
    long long int amount;
    char *trans_filepath, *amount_str, *timestamp_str;
    
    // select the ATM's transactions file 
    if (strcmp(atm, "1") == 0)
        trans_filepath = TRANS711_FILE_PATH;
    else
        trans_filepath = TRANS713_FILE_PATH;

    timestamp_str = format_to_string(timestamp, TIMESTAMP_SIZE);
    
    if (service == DEPOSIT) {
        // get amount and validate it
        do {
            amount = get_amount();
        } while (validate_amount(amount, service, acc) != SUCCESS);
        
        // record the transaction
        FILE *fp = fopen(trans_filepath, "a");
        if (fp) {
            amount_str = format_to_string(amount, AMOUNT_SIZE);
            timestamp_str = format_to_string(timestamp, TIMESTAMP_SIZE);
            fprintf(fp, "%s%c%s%s\n", acc, 'D', amount_str, timestamp_str);
            fclose(fp);
        } else {
            perror(trans_filepath);
            exit(1);
        }
    } 
    
    else if (service == WITHDRAWAL) {
        // get amount and validate it
        do {
            amount = get_amount();
        } while (validate_amount(amount, service, acc) != SUCCESS);

        // record the transaction
        FILE *fp = fopen(trans_filepath, "a");
        if (fp) {
            amount_str = format_to_string(amount, AMOUNT_SIZE);
            fprintf(fp, "%s%c%s%s\n", acc, 'W', amount_str, timestamp_str);
            fclose(fp);
        } else {
            perror(trans_filepath);
            exit(1);
        }
    } 
    
    else if (service == TRANSFER) {
        char *target_acc;
        do {
            target_acc = prompt_user(TARGET_ACC_PROMPT);
        } while (validate_target_acc(target_acc, acc) != SUCCESS);

        do {
            amount = get_amount();
        } while (validate_amount(amount, service, acc) != SUCCESS);
        
        // record the transactions
        FILE *fp = fopen(trans_filepath, "a");
        if (fp) {
            amount_str = format_to_string(amount, AMOUNT_SIZE);
            
            // first record withdrawal from sender
            fprintf(fp, "%s%c%s%s\n", acc, 'W', amount_str, timestamp_str);
            
            // increment timestamp
            free(timestamp_str);
            timestamp_str = format_to_string(++timestamp, TIMESTAMP_SIZE);
            
            // then record deposit to receiver
            fprintf(fp, "%s%c%s%s\n", target_acc, 'D', amount_str, timestamp_str);
            
            fclose(fp);
        } else {
            perror(trans_filepath);
            exit(1);
        }
        free(target_acc);
    }
    
    free(amount_str);
    free(timestamp_str);

    return ++timestamp;
}

int main() {
    int auth_err = SUCCESS;
    int timestamp = 0;
    int service_code = 0;
    char *atm, *acc, *pwd, *service, *cont;
    
    create_empty_files();
    print_welcome_msg();
    do {
        do {
            atm = prompt_user(ATM_PROMPT);
        } while (validate_input(atm, ATM_PROMPT) != SUCCESS);
        
        do {
            acc = prompt_user(ACCOUNT_PROMPT);
            pwd = prompt_user(PASSWORD_PROMPT);
            auth_err = authenticate_user(acc, pwd);
        } while (auth_err == INCORRECT_ACC_PWD);
        
        if (auth_err == NEG_BALANCE)
            continue;
        
        do {
            service = prompt_user(SERVICE_PROMPT);
        } while (validate_input(service, SERVICE_PROMPT) != SUCCESS);
        
        // handle the requested service
        service_code = get_service_code(service);
        timestamp = handle_service(service_code, atm, acc, timestamp);

        // ask if user wants to continue
        do {
            cont = prompt_user(CONTINUE_PROMPT);
        } while (validate_input(cont, CONTINUE_PROMPT) == INVALID_INPUT);
        
        // free all the allocated memory
        free(atm);
        free(acc);
        free(pwd);
        free(service);
    } while (validate_input(cont, CONTINUE_PROMPT) == SUCCESS);
    
    free(cont);
    return 0;
}