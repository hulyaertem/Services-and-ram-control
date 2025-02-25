#!/bin/bash

# Log dosyasını scriptin bulunduğu dizine kaydet
LOG_FILE="$(dirname "$0")/ram_usage.log"
LOG_ROTATE_SIZE=10240 # Log dosyası boyutu limiti (KB)

# Mevcut tarihi al
CURRENT_DATE=$(date +"%Y-%m-%d %H:%M:%S")

# RAM kullanımı yüzdesini hesapla
TOTAL_RAM=$(free | awk '/^Mem:/ { print $2 }')
USED_RAM=$(free | awk '/^Mem:/ { print $3 }')
RAM_USAGE=$(( 100 * USED_RAM / TOTAL_RAM ))

# Adımları loglamak için kontrol başlangıcı
echo "$CURRENT_DATE - Script execution started." >> "$LOG_FILE"

# Log dosyası döndürme kontrolü
if [ -f "$LOG_FILE" ] && [ $(du -k "$LOG_FILE" | cut -f1) -gt "$LOG_ROTATE_SIZE" ]; then
    mv "$LOG_FILE" "$LOG_FILE.$(date +"%Y%m%d%H%M%S")"
    echo "$CURRENT_DATE - Log file rotated." > "$LOG_FILE"
fi

# RAM kontrolü ve servis restart işlemi
if [ "$RAM_USAGE" -gt 80 ]; then
    echo "$CURRENT_DATE - RAM usage is $RAM_USAGE%. Restarting pam-ssh.service." >> "$LOG_FILE"
    if systemctl restart pam-ssh.service; then
        echo "$CURRENT_DATE - pam-ssh.service restarted successfully." >> "$LOG_FILE"
    else
        echo "$CURRENT_DATE - Failed to restart pam-ssh.service." >> "$LOG_FILE"
    fi
else
    echo "$CURRENT_DATE - RAM usage is $RAM_USAGE%. No action required." >> "$LOG_FILE"
fi

# Script sonlandırma logu
echo "$CURRENT_DATE - Script execution finished." >> "$LOG_FILE"

