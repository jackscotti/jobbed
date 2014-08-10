require 'sinatra'
require 'net/http'
require 'json'

set :port, 8180
set :static, true
set :public_folder, "static"
set :views, "views"

@url
@total_results

get '/' do
  erb :input_page
end

post '/' do
	counter = 0

	create_url()
	api_result_array_of_hash = query_result()
	create_data_arrays(api_result_array_of_hash)

	erb :index, locals: {

		jobIds: @jobIds,
		employerNames: @employerNames,
		jobTitles: @jobTitles,
		minimumSalarys: @minimumSalarys,
		maximumSalarys: @maximumSalarys,
		expirationDates: @expirationDates,
		jobDescriptions: @jobDescriptions,
		total_results: @total_results,
		counter: counter
	}
end
		

def create_url
	@api_key = "4f87ebd0-0e8a-45a8-8ab9-d4c443f13405"

	#input from get
	@keywords = params[:keywords]
  @location = params[:location] || ""

	@url = "http://www.reed.co.uk/api/1.0/search?keywords=#{@keywords}"
	@url = @url + "&locationName=#{@location}"
end

def api_query
  uri = URI.parse(@url) #to test content and if uri object
  puts "loading"
  http = Net::HTTP.new(uri.host, uri.port)
  request = Net::HTTP::Get.new(uri.request_uri)
  # basic authorization with api key as username and no password
  request.basic_auth(@api_key, "")
  response = http.request(request)
  puts "ended loading"
  # Main array
  result = JSON.parse(response.body)
end

def query_result
  query_result = api_query()
  # query_result array from results hash
  query_result = query_result["results"]
  query_result
end

def create_data_arrays(array_of_hashes)
	@jobIds = []
	@employerNames = []
	@jobTitles = []
	@minimumSalarys = []
	@maximumSalarys = []
	@expirationDates = []
	@jobDescriptions = []

	array_of_hashes.each do |jobs|
		@jobIds << jobs["jobId"]
		@employerNames << jobs["employerName"]
		@jobTitles << jobs["jobTitle"]
		@minimumSalarys << jobs["minimumSalary"]
		@maximumSalarys << jobs["maximumSalary"]
		@expirationDates << jobs["expirationDate"]
		@jobDescriptions << jobs["jobDescription"]
	end
	@total_results = array_of_hashes.count
end
