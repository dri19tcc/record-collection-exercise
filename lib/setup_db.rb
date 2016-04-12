require 'sqlite3'
require 'csv'

class ReleaseDatabase
  FILE_PATH = 'source/20160406-record-collection.csv'

  attr_reader :db

  def initialize(dbname = "releases")
    @db = SQLite3::Database.new "database/#{dbname}.db"
  end

  def setup!
    reset_schema!
    load!
  end

  private

  def reset_schema!
    puts "Recreating Schema..."

    query = <<-CREATESTATEMENT
      CREATE TABLE albums (
        id INTEGER PRIMARY KEY,
        label_code BLOB,
        artist TEXT NOT NULL,
        title TEXT NOT NULL,
        label TEXT,
        format TEXT,
        released INTEGER,
        date_added TEXT
      );
    CREATESTATEMENT

    db.execute("DROP TABLE IF EXISTS albums;")
    db.execute(query) #runs one and only one query!
  end

  def load!
    puts "Preparing INSERT statements..."

    insert_statement = <<-INSERTSTATEMENT
      INSERT INTO albums (
        label_code, artist, title, label, format, released, date_added
      ) VALUES (
        :label_code, :artist, :title, :label, :format, :released, :date_added
      );
    INSERTSTATEMENT

    prepared_statement = db.prepare(insert_statement)

    # now that we have a prepared statement...
    # let's iterate the csv and use its values to populate our database
    CSV.foreach(FILE_PATH, headers: true) do |row|
      prepared_statement.execute(row.to_h)
    end

    puts "Data import complete!"
  end
end

ReleaseDatabase.new.setup!


















# require 'sqlite3'
# require 'CSV'
#
# class ReleaseDatabase
#   FILE_PATH = 'source/20160406-record-collection.csv'
#
#   attr_reader :db
#
#   def initialize(dbname = "releases")
#     @db = SQLite3::Database.new "database/#{dbname}.db"
#   end
#
#   def reset_schema!
#     query = <<-CREATESTATEMENT
#       CREATE TABLE albums (
#         id INTEGER PRIMARY KEY,
#         label_code BLOB,
#         artist TEXT NOT NULL,
#         title TEXT NOT NULL,
#         label TEXT,
#         format TEXT,
#         released INTEGER,
#         date_added TEXT
#       );
#     CREATESTATEMENT
#
#     @db.execute("DROP TABLE IF EXISTS albums;")
#     @db.execute(query) #execute only runs one and only one query at a time.  If need more then execute twice.
#     # the above created a heredocs(sp?)
#
#   # table name: albums
#   # label_code,artist,title,label,format,released,date_added
#   # BLOB,     TEXT,   TEXT, TEXT, TEXT,  INTEGER, TEXT
#   # one table
#   # use a bang method for when something will change, it's serious business
#   end
#
#   def load! # this will parse and put data into the database
#     #statement prep is a sql concept where you create a query tht is designed for single use
#     insert_statement = <<-INSERT_STATEMENT
#       INSERT INTO albums (
#           label_code, artist, title, label, format, released, date_added
#         ) VALUES (
#         :label_code, :artist, :title, :label, :format, :released, :date_added
#       );
#     INSERT_STATEMENT
#
#     prepared_statement = @db.prepare(insert_statement) #prepare does sql tranformations to prepare it so we can use it.
#     # This can be done with pure Ruby, but this is the SQLite3 version way to do it.  It's much faster than pure ruby
#     # In the values you are using a symbol to store into hashes.  it makes it quick and easy.
#     # There's no id because SQL takes care of that part
#
#     # now that we have a prepared statement... let's iterate the csv and use its values to populate our database
#     CSV.foreach(FILE_PATH, headers: true) do |row|
#       prepared_statement.execute(row.to_h) #to_h is to hash. Because the csv row has headers you can put it into a hash
#     end
#   end
# end
#
# release_db = ReleaseDatabase.new
# release_db.reset_schema!
# release_db.load!

#csv with headers let you have hashes, so so much better to understand













#
