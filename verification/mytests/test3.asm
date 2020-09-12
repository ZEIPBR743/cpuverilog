lbi r1, 2        // set r1
lbi r2, 3        // set r2
sub r3, r1, r2   // r3 = r2 - r1 = 1
addi r1, r3, 2  // r1 = r3 + 2 = 3
bltz r3, .label1 // branch if previous r1 greater than r2

sub r3, r1, r3   // r3 = r3 - r1 = -2
add r2, r2, r1  // r2 = 6
beqz r1, .label2 // branch if r1 is 0

.label1:
addi r2, r2, 1  // r2 = 7

.label2:
halt
