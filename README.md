# **Project One: Deploying a web server in Azure**
![Azure](https://png.pngitem.com/pimgs/s/299-2994950_microsoft-dynamics-nav-hd-png-download.png)

## Introduction

The respository provides files which can be cloned to assist you in future Infrastructure as Code (IAC) deployments. These files will be the baseline for IAC tools such as Packer, Terraform, Azure Console and Command Line Interface (CLI). The IAC will deploy a website that will include a load balancer in Azure. 

### Dependencies
____
1. Create a free (30-day) Microsoft Azure Account [here](https://www.portal.azure.com/)
   - This will provide access to the Microsoft Azure Console
2. Go [here](https://www.docs.microsoft.com/en-us/cli/azure/install-azure-cli?view=azure-cli-latest) to install the Azure CLI
3. Go [here](https://www.packer.io/downloads) to install HashiCorp Packer
4. Go [here](https://www.terraform.io/downloads.html) to install HashiCorp Terraform

## Getting Started 
1. Clone this repository
2. Create and establish your IAC
3. Update this ReadM file to relfect how some would use your code -- edit to use your own words

## Instructions
Start by Creating a Service Principle Name (SPN)
1. Launch the Microsoft Azure Console
2. In the Azure Console, use the search bar and search for: Azure Active Directory
3. Then Search for: App Registration
4. Select New Registration
5. Create and establish a single tenant service, ensure the single tenant doesn't have a redirect URL enabled
6. Now, search for: Subscription Services
7. Select the primary subscription that you've established
8. In your primary subscription select Access Control (IAM)
9. Set the Contributor role on your application
10. Select Save

## Deploy Packer Image
1. In the Azure Portal or Azure CLI (Command Line Interface) create a resource group that will be utilized for your Packer Image 
2. Open the file directory that contains the server_web.json (or filename.json) file
3. Open the server_web.json in your preferred text editor
4. Edit the server_web.json file to point the image resource group to your established resource group
5. Save the server_web.json file
6. Open CMD from the Packer directory
7. In CMD run the following command: packer bulder server_web.json (or filename.json)
8. To verify that the image has been deployed while in Azure CLI
9. Run the following command: az image list

## Creating and Deploying Terraform 
Copy and Save the main.tf and vars.tf files from the Terraform Software directory that were provided by the instructor
1. Open the vars.tf file to edit the variables that are currently preset
2. Update the prefix variable
3. Update the location variable ensure that you're using default = "EAST US" for the Azure Region
4. Update the admin variable --- you don't want this hardcoded in the main.tf
5. Update the password variable --- you don't want this harcoded in the main.tf
6. Update the imagegroup -- deafault will be the Packer resoruce group you created in the previous section (for example, jbprojectonerg)
7. Update the virtualiamge -- default will be the Packer image you created in the previous section (for example, jbprojectoneimg)
8. Update the vm_count -- default is 2, however, you can adjust to 5 if you choose to
9. Save and store the vars.tf file in the directory you're using for this project
10. In the directory you can launch CMD 
11. Run the following command: terraform init -- this command initializes Terraform
12. Run the following command: terraform plan -- this commnnd will establish the solution.plan file which will save to the directory
13. Run the following command: terraform apply -- this will deploy and establish you IAC Infrastructure
14. Run the following command: terrform show --- this will display the IAC Infrastructure you've deployed
15. If all above commands have run successsful you should see the IAC via Azue CLI with terrform show command or access the Azure Console to see the VM's deployed

## Output
Again, if you've successfully deployed both Packer and Terraform templates you've edited. You should now see the following resources deployed:
1. Two Linux Virtual Machines with two associated disk
2. Two Network Interfaces
3. Two Storage disks
4. A Public IP space
5. A Avaibility set
6. A Load Balancer
