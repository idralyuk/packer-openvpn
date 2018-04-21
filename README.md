[Packer](https://www.packer.io/intro) template to build enhanced OpenVPN AMIs [![CircleCI](https://circleci.com/gh/idralyuk/packer-openvpn.svg?style=svg)](https://circleci.com/gh/idralyuk/packer-openvpn)
==============================================

Based off [OpenVPN Technologies AMIs](https://aws.amazon.com/marketplace/seller-profile?id=aac3a8a3-2823-483c-b5aa-60022894b89d).

Currently creates AMIs based off the following images:
* [Bring Your Own License](https://aws.amazon.com/marketplace/pp/B00MI40CAE/) (2 connected devices free)

Updates (dist-upgrade) AMIs and adds the following packages:
* [awscli](https://aws.amazon.com/cli/) - AWS Command Line Interface
* [awslogs](https://docs.aws.amazon.com/AmazonCloudWatch/latest/logs/QuickStartEC2Instance.html) - CloudWatch Logs Agent
* [certbot](https://certbot.eff.org/) - Official Let’s Encrypt Client
* [jq](https://stedolan.github.io/jq/) - Command Line JSON processor
* [logrotate](http://www.linuxmanpages.org/8/logrotate) - Log file administration utility

Note: in order to spin up instances from these AMIs you need to review and accept the OpenVPN Technologies, Inc. licenses in your AWS account(s).

CircleCI executes [`build.sh`](build.sh) which runs packer with [`openvpn-template.json`](openvpn-template.json) that in turns uses [`setup-openvpn-ami.sh`](setup-openvpn-ami.sh) to setup the AMIs.

To build AMIs manually:
* [Install Packer](http://www.packer.io/downloads.html).
* Make sure your Amazon credentials are in `~/.aws/credentials`.
* Make sure the IAM policy has [appropriate permissions](https://www.packer.io/docs/builders/amazon.html#iam-task-or-instance-role), including [iam:PassRole](https://www.packer.io/docs/builders/amazon.html#attaching-iam-policies-to-roles).
* Run `build.sh`.
