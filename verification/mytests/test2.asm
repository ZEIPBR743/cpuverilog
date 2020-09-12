lbi r1, 2        // set r1
lbi r2, 3        // set r2
slt r3, r1, r2   // compare r1 with r2. r3 should be 1
addi r1, r1, 1   // r1 = r1 + 1
beqz r3, .label1 // branch if r1 greater or equal to r2

slt r3, r1, r2   // compare r1 with r2. r3 should be 0

.label1:
halt