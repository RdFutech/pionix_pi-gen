# How to cross compile

Install cross compiler:
```bash
sudo apt-get install g++-arm-linux-gnueabihf
sudo apt-get install gcc-arm-linux-gnueabihf
sudo apt-get install binutils-arm-linux-gnueabihf
```

Build pi-gen sysroot:
```bash
sudo ./build-cross.sh
```

Now you should see a message like:
```
finished preparing sysroot located at /sysroot
please use the toolchain file located at /home/everest/pi-gen/work/belaybox/everest/toolchain.cmake like this:
cmake .. -DCMAKE_TOOLCHAIN_FILE=/home/everest/pi-gen/work/belaybox/everest/toolchain.cmake -DLIBLOG_CROSS_COMPILE=ON
```

Follow these instructions to cross-compile everest-core on your host machine.

If you want to build the whole image comment out the PIONIX_BUILD_SYSROOT variable in __./build-cross.sh__ like such:
```bash
# export PIONIX_BUILD_SYSROOT=1
```
