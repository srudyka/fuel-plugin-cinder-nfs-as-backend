class nfs_server_backend::install  {
  include nfs_server_backend::params
  include cinder::params 

  package { $nfs_server_backend::params::pkg_name_client:
    ensure => installed, 
  }

  $mnt_dir = '/var/lib/cinder/mnt' 

  file { 'cinder_mnt':
    path    => $mnt_dir,
    ensure  => directory,
    group   => 'cinder',
    owner   => 'cinder',
    mode    => 750,
  }

  nfs_server_backend::cinder_backend_nfs { "DEFAULT" :
    volume_backend_name  => 'DEFAULT',
    nfs_mount_options    => "",
    nfs_disk_util        => "",
    nfs_sparsed_volumes  => "True",
    nfs_mount_point_base => $mnt_dir,
    nfs_servers          => $nfs_server_backend::params::nfs_share,
    nfs_shares_config    => '/etc/cinder/shares.conf',
    nfs_used_ratio       => '0.95',
    nfs_oversub_ratio    => '1.0',
    extra_options        => {},
  }

  package { $::cinder::params::volume_package:
    ensure => present, 
  }
  service { $::cinder::params::volume_service:
    ensure => running,
  }

  exec { 'cinder_mnt chown':
    command  => "/bin/chown -R cinder:cinder $mnt_dir",
  }


}

