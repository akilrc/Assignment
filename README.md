# Assignment
Deploying a microapplication to cloud GCP using terraform

Prerequisite:


please make JDK latest version, jenkins and terraform is installed (use sudo if needed)
yum install java-1.8.0-openjdk.x86_64
wget -O /etc/yum.repos.d/jenkins.repo https://pkg.jenkins.io/redhat-stable/jenkins.repo
rpm --import https://pkg.jenkins.io/redhat-stable/jenkins.io.key
yum install jenkins


A `gcp` bucket to store the remote state
Jenkins to run the jobs specified in the jenkinsfile

For the 1st scenario (`no-backend`), you need to create a Variable to store the `credentials` file and 
here I have set the variable name as `GCE_TOKEN` using;
And also **replace** the `bucket` and `prefix` values with yours.
```
terraform init -backend-config="bucket=<your-bucket-name>" \
               -backend-config="prefix=<prefix>" \
               -backend-config="credentials=$GCE_TOKEN"
```
---

Steps to run and open the application
