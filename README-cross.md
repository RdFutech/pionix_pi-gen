# How to cross compile

Install cross compiler:
```bash
sudo apt-get install g++-arm-linux-gnueabihf
sudo apt-get install gcc-arm-linux-gnueabihf
sudo apt-get install binutils-arm-linux-gnueabihf
```

Export CC and CXX variables:
```bash
export CC=/usr/bin/arm-linux-gnueabihf-gcc
export CXX=/usr/bin/arm-linux-gnueabihf-g++
```

Build pi-gen normally:
```bash
sudo ./build.sh
```
