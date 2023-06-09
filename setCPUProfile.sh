#!/bin/bash

# Name: setCPUProfile
# Description: Sets the scaling_governor value depending on current state and if there is a VM running.
#              This works with AMD RYZEN CPUs, Intel has different states the script could be modified
#              to use their states very easily.
#              https://wiki.archlinux.org/title/CPU_frequency_scaling#Scaling_governors
# Date: Aug 25, 2021
# Author: Jason McLeod
# Version: 1.0

isRunning=$(virsh list --state-running --name | grep -v '^$' | wc -l)
curState=$(cat /sys/devices/system/cpu/cpu0/cpufreq/scaling_governor)

if [ $isRunning -gt 0 ]; then
  echo "VMs are running"
  if ! [ "$curState" == "performance" ]; then
    echo "Enabling performance mode"
    for cpu in /sys/devices/system/cpu/cpu[0-9]*/cpufreq/scaling_governor; do echo "performance" > $cpu; done
  fi
else
  echo "VMs are stopped"
  if ! [ "$curState" == "powersave" ]; then
    echo "Enabling powersave mode"
    for cpu in /sys/devices/system/cpu/cpu[0-9]*/cpufreq/scaling_governor; do echo "powersave" > $cpu; done
  fi
fi
