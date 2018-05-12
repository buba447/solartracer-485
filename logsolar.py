#!/usr/bin/env python
import minimalmodbus
import datetime
import MySQLdb as mdb

def readNumberAndSaveToTable(instrument, db, address, table):
	try:
   		reading = instrument.read_register(address, 2, 4)
   		print("Reading " + table + ": " + str(reading))
   		cursor = db.cursor()
		cursor.execute("INSERT INTO %s (%s, date) VALUES (%s, NOW())" % (table, table, reading))
		db.commit()
		print("Read Committed")
	except IOError:
		print("Failed to read from instrument")

def setupSQLTables(db):
	cursor = db.cursor()
	cursor.execute("CREATE TABLE IF NOT EXISTS daily_kw_generated (Id INT PRIMARY KEY AUTO_INCREMENT, daily_kw_generated FLOAT(5, 1), date DATETIME)")
	cursor.execute("CREATE TABLE IF NOT EXISTS daily_kw_used (Id INT PRIMARY KEY AUTO_INCREMENT, daily_kw_used FLOAT(5, 1), date DATETIME)")
	cursor.execute("CREATE TABLE IF NOT EXISTS solar_voltage (Id INT PRIMARY KEY AUTO_INCREMENT, solar_voltage FLOAT(4, 1), date DATETIME)")
	cursor.execute("CREATE TABLE IF NOT EXISTS battery_voltage (Id INT PRIMARY KEY AUTO_INCREMENT, battery_voltage FLOAT(4, 1), date DATETIME)")
	cursor.execute("CREATE TABLE IF NOT EXISTS solar_amps (Id INT PRIMARY KEY AUTO_INCREMENT, solar_amps FLOAT(4, 1), date DATETIME)")
	cursor.execute("CREATE TABLE IF NOT EXISTS battery_amps (Id INT PRIMARY KEY AUTO_INCREMENT, battery_amps FLOAT(4, 1), date DATETIME)")
	cursor.execute("CREATE TABLE IF NOT EXISTS load_amps (Id INT PRIMARY KEY AUTO_INCREMENT, load_amps FLOAT(4, 1), date DATETIME)")
	cursor.execute("CREATE TABLE IF NOT EXISTS temperature (Id INT PRIMARY KEY AUTO_INCREMENT, temperature FLOAT(4, 1), date DATETIME)")
	db.commit()
	print("TABLES CREATED")

instrument = minimalmodbus.Instrument('/dev/ttyXRUSB0', 1)
instrument.serial.baudrate = 115200
instrument.serial.bytesize = 8
instrument.serial.parity   = minimalmodbus.serial.PARITY_NONE
instrument.serial.stopbits = 1
instrument.serial.timeout  = 1.2
instrument.mode = minimalmodbus.MODE_RTU

con = mdb.connect('localhost', 'buba', 'buba', 'van_solar')

setupSQLTables(con)

#Read Solar Voltage
readNumberAndSaveToTable(instrument, con, 0x3100, "solar_voltage")

#Read Battery Voltage
readNumberAndSaveToTable(instrument, con, 0x3104, "battery_voltage")

#Read Solar Amps
readNumberAndSaveToTable(instrument, con, 0x3101, "solar_amps")

#Read Battery Amps
readNumberAndSaveToTable(instrument, con, 0x3105, "battery_amps")

#Read Battery Amps
readNumberAndSaveToTable(instrument, con, 0x310D, "load_amps")

#Read Battery Temperature
readNumberAndSaveToTable(instrument, con, 0x331E, "temperature")

#Read Daily Use
readNumberAndSaveToTable(instrument, con, 0x3304, "daily_kw_used")

#Read Daily Generated
readNumberAndSaveToTable(instrument, con, 0x330C, "daily_kw_generated")

print("FINISHED")
