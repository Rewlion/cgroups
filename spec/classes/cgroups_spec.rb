require 'spec_helper'
require 'puppet/type/cgroups.rb'

describe 'cgroups', :type => :class do
	
	context "On RedHat" do
		
		let (:facts) {{
					:osfamily => "redhat",
					:operatingsystem => "CentOS"
				}}

		let (:params) do 
			{ :cgroups_set => {  
								'Apache' => { 'properties' => [ "CPUShares=600", "MemoryLimit=500M" ] } 
							 } }
		end

		it{ is_expected.to compile }
		
		it { should contain_class('cgroups').with(:cgroups_set => params[:cgroups_set] )	}
	
		it{ should contain_cgroups('Apache').with({ 'properties' => [ "CPUShares=600", "MemoryLimit=500M" ] } ) }
	end

end
