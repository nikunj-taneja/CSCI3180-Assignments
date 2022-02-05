from doctest import master
import random
import string

lines = 10000
sample_name = "abcdefghijklmnopqrst"
master_base = ["A", 1111111111111111, 222222, "+000000000099999"]
timestamp = 0

txn_711 = open("trans711.txt", "w")
txn_713 = open("trans713.txt", "w")
updated = open("updatedMaster.txt", "w")

custom_in = open("custom.in", "w")

with open("master.txt", "w") as f:
    for i in range(lines):
        name = ''.join((random.choice(sample_name)) for x in range(20))  
        master_base[0] = name
        master_base[1] += 1
        master_base[2] += 1
        balance_before = random.randrange(-999999999999999, 999999999999999)
        amount = random.randrange(0, 9999999)
        val = str(abs(balance_before)).zfill(15)
        sign = '+' if balance_before >= 0 else '-'
        master_base[3] = sign+val
        if balance_before >= 0:
            txn = txn_711 if i%2 == 0 else txn_713
            print(f"{str(master_base[1])}W{str(amount).zfill(7)}{str(timestamp).zfill(5)}", file=txn, end="\r\n")
            timestamp += 1
            balance_after = balance_before - amount
            line = "".join([str(x) for x in master_base])
            updated_master = master_base.copy()
            if balance_after < 0:
                updated_master[3] = str(balance_after).zfill(16)
            else:
                updated_master[3] = '+' + str(balance_after).zfill(15)
            print("".join([str(x) for x in updated_master]), file=updated, end='\r\n')
        else:
            print("".join([str(x) for x in master_base]), file=updated, end='\r\n')
        line = "".join([str(x) for x in master_base])
        print(line, end='\r\n', file=f)

txn_711.close()
txn_713.close()