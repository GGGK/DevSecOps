ecs-cli configure profile \
  --profile-name wpfargate \
  --access-key <your-access-key> \
  --secret-key <your-secret-key> 

ecs-cli configure \
  --cluster wpfargate \
  --region us-east-1 \
  --default-launch-type FARGATE \
  --config-name wpfargate

{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Sid": "",
      "Effect": "Allow",
      "Principal": {
        "Service": "ecs-tasks.amazonaws.com"
      },
      "Action": "sts:AssumeRole"
    }
  ]
}


aws iam \
  --region us-east-1 create-role \
  --role-name ecsTaskExecutionRole \
  --assume-role-policy-document file://task-execution-assume-role.json

ecs-cli up --cluster-config wpfargate

aws ec2 create-security-group \
  --group-name "wpfargate-sg" \
  --description "My Fargate security group" \
  --vpc-id "vpc-0fd8a0742962a4c7e"

aws ec2 authorize-security-group-ingress \
  --group-id "sg-056e52a070c1aad48" \
  --protocol tcp \
  --port 80 \
  --cidr 0.0.0.0/0