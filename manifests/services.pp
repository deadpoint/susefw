#
# Definition: susefw::services
#
# add or remove a firewall rule
#
define susefw::services (
    $ensure,    # present|absent
    $zone,      # DMZ|EXT|INT
    $type       # service|tcpport|udpport
    ) {

    include susefw
    #
    $fwcfg  = "/etc/sysconfig/SuSEfirewall2"
    $helper = "/usr/local/sbin/susefw-puppet-helper.sh"

    # must be upper case
    $fw_zone = upcase("$zone")

    case $type {
        service: { $fw_type = "service=service:" }
        tcpport: { $fw_type = "tcpport=" }
        udpport: { $fw_type = "tcpport=" }
    }

    # combine type and service
    $fw_rule = "${fw_type}${name}"

    case $ensure {
        present: {
            exec { "susefw_add_${fw_rule}_${fw_zone}":
                command => "yast firewall services add $fw_rule zone=$fw_zone",
                unless  => "$helper $fw_zone $type $name",
            }
        }
        absent: {
            exec { "susefw_rm_${fw_rule}_${fw_zone}":
                command => "yast firewall services remove $fw_rule zone=$fw_zone",
                onlyif  => "$helper $fw_zone $type $name",

            }
        }
        default: {
            fail "Invalid 'ensure' value '$ensure' for susefw::services"
        }
    }
}