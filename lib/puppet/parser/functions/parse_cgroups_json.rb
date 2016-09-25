require 'json'




def isStrBool?(str)
  str.to_s == "true" or str.to_s == "false"
end



def isValidSharesValue?(value)
  if value.to_s =~ /^[0-9]+$/
    return (2..262144) === value.to_s.to_i
  else
    false
  end
end



def isValidCPUQuotaValue?(value)
   value.to_s =~ /^[0-9]+%$/
end



def isValidMemoryValue?(value)
   value.to_s =~ /^[0-9]+[K|M|G|T]?$/
end




def isValidTaskMaxValue?(value)
   value.to_s =~ /^[0-9]+$/
end




def isValidBlockIODeviceWeightValue?(value)
  if value =~ /^\/dev\/.+\s+[0-9]+$/
    return (1..1000) === value.split[1].to_i
  else
    return false
  end
end



def isDeviceBytesValue?(value)
  value =~ /^\/dev\/.+\s+[0-9]+[K|M|G|T]?$/
end



def isValidDeviceAllowValue?(value)
  value =~ /^\/dev\/.+\s+[r|w|x]?$/
end


def isValidDevicePolicyValue?(value)
  value.to_s =~ /strict|auto|closed/
end


def validateOption( service, property, value ) 
  #raise ("#{service}::#{property}::#{value} is not a string type") unless value.is_a?(String)

  case property
    when "CPUAccounting", "MemoryAccounting", "TasksAccounting", "BlockIOAccounting"
      raise ("#{service}::#{property}::#{value} is not valid") unless isStrBool? value
    
    when "CPUShares", "StartupCPUShares"
      raise ("#{service}::#{property}::#{value} is not valid ") unless isValidSharesValue? value 

    when "CPUQuota"
      raise ("#{service}::#{property}::#{value} is not valid") unless isValidCPUQuotaValue? value 
    
    when "MemoryLimit"
      raise ("#{service}::#{property}::#{value} is not valid") unless isValidMemoryValue? value
   
    when "TasksMax"
      raise ("#{service}::#{property}::#{value} is not valid") unless isValidTaskMaxValue? value
    
    when "BlockIODeviceWeight" 
      raise ("#{service}::#{property}::#{value} is not valid") unless isValidBlockIODeviceWeightValue? value
    
    when "BlockIOReadBandwidth", "BlockIOWriteBandwidth" 
      raise ("#{service}::#{property}::#{value} is not valid") unless isDeviceBytesValue? value 
    
    when "DeviceAllow"
      raise ("#{service}::#{property}::#{value} is not valid") unless isValidDeviceAllowValue? value 
    
    when "DevicePolicy"
      raise ("#{service}::#{property}::#{value} is not valid") unless isValidDevicePolicyValue? value
    
    when "Slice" , "Delegate"
    
    else
      raise("#{service}::#{property} is not supported")
    end
end




def parse_properties(service, json)
	options = JSON.parse(json) rescue raise("#{service} JSON parsing  error for : #{json}")

	unless options.is_a?(Hash)
		raise(Puppet::ParseError ,"#{service}::#{options} is not a hash")
	end

	options.each do |property, value|
	 validateOption(service, property, value)
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