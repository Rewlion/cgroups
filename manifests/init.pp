class cgroups( $cgroups_set = {} ) {

	case $::osfamily {
		'redhat': {
     			$cgroups_set.each |$service, $properties| {
     				$properties.each |$property,$value| {
     					exec {"/usr/bin/systemctl set-property ${service}.service ${property}=${value}"  :}
     				}
     			} 
     		}
   		default: { fail('Unsupported OS') }
	}
}