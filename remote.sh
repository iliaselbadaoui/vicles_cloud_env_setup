export AWS_ACCESS_KEY_ID=AKIA2N66YHO4RRKYSEDX;
export AWS_SECRET_ACCESS_KEY=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;
export KUBECONFIG=$PWD/kubeconfig.yaml;
eksctl get cluster --name=vicles --region=eu-central-1;
eksctl utils write-kubeconfig --cluster=vicles --region=eu-central-1 --kubeconfig=$KUBECONFIG;