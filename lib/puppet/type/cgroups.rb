Puppet::Type.newtype(:cgroups) do 
	@doc = %q{ Sets cgroups properties for systemd service
		
		Example:
			cgroups{ 'mysqld':
				CPUShares => 600, 
				MemoryLimit => "500M" ,				
			} 
		}

	ensurable

 	newparam(:name, :namevar => true) do
    	desc 'The name of the service to manage.'
	end

	newparam(:CPUShares) do
    	desc '
    	CPUShares => value

    	By increasing the value you assign more CPU to the unit. 
    	This parameter implies that CPUAccounting is turned on in the unit file. 

    	The CPUShares parameter controls the cpu.shares control group parameter
    	The default value in system is 1024

    	Example: 
    		CPUShares => 1500 '
	end

	newparam(:MemoryLimit) do
    	desc '
    	MemoryLimit => value

    	Replace value with a limit on maximum memory usage of the processes executed in the cgroup. 
    	Use K, M, G, T suffixes to identify Kilobyte, Megabyte, Gigabyte, or Terabyte as a unit of measurement.

    	The MemoryLimit parameter controls the memory.limit_in_bytes control group parameter.

    	Example:
    		MemoryLimit => 1024M'
	end

	newparam(:BlockIOWeight) do
    	desc '
    	BlockIOWeight => value

    	Replace value with a new overall block IO weight for the executed processes. 
    	Choose a single value between 10 and 1000, the default setting is 1000. 

    	Example:
    		BlockIOWeight => 300 '
	end

	newparam(:BlockIODeviceWeight) do
    	desc '
    	BlockIODeviceWeight => "device_name value"

    	Replace value with a block IO weight for a device specified with device_name. 
    	Replace device_name either with a name or with a path to a device. 
    	As with BlockIOWeight, it is possible to set a single weight value between 10 and 1000. 

    	Example:
    		BlockIOReadBandwith => "/home/jdoe 750" '
	end

	newparam(:BlockIOReadBandwidth) do
    	desc '
    	BlockIOReadBandwidth => "device_name value"

    	This directive allows to limit a specific bandwidth for a unit. 
    	Replace device_name with the name of a device or with a path to a block device node, 
    	value stands for a bandwidth rate. Use K, M, G, T suffixes to specify units of measurement, 
    	value with no suffix is interpreted as bytes per second. 
    	
    	Example:
    		BlockIOReadBandwith => "/var/log 5M"
    	'
	end

	newparam(:BlockIOWriteBandwidth) do
    	desc '
    	BlockIOWriteBandwidth="device_name value"
    	
    	Limits the write bandwidth for a specified device. 
    	Accepts the same arguments as BlockIOReadBandwidth. 

    	Example:
    		BlockIOWriteBandwith => "/var/log 5M"
    	'
	end

	newparam(:DeviceAllow) do
    	desc '
    	DeviceAllow => "device_name options"

    	This option controls access to specific device nodes. 
    	Here, device_name stands for a path to a device node or a device group name as specified in /proc/devices. 
    	Replace options with a combination of r, w, and m to allow the unit to read, write, or create device nodes. 
    	'
	end

	newparam(:DevicePolicy) do
    	desc '
    	DevicePolicy => value

    	Here, value is one of: strict (only allows the types of access explicitly specified with DeviceAllow), 
    	closed (allows access to standard pseudo devices 
    	including /dev/null, /dev/zero, /dev/full, /dev/random, and /dev/urandom) 
    	or auto (allows access to all devices if no explicit DeviceAllow is present, which is default behavior) 
    	'
	end

	newparam(:Slice) do
    	desc '
    	Slice => slice_name
    	
    	Replace slice_name with the name of the slice to place the unit in. 
    	The default is system.slice. Scope units can not be arranged this way, 
    	since they are tied to their parent slices. 
    	'
	end

	newparam(:ControlGroupAttribute) do
    	desc '
    	ControlGroupAttribute => "attribute value"
    	
    	This option sets various control group parameters exposed by Linux cgroup controllers. 
    	Replace attribute with a low-level cgroup parameter you wish to modify 
    	and value with a new value for this parameter. 

    	'
	end
end
