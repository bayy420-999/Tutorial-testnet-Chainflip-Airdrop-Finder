echo "     _    _         _                   _____ _           _           "
echo "    / \  (_)_ __ __| |_ __ ___  _ __   |  ___(_)_ __   __| | ___ _ __ "
echo "   / _ \ | | '__/ _\` | '__/ _ \| '_ \  | |_  | | '_ \ / _\` |/ _ \ '__|"
echo "  / ___ \| | | | (_| | | | (_) | |_) | |  _| | | | | | (_| |  __/ |   "
echo " /_/   \_\_|_|  \__,_|_|  \___/| .__/  |_|   |_|_| |_|\__,_|\___|_|   "
echo "                               |_|                                    "

echo "Website  : https://www.airdropfinder.com"
echo "Telegram : https://t.me/airdropfind"
echo "Facebook : https://www.facebook.com/groups/744001332439290"
echo "Twitter  : https://twitter.com/AirdropfindX"
sleep 5

echo -e "\n==========INSTALLING DEPENDENCIES==========\n"
sleep 2
sudo apt-get update
sudo apt-get install -y make git wget curl screen

sudo mkdir -p /etc/apt/keyrings
curl -fsSL repo.chainflip.io/keys/gpg | sudo gpg --dearmor -o /etc/apt/keyrings/chainflip.gpg


echo -e "\n==========CHECKING CHAINFLIP GPG KEY==========\n"
sleep 2

gpg --show-keys /etc/apt/keyrings/chainflip.gpg

echo "deb [signed-by=/etc/apt/keyrings/chainflip.gpg] https://repo.chainflip.io/perseverance/ focal main" >> /etc/apt/sources.list.d/chainflip.list


echo -e "\n==========INSTALLING CHAINFLIP PACKAGE==========\n"
sleep 2

sudo apt-get update
sudo apt-get install -y chainflip-cli chainflip-node chainflip-engine

echo -e "\n==========SETUP ETHEREUM KEY==========\n"
sleep 2

if [[ -d /etc/chainflip/keys ]]; then
    sudo rm -rf /etc/chainflip/keys
fi

sudo mkdir /etc/chainflip/keys

read -p "Enter ethereum private keys (without 0x): " ETH_PRIVATE_KEY
echo -n "$ETH_PRIVATE_KEY" >> /etc/chainflip/keys/ethereum_key_file

echo -e "\n==========SETUP SIGNIN KEY==========\n"
sleep 2

if [[ -s sign_key.txt ]]; then
    rm sign_key.txt
fi

chainflip-node key generate >> sign_key.txt


SIGNING_KEY=$(cat sign_key.txt)
echo -e "$SIGNING_KEY\n"

SECRET_SEED=$(grep "Secret seed" sign_key.txt)
echo -n "${SECRET_SEED:23}" >> /etc/chainflip/keys/signing_key_file

echo -e "==========GENERATING NODE KEY==========\n"
sleep 2

sudo chainflip-node key generate-node-key --file /etc/chainflip/keys/node_key_file

echo -e "\n==========GENERATING Default.toml==========\n"
sleep 2

if [[ -d /etc/chainflip/config ]]; then
    rm -rf /etc/chainflip/config
fi

sudo mkdir -p /etc/chainflip/config
IP_ADDRESS=$(curl -sw "\n" ifconfig.me)

read -p "Enter WSS Node endpoint: " WSS_NODE_ENDPOINT
read -p "Enter HTTP Node endpoint: " HTTP_NODE_ENDPOINT

echo '# Default configurations for the CFE
[node_p2p]
node_key_file = "/etc/chainflip/keys/node_key_file"' >> /etc/chainflip/config/Default.toml
echo 'ip_address = '\"${IP_ADDRESS}\" >> /etc/chainflip/config/Default.toml
echo 'port = "8078"

[state_chain]
ws_endpoint = "ws://127.0.0.1:9944"
signing_key_file = "/etc/chainflip/keys/signing_key_file"

[eth]
# Ethereum RPC endpoints (websocket and http for redundancy).' >> /etc/chainflip/config/Default.toml
echo 'ws_node_endpoint = '\"${WSS_NODE_ENDPOINT}\" >> /etc/chainflip/config/Default.toml
echo 'http_node_endpoint = '\"${HTTP_NODE_ENDPOINT}\" >> /etc/chainflip/config/Default.toml

echo '
# Ethereum private key file path. This file should contain a hex-encoded private key.
private_key_file = "/etc/chainflip/keys/ethereum_key_file"

[signing]
db_file = "/etc/chainflip/data.db"' >> /etc/chainflip/config/Default.toml

sleep 2

echo -e "\n==========SETUP FINISH==========\n"
echo -e "To start node run \`sudo systemctl start chainflip-node\`"
echo -e "To check node status run \`sudo systemctl status chainflip-node\`"
