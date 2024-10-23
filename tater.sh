#!/bin/bash

VENDOR="HACKSHACK-INC   "
SERIAL="8675309         "

# Calculate MD5 and CRC32 checksums
MD5SUM=$(echo -n "${VENDOR}${SERIAL}" | md5sum | awk '{print $1}')
CRC32=$(echo -n "${VENDOR}${SERIAL}" | cksfv -b | awk '{print $1}') # or use `crc32` if installed

echo "Unlocking module"
./myunlock.sh
sleep 1

# Write vendor
echo "Writing vendor"
writeaddr=20
for chr in $(printf "${VENDOR}" | xxd -p -c1); do
    i2cset -y 1 0x50 0x$(printf "%02x" ${writeaddr}) 0x$chr
    sleep 0.05
    writeaddr=$((writeaddr+1))
done

# Write serial
echo "Writing serial"
writeaddr=68
for chr in $(printf "${SERIAL}" | xxd -p -c1); do
    i2cset -y 1 0x50 0x$(printf "%02x" ${writeaddr}) 0x$chr
    sleep 0.05
    writeaddr=$((writeaddr+1))
done

# Write MD5 checksum
echo "Writing md5sum"
writeaddr=99
for chr in $(echo -n "${MD5SUM}" | sed -E 's/(.{2})/\1\n/g'); do
    i2cset -y 1 0x50 0x$(printf "%02x" ${writeaddr}) 0x$chr
    sleep 0.05
    writeaddr=$((writeaddr+1))
done

# Write CRC32 checksum
echo "Writing crc32"
writeaddr=124
for chr in $(echo -n "${CRC32}" | sed -E 's/(.{2})/\1\n/g'); do
    i2cset -y 1 0x50 0x$(printf "%02x" ${writeaddr}) 0x$chr
    sleep 0.05
    writeaddr=$((writeaddr+1))
done
