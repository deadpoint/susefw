#
# Definition: susefw::services
#
# add or remove a firewall rule
#
define susefw::services (
    $ensure,    # present|absent
    $zone,      # DMZ|EXT|INT
    $type,       # service|tcpport|udpport
    $service="$name" # service name|port 
    ) {

    include susefw
    include susefw::params
    #
    $fwcfg  = $susefw::params::firewall_config
    $helper = $susefw::params::firewall_helper

    # must be upper case
    $fw_zone = upcase("$zone")

    case $type {
        service: { $fw_type = "service=service:" }
        tcpport: { $fw_type = "tcpport=" }
        udpport: { $fw_type = "udpport=" }
    }

    # combine type and service
    $fw_rule = "${fw_type}${service}"

    case $ensure {
        present: {
            exec { "susefw_add_${fw_rule}_${fw_zone}":
                command => "yast firewall services add $fw_rule zone=$fw_zone",
                unless  => "$helper $fw_zone $type $service",
            }
        }
        absent: {
            exec { "susefw_rm_${fw_rule}_${fw_zone}":
                command => "yast firewall services remove $fw_rule zone=$fw_zone",
                onlyif  => "$helper $fw_zone $type $service",

            }
        }
        default: {
            fail "Invalid 'ensure' value '$ensure' for susefw::services"
        }
    }
}
