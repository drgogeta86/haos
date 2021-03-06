#!/bin/bash -xe

SERVER_ENDPOINT=$1

for i in `fuel nodes 2>/dev/null | grep ready | awk '{print $1}'`
do
    NODE_NAME="node-${i}"
    echo "Hacking ${NODE_NAME}"
    scp hack_openstack_node.sh ${NODE_NAME}:/root/
    scp haosagent ${NODE_NAME}:/root/
    ssh ${NODE_NAME} "/root/hack_openstack_node.sh ${SERVER_ENDPOINT}"
done

if [ ! -d "mos-tempest-runner" ]; then
    yum -y install git
    git clone https://github.com/Mirantis/mos-tempest-runner.git
    cd mos-tempest-runner
    ./setup_env.sh
fi
