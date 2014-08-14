require 'sinatra'
require 'net/http'
require 'json'

set :port, 8600
set :static, true
set :public_folder, "static"
set :views, "views"

get '/' do
  erb :input_page
end

post '/' do
	counter = 0
	@url = create_url(params[:keywords], params[:location])
	@array_of_ids = []
	@local_result_array = []
	@key = "4f87ebd0-0e8a-45a8-8ab9-d4c443f13405"
	@total_results
	@page_counter = 0
	@jobIds = []
	@employerNames = []
	@jobTitles = []
	@minimumSalarys = []
	@maximumSalarys = []
	@expirationDates = []
	@jobDescriptions = []


# - query api providing url
	api_query(@url)
# - count total results from api
  count_total_results()
# - update local array
  update_local_temp_array()
# - check the number of results, update if needed
  check_number_of_results() # to be refactored into more specific methods
# - Add each separate id to the relevant array
	create_data_arrays()


	erb :index, locals: {

		jobIds: @jobIds,
		employerNames: @employerNames,
		jobTitles: @jobTitles,
		minimumSalarys: @minimumSalarys,
		maximumSalarys: @maximumSalarys,
		expirationDates: @expirationDates,
		jobDescriptions: @jobDescriptions,
		total_results: @total_results,
		total_ids: @array_of_ids.count,
		counter: counter
	}
end
		
def create_url(keywords,location)
	url = "http://www.reed.co.uk/api/1.0/search?"
	url << "keywords=" << keywords
	url << "&locationName=" << location
	url
end

def api_query(url)
  uri = URI.parse(url) #to test content and if uri object
  puts "loading"
  http = Net::HTTP.new(uri.host, uri.port)
  request = Net::HTTP::Get.new(uri.request_uri)
  # basic authorization with api key as username and no password
  request.basic_auth("4f87ebd0-0e8a-45a8-8ab9-d4c443f13405", "")
  response = http.request(request)
  puts "ended loading"
  result = JSON.parse(response.body) # this will crash everytime response.body is nil
  @first_hash_result_from_api = result
end

def count_total_results
  @total_results = @first_hash_result_from_api['totalResults']
end

def update_local_temp_array
  @local_temp_array = @first_hash_result_from_api["results"]
end

def update_array_of_ids
  @local_temp_array.each do |result|
    @array_of_ids << result['jobId']
  end
  @array_of_ids.uniq! 
end


def check_number_of_results
  while (@array_of_ids.count < @total_results - 10) # do not know why (error in the api?)
    add_new_jobs()
    update_array_of_ids()
    adjust_url()
    api_query(@url)
    update_local_temp_array()
  end
end

def add_new_jobs
	@local_temp_array.each do |result|
    unless @array_of_ids.include?(result['jobId'])
      @local_result_array << result
    end
  end
end

def adjust_url
	@page_counter += 100
  if @array_of_ids.count < 200
  	@url << "&resultsToSkip="
  elsif @array_of_ids.count < 1000
    @url = @url[0..-4] 
  else
    @url = @url[0..-5] 
  end
  @url << @page_counter.to_s
end

def create_data_arrays
	@local_result_array.each do |job|
		@jobIds << job["jobId"]
		@employerNames << job["employerName"]
		@jobTitles << job["jobTitle"]
		@minimumSalarys << job["minimumSalary"]
		@maximumSalarys << job["maximumSalary"]
		@expirationDates << job["expirationDate"]
		@jobDescriptions << job["jobDescription"]
	end
end
