require 'mysql2'

SCHEDULER.every '1m', :first_in => 0 do |job|

  # Myql connection
  db = Mysql2::Client.new(:host => "localhost", :username => "buba", :password => "buba", :database => "van_solar" )

  # Mysql query
  sql = "select temperature, UNIX_TIMESTAMP(date) FROM temperature WHERE date >= NOW() - INTERVAL 1 DAY"

  # Execute the query
  results = db.query(sql)

  # tempItems to List widget, so map to :label and :value
  items = results.map do |row|
    row = {
      temp = (row['temperature'] * 9.0/5.0) + 32
      :x => row['UNIX_TIMESTAMP(date)'],
      :y => temp
    }
  end

  # Update the List widget
  send_event('bat_temp', points: items)

end
