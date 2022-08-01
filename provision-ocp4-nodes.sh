#!/bin/bash
nodes=(
ocp-bootstrap,00:0c:29:83:df:be
ocp-cp-1,00:0c:29:65:d5:0f
ocp-cp-2,00:0c:29:8e:91:c2
ocp-cp-3,00:0c:29:4e:e6:77
ocp-w-1,00:0c:29:da:35:11
ocp-w-2,00:0c:29:3d:ea:c4
)
cores=4
memory=8192
disk=50
storage="8cb10545-8744-8288-5a61-d61bfd75afb4"
network=22
template=CoreOS
distro=CentOS

for node in "${nodes[@]}"; do
  node_name="${node%%,*}" 
  node_mac="${node##*,}"
  echo "Creating vm ${node_name} with mac address: ${node_mac}"
  /root/xenserver-admin-scripts/xs-vm-install-from-template -l ${node_name} -c ${cores} -m ${memory} -h ${disk} -s ${storage} -n ${network} -t ${template} -v ${template} -v ${template} -p ${node_mac}
  xe vbd-create vm-uuid=$(xe vm-list --minimal name-label=${node_name}) device=1 type=CD mode=RO
  xe vm-cd-insert cd-name='rhcos-410.84.202205191234-0-live.x86_64.iso' vm="${node_name}"
  xe vm-start vm=${node_name}
done
