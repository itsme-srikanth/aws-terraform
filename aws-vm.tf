# ec2 instance
resource "aws_instance" "srikanth_web" {
    user_data = file("ecomm.sh")
    subnet_id = aws_subnet.srikanth_pub_sn.id
    ami       = "ami-067c21fb1979f0b27"
    instance_type = "t2.large"
    key_name = "srikanth"
    vpc_security_group_ids = [aws_security_group.srikanth_pub_sg.id]
    tags = {
      name = "srikanth_server"                      
    }
}