#!/bin/bash

echo "📦 Memulai pemasangan tema Jexactyl untuk Pterodactyl..."

# Step 1: Backup Panel & Database
echo "🗄️ Membackup file panel dan database..."
cp -R /var/www/pterodactyl /var/www/pterodactyl-backup
mysqldump -u root -p panel > /var/www/pterodactyl-backup/panel.sql

# Step 2: Masuk ke direktori panel
cd /var/www/pterodactyl || exit

# Step 3: Maintenance mode (offline)
echo "⛔ Menonaktifkan panel sementara..."
php artisan down

# Step 4: Download & extract tema Jexactyl
echo "🌐 Mengunduh dan mengekstrak tema Jexactyl..."
curl -L -o panel.tar.gz https://github.com/jexactyl/jexactyl/releases/latest/download/panel.tar.gz
tar -xzvf panel.tar.gz && rm -f panel.tar.gz
chmod -R 755 storage/* bootstrap/cache

# Step 5: Update dependensi composer
echo "📦 Menginstall dependensi tambahan via composer..."
composer require asbiin/laravel-webauthn
composer install --no-dev --optimize-autoloader

# Step 6: Bersihkan cache
echo "🧹 Membersihkan cache..."
php artisan optimize:clear

# Step 7: Migrasi database
echo "🛠️ Menjalankan migrasi database..."
php artisan migrate --seed --force

# Step 8: Set permission ke web server
echo "🔐 Mengatur izin file..."
chown -R www-data:www-data /var/www/pterodactyl/*

# Step 9: Restart queue
echo "♻️ Merestart queue worker..."
php artisan queue:restart

# Step 10: Onlinekan kembali panel
echo "✅ Mengaktifkan kembali panel..."
php artisan up

echo "🎉 Selesai! Tema Jexactyl berhasil dipasang di panelmu."
