require 'mysql2'

SCHEDULER.every '5s', :first_in => 0 do |job|

voltage = exec("python ~/coding/white_whale/jobs/getRegister.py 0x3104")
solarAmp = exec("python ~/coding/white_whale/jobs/getRegister.py 0x3101")
loadAmp = exec("python ~/coding/white_whale/jobs/getRegister.py 0x310D")
powerGen = exec("python ~/coding/white_whale/jobs/getRegister.py 0x330C")
powerUsed = exec("python ~/coding/white_whale/jobs/getRegister.py 0x3304")

# Update the List widget
send_event('battery_voltage', { value: rand(15) })
send_event('power_gen', { current: rand(15) })
send_event('power_used', { current: rand(15) })
send_event('solar_amp', { current: rand(100) })
send_event('load_amp', { current: rand(100) })
end