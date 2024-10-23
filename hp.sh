#!/bin/bash

# Define the new data to be written in hex format
DATA=(
    "03" "04" "07" "00" "00" "00" "02" "12"
    "10" "01" "01" "01" "0D" "00" "0A" "64"
    "37" "37" "00" "00" "45" "6D" "63" "6F"
    "72" "65" "20" "43" "6F" "72" "70" "2E"
    "20" "20" "20" "20" "00" "00" "0D" "C4"
    "54" "58" "4E" "32" "32" "31" "32" "30"
    "30" "30" "30" "30" "30" "35" "20" "20"
    "20" "20" "20" "05" "1E" "00" "B5"
    "00" "1A" "69" "50" "43" "4E" "30" "31"
    "30" "45" "4C" "31" "49" "45" "20" "20"
    "20" "20" "20" "20" "31" "30" "30" "33"
    "30" "35" "20" "20" "00" "00" "00" "6E"
    "FF" "FF" "FF" "FF" "FF" "FF" "FF" "FF"
    "4A" "34" "38" "35" "39" "43" "20" "31"
    "39" "39" "30" "2D" "33" "36" "37" "37"
    "FF" "FF" "FF" "FF" "A6" "60" "9E" "10"
    "FF" "48" "50" "20" "50" "72" "6F" "43"
    "75" "72" "76" "65" "20" "50" "72" "6F"
    "70" "72" "69" "65" "74" "61" "72" "79"
    "20" "54" "65" "63" "68" "6E" "6F" "6C"
    "6F" "67" "79" "20" "2D" "20" "55" "73"
    "65" "20" "69" "6D" "70" "6C" "69" "65"
    "73" "20" "61" "63" "63" "65" "70" "74"
    "61" "6E" "63" "65" "20" "6F" "66" "20"
    "6C" "69" "63" "65" "6E" "73" "69" "6E"
    "67" "20" "74" "65" "72" "6D" "73" "20"
    "48" "50" "31" "30" "30" "30" "4C" "58"
    "20" "20" "20" "20" "FF" "FF" "FF" "FF"
    "FF" "FF" "FF" "FF" "FF" "FF" "FF" "FF"
    "FF" "FF" "FF" "FF" "FF" "FF" "FF" "FF"
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
