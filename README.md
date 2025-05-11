# aws-capstone-2
Module 2 capstone project

---

# Capstone Project: Containerized Web App Deployment on Amazon EKS

## Table of Contents

1. [Deployment Environment Setup](#1-deployment-environment-setup)
2. [Containerizing the Application](#2-containerizing-the-application)
3. [Deploying Amazon EKS Cluster](#3-deploying-amazon-eks-cluster)
4. [Deploying the Application with Backend DB](#4-deploying-the-application-with-backend-db)
5. [Blue/Green Deployment Update](#5-bluegreen-deployment-update)

---

## 1. Deployment Environment Setup

### Objective:
Clone this repo locally.
Execute this command from a cli:
   ```bash
   git clone <repo git URL>
   ```
Configure your environment setting the env AWS variable:
export AWS_ACCESS_KEY_ID=<value>
export AWS_SECRET_ACCESS_KEY=<value>
export AWS_SESSION_TOKEN=<value>
export AWS_REGION=<value>


Create a deployment environment with all required tools:
To deploy the deployment server will we use packer and terraform.
First thing first, edit the hcl packer file and modify 
* region 
* instance_type 
* ami_name
---
accordingly to your use case then create the custom AMI using the script provided in packer directory, by executing command:
   ```bash
   packer build dsrveks.pkr.hcl
   ```
Notedown the ami ID at the end of the output or look inside AWS console in the AMI Catalog, side tab My AMI
The AMI image will contain all the tools needed:
kubectl
eksctl
docker
npm
helm
terraform

Create the deployment server using terraform script in directory terraform/deplsrveks.
Before executing the provisioning command, remember to change the AMI ID variabble value in file terraform/deplsrveks/terraform.tfvars with the AMI ID obtained earlier.
When done, execute in sequence the commands:
```bash
terraform init
terraform fmt
terraform validate
terraform apply
```
the EC2 instance will be created. Use the connect tab on AWS Console to connect to the instance

### Verification:

* All tools ran without errors.
  To verify that everything 
* Tested a sample Docker container and connected to AWS CLI successfully.

---

## 2. Containerizing the Application

### ✅ Objective:

* Create Docker image of the app.
* Push to DockerHub or Amazon ECR.

### 🛠️ Steps:

1. Created a Dockerfile for my web app:

   ```Dockerfile
   FROM node:18
   WORKDIR /app
   COPY . .
   RUN npm install
   EXPOSE 3000
   CMD ["npm", "start"]
   ```
2. Built and tested image locally:

   ```bash
   docker build -t myapp:v1 .
   docker run -p 3000:3000 myapp:v1
   ```
3. Tagged and pushed image to Docker Hub:

   ```bash
   docker tag myapp:v1 mydockerhubusername/myapp:v1
   docker push mydockerhubusername/myapp:v1
   ```

### ✅ Verification:

* Image is visible in ECR.
* Pulled and ran image successfully.
* Created `v2` with a small update and pushed that version as well.

---

## 3. Deploying Amazon EKS Cluster

### ✅ Objective:

* Deploy EKS cluster using `eksctl` and a customized config file.

### 🛠️ Steps:

Created `eks-cluster.yaml`:

```yaml
apiVersion: eksctl.io/v1alpha5
kind: ClusterConfig
metadata:
  name: my-eks-cluster
  region: us-east-1
nodeGroups:
  - name: ng-app
    instanceType: t2.medium
    desiredCapacity: 3
```

Created the cluster:

```bash
eksctl create cluster -f eks-cluster.yaml
```

### ✅ Verification:

* `eksctl get cluster`
* Connected using:

  ```bash
  aws eks --region us-east-1 update-kubeconfig --name my-eks-cluster
  kubectl get nodes
  ```

---

## 4. Deploying the Application with Backend DB

### ✅ Objective:

* Deploy full application stack (frontend + backend database) in EKS using Kubernetes manifests.

### 🛠️ Steps:

1. Created `deployment.yaml` and `service.yaml` for the app.

2. Created a PostgreSQL deployment and service:

   ```yaml
   # postgres-deployment.yaml
   apiVersion: apps/v1
   kind: Deployment
   metadata:
     name: postgres
   spec:
     replicas: 1
     selector:
       matchLabels:
         app: postgres
     template:
       metadata:
         labels:
           app: postgres
       spec:
         containers:
         - name: postgres
           image: postgres:15
           env:
             - name: POSTGRES_DB
               value: mydb
             - name: POSTGRES_USER
               value: user
             - name: POSTGRES_PASSWORD
               value: password
   ```

3. Applied all configurations:

   ```bash
   kubectl apply -f postgres-deployment.yaml
   kubectl apply -f app-deployment.yaml
   kubectl apply -f app-service.yaml
   ```

4. Tested app availability:

   * Used LoadBalancer or port-forward.
   * Deleted pods to test auto-recovery:

     ```bash
     kubectl delete pod <pod-name>
     ```

### ✅ Verification:

* App reachable from web browser.
* Database connects from app container (logs confirmed).
* Auto-restart of pods tested and verified.

---

## 5. Blue/Green Deployment Update

### ✅ Objective:

* Deploy new app version using blue/green strategy.

### 🛠️ Steps:

1. Created a new Deployment YAML (green) with new image tag (`v2`).
2. Labeled the service to point to `green` deployment.
3. Once verified, removed old `blue` deployment.

Example:

```yaml
# green-deployment.yaml
spec:
  template:
    metadata:
      labels:
        version: green
    spec:
      containers:
      - image: mydockerhubusername/myapp:v2
```

Updated service selector:

```yaml
spec:
  selector:
    version: green
```

4. Verified service routing and successful rollout:

   ```bash
   kubectl rollout status deployment/green
   ```

### ✅ Verification:

* v2 of the app running and served.
* Successfully rolled back to v1 by switching service selector.

---

## 📁 Repository Structure

```
.
├── Dockerfile
├── eks-cluster.yaml
├── postgres-deployment.yaml
├── app-deployment.yaml
├── app-service.yaml
├── green-deployment.yaml
└── README.md
```

---

## 📌 Notes

* All YAML manifests are included in this repo.
* Image repository: \[DockerHub Link Here]
* AWS EKS deployed in `us-east-1` region.

---

Would you like a template GitHub repo with these files to start from?

