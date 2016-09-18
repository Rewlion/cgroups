Puppet::Type.newtype(:cgroups) do 
    @doc = %q{ Sets cgroups properties for systemd service
        
        Example:
            cgroups{ 'mysqld':
                properties => [ "CPUShares=600", 
                "MemoryLimit=500M" ]         
            } 
        }

    newparam(:name, :namevar => true) do
        desc 'The name of the service to manage.'
    end

    newparam(:properties) do
    	desc 'Properties for cgroups'
    end

end

