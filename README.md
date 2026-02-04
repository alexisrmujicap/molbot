# moltbot

chmod 400 dtb.pem
ssh -i "dtb.pem" admin@ec2-51-48-97-177.eu-south-2.compute.amazonaws.com

openssl rand -hex 32 | sed 's/^/CLAWDBOT_GATEWAY_TOKEN=/' | tee -a .env

http://ec2-51-48-97-177.eu-south-2.compute.amazonaws.com:18789