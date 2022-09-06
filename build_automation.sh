#!bin/bash


echo -e "[+] Build Automation Start\n"
echo -e "[+] Crypto Build Start\n"
cd /home/company/Crypto_v2.0/LINUX
make clean
make
make install
echo -e "[+] Crypto Build Finished\n"

echo -e "[+] Build CRYPTO-ENGINE Start\n"
cd /home/company/engine_v2/engine
make clean
make
echo -e "[+] Build CRYPTO-ENGINE Finished\n"
