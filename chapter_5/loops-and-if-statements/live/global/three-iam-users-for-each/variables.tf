variable "user_name"{
    description = "create IAM user with these names"
    type = list(string)
    default = ["alice", "bob", "charlie"]
}