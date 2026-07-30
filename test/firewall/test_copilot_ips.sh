#!/usr/bin/env bash

set -e

source dev-container-features-test-lib

check "firewall script exists" test -f /usr/local/bin/init-firewall.sh
check "firewall script is executable" test -x /usr/local/bin/init-firewall.sh
check "bundled GitHub metadata exists" test -f /usr/local/share/firewall/github_meta.json
check "copilot IPs enabled" grep -q 'INCLUDE_COPILOT_IPS="true"' /usr/local/bin/firewall-config.sh
check "github IP fetch disabled" grep -q 'INCLUDE_GITHUB_IPS="false"' /usr/local/bin/firewall-config.sh

check "Copilot IPv4 API range loaded" bash -c "sudo ipset list allowed-hosts | grep -q '192.30.252.0/22'"
check "Copilot IPv4-only range loaded" bash -c "sudo ipset list allowed-hosts | grep -q '13.107.5.93'"
check "Copilot IPv6 range loaded" bash -c "sudo ipset list allowed-hosts-v6 | grep -q '2a0a:a440::/29'"
check "IPv4 Copilot allow rule exists" bash -c "sudo iptables -S OUTPUT | grep -q -- '--match-set allowed-hosts dst'"
check "IPv6 Copilot allow rule exists" bash -c "sudo ip6tables -S OUTPUT | grep -q -- '--match-set allowed-hosts-v6 dst'"

reportResults
