#!/usr/bin/python
import sys
import minimalmodbus

if len(sys.argv) == 1:
	print(0)
	sys.exit()

register = sys.argv[1]

instrument = minimalmodbus.Instrument('/dev/ttyXRUSB0', 1)
instrument.serial.baudrate = 115200
instrument.serial.bytesize = 8
instrument.serial.parity   = minimalmodbus.serial.PARITY_NONE
instrument.serial.stopbits = 1
instrument.serial.timeout  = 1.2
instrument.mode = minimalmodbus.MODE_RTU

try:
	reading = instrument.read_register(address, 2, 4)
	print(reading)
except IOError:
	print(0)
