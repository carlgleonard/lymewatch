require 'mongo'
require './model/mongoModule'
require './model/user'

# Connection code goes here
CONNECTION = Mongo::Connection.new("localhost")
DB         = CONNECTION.db('lymeproto')

# Alias to collections goes here
USERS      = DB['users']
VENUES     = DB['venues']
CHECKINS   = DB['checkins']
ADDYS      = DB['addys']
