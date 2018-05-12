require 'mysql2'

SCHEDULER.every '1m', :first_in => 0 do |job|

  # Myql connection
  db = Mysql2::Client.new(:host => "localhost", :username => "buba", :password => "buba", :database => "van_solar" )

  # Mysql query
  voltageSql = "select solar_voltage, UNIX_TIMESTAMP(date) FROM solar_voltage WHERE date >= NOW() - INTERVAL 1 DAY"

  # Execute the query
  voltageResults = db.query(voltageSql)

  # Sending to List widget, so map to :label and :value
  voltageItems = voltageResults.map do |row|
    row = {
      :x => row['date'],
      :y => row['solar_voltage']
    }
  end

  # Mysql query
  ampsSql = "select solar_amps, UNIX_TIMESTAMP(date) FROM solar_amps WHERE date >= NOW() - INTERVAL 1 DAY"

  # Execute the query
  ampsResults = db.query(ampsSql)

  # Sending to List widget, so map to :label and :value
  ampItems = ampsResults.map do |row|
    row = {
      :x => row['date'],
      :y => row['solar_amps']
    }
  end

  series = [
    {
        name: "Volts",
        data: voltageItems
    },
    {
        name: "Amps",
        data: ampItems
    }
  ]

  # Update the List widget
  send_event('pv_power', points: [points1, points2])

end
