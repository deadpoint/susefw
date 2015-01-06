# Class susefw
#
class susefw {
    include susefw::params
    #
    if $::operatingsystemrelease >= 12.3 or ($::operatingsystem == 'SLES' and $::operatingsystemrelease >= 12.0){
        Service { provider => 'systemd' }
    }

    package { [ "iptables", "SuSEfirewall2", "yast2"]:
        ensure  => installed,
    }
    service { 'SuSEfirewall2_init':
        name    => $susefw::params::susefirewall_init,
        #ensure => running,
        enable  => true,
    }
    service { "SuSEfirewall2_setup":
        name    => $susefw::params::susefirewall_setup,
        ensure  => running,
        enable  => true,
        require => Service["SuSEfirewall2_init"],
    }
    #
    file { "susefw-puppet-helper":
        ensure  => present,
        owner   => root,
        group   => root,
        mode    => 0755,
        path    => "/usr/local/sbin/susefw-puppet-helper.sh",
        source  => "puppet:///modules/susefw/susefw-puppet-helper.sh",
    }
}
