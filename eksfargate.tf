resource "aws_eks_fargate_profile" "threedots_fargate" {
  cluster_name           = aws_eks_cluster.threedots.name
  fargate_profile_name   = "threedots_profile"
  pod_execution_role_arn = aws_iam_role.threedots_fargate.arn
  subnet_ids             = [aws_subnet.private_subnet1.id,aws_subnet.private_subnet2.id]

  selector {
    namespace = "default"
  }
}

resource "aws_eks_fargate_profile" "threedots_fargate2" {
  cluster_name           = aws_eks_cluster.threedots.name
  fargate_profile_name   = "threedots_profile2"
  pod_execution_role_arn = aws_iam_role.threedots_fargate.arn
  subnet_ids             = [aws_subnet.private_subnet1.id,aws_subnet.private_subnet2.id]

  selector {
    namespace = "kube-public"
  }
}

resource "aws_eks_fargate_profile" "threedots_fargate3" {
  cluster_name           = aws_eks_cluster.threedots.name
  fargate_profile_name   = "threedots_profile3"
  pod_execution_role_arn = aws_iam_role.threedots_fargate.arn
  subnet_ids             = [aws_subnet.private_subnet1.id,aws_subnet.private_subnet2.id]

  selector {
    namespace = "kube-node-lease"
  }
}

resource "aws_eks_fargate_profile" "threedots_fargate4" {
  cluster_name           = aws_eks_cluster.threedots.name
  fargate_profile_name   = "threedots_profile4"
  pod_execution_role_arn = aws_iam_role.threedots_fargate.arn
  subnet_ids             = [aws_subnet.private_subnet1.id,aws_subnet.private_subnet2.id]

  selector {
    namespace = "kube-system"
  }
}

resource "aws_iam_role" "threedots_fargate" {
  name = "eks-fargate-profile-threedots"

  assume_role_policy = jsonencode({
    Statement = [{
      Action = "sts:AssumeRole"
      Effect = "Allow"
      Principal = {
        Service = "eks-fargate-pods.amazonaws.com"
      }
    }]
    Version = "2012-10-17"
  })
}

resource "aws_iam_role_policy_attachment" "threedots_fargate_AmazonEKSFargatePodExecutionRolePolicy" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKSFargatePodExecutionRolePolicy"
  role       = aws_iam_role.threedots_fargate.name
}