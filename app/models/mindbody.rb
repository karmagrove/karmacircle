class MindBody

   #ads person and returns their id	
   def add_person
   	site_ids = { 'int' => -99 }
   	source_credentials = { 'SourceName' => 'karmagrovellc', 'Password' => 'wHS4YfnGIW4UFPkPi20ljXRGBz0=', 'SiteIDs' => site_ids }
   	user_credentials = { 'Username' => 'Siteowner', 'Password' => 'apitest1234', 'SiteIDs' => site_ids }
  	http_client = Savon.client("https://api.mindbodyonline.com/0_5/ClientService.asmx?WSDL")
	http_request = { 'SourceCredentials' => source_credentials, 'UserCredentials' => user_credentials,
	'Clients' => {"Client" => {"FirstName" => "joseph", "LastName" => "schump", "BirthDate" => "1987-12-12", "ReferredBy" => "KarmaGrove"}}
	}
	params = { 'Request' => http_request } 
	result = http_client.request(:add_or_update_clients) do soap.body = params end
    @new_client = result[:add_or_update_clients_response][:add_or_update_clients_result]
    return @new_client[:clients][:client][:id]
   end

   def get_person_fields
   	site_ids = { 'int' => -99 }
   	source_credentials = { 'SourceName' => 'karmagrovellc', 'Password' => 'wHS4YfnGIW4UFPkPi20ljXRGBz0=', 'SiteIDs' => site_ids }
   	user_credentials = { 'Username' => 'Siteowner', 'Password' => 'apitest1234', 'SiteIDs' => site_ids }
   	http_request = { 'SourceCredentials' => source_credentials, 'UserCredentials' => user_credentials  }
  	http_client = Savon.client("https://api.mindbodyonline.com/0_5/ClientService.asmx?WSDL")
params = { 'Request' => http_request }
result = http_client.request(:get_required_client_fields) do
soap.body = params
end
# Rails.logger.info result.inspect
@fields = result[:get_required_client_fields_response][:get_required_client_fields_result]
return @fields[:required_client_fields]
   end

   def get_packages
   	site_ids = { 'int' => -99 }
   	source_credentials = { 'SourceName' => 'karmagrovellc', 'Password' => 'wHS4YfnGIW4UFPkPi20ljXRGBz0=', 'SiteIDs' => site_ids }
   	user_credentials = { 'Username' => 'Siteowner', 'Password' => 'apitest1234', 'SiteIDs' => site_ids }
   	http_client = Savon.client("https://api.mindbodyonline.com/0_5/SaleService.asmx?WSDL")
	http_request = { 'SourceCredentials' => source_credentials, 'UserCredentials' => user_credentials  }
	params = { 'Request' => http_request }
	#Run the call and store the results
	result = http_client.request(:get_packages) do
		soap.body = params
	end
	@result = result
   end

end