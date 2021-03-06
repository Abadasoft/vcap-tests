require 'rest_client'

Given /^I know the UAA service base URL$/ do
  @uaabase = @client.info[:authenticationEndpoint]
  pending "no uaa authentication endpoint available" unless @uaabase
end

When /^I get the login prompts$/ do
  @prompts = get_url "/login"
end

Then /^the content should contain prompts$/ do
  @prompts.should =~ /prompts/
end

When /^I try and get the user data$/ do
  @code = get_status "/Users"
end

Then /^the response should be UNAUTHORIZED$/ do
  @code.should == 401
end

def get_url(path)
  url = @uaabase + path
  response = RestClient.get url, {"Accept"=>"application/json"}
  response.should_not == nil
  response.code.should == 200
  response.body.should_not == nil
  response.body
end

def get_status(path)
  url = @uaabase + path
  begin
    response = RestClient.get url, {"Accept"=>"application/json"}
    response.code
  rescue RestClient::Exception => e
    e.http_code
  end
end
