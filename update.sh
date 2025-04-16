#!/bin/bash

show_usage() {
    echo "用法: $0 目录1 [目录2 ...]"
    echo "功能: 将指定的目录复制到远程服务器，并重启 open-webui 容器"
    echo "示例: $0 static templates"
}

if [[ $# -eq 0 ]]; then
    show_usage
    exit 1
fi

for dir in "$@"; do
    if [[ -d "$dir" ]]; then
        echo "上传: $dir"
        scp -r "$dir" photon:/tmp/ && ssh photon "cd /tmp && docker cp ${dir} open-webui:/app/"
    else
        echo "错误: $dir 不存在"
    fi
done

ssh photon "docker restart open-webui"