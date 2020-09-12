// Next instruction needs to stall to wait for jr
// jr has to complete the EX stage to get the next PC
lbi r1, 2  // load 2 into r1
lbi r3, 4  // load 4 into r3
lbi r2, 1  // load 1 into r2
jr r1, 8   // jump to PC = 0x000a
// the next instruction should not be fetched until jr finishes its EX stage
// skip the add instruction
add r3, r1, r3
sub r1, r2, r3  // expected r1 = 3
halt
