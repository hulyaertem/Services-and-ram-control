#!/bin/bash

# Mevcut tarih bilgisi, günlük log dosyası için
LOG_DIR="$(dirname "$0")" # Log dosyalarının bulunduğu dizin
LOG_FILE="$LOG_DIR/ram_usage_$(date +"%Y%m%d").log" # Günlük log dosyası

# Servislerin listesi (isimler)
SERVICES=(
    "pam-auth.service"     # Auth-Service (Kimlik Doğrulama Servisi)
    "pam-daemon.service"   # pam-daemon (Daemon Servisi)
    "pam-gui.service"      # WebGUI Service (Web Arayüz Servisi)
    "pam-http.service"     # HTTP Proxy Service (HTTP Proxy Servisi)
    "pam-mobile.service"   # Netright Mobile (Mobil Servis)
    "pam-radius.service"   # Radius Service (RADIUS Kimlik Doğrulama Servisi)
    "pam-rdpgw.service"    # Guacamole Service (RDP Proxy Servisi)
    "pam-reporting.service" # Superset (Raporlama Servisi)
    "pam-sftp.service"     # SFTP Proxy Service (SFTP Proxy Servisi)
    "pam-sql.service"      # SQL Proxy Service (SQL Proxy Servisi)
    "pam-ssh.service"      # SSH Proxy Service (SSH Proxy Servisi)
    "pam-tacacs.service"   # TACACS Service (TACACS Kimlik Doğrulama Servisi)
    "pam-wdog.service"     # Watchdog Service (Sistem İzleme Servisi)
)

# Mevcut tarihi al
CURRENT_DATE=$(date +"%Y-%m-%d %H:%M:%S")

# RAM kullanımı yüzdesini hesapla
TOTAL_RAM=$(free | awk '/^Mem:/ { print $2 }')
USED_RAM=$(free | awk '/^Mem:/ { print $3 }')
RAM_USAGE=$(( 100 * USED_RAM / TOTAL_RAM ))

# Adımları loglamak için kontrol başlangıcı
echo "$CURRENT_DATE - Script execution started." >> "$LOG_FILE"

# RAM kontrolü ve servis restart işlemi
if [ "$RAM_USAGE" -gt 79 ]; then
    echo "$CURRENT_DATE - RAM usage is $RAM_USAGE%. Restarting services." >> "$LOG_FILE"
    for SERVICE in "${SERVICES[@]}"; do
        echo "$CURRENT_DATE - Attempting to restart $SERVICE..." >> "$LOG_FILE"
        if systemctl restart "$SERVICE"; then
            echo "$CURRENT_DATE - $SERVICE restarted successfully." >> "$LOG_FILE"
        else
            echo "$CURRENT_DATE - Failed to restart $SERVICE." >> "$LOG_FILE"
        fi
    done
else
    echo "$CURRENT_DATE - RAM usage is $RAM_USAGE%. No action required." >> "$LOG_FILE"
fi

# Script sonlandırma logu
echo "$CURRENT_DATE - Script execution finished." >> "$LOG_FILE"

