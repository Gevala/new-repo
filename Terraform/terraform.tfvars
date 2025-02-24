#Network Variables
region               = "us-east-1" #Should be changed based on users default region
AZs                  = ["us-east-1a", "us-east-1b"] #Should be changed based on users default region
VPC_CIDR_block       = "10.0.0.0/16"
public_subnet_cidrs  = ["10.0.1.0/24", "10.0.3.0/24"]
private_subnet_cidrs = ["10.0.2.0/24", "10.0.4.0/24"]

##########

#EC2 Instance variables
ssh_file         = "Feyi_key_pair" #Should be changed to a key pair available on the  user's system (without the .pem extension)
AMI              = "ami-04b4f1a9cf54c11d0" #Ubuntu 24.04 #should be changed to the AMI/OS pressent in the user's region
instance_type    = "t2.micro"
root_volume_size = 8 #GB

###########
db_engine         = "postgres"
db_instance_class = "db.t3.micro"
db_storage        = 8 #GB (For test)
db_user           = "postgres"
db_password       = "postgres"
db_name           = "postgres"
 
################
# Autoscaling variables
#launch template vars
name_prefix_launch_tem = "auto_scale-"

#auto scaling group
name_prefix_asg = "app_ASG-"

max_size = 3 # max number of instances
min_size = 1
desired_cap = 1
scale_up_by = 1
scale_down_by = -1
high_thresh = 70 # %
low_thresh = 30  # %