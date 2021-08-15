resource "aws_eks_cluster" "threedots" {
  name     = "threedots"
  role_arn = aws_iam_role.threedots.arn

  vpc_config {
    subnet_ids = [aws_subnet.public_subnet1.id,aws_subnet.public_subnet2.id,aws_subnet.private_subnet1.id,aws_subnet.private_subnet2.id]
  }

  depends_on = [
    aws_iam_role_policy_attachment.threedots-AmazonEKSClusterPolicy,
    aws_iam_role_policy_attachment.threedots-AmazonEKSVPCResourceController
  ]
}

output "endpoint" {
  value = aws_eks_cluster.threedots.endpoint
}

output "kubeconfig-certificate-authority-data" {
  value = aws_eks_cluster.threedots.certificate_authority[0].data
}

resource "aws_iam_role" "threedots" {
  name = "eks-cluster-threedots"

  assume_role_policy = <<POLICY
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Principal": {
        "Service": "eks.amazonaws.com"
      },
      "Action": "sts:AssumeRole"
    }
  ]
}
POLICY
}

resource "aws_iam_role_policy_attachment" "threedots-AmazonEKSClusterPolicy" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKSClusterPolicy"
  role       = aws_iam_role.threedots.name
}

resource "aws_iam_role_policy_attachment" "threedots-AmazonEKSVPCResourceController" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKSVPCResourceController"
  role       = aws_iam_role.threedots.name
}