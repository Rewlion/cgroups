require 'spec_helper'


describe 'parse_cgroups_json' do 

	context 'parse valid hash data' do 
		let(:params) {
      	{
        	'metadata' => {
          	'always_editable' => true,
          	'group' => 'general',
          	'label' => 'Cgroups',
          	'weight' => 50
        	},
        	"cinder-api" 	=>  '{"BlockIOWeight":500, "MemoryLimit":"1G"}',
        	"apache"		=> 	'{"CPUShares":1200}'
      	} }

      	let(:result) {
        {
        	"cinder-api"  => { "BlockIOWeight" => 500, "MemoryLimit" => "1G" },
       	 	"apache" 	  => { "CPUShares" => 1200 } 
       	}}
		

       	it 'should parse valid hash' do
      		is_expected.to run.with_params(params).and_return(result)
		end
	end

	context "wrong JSON format" do

    	let(:params) {
      	{
        	"apache" => '{{"CPUShares":1200}'
      	}}

    	it 'should raise if settings have wrong JSON format' do
      		is_expected.to run.with_params(params).and_raise_error(RuntimeError)
		end
	end

	context "should not parse a data with type different from Hash" do

    	let(:params) {
        	'cinder-api:{"BlockIOWeight":500, "MemoryLimit":"1G"}'
    	}

    	it 'should raise if group option is not a Hash' do
      		is_expected.to run.with_params(params).and_raise_error(Puppet::ParseError)
		end
	end

	context "should not parse a data with property value's type different from int and string" do

    	let(:params) {
      	{
        	"cinder-api" => '{"BlockIOWeight":[500,1]}'
      	}
    	}

    	it 'should raise if property value is an array' do
      		is_expected.to run.with_params(params).and_raise_error(Puppet::ParseError)
		end
	end

	 
end
