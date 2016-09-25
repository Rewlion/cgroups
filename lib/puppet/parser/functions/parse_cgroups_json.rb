require 'json'

# validates input values for service's properties
class Validator
  @nop = ->() {}

  @bool_validator = lambda do |str|
    str.to_s == 'true' || str.to_s == 'false'
  end

  @shares_value_validator = lambda do |value|
    valid_syntax = value.to_s =~ /^[0-9]+$/

    return (2..262_144).cover?(value.to_s.to_i) if valid_syntax
    false
  end

  @cpuquota_value_validator = lambda do |value|
    value.to_s =~ /^[0-9]+%$/
  end

  @memory_value_validator = lambda do |value|
    value.to_s =~ /^[0-9]+[K|M|G|T]?$/
  end

  @taskmax_value_validator = lambda do |value|
    value.to_s =~ /^[0-9]+$/
  end

  @blockweight_value_validator = lambda do |value|
    valid_syntax = value =~ %r{^/dev/.+\s+[0-9]+$}

    return (1..1000).cover?(value.split[1].to_i) if valid_syntax
    false
  end

  @devicebites_value_validator = lambda do |value|
    value =~ %r{^/dev/.+\s+[0-9]+[K|M|G|T]?$}
  end

  @deviceallow_value_validator = lambda do |value|
    value =~ %r{^/dev/.+\s+[r|w|x]?$}
  end

  @devicepolicy_value_validator = lambda do |value|
    value.to_s =~ /strict|auto|closed/
  end

  @validators_by_property_hash = {
    'CPUAccounting' =>         @bool_validator,
    'MemoryAccounting' =>      @bool_validator,
    'TasksAccounting' =>       @bool_validator,
    'BlockIOAccounting' =>     @bool_validator,
    'CPUShares' =>             @shares_value_validator,
    'StartupCPUShares' =>      @shares_value_validator,
    'CPUQuota' =>              @cpuquota_value_validator,
    'MemoryLimit' =>           @memory_value_validator,
    'TasksMax' =>              @taskmax_value_validator,
    'BlockIODeviceWeight' =>   @blockweight_value_validator,
    'BlockIOReadBandwidth' =>  @devicebites_value_validator,
    'BlockIOWriteBandwidth' => @devicebites_value_validator,
    'DeviceAllow' =>           @deviceallow_value_validator,
    'DevicePolicy' =>          @devicepolicy_value_validator,
    'Slice' =>                 @nop,
    'Delegate' =>              @nop
  }

  def self.validate_option(service, property, value)
    err_by_value = "#{service}::#{property}::#{value} is not valid"
    err_by_unknown = "#{service}::#{property} is not supported"

    validator = @validators_by_property_hash[property]
    raise(err_by_unknown) if validator.is_a?(NilClass)
    raise(err_by_value) unless validator.call(value)
  end
end

def parse_properties(service, json)
  options = JSON.parse(json) rescue raise("#{service}::#{json} invalid json")

  unless options.is_a?(Hash)
    raise(Puppet::ParseError, "#{service}::#{options} is not a hash")
  end

  v = Validator

  options.each do |property, value|
    v.validate_option(service, property, value)
  end

  options
end

parse_cgroups_json_description = <<-EOS
    This functions parses an input hash with metadata and cgroups settings(*)
    into a valid hash for cgroups's argument
    (*)cgroups settings have to be in JSON format

    Example: parse_cgroups_json(hiera('cgroups'))

    Following input:
    {
       "metadata"   => { ... },
       "cinder-api" =>  '{BlockIOWeight:500, MemoryLimit:"1G"}',
       "apache"   =>  '{CPUShares:1200}'
    }

    Returns Hash:
      {"cinder-api" => { "BlockIOWeight" => 500, MemoryLimit => "1G" },
       "apache"   => { "CPUShares" => 1200 } }

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

Puppet::Parser::Functions.newfunction(
  :parse_cgroups_json,
  type: :rvalue,
  doc: parse_cgroups_json_description
) do |argv|

  unless argv[0].is_a?(Hash)
    raise(Puppet::ParseError, 'parse_cgroups_json::argument isn`t a Hash type')
  end

  settings = argv[0].tap { |el| el.delete('metadata') }

  settings.each do |service, properties|
    settings[service] = parse_properties(service, properties)
  end

  return settings
end
