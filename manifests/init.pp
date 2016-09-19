class cgroups( $cgroups_set = {} ) {

	case $::osfamily {
		'redhat': 	{ create_resources('cgroups', $cgroups_set) }
   		default: 	{ fail('Unsupported OS') }
	}
}