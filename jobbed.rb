require 'sinatra'
require 'net/http'
require 'json'

require './helpers/helpers'

set :port, 8699
set :static, true
set :public_folder, "static"
set :views, "views"

get '/' do
  erb :input
end

post '/' do
	counter = 0
	@page_counter = 0
	@total_results
	@ids, @local_result_hash = [], []
	@jobIds = []
	@employerNames = []
	@jobTitles = []
	@minimumSalarys, @maximumSalarys = [], []
	@expirationDates = []
	@jobDescriptions = []

	@api_parameters = ["jobId",
										 "employerName",
										 "jobTitle",
										 "minimumSalary",
										 "maximumSalary",
										 "expirationDate",
										 "jobDescription"]

	@url = create_url(format_user_input(params[:keywords],params[:location]))
	@first_hash_result_from_api = api_query(@url)

# - count total results from api
  count_total_results()
# - update local array
  update_local_temp_array()
# - check the number of results, update if needed
  check_number_of_results() 
# - Add each separate id to the relevant array
	create_data_arrays()

	erb :search_results, locals: {

		jobIds: @jobIds,
		employerNames: @employerNames,
		jobTitles: @jobTitles,
		minimumSalarys: @minimumSalarys,
		maximumSalarys: @maximumSalarys,
		expirationDates: @expirationDates,
		jobDescriptions: @jobDescriptions,
		total_results: @total_results,
		total_ids: @ids.count,
		counter: counter
	}
end

get '/:id' do
	parameters = ["jobId",
							  "employerName",
							  "jobTitle",
							  "minimumSalary",
							  "maximumSalary",
							  "expirationDate",
							  "jobDescription"]

  url = create_url_desc(params[:id])
  parsed_response = api_query(url)
 	job_details = prepare_data(parameters, parsed_response)

  erb :job_details, locals: {
  	job_details: job_details
	}
end
# description query
def create_url_desc(id)
	url = "http://www.reed.co.uk/api/1.0/jobs/" + id
	url 
end
def prepare_data(parameters, parsed_response)
	details = []
	parameters.each do |parameter|
    details << parsed_response[parameter]
  end
  details
end

# shared methods
def api_query(url)
  uri = URI.parse(url) #test content if !uri object app will crash
  puts "loading"
  http = Net::HTTP.new(uri.host, uri.port)
  request = Net::HTTP::Get.new(uri.request_uri)
  # basic authorization with api key as username and no password
  request.basic_auth("4f87ebd0-0e8a-45a8-8ab9-d4c443f13405", "")
  response = http.request(request)
  puts "ended loading"
  parsed_response = JSON.parse(response.body) # this will crash everytime response.body is nil
  parsed_response
end

# general query methods
def remove_spaces(input)
  input = input.split(" ").join("+");
  input
end
def format_user_input(keywords,location)
	keywords = remove_spaces(keywords)
	location = remove_spaces(location)
	return keywords, location
end
def create_url(input)
	keywords, location = input
	url = "http://www.reed.co.uk/api/1.0/search?"
	url << "keywords=" << keywords << "&locationName=" << location
	url
end
def count_total_results
  @total_results = @first_hash_result_from_api['totalResults']
end
def update_local_temp_array
  @local_temp_array = @first_hash_result_from_api["results"]
end
def update_array_of_ids
  @local_temp_array.each do |result|
    @ids << result['jobId']
  end
  @ids.uniq! 
end
def check_number_of_results
  while (@ids.count < @total_results - 10) # do not know why (error in the api?)
    add_new_jobs()
    update_array_of_ids()
    adjust_url()
    @first_hash_result_from_api = api_query(@url)
    update_local_temp_array()
  end
end
def add_new_jobs
	@local_temp_array.each do |result|
    unless @ids.include?(result['jobId'])
      @local_result_hash << result
    end
  end
end
def adjust_url
	@page_counter += 100
  if @ids.count <= 100
  	@url << "&resultsToSkip="
  elsif @ids.count < 1000
    @url = @url[0..-4] 
  else
    @url = @url[0..-5] 
  end
  @url << @page_counter.to_s
end
def create_data_arrays
  @local_result_hash.each do |job|
    @api_parameters.each do |parameter|
      instance_variable_get("@#{parameter}s") << job[parameter]
    end
  end
end
