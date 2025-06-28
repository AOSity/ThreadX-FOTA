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
4. Configure `target/<taget-name>/target_config.cmake`, ref supported targets
5. Add init_complete_handler into `target/<target-name>/Core/Src/main.c`, ref supported targets
6. Add your target's OpenOCD config in `Makefile` TARGET_CFG_MAP define
7. Build project with `make TARGET=<target-name>`
8. Flash project with `make flash TARGET=<target-name>`

## Build Rules

```bash
Build firmawe:
$ make [TARGET=]

Upload fimware to device:
$ make flash [TARGET=]

Clean build directry:
$ make clean
```
