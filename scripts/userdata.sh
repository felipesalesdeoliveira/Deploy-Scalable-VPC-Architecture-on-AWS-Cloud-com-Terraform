#!/bin/bash
set -euxo pipefail

yum update -y
yum install -y httpd git awscli amazon-cloudwatch-agent

rm -rf /var/www/html/*

if [ -n "${app_repo_url}" ]; then
  git clone --depth 1 --branch "${app_repo_branch}" "${app_repo_url}" /tmp/app

  if [ -d /tmp/app/html-web-app ]; then
    cp -r /tmp/app/html-web-app/* /var/www/html/
  else
    cp -r /tmp/app/* /var/www/html/
  fi
else
  cat > /var/www/html/index.html <<HTML
<html>
  <head><title>Scalable VPC App</title></head>
  <body>
    <h1>Deploy concluido com sucesso</h1>
    <p>Instancia provisionada via Terraform + ASG.</p>
  </body>
</html>
HTML
fi

systemctl enable httpd
systemctl restart httpd
