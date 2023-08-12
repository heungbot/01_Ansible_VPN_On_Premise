output "vpc_id" {
  value = aws_vpc.main.id
}

output "public_subnet_ids" {
  description = "public subnet's id list"
  value       = aws_subnet.public.*.id
}

output "private_subnet_ids" {
  description = "private subnet's id list"
  value       = aws_subnet.private.*.id
}

output "public_route_table_id" {
  value = aws_route_table.public.id
}

