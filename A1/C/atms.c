#include<stdio.h>
#include<stdlib.h>
#include<string.h>

#define MASTER_FILE_PATH "../testcase/master.txt"

#define NAME_SIZE           20
#define ACC_SIZE            16
#define PWD_SIZE            6
#define BALANCE_SIZE        16
#define MAX_INPUT_SIZE      128
#define MASTER_LINE_SIZE    60

#define ATM_PROMPT         1
#define ACCOUNT_PROMPT     2
#define PASSWORD_PROMPT    3
#define SERVICE_PROMPT     4
#define AMOUNT_PROMPT      5
#define TARGET_PROMPT      6
#define CONTINUE_PROMPT    0

#define SUCCESS            0
#define INVALID_INPUT      1
#define INCORRECT_ACC_PWD  2
#define NEG_BALANCE        3
#define TARGET_ACC_DNE     4
#define TRANSFER_SELF      5
#define INSUFF_BALANCE     6
#define FILE_NOT_FOUND    -1

typedef struct {
    char name[NAME_SIZE+1];
    char acc[ACC_SIZE+1];
    char pwd[PWD_SIZE+1];
    char balance[BALANCE_SIZE+1];
} MasterRecord;

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
    case FILE_NOT_FOUND:
        printf("ERROR: Couldn't open the required file!\n");
        break;
    }
    
    return err;
}

MasterRecord* construct_master_record(char *line) {
    MasterRecord* record = (MasterRecord *) malloc(sizeof(MasterRecord));
    int pos = 0;
    strncpy(record->name, line, NAME_SIZE);
    pos += NAME_SIZE;
    strncpy(record->acc, line+pos, ACC_SIZE);
    pos += ACC_SIZE;
    strncpy(record->pwd, line+pos, PWD_SIZE);
    pos += PWD_SIZE;
    strncpy(record->balance, line+pos, BALANCE_SIZE);
    
    return record;
}

int authenticate_user(char* acc, char* pwd) {
    size_t num_chars;
    size_t line_size = MASTER_LINE_SIZE;
    int ret;
    int found = 0;
    char *line = (char *) malloc(sizeof(char) * line_size);
    FILE *fp;
    
    fp = fopen(MASTER_FILE_PATH, "r");
    
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
        perror("COULDN'T OPEN master.txt\n");
        exit(1);
    }
}

int validate_input(char* input, int prompt_id) {
    switch (prompt_id)
    {
    case ATM_PROMPT:
        if (!(strcmp(input, "1") == 0 || strcmp(input, "2") == 0)) {
            return handle_err(INVALID_INPUT);
        }
        break;
    }
    
    return SUCCESS;
}

char* prompt_user(int prompt_id) {
    char* input = (char *) malloc(sizeof(char) * MAX_INPUT_SIZE);
    switch (prompt_id) 
    {
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
    
    case AMOUNT_PROMPT:
        printf("=> AMOUNT\n");
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

int main() {
    print_welcome_msg();
    char *atm, *acc, *pwd;

    do {
        atm = prompt_user(ATM_PROMPT);
    } while (validate_input(atm, ATM_PROMPT) != SUCCESS);
    
    do {
        acc = prompt_user(ACCOUNT_PROMPT);
        pwd = prompt_user(PASSWORD_PROMPT);
    } while (authenticate_user(acc, pwd) != SUCCESS);
    
    free(atm);
    free(acc);
    free(pwd);
    return 0;
}