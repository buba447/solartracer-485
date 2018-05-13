require 'mysql2'

SCHEDULER.every '1m', :first_in => 0 do |job|

  # Myql connection
  db = Mysql2::Client.new(:host => "localhost", :username => "buba", :password => "buba", :database => "van_solar" )

  # Mysql query
  sql = "select daily_kw_generated, UNIX_TIMESTAMP(date) FROM daily_kw_generated WHERE date >= NOW() - INTERVAL 1 DAY"

  # Execute the query
  results = db.query(sql)

  # tempItems to List widget, so map to :label and :value
  items = results.map do |row|
    ampH = row['daily_kw_generated'] / 12.0
    row = {
      :x => row['UNIX_TIMESTAMP(date)'],
      :y => ampH
    }
  end

  # Update the List widget
  send_event('power_gen', points: items)

end
