require 'mysql2'

SCHEDULER.every '1m', :first_in => 0 do |job|

  # Myql connection
  db = Mysql2::Client.new(:host => "localhost", :username => "buba", :password => "buba", :database => "van_solar" )

  # Mysql query
  sql = "select solar_voltage, UNIX_TIMESTAMP(date) FROM solar_voltage WHERE date >= NOW() - INTERVAL 1 DAY"

  # Execute the query
  results = db.query(sql)
  puts results

  # Sending to List widget, so map to :label and :value
  voltageItems = results.map do |row|
    row = {
      :x => row['date'],
      :y => row['solar_voltage']
    }
  end

  # Update the List widget
  send_event(:solar_voltage, points: voltageItems)

end

# def data_with_minmax(nested_array)
#   out = nested_array.first[:datapoints].collect {|ind| ind[0]}.minmax
#   {series: nested_array, min: out[0]-1, max: out[1]+1 }
# end

# send_event("open_tickets"  , data_with_minmax(graphite_data) )