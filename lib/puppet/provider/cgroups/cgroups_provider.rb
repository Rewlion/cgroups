Puppet::Type.type(:cgroups).provide(:cgroups_provider) do 
	desc 'cgroups provider for properties setting'

	def self.set_properties
		property_hash[:properties].each |property, value| do
			unless value.nil?
				property = property + "=" + value
				set_property(property) 
			end
		end
	end



	def self.set_property( property )
		service = @property_hash[:name] + ".service"
		cmd = "systemctl set-property " + service + " " + property
		system(cmd)
	end



	def create
		@property_hash[:properties] = {
			CPUShares				=> @resource[CPUShares] 			, 
			MemoryLimit				=> @resource[MemoryLimit	] 		,
			BlockIOWeight 			=> @resource[BlockIOWeight] 		,
			BlockIODeviceWeight 	=> @resource[BlockIODeviceWeight ] 	,
			BlockIOReadBandwidth	=> @resource[BlockIOReadBandwidth] 	,
			BlockIOWriteBandwidth	=> @resource[BlockIOWriteBandwidth] ,
			DeviceAllow				=> @resource[DeviceAllow] 			,
			DevicePolicy			=> @resource[DevicePolicy] 			,
			Slice					=> @resource[Slice] 				,
			ControlGroupAttribute	=> @resource[ControlGroupAttribute] 
		}
		@property_hash[:name]	= :resource[:name]
		set_properties
		@property_hash[:ensure] = :present

		exist?

	end



	def destroy
	
	end



	def exist?
		 @property_hash[:ensure] == :present
	end
end