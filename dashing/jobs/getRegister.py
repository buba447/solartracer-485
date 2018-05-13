#!/usr/bin/python
import sys
import minimalmodbus

def readRegister(register):
	try:
		instrument = minimalmodbus.Instrument('/dev/ttyXRUSB0', 1)
	except minimalmodbus.serial.SerialException:
		return 0

	instrument.serial.baudrate = 115200
	instrument.serial.bytesize = 8
	instrument.serial.parity   = minimalmodbus.serial.PARITY_NONE
	instrument.serial.stopbits = 1
	instrument.serial.timeout  = 1.2
	instrument.mode = minimalmodbus.MODE_RTU

	try:
		reading = instrument.read_register(int(register, 16), 2, 4)
		return reading
	except IOError:
		return 0

if len(sys.argv) == 1:
	print(0)
else :
	register = sys.argv[1]
	print readRegister(register)
