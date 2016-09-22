require 'json'

def parse_properties(service, json)
	options = JSON.parse(json) rescue raise("#{service} JSON parsing  error for : #{json}")

	unless options.is_a?(Hash)
		raise(Puppet::ParseError ,"#{service}::#{options} is not a hash")
	end

	options.each do |property, value|
		unless value.is_a?(Integer) or value.is_a?(String) 
			raise(Puppet::ParseError ,"#{service}::#{property}::#{value} is not a string or Int")
		end
	end

	options
end

Puppet::Parser::Functions::newfunction(:parse_cgroups_json, :type => :rvalue,  :doc => <<-EOS
    This functions parses an input hash with metadata and cgroups settings(*) 
    into a valid hash for cgroups's argument
    (*)cgroups settings have to be in JSON format

    Example: parse_cgroups_json(hiera('cgroups'))
    
    Following input:
    {
       "metadata" 	=> { ... },
       "cinder-api" =>  '{BlockIOWeight:500, MemoryLimit:"1G"}',
       "apache" 	=> 	'{CPUShares:1200}' 
    }
    
    Returns Hash:
      {"cinder-api" => { "BlockIOWeight" => 500, MemoryLimit => "1G" },
       "apache" 	=> { "CPUShares" => 1200 } }
    
    Pattern for value field:
      {
        service1 => {
          property1 => value1,
          property2 => value2
        },
        service2 => {
          property3 => value3,
          property4 => value4
        }
      }
    EOS
) do |argv|
    	unless argv[0].is_a?(Hash)
    		raise(Puppet::ParseError, "parse_cgroups_json::argument:Argument have to be a Hash type")
    	end

    	settings = argv[0].tap { |el| el.delete('metadata') }

    	settings.each do |service,properties|
    		settings[service] = parse_properties(service, properties)
    	end 

    	return settings
end