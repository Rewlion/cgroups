# CGroups


This puppet module configures Control Groups on the nodes which uses Systemd. Under the hood is systemctl usage.




### Initialization

Place this module at /etc/puppet/modules/cgroups or in the directory where
your puppet modules are stored.

The 'cgroups' class has the following parameters and default values:
```puppet
class { 'cgroups':
      cgroups_set => {}
    }
```

* *cgroups_set* - user settings of Control Groups defined in the hash
 format. Settings: pairs of {[Service] => {[property] => [String value]}}

``` cgroups_set example: { "keystone" => { "CPUShares":"1200", "MemoryLimit":"1G"}  } ```


## Fuel Usage
This puppet module relies on fuel cluster's settings. Puppet function parse_cgroups_json is used to parse the info from cluster's settings to valid hash format for cgroups class. For example:

```puppet
  $cgroups_config = hiera('cgroups', {})
  $cgroups_set = parse_cgroups_json($cgroups_config)

    class { '::cgroups':
      cgroups_set => $cgroups_set,
    }
```
---
For activating cgroup user should add 'cgroup' section into cluster's settings
file via CLI. Value have to be a JSON type.For example:
```
  cgroups:
    metadata:
      group: general
      label: Cgroups configuration
      weight: 90
      restrictions:
        - condition: "true"
        action: "hide"
    keystone:
      label: keystone
      type:  text
      value: {"CPUShares":"1200", "MemoryLimit":"1G"}
```



## Documentation

[Official documentation for CGroups](https://access.redhat.com/documentation/en-US/Red_Hat_Enterprise_Linux/7/html/Resource_Management_Guide/index.html)
