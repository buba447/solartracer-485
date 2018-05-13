require 'mysql2'

SCHEDULER.every '1m', :first_in => 0 do |job|

  # Myql connection
  db = Mysql2::Client.new(:host => "localhost", :username => "buba", :password => "buba", :database => "van_solar" )

  # Mysql query
  voltageSql = "select battery_voltage, UNIX_TIMESTAMP(date) FROM battery_voltage WHERE date >= NOW() - INTERVAL 1 DAY"

  # Execute the query
  voltageResults = db.query(voltageSql)

  # Sending to List widget, so map to :label and :value
  voltageItems = voltageResults.map do |row|
    row = {
      :x => row['UNIX_TIMESTAMP(date)'],
      :y => row['battery_voltage']
    }
  end

  # Mysql query
  ampsSql = "select battery_amps, UNIX_TIMESTAMP(date) FROM battery_amps WHERE date >= NOW() - INTERVAL 1 DAY"

  # Execute the query
  ampsResults = db.query(ampsSql)

  # Sending to List widget, so map to :label and :value
  ampItems = ampsResults.map do |row|
    row = {
      :x => row['UNIX_TIMESTAMP(date)'],
      :y => row['battery_amps']
    }
  end

  # Update the List widget
  send_event('bat_power', points: [voltageItems, ampItems])

end
