require 'mysql2'

SCHEDULER.every '5s', :first_in => 0 do |job|

  
  # Update the List widget
  send_event('battery_voltage', { value: rand(15) })
  send_event('solar_amp', { current: rand(100) })
  send_event('load_amp', { current: rand(100) })
end