class cgroups( $cgroups_set = {} ) {

	case $::osfamily{
		'redhat': {
     		$cgroups_set.each() |service, settings| do
				create_resources('cgroups', service, settings)
			end
   		}
   		default: {
   			fail("Unsupported platform")
   		}
	}
}