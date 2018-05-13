require 'mysql2'

SCHEDULER.every '1m', :first_in => 0 do |job|

  # Myql connection
  db = Mysql2::Client.new(:host => "localhost", :username => "buba", :password => "buba", :database => "van_solar" )

  # Mysql query
  ampsSql = "select load_amps, UNIX_TIMESTAMP(date) FROM load_amps WHERE date >= NOW() - INTERVAL 1 DAY"

  # Execute the query
  ampsResults = db.query(ampsSql)

  # Sending to List widget, so map to :label and :value
  ampItems = ampsResults.map do |row|
    row = {
      :x => row['UNIX_TIMESTAMP(date)'],
      :y => row['load_amps']
    }
  end

  # Update the List widget
  send_event('load_power', points: ampItems)

end
