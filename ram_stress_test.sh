#!/bin/bash

# RAM kullanımını artırmak için parametre
ALLOCATE_MB=8000  # MB cinsinden kullanılacak RAM miktarı (örneğin 8000 MB = 8 GB)
declare -a RAM_FILLER  # RAM doldurmak için bir dizi tanımla

echo "RAM Yükseltme başlatılıyor: ${ALLOCATE_MB} MB"
for ((i=0; i<$ALLOCATE_MB; i++)); do
    RAM_FILLER[$i]=$(yes | head -c 1048576)  # 1 MB veriyi RAM'e doldur
    echo "$((i + 1)) MB RAM kullanıldı"
done

echo "RAM kullanımını artırma tamamlandı. RAM şu anda kullanılıyor..."
echo "RAM kullanımı durdurmak için Ctrl+C'ye basabilirsiniz."
sleep infinity
