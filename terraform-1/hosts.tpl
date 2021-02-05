[db]
%{ for i in range(length(names)) ~}
%{ if names[i] ==  "db-server" ~}
${names[i]} ansible_host=${addrs[i]}
%{ endif ~}
%{ endfor ~}

[app]
%{ for i in range(length(names)) ~}
%{ if names[i] ==  "app-server" ~}
${names[i]} ansible_host=${addrs[i]}
%{ endif ~}
%{ endfor ~}

[db:vars]
ansible_ssh_common_args=-o ProxyCommand="ssh -W %h:%p ubuntu@${bastion} -i ${privat_key}"
