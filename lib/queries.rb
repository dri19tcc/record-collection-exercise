require 'sqlite3'

class Query

  def initialize(dbname = "releases")
    @db = SQLite3::Database.new "database/#{dbname}.db"
    #this connects to the database
  end

  def count_releases
    rows = @db.execute("SELECT * FROM albums;")
    return rows.length
  end

  def artist_releases
    (@db.execute ("SELECT artist FROM albums;")).uniq.length
  end

  def oldest_release
    @db.get_first_row("SELECT title FROM albums WHERE released > 0 ORDER BY released;")
  end

  def recent_release
    @db.get_first_row("SELECT * FROM albums ORDER BY date_added DESC;")
  end

  def first_album
    @db.get_first_row("SELECT * FROM albums ORDER BY date_added;")
  end

  def year_2014
    @db.get_first_value("SELECT COUNT(*) FROM albums WHERE date_added LIKE ('2014%');")
  end

  def seventies
    row = @db.execute("SELECT * FROM albums WHERE released BETWEEN 1970 AND 1979 ")
    return row.length
  end
end

new_query = Query.new
answer_1 = new_query.count_releases
answer_2 = new_query.artist_releases
answer_3 = new_query.oldest_release
answer_4 = new_query.recent_release
answer_5 = new_query.first_album
answer_6 = new_query.year_2014
answer_7 = new_query.seventies

puts "Answer 1: There are #{answer_1} releases in the database."
puts "Answer 2: There are #{answer_2} unique artists in the database."
puts "Answer 3: The oldest release is #{answer_3}"
puts "Answer 4: The most recent release is #{answer_4}"
puts "Answer 5: The first album added was #{answer_5}"
puts "Answer 6: There were #{answer_6} albums added in 2014"
puts "Answer 7: There were #{answer_7} albums released in the seventies"










# Question 1: How many albums are in the collection?
