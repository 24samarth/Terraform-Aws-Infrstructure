resource "aws_ecr_repository" "ecr_repos" {
  count = length(var.repo_names)

  name = "${var.environment}-${var.repo_names[count.index]}"
}