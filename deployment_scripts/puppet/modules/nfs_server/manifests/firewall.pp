class nfs_server::firewall  {
  firewall { '011 allow nfs':
           dport => [ 111, 2049],
           proto => tcp,
           action => accept,
    }
  firewall { '012 allow nfs':
           dport => [ 111, 2049],
           proto => udp,
           action => accept,
    }
}
