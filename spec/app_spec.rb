require 'spec_helper'

url = "http://www.reed.co.uk/api/1.0/search?keywords=ruby&locationName=london"
key = "4f87ebd0-0e8a-45a8-8ab9-d4c443f13405"

describe "GET test" do

  it "should respond to GET" do
    get '/'
    last_response.should be_ok
    last_response.body.should match(/Fill the form!/)
  end
end

describe "Back end tests" do
  it "should return the url" do
  	expect(create_url("ruby","london")).to eq url
  end
  # describe "will call query api method" do
  # 	it "should return an array" do
  # 		expect(api_query(url, key).class).to eq Hash
  # 	end
  # end
end
