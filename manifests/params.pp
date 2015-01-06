class susefw::params {
  if $::operatingsystemrelease >= 12.3 or ($::operatingsystem == 'SLES' and $::operatingsystemrelease >= 12.0) {
    $susefirewall_setup = "SuSEfirewall2.service"
    $susefirewall_init = "SuSEfirewall2_init.service"
  } else {
    $susefirewall_setup = "SuSEfirewall2_setup"
    $susefirewall_init = "SuSEfirewall2_init"
  }
  $firewall_config = "/etc/sysconfig/SuSEfirewall2"
  $firewall_helper = "/usr/local/sbin/susefw-puppet-helper.sh"
  $yast = "/usr/sbin/yast2"
}
