# Tutorial testnet Chainflip Airdrop Finder

<p style="font-size:14px" align="right">
<a href="https://t.me/airdropfind" target="_blank">Join Telegram Airdrop Finder<img src="https://user-images.githubusercontent.com/50621007/183283867-56b4d69f-bc6e-4939-b00a-72aa019d1aea.png" width="30"/></a>
</p>

<p align="center">
  <img height="auto" width="auto" src="https://raw.githubusercontent.com/bayy420-999/airdropfind/main/NavIcon.png">
</p>

## Referensi

[Dokumen resmi](https://docs.chainflip.io/perseverance-validator-documentation/)

[Validator auction](https://stake-perseverance.chainflip.io/auctions)

[Server Discord Chainflip](https://discord.gg/FdZTa9FPQn)

[Vanity ETH](https://vanity-eth.tk/)

[Goerli faucet](https://goerlifaucet.com)

[Goerli RPC](https://alchemy.com/?r=44b9e90dc6860958)

## Persyaratan hardware & software

### Persyaratan hardware

| Komponen | Spesifikasi minimal |
|----------|---------------------|
|CPU|4 Cores|
|RAM|32 GB DDR4 RAM|
|Penyimpanan|1 TB HDD|
|Koneksi|10Mbit/s port|

| Komponen | Spesifikasi rekomendasi |
|----------|---------------------|
|CPU|32 Cores|
|RAM|32 GB DDR4 RAM|
|Penyimpanan|2 x 1 TB NVMe SSD|
|Koneksi|1 Gbit/s port|

### Persyaratan software/OS

| Komponen | Spesifikasi minimal |
|----------|---------------------|
|Sistem Operasi|Ubuntu 16.04|

| Komponen | Spesifikasi rekomendasi |
|----------|---------------------|
|Sistem Operasi|Ubuntu 20.04|

> Untuk node kali ini, kita tidak meng-compile sendiri programnya melainkan menggunakan binary yang sudah disediakan dev, maka kita disarankan menggunakan Ubuntu 20.04 karena dev meng-compile programnya menggunakan Ubuntu 20.04 tetapi admin telah mencoba menggunakan Ubuntu 22.04 dan work

## Persyaratan tambahan

Sebelum melanjutkan ke langkah selanjutnya pastikan anda telah melengkapi persyaratan-persyaratan berikut:
* Dompet ETH
* Goerli RPC
* tFlip Token

### Dompet ETH

Dalam menjalankan testnet node, anda tidak disarankan untuk menggunakan akun ETH ber-asset. Anda disarankan untuk membuat akun ETH baru.

Anda dapat membuat dompet ETH di Metamask atau website lain seperti [Vanity ETH](https://vanity-eth.tk/). Lalu simpan private key dompet baru anda.

Selain itu, pastikan dompet anda memiliki setidaknya 0.1 gETH (goerli ETH). Anda bisa mendapatkannya dengan mengklaim faucet di [disini](https://goerlifaucet.com/)

### Goerli RPC

Anda memerlukan Goerli RPC untuk menjalankan node, Anda bisa membuatnya [disini](https://alchemy.com/?r=44b9e90dc6860958).

* Registrasi di alchemy
* Pilih `CREATE APP`
* Isi Name dan Description
* Di bagian CHAIN ganti CHAIN menjadi GOERLI
* Klik `CREATE APP`
* Setelah itu cari App yang anda buat tadi 
* Pilih `VIEW DETAILS`
* Pilih `VIEW KEY`
* Salin HTTPS dan Websocket

### tFlip Token

tFlip Token dibutuhkan untuk delegasi dan memenangkan slot validator. Jika anda mendapatkan slot validator, maka validator anda akan dimasukan `active list`

Minimal stake untuk mendapatkan slot validator akan berubah setiap saat, anda bisa mengecek minimal stake [disini](https://stake-perseverance.chainflip.io/)

Untuk mendapatkan tFlip Token anda dapat mengikuti langkah-langkah dibawah:

* Join Discord [Chainflip](https://discord.gg/FdZTa9FPQn)
* Pergi ke 🚰|faucet 
* Kirim chat `!drip <ADDRESS_ETH>`

## Setup

Terdapat dua cara untuk setup node Chainflip yaitu setup secara otomatis dan setup secara manual

### Setup otomatis

* Unduh script

```console
wget https://raw.githubusercontent.com/bayy420-999/Tutorial-testnet-Chainflip-Airdrop-Finder/main/run.sh
```

* Ubah permission menjadi executable

```console
chmod +x run.sh
```

* Jalankan script

```console
./run.sh
```

Lalu isi informasi yang diperlukan

### Setup manual

* Tambahkan repositori Chainflip

```console
sudo mkdir -p /etc/apt/keyrings
curl -fsSL repo.chainflip.io/keys/gpg | sudo gpg --dearmor -o /etc/apt/keyrings/chainflip.gpg
```

* Verifikasi Chainflip GPG Key

```console
gpg --show-keys /etc/apt/keyrings/chainflip.gpg
```

Pastikan anda melihat output seperti ini

```console
pub   rsa3072 2022-11-08 [SC] [expires: 2024-11-07]
      BDBC3CF58F623694CD9E3F5CFB3E88547C6B47C6
uid                      Chainflip Labs GmbH <dev@chainflip.io>
sub   rsa3072 2022-11-08 [E] [expires: 2024-11-07]
```

* Tambahkan repositori Chainflip ke daftar sumber

```console
echo "deb [signed-by=/etc/apt/keyrings/chainflip.gpg] https://repo.chainflip.io/perseverance/ focal main" | sudo tee /etc/apt/sources.list.d/chainflip.list
```

* Pasang paket Chainflip

```console
sudo apt-get update
sudo apt-get install -y chainflip-cli chainflip-node chainflip-engine
```

* Impor dompet ETH

```console
echo -n "YOUR_VALIDATOR_WALLET_PRIVATE_KEY" |  sudo tee /etc/chainflip/keys/ethereum_key_file
```

> Ganti `YOUR_VALIDATOR_WALLET_PRIVATE_KEY` dengan private key anda
> Jika ada `0x` di private key anda, maka hapus `0x`

* Buat Signing Keys

```console
chainflip-node key generate >> sign_key.txt
```

Cek apakah Signing Keys sudah tersimpan

```console
cat sign_key.txt
```

* Setting Secret Seed

Jalankan perintah berikut dan masukan Secret Seed anda

```console
SECRET_SEED=<MASUKAN_SECRET_SEED_TADI>
```
Lalu jalankan perintah

```console
echo -n "${SECRET_SEED:2}" | sudo tee /etc/chainflip/keys/signing_key_file
```

* Buat Node Key

```console
sudo chainflip-node key generate-node-key --file /etc/chainflip/keys/node_key_file
```

Lalu cek Node Key anda

```console
cat /etc/chainflip/keys/node_key_file
```

* Buat file konfigurasi

```console
sudo mkdir -p /etc/chainflip/config
sudo nano /etc/chainflip/config/Default.toml
```

Salin text dibawah:

```console
# Default configurations for the CFE
[node_p2p]
node_key_file = "/etc/chainflip/keys/node_key_file"
ip_address="IP_ADDRESS_OF_YOUR_NODE"
port = "8078"

[state_chain]
ws_endpoint = "ws://127.0.0.1:9944"
signing_key_file = "/etc/chainflip/keys/signing_key_file"

[eth]
# Ethereum RPC endpoints (websocket and http for redundancy).
ws_node_endpoint = "WSS_ENDPOINT_FROM_ETHEREUM_CLIENT"
http_node_endpoint = "HTTPS_ENDPOINT_FROM_ETHEREUM_CLIENT"

# Ethereum private key file path. This file should contain a hex-encoded private key.
private_key_file = "/etc/chainflip/keys/ethereum_key_file"

[signing]
db_file = "/etc/chainflip/data.db"
```

Ganti variabel berikut

| Variabel | Keterangan |
|----------|------------|
|ip_address|Ganti dengan IP Address VPS anda (yang dipake login VPS)|
|ws_node_endpoint|Ganti dengan Websicket node endpoint anda (yang tadi bikin)|
|http_node_endpoint|Ganti dengan HTTP node endpoint anda (yang tadi bikin)|

Lalu pencet <kbd>CTRL</kbd>+<kbd>x</kbd>+<kbd>y</kbd> untuk menyimpan file

Setup manual selesai, anda dapat melanjutkan langkah berikutnya untuk menjalankan node

## Jalankan node

* Jalankan node

```console
sudo systemctl start chainflip-node
```

* Cek status node

```console
sudo systemctl status chainflip-node
```

* Cek log

```console
tail -f /var/log/chainflip-node.log
```

> Jika log sudah seperti ini `💤 Idle (15 peers), best: #3578 (0xcf9a…d842), finalized #3576 (0x6a0e…03fe), ⬇ 27.0kiB/s ⬆ 25.5kiB/s 
✨ Imported #3579 (0xa931…c03e)`  anda  dapat melanjutkan langkah selanjutnya

* Jalankan chainflip-engine

```console
sudo systemctl start chainflip-engine
```

* Cek status chainflip-engine

```console
sudo systemctl status chainflip-engine
```

* Mulai ulang chainflip-node & chainflip-engine

```console
sudo systemctl enable chainflip-node
sudo systemctl enable chainflip-engine
```

* Cek log chainflip-engine

```console
tail -f /var/log/chainflip-engine.log
```

## Stake

Sebelum melanjutkan ke langkah berikutnya, pastikan anda telah memiliki tFlip Token

Ikuti langkah-langkah berikut untuk staking tFlip Token:

* Pergi ke [Perseverance Staking App](https://stake-perseverance.chainflip.io/)
* Pilih `My nodes`
* Pilih `+ Add node` 
* Pilih `Register new node`
* Masukan `Public key (SS58)` dan jumlah tFlip Token yang ingin di-stake, lalu pencet `Stake`
* Konfirmasi transaksi di Metamask

Setelah itu mulai ulang chainflip-engine

```console
sudo systemctl restart chainflip-engine
```

> Jika anda membuka website `Perseverance Staking App` menggunakan hp, pastikan anda menggunakan Desktop mode untuk melihat menu `My nodes`
> Jika anda mengikuti tutorial ini dari awal, anda dapat mencari `Public key (SS58)` di file `sign_key.txt`


## Daftarkan Validator key

Sebelum mendaftarkan Validator key, pastikan node anda telah tersinkronisasi penuh, lalu jalankan perintah dibawah:

```console
sudo chainflip-cli \
      --config-path /etc/chainflip/config/Default.toml \
      register-account-role Validator
```

> Setelah menjalankan perintah diatas, tunggu sampe validator key anda terdaftar. Proses ini dapat memakan waktu beberapa saat

Setelah itu aktifkan validator agar bisa mengikuti auction selanjutnya, jalankan perintah berikut:

```console
sudo chainflip-cli \
    --config-path /etc/chainflip/config/Default.toml \
    activate
```

Terakhir putar validator key anda dengan menggunakan perintah berikut:

```console
sudo chainflip-cli \
    --config-path /etc/chainflip/config/Default.toml rotate
```

(OPSIONAL) anda dapat mengkostumisasi nama validator anda menggunakan perintah berikut:

```console
sudo chainflip-cli \
    --config-path /etc/chainflip/config/Default.toml \
    vanity-name <NAMA_BARU_VALIDATOR_ANDA>
```

## Menghentikan validator

Jika anda ingin berhenti menjadi validator, anda bisa menggunakan perintah berikut:

```console
sudo chainflip-cli \
    --config-path /etc/chainflip/config/Default.toml \
    retire
```

> Setelah menjalankan perintah diatas, anda akan berhenti mengikuti validator auction

Lalu tarik tFlip Token anda

```console
sudo chainflip-cli \
    --config-path /etc/chainflip/config/Default.toml \
    claim <JUMLAH_TFLIP_TOKEN_YANG_INGIN_DITARIK> <ADDRESS_ETH_UNTUK_MENERIMA_TOKEN>
```

> Jangan lupa untuk memasukan jumlah tFlip Token yang ingin ditarik dan mengganti address ETH

## Perintah berguna

### Menjalankan service

* Menjalankan service chainflip-node

```console
sudo systemctl start chainflip-node
```

* Menjalankan service chainflip-engine

```console
sudo systemctl start chainflip-engine
```

### Memulai ulang service

* Memulai ulang service chainflip-node

```console
sudo systemctl restart chainflip-node
```

* Memulai ulang service chainflip-engine

```console
sudo systemctl restart chainflip-engine
```

### Menghentikan service

* Menghentikan service chainflip-node

```console
sudo systemctl stop chainflip-node
```

* Menghentikan service chainflip-engine

```console
sudo systemctl stop chainflip-engine
```

### Cek log

* Cek log chainflip-node

```console
tail -f /var/log/chainflip-node.log
```

* Cek log chainflip-engine

```console
tail -f /var/log/chainflip-engine.log
```

## Troubleshoot

Nanti aja