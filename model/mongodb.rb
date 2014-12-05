require 'mongo'
require './model/mongoModule'
require './model/user'
#require './model/venue'
#require './model/checkin'

DB = Mongo::Connection.new("localhost", 27017).db('lymeproto')

USERS      = DB['users']
VENUES     = DB['venues']
CHECKINS   = DB['checkins']
#VENUES.ensure_index([["location.geo", Mongo::GEO2D]])
