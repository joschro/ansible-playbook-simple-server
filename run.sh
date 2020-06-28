#!/bin/sh

rpm -q epel-release || sudo yum install -y epel-release
rpm -q ansible || sudo yum install -y ansible
ansible-playbook simple-server.yml

test -f roles/requirements.yml || {
  mkdir roles
  cat >>roles/requirements.yml<<EOF
---

- src: ikke_t.container_image_cleanup
  name: container_image_cleanup

- src: ikke_t.podman_container_systemd
  name: podman_container_systemd
EOF

  ansible-galaxy --roles-path roles install -r roles/requirements.yml
}


cat <<EOF

--- Base setup done. ---

You may now run 

	ansible-playbook <yml-file>

with <yml-file> being any of
$(ls -1 *yml)

to (re-)install a functionality of the server.
EOF
