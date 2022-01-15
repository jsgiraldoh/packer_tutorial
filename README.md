https://www.digitalocean.com/community/tutorials/how-to-set-up-a-node-js-application-for-production-on-ubuntu-20-04-es

https://learn.hashicorp.com/tutorials/packer/aws-get-started-build-image?in=packer/aws-get-started
https://www.packer.io/docs/provisioners/file


export AWS_ACCESS_KEY_ID=YOUR_ACCESS_KEY
export AWS_SECRET_ACCESS_KEY=YOUR_SECRET_KEY

packer init .
packer validate .
packer build aws-ubuntu.pkr.hcl

pm2 start hello.js

