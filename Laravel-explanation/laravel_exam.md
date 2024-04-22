# **Cloud Engineering Second Semester Examination Project**

## **Automating LAMP Stack Deployment with Vagrant and Ansible**

## **Objective**
The objective of this project is to automate the provisioning of two Ubuntu-based servers, named "Master" and "Slave", using Vagrant. On the Master node, a bash script is created to automate the deployment of a LAMP (Linux, Apache, MySQL, PHP) stack. This script clones a PHP application from GitHub, installs all necessary packages, and configures Apache web server and MySQL. An Ansible playbook is used to execute the bash script on the Slave node and verify that the PHP application is accessible through the VM’s IP address. Additionally, a cron job is created to check the server’s uptime every 12 am.

## **Prerequisites**
1. Vagrant: Install Vagrant.
1. Virtualization Provider: Install VirtualBox or VMware.
1. Git: Install Git.
1. Text Editor: Have a text editor installed.
1. GitHub Account: Sign up for a GitHub account.
1. Understanding of Vagrant and Ansible: Have a foundational understanding of Vagrant and Ansible.

### **Configuration of Vagrantfile**
To successfully carry out this task, the first step is to edit the configuration of your default vagrantfile. This guide will show you how to use Vagrant to easily set up two virtual Ubuntu servers. We'll call them "Master" and "Slave". This will help you to quickly create consistent environments to work on, saving you time and making it easier to grow your system as needed. We'll be using a Vagrantfile to tell Vagrant exactly what to set up on the servers, so anyone can easily follow the steps to provision similars servers on their end. By the end, you'll be setting up virtual servers in no time! 

To configure you vagrantfile, go to the directory where the file is located and run `ls` to confirm it within that directory. Thereafter, using your preferred text editor either "nano or vi", enter the vagrantfile using `vi vagrantfile`. Within the vagrantfile make the follow changes as shown in the image below. 
![vagrantfile](./images/ss1%20-%20Copy.png)  
 ```
  config.vm.define "master" do |master|
    master.vm.box = "ubuntu/focal64"
    master.vm.network "private_network", ip: "192.168.50.15"
    # You can add more configurations specific to master here
  end

  # Define Slave
  config.vm.define "slave" do |slave|
    slave.vm.box = "ubuntu/focal64"
    slave.vm.network "private_network", ip: "192.168.50.16"
    # You can add more configurations specific to master here
  end
  ```

After successfully editing the vagrantfile, run the command below
```
vagrant up
```
Then open two terminals, one for your **Master and another for the Slave**, then ssh into them using the command;
```
vagrant ssh master
vagrant ssh slave
```
You should get a prompt similar to this when you enter into both servers.  
**Master**

**Slave**

## **Establishing SSH Connection Between Master and Slave**

