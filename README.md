C3PowerBenchmark
================
It's extremely easy to benchmark the battery life of a notebook, laptop, or tablet. However, it's much harder to answer the question: What is my standby battery life? C3PowerBenchmark was written to answer this very question.

Most people use their mobile devices in similar ways. Like your cellphone, no one turns on their computer and uses it from 100% to 0% battery life. Instead, you'll put the system to sleep until you need to use it later. The problem is that like your cellphone's standby mode, your computer consumes power when it's sleeping or in hiberation. 

C3PowerBenchmark is named after the C3 power state that the CPU enters when going to sleep or hibernation, and it's designed to benchmark the power consumption efficiency of Windows-based notebooks, tablets, and laptops.

This program follows a workflow process:

1. prompts user to select sleep or hibernate
2. queries and records battery information and current time stamp to csv file
3. sets wake timer for exactly 12 hours ahead
4. goes into user selected power saving mode
5. wakes up at set timer
6. queries and records battery information and current time stamp  to csv file

This process repeats 12 times (the scientific process demands reproducibility after all) or until you exit the program (using system tray icon). The csv information contains battery capacity at each time stamp. The amount of power consumed is the difference. As we know the voltage from the physical battery label and the standby duration (12 hours), we can calculate the amount of power consumed in watts during this time period, and even extrapolate total standby battery life with a high degree of precision.

## Background

This benchmark is another real-work application of my [BatteryUDF](../../../BatteryUDF/) and in some way a twist on [KuLogger](../../../KuLogger). As notebooks and mobile systems have become more affordable, concerns with battery life continue to come to the forefront of any purchase. No matter how cutting edge a system is advertised, there's only so much power that PC manufacturers can squeeze into their systems. It's a matter of simple physics. You have fixed volume of space to build a battery that must hold up to hundreds if not thousands of chargers.

This is why battery life benchmarks are so important, and will continue to be a valued metric for enterprise and general consumers. The problem is that most benchmarks represent a use case that's highly unrealistic. Typically, this involves leaving a computer on during a burn-in test with CPU stress tested till the battery dies. Putting aside that no real-life scenario involves 100% CPU usage, this also ignores the fact that most people use their notebooks, laptops, or tablets for a few hours the put the system to sleep. They'll move around. Go from class to class or meeting to meeting. Maybe they'll even forget to charge it as they are out and about. 

The point is that sleep/hibernation is now a common task to squeeze as much battery life out your system. The problem is that sleep, even hibernation, does not mean you're consumping battery life. The system exists in a sleep state (S3 or S4) consuming a little bit of power to keep information. The CPU is also in a sleep state (C3). What is this rate of power consumption? How long can I keep my system a sleep?

## Executable Requirements
* Windows XP/NT/2000/7/8
 * "Allow Sleep Timers" must be enabled in power management

## Requirements for Source
* AutoIt 3.3.x or later
* Required .au3 libs
  * [BatteryUDF](../../../BatteryUDF/)
  * getbattstatus

## License

Copyright Caleb Ku 2009. Distributed under the Apache 2.0 License. (See accompanying file LICENSE or copy at http://www.apache.org/licenses/LICENSE-2.0)
