class nfs_server_backend::install  {
  include nfs_server_backend::params
# include nfs_server::firewall
  package { $nfs_server_backend::params::pkg_name_client:
    ensure => installed, 
  }
  file { 'cinder_mnt':
    path    => '/var/lib/cinder/mnt',
    ensure  => directory,
    group   => 'cinder',
    owner   => 'cinder',
    mode    => 750,
  }
#  package { 'cinder-common':
#    ensure => installed,
#  }
# service { 'cinder-volume':
#   ensure    => running,
#  enable    => true,
# }



  cinder::backend::nfs { "DEFAULT" :
    volume_backend_name  => '',
    nfs_mount_options    => '',
    nfs_disk_util        => '',
    nfs_sparsed_volumes  => '',
    nfs_mount_point_base => '',
    nfs_servers          => $nfs_server_backend::params::nfs_share,
    nfs_shares_config    => '/etc/cinder/shares.conf',
    nfs_used_ratio       => '0.95',
    nfs_oversub_ratio    => '1.0',
    extra_options        => {},
  }

  package { $::cinder::params::volume_package:
    ensure => present }
  service { $::cinder::params::volume_service:
    ensure => running,}
  File['/etc/cinder/shares.conf'] {
    require => Package[$::cinder::params::package_name],
    notify => Service[$::cinder::params::volume_service]
  }


#file { 'file_for_cinder_shares':
#  path    => $nfs_server_backend::params::file_for_cinder_shares,
#  content => "$nfs_server_backend::params::nfs_share:$nfs_server_backend::params::nfs_root_path \n",
#  notify  => Service["$nfs_server::params::service_name"],
#}
# service { $nfs_server::params::service_name:
#   ensure    => running,
#   enable    => true,
# }
}

