#!/bin/bash

# Mevcut tarih bilgisi, günlük log dosyası için
LOG_DIR="$(dirname "$0")" # Log dosyalarının bulunduğu dizin
LOG_FILE="$LOG_DIR/ram_usage_$(date +"%Y%m%d").log" # Günlük log dosyası

# Mevcut tarihi al
CURRENT_DATE=$(date +"%Y-%m-%d %H:%M:%S")

# RAM kullanımı yüzdesini hesapla
TOTAL_RAM=$(free | awk '/^Mem:/ { print $2 }')
USED_RAM=$(free | awk '/^Mem:/ { print $3 }')
RAM_USAGE=$(( 100 * USED_RAM / TOTAL_RAM ))

# Adımları loglamak için kontrol başlangıcı
echo "$CURRENT_DATE - Script execution started." >> "$LOG_FILE"

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
