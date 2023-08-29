# to make sure kops will load your ~/.aws/config
export AWS_SDK_LOAD_CONFIG=1
# tell tools below which profile they should use to authenticate with AWS
export AWS_PROFILE=default
# k8s cluster name
echo "Please provide cluster-name, i.e. devops1"
read NAME
#NAME=devops-demo.local    #tested for demo purposes only
# AWS region to deploy to
REGION=us-west-2

# create S3 bucket for storing kops state
aws s3 mb s3://$NAME-triangu-kops-state --region $REGION
ssh-keygen -t rsa -b 2048 -f $NAME -q -P ""

# spin up k8s cluster
kops create cluster \
--name $NAME.k8s.local \
--zones=${REGION}a \
--master-zones=${REGION}a \
--networking kube-router \
--dns=private \
--topology=private \
--node-count=1 \
--node-size=t3.large \
--master-size=t3.medium \
--master-count=1 \
--ssh-public-key ./$NAME.pub \
--state s3://$NAME-triangu-kops-state \
--cloud=aws \
--yes
