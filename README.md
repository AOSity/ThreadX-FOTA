# threadx-netxduo-fota
Learning ThreadX, planing to implement very basic Firmware-Over-The-Air (network, eth) mechanism

## Getting Started

Clone the repository:

```
git clone https://github.com/AOSity/threadx-netxduo-fota.git
cd threadx-netxduo-fota
git submodule update --init --recursive
```

## Adding New Target

To add your target follow these steps:
1. Create STM32CubeMX project, save .ioc file into `target/<target-name>`
2. In Project Manager:
    * Select Makefile for "Toolchain / IDE"
    * Check "Generate peripheral initialization as pair of '.c/.h' files per peripheral"
3. Save and click "Generate Code"
4. Add init_complete_handler into `target/<target-name>/Core/Src/main.c`, ref supported targets
5. Create `target/<target-name>/bootloader.ld` with FLASH ORIGIN = 0x08000000, LENGTH = 32K
6. Configure `target/<target-name>/STM32xxxxxx_FLASH.ld` FLASH ORIGIN = 0x08008000, LENGTH = half the memory minus 32K (for bootloader)
7. Create and Configure `target/<target-name>/target_config.cmake` ref supported targets
8. Add your target's OpenOCD config in `Makefile` TARGET_CFG_MAP define

## Build Rules

```bash
Build:
$ make [TARGET=] [PROJECT=]

Upload bootloader to device:
$ make TARGET=<target-name> PROJECT=boot flash

Upload firmware to device:
$ make TARGET=<target-name> PROJECT=app flash

Clean build directry:
$ make clean
```
