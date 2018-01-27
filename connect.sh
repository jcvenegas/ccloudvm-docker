#!/bin/bash

set -e

die()
{
	msg="$*"
	echo "ERROR: ${msg}" >&2
	exit 1
}

operation=$1
config_dir=$2
[ -d "$config_dir" ] || die "not a dir $config_dir"
[ -f "$config_dir/workload.yaml" ] || die "workload.yaml not found"
config_dir=$(readlink -f $config_dir)
c_id=$(basename $config_dir)

docker build \
	--build-arg http_proxy=${http_proxy}\
	--build-arg https_proxy=${https_proxy}\
	-t ccloudvm  ${PWD}/build

docker_run="docker run --privileged"
docker_run+="	--rm"
docker_run+="	--name ${c_id} "
docker_run+="	-e http_proxy=${http_proxy}"
docker_run+="	-e https_proxy=${https_proxy}"
docker_run+="	-e USER=root"
docker_run+="	-v ${HOME}/.ssh:/root/.ssh"
docker_run+="	-v ${HOME}/.gitconfig:/root/.gitconfig"
docker_run+="	-v ${config_dir}:/root/.ccloudvm"
docker_run+="	-v ${GOPATH}:/gopath"
docker_run+="	-v ${config_dir}/workload.yaml:/root/.ccloudvm/workloads/workload.yaml"
docker_run+="	-ti "
docker_run+="	ccloudvm"


case "$operation" in
	create)
		$docker_run -c "ccloudvm create workload && ccloudvm connect && ccloudvm stop"
		;;
	start)
		set -x
		$docker_run -c "ccloudvm start && ccloudvm connect && ccloudvm stop"
		;;
esac

