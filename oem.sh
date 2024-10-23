#!/bin/bash

# Define the new data to be written in hex format
DATA=(
    "03" "04" "07" "10" "00" "00" "00" "00"
    "00" "00" "00" "06" "67" "00" "00" "00"
    "08" "03" "00" "1e" "46" "49" "4e" "49"
    "53" "41" "52" "20" "43" "4f" "52" "50"
    "2e" "20" "20" "20" "00" "00" "90" "65"
    "46" "54" "4c" "58" "38" "35" "37" "34"
    "44" "33" "42" "43" "4c" "20" "20" "20"
    "41" "20" "20" "20" "03" "52" "00" "4b"
    "00" "1a" "00" "00" "4e" "36" "46" "44"
    "54" "42" "4d" "20" "20" "20" "20" "20"
    "20" "20" "20" "32" "31" "31" "30" "31"
    "39" "20" "20" "68" "f0" "05" "f6"
)

# Total number of addresses to write (0x00 to 0xFF = 256)
TOTAL_ADDRESSES=256

# Unlocking module
echo "Unlocking module"
./myunlock.sh
sleep 1

# Write data to the specified addresses
start_addr=0
echo "Writing data"
for value in "${DATA[@]}"; do
    i2cset -y 1 0x50 0x$(printf "%02x" ${start_addr}) 0x$value
    sleep 0.05
    start_addr=$((start_addr + 1))
done

# Write 00 to remaining addresses
for (( ; start_addr < TOTAL_ADDRESSES; start_addr++ )); do
    i2cset -y 1 0x50 0x$(printf "%02x" ${start_addr}) 0x00
    sleep 0.05
done
