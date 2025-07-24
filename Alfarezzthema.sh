#!/bin/bash

set -e

echo "📦 [1/10] Memulai install tema Jexactyl..."

# ========================================
# OPTIONAL: Setup akses mysql otomatis
# ========================================
echo "🔐 [2/10] Cek akses root MySQL..."
read -s -p "Masukkan password MySQL root (tekan Enter jika tidak ada): " MYSQL_PW
echo ""

# Buat file ~/.my.cnf agar perintah mysql/mysqldump tidak minta password
echo "[client]" > ~/.my.cnf
echo "user=root" >> ~/.my.cnf
echo "password=${MYSQL_PW}" >> ~/.my.cnf
chmod 600 ~/.my.cnf

# ========================================
# Backup data
# ========================================
echo "🗄️ [3/10] Backup panel & database..."
cp -r /var/www/pterodactyl /var/www/pterodactyl-backup
if mysqldump panel > /var/www/pterodactyl-backup/panel.sql; then
    echo "✅ Backup database berhasil."
else
    echo "⚠️  Gagal backup database. Pastikan nama database = 'panel' dan password benar."
    rm -f ~/.my.cnf
    exit 1
fi

# ========================================
# Maintenance mode
# ========================================
echo "🔧 [4/10] Menonaktifkan panel..."
cd /var/www/pterodactyl || { echo "❌ Direktori tidak ditemukan!"; rm -f ~/.my.cnf; exit 1; }
php artisan down

# ========================================
# Download & pasang tema Jexactyl
# ========================================
echo "🌐 [5/10] Mengunduh tema Jexactyl..."
curl -L -o panel.tar.gz https://github.com/jexactyl/jexactyl/releases/latest/download/panel.tar.gz
tar -xzvf panel.tar.gz && rm -f panel.tar.gz
chmod -R 755 storage/* bootstrap/cache

# ========================================
# Update composer
# ========================================
echo "📦 [6/10] Install dependensi..."
if ! command -v composer &> /dev/null; then
    echo "⚙️  Composer tidak ditemukan. Mengunduh..."
    curl -sS https://getcomposer.org/installer | php
    mv composer.phar /usr/local/bin/composer
fi
composer require asbiin/laravel-webauthn
composer install --no-dev --optimize-autoloader

# ========================================
# Bersihkan cache
# ========================================
echo "🧹 [7/10] Clear cache..."
php artisan optimize:clear

# ========================================
# Migrasi database
# ========================================
echo "📂 [8/10] Migrasi database..."
php artisan migrate --seed --force

# ========================================
# Permission + queue
# ========================================
echo "🔐 [9/10] Set permission & restart queue..."
chown -R www-data:www-data /var/www/pterodactyl/*
php artisan queue:restart

# ========================================
# Onlinekan kembali
# ========================================
echo "✅ [10/10] Menyalakan panel kembali..."
php artisan up

# ========================================
# Hapus file .my.cnf demi keamanan
# ========================================
echo "🧹 Menghapus file .my.cnf untuk keamanan..."
rm -f ~/.my.cnf

echo ""
echo "🎉 Selesai! Tema Jexactyl berhasil terpasang dengan aman."
