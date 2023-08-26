# This script allows you to verify the registers internally. 
# Comment the registers that you don't want to look at
# Uncomment the registers that you want to look at (if they exists)

vsim work.TBREGISTERFILE(TEST) -t 10ps -voptargs=+acc

add wave -divider -height 30 "REGISTER FILE SIM"
add wave CLK
add wave RESET
add wave ENABLE
add wave RD1
add wave RD2
add wave WR
add wave CALL;
add wave SUB_RTN;
add wave sim:/tbregisterfile/RG/CANSAVE;
add wave sim:/tbregisterfile/RG/CANRESTORE;
add wave FILL;
add wave SPILL;
add wave -color blue ADD_WR
add wave -color blue ADD_RD1
add wave -color blue ADD_RD2
add wave -color white DATAIN
add wave -color white OUT1
add wave -color white OUT2
add wave -color white MEM_BUS;
add wave -color white MEM_BUSread;
add wave sim:/tbregisterfile/RG/CWP
add wave sim:/tbregisterfile/RG/SWP
add wave sim:/tbregisterfile/RG/i

add wave -divider -height 30 "INTERNAL REGISTERS"
add wave -position insertpoint  \
sim:/tbregisterfile/RG/REGISTERS(0) \
sim:/tbregisterfile/RG/REGISTERS(1) \
sim:/tbregisterfile/RG/REGISTERS(2) \
sim:/tbregisterfile/RG/REGISTERS(3) \
sim:/tbregisterfile/RG/REGISTERS(4) \
sim:/tbregisterfile/RG/REGISTERS(5) \
sim:/tbregisterfile/RG/REGISTERS(6) \
sim:/tbregisterfile/RG/REGISTERS(7) \
sim:/tbregisterfile/RG/REGISTERS(8) \
sim:/tbregisterfile/RG/REGISTERS(9) \
sim:/tbregisterfile/RG/REGISTERS(10) \
sim:/tbregisterfile/RG/REGISTERS(11) \
sim:/tbregisterfile/RG/REGISTERS(12) \
sim:/tbregisterfile/RG/REGISTERS(13) \
sim:/tbregisterfile/RG/REGISTERS(14) \
sim:/tbregisterfile/RG/REGISTERS(15) \
sim:/tbregisterfile/RG/REGISTERS(16) \
sim:/tbregisterfile/RG/REGISTERS(17) \
sim:/tbregisterfile/RG/REGISTERS(18) \
sim:/tbregisterfile/RG/REGISTERS(19) \
sim:/tbregisterfile/RG/REGISTERS(20) \
sim:/tbregisterfile/RG/REGISTERS(21) \
sim:/tbregisterfile/RG/REGISTERS(22) \
sim:/tbregisterfile/RG/REGISTERS(23) \
sim:/tbregisterfile/RG/REGISTERS(24) \
sim:/tbregisterfile/RG/REGISTERS(25) \
sim:/tbregisterfile/RG/REGISTERS(26) \
sim:/tbregisterfile/RG/REGISTERS(27) \
sim:/tbregisterfile/RG/REGISTERS(28) \
sim:/tbregisterfile/RG/REGISTERS(29) \
sim:/tbregisterfile/RG/REGISTERS(30) \
sim:/tbregisterfile/RG/REGISTERS(31)

# sim:/tbregisterfile/RG/REGISTERS(32) \
# sim:/tbregisterfile/RG/REGISTERS(33) \
# sim:/tbregisterfile/RG/REGISTERS(34) \
# sim:/tbregisterfile/RG/REGISTERS(35) \
# sim:/tbregisterfile/RG/REGISTERS(36) \
# sim:/tbregisterfile/RG/REGISTERS(37) \
# sim:/tbregisterfile/RG/REGISTERS(38) \
# sim:/tbregisterfile/RG/REGISTERS(39) \
# sim:/tbregisterfile/RG/REGISTERS(40) \
# sim:/tbregisterfile/RG/REGISTERS(41) \
# sim:/tbregisterfile/RG/REGISTERS(42) \
# sim:/tbregisterfile/RG/REGISTERS(43) \
# sim:/tbregisterfile/RG/REGISTERS(44) \
# sim:/tbregisterfile/RG/REGISTERS(45) \
# sim:/tbregisterfile/RG/REGISTERS(46) \
# sim:/tbregisterfile/RG/REGISTERS(47) \
# sim:/tbregisterfile/RG/REGISTERS(48) \
# sim:/tbregisterfile/RG/REGISTERS(49) \
# sim:/tbregisterfile/RG/REGISTERS(50) \
# sim:/tbregisterfile/RG/REGISTERS(51) \
# sim:/tbregisterfile/RG/REGISTERS(52) \
# sim:/tbregisterfile/RG/REGISTERS(53) \
# sim:/tbregisterfile/RG/REGISTERS(54) \
# sim:/tbregisterfile/RG/REGISTERS(55) \
# sim:/tbregisterfile/RG/REGISTERS(56) \
# sim:/tbregisterfile/RG/REGISTERS(57) \
# sim:/tbregisterfile/RG/REGISTERS(58) \
# sim:/tbregisterfile/RG/REGISTERS(59) \
# sim:/tbregisterfile/RG/REGISTERS(60) \
# sim:/tbregisterfile/RG/REGISTERS(61) \
# sim:/tbregisterfile/RG/REGISTERS(62) \
# sim:/tbregisterfile/RG/REGISTERS(63) \

run 300 ns

wave zoom full
radix hexadecimal
