// This output gets the ARN for the first user in the list
output "first_arn" {
  value       = aws_iam_user.example[0].arn
  description = "The ARN for the first user"
}

// This output uses the splat operator to get a list of all ARNs
output "all_arns" {
  value       = aws_iam_user.example[*].arn
  description = "The ARNs for all users"
}

// This output uses a ternary operator to choose between two different ARNs
// based on the value of the variable `give_alice_cloudwatch_full_access`.
output "alice_cloudwatch_policy_arn_ternary" {
  value = (
    var.give_alice_cloudwatch_full_access
    ? aws_iam_user_policy_attachment.alice_cloudwatch_full_access[0].policy_arn
    : aws_iam_user_policy_attachment.alice_cloudwatch_read_only[0].policy_arn
  )
}

// This output uses the `concat` function to combine the two lists of ARNs,
// and the `one` function to extract the single value from the resulting list.
output "alice_cloudwatch_policy_arn" {
  value = one(concat(
    aws_iam_user_policy_attachment.alice_cloudwatch_full_access[*].policy_arn,
    aws_iam_user_policy_attachment.alice_cloudwatch_read_only[*].policy_arn
  ))
}