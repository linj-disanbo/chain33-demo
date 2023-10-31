#!/bin/bash

# to check
backendHost="127.0.0.1:46789"
rpcHost="127.0.0.1:9992"

envs=("proof-mysql" "proof-es" "proof-sync" "proof-convert" "proof-rpc" "proof-backend" )
services=()

function main() {
  blue "===================================="
  blue "===== Auto Proof V4 Self Check ====="
  blue "===================================="
  blue ""
  blue "===== check service function ====="
  checkServiceFunction
  blue "============ all right! ============"
  blue ""
  blue "===================================="
  blue "===== Auto Proof V4 All Right! ====="
  blue "===================================="
}

function checkDockerServices() {
  for i in "${envs[@]}"; do
    checkDockerService "$i"
  done
}

function checkDockerService() {
  blue "$1 \c"
  if [ "$(sudo docker ps | grep -c "$1")" -lt 1 ]; then
    red "not running."
    red "检查$1是否运行，若是名称不匹配请修改当前脚本的第7行名称"
    exit 1
  else
    green "running"
  fi
}

function checkServices() {
  for i in "${services[@]}"; do
    checkService "$i"
  done
}

function checkService() {
  blue "$1 \c"
  if [ "$(ps -ef | grep -v "grep" | grep -c "$1")" -lt 1 ]; then
    red "not running"
    red "检查$1是否运行，若是名称不匹配请修改当前脚本的第8行名称"
    exit 1
  else
    green "running"
  fi
}

function checkServiceFunction() {
  autoProof
  # wait sync
  waitProofSync
}

function autoProof() {
  blue "sending proof to blockchain ... \c"
  resp=$(
    curl -s --location --request POST 'http://'$backendHost'/api/auto_proofs' \
    --header 'Content-Type: application/json' \
    --data '[
        {
            "detail": "{\"文章\": {\"正文\":\"本数据为技术人员测试数据\"}}",
            "id": "1",
            "ext": {
                "template_id": 3,
                "version": "v4"
            }
        }
    ]'
  )
  if contain "$resp" 'hash'; then
    green "success! \c"
    proofHash=$(getJsonStringField "$resp" "tx_hash")
    echo "proofHash: $proofHash"
  else
    red "failed! resp: $resp"
    exit 1
  fi
}

function waitProofSync() {
  checkProofSync
  start=$(date +%s)
  while [ "$proofSyncFlag" == 0 ]; do
    end=$(date +%s)
    take=$((60 - (end - start)))
    blue "\rwaiting for sync proof ... \c"
    if [ "$take" -lt 1 ]; then
      if confirm "time out, continue waiting?"; then
        waitProofSync
      else
        exit 1
      fi
    fi
    sleep 1s
    checkProofSync
  done
}

proofSyncFlag=0
function checkProofSync() {
  resp=$(
    curl -s -XPOST "http://${rpcHost}/v1/proof/List" \
      --header 'Content-Type: application/json' \
      --data '{"params":[{"match":[{"key":"proof_tx_hash","value":"'"$proofHash"'"}]}]}'
  )
  # echo "$resp"
  if contain "$resp" 'proof_tx_hash'; then
    proofSyncFlag=1
    green "sync completed"
  elif notContain "$resp" '"error":null'; then
    red "rpc err, resp: $resp"
    exit 1
  fi
}

blue() {
  echo -e "\033[34m\033[01m$1\033[0m"
}
green() {
  echo -e "\033[32m\033[01m$1\033[0m"
}
red() {
  echo -e "\033[31m\033[01m$1\033[0m"
}

function contain() {
  if [ "$(echo "$1" | grep -c "$2")" -gt 0 ]; then return 0; else return 1; fi
}
function notContain() {
  if [ "$(echo "$1" | grep -c "$2")" -gt 0 ]; then return 1; else return 0; fi
}

function confirm() {
  while true; do
    read -r -p " $1 [y/n] " input

    case $input in
      [yY][eE][sS] | [yY])
        return 0
        ;;

      [nN][oO] | [nN])
        return 1
        ;;

      *)
        red "Invalid input, $1 [y/n]"
        ;;
    esac
  done
}

# echo $(getJsonStringField '{"text":"hello", "text2":"hi"}' "text")
function getJsonStringField() {
  pre='*"'$2'":"'
  tmp=${1#${pre}}
  echo "${tmp%%\"*}"
}

main
