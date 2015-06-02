#!/usr/bin/env sh
openssl aes-256-cbc -k $DEPLOY_KEY -in config/deploy_id_rsa_encrypted -d -a -out config/deploy_id_rsa
cp config/deploy_id_rsa ~/.ssh/id_rsa
chmod 600 ~/.ssh/id_rsa
echo -e "Host www.stronglifters.com\n\tStrictHostKeyChecking no\n" >> ~/.ssh/config
eval "$(ssh-agent)"
ssh-add
[ "${TRAVIS_PULL_REQUEST}" = "false" ] && bundle exec cap production deploy || false
