require 'sinatra'

set :port, 8080

get '/' do
	@var = "Jack Scotti"
end
