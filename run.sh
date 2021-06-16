#!/bin/sh

echo "Checking if we are running Centos 8 underneath..."
test -f /etc/centos-release && grep "CentOS Linux release 8" /etc/centos-release || exit

rpm -q epel-release || sudo yum install -y epel-release
rpm -q ansible || sudo yum install -y ansible
test -f simple-server.yml || {
  rpm -q git || sudo yum install -y git
  wget https://github.com/joschro/ansible-playbook-simple-server/archive/refs/heads/master.zip && unzip master.zip && cd ansible-playbook-simple-server-master || exit
}
ansible-playbook simple-server.yml

mkdir -p roles
cat >roles/requirements.yml<<EOF
---

- src: ikke_t.container_image_cleanup
  name: container_image_cleanup

- src: ikke_t.podman_container_systemd
  name: podman_container_systemd
EOF
ansible-galaxy role install -p roles -r roles/requirements.yml


cat <<EOF

--- Base setup done. ---

You may now run 

	ansible-playbook <yml-file>

with <yml-file> being any of
$(ls -1 run-*.yml)

to (re-)install a functionality of the server.
EOF
