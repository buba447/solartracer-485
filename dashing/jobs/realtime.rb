require 'mysql2'

SCHEDULER.every '5s', :first_in => 0 do |job|

voltage = (`python /home/pi/coding/white_whale/jobs/getRegister.py 0x3104`).to_f
solarAmp = (`python /home/pi/coding/white_whale/jobs/getRegister.py 0x3101`).to_f
loadAmp = (`python /home/pi/coding/white_whale/jobs/getRegister.py 0x310D`).to_f
powerGen = (`python /home/pi/coding/white_whale/jobs/getRegister.py 0x330C`).to_f / 12.0
powerUsed = (`python /home/pi/coding/white_whale/jobs/getRegister.py 0x3304`).to_f / 12.0
# Update the List widget
send_event('battery_voltage', { value: voltage })
send_event('power_gen', { current: powerGen })
send_event('power_used', { current: powerUsed })
send_event('solar_amp', { current: solarAmp })
send_event('load_amp', { current: loadAmp })
end