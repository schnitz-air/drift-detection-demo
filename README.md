# Cortex Cloud Drift Detection Demo

This repository contains a sample Infrastructure as Code (IaC) setup using GitHub Actions to demonstrate the drift detection capabilities of Cortex Cloud.

## Overview

This repository is currently an empty template containing only the GitHub Actions workflow (`.github/workflows/deploy.yml`). You can add your own Infrastructure as Code (IaC) files (like Terraform, CloudFormation, Helm, or Kubernetes manifests) to this repository to demonstrate drift detection. The GitHub Actions workflow is configured to automatically apply Terraform configurations located in a `terraform/` directory whenever changes are pushed to the `main` branch.

## Prerequisites

1. A Kubernetes cluster.
2. A GitHub repository to host this code.
3. Cortex Cloud configured to monitor your Kubernetes cluster and GitHub repository.

## Setup Instructions

### 1. Configure AWS IAM and GitHub Secrets

To allow GitHub Actions to authenticate with your Amazon EKS cluster, you need to configure AWS IAM credentials and add your `kubeconfig` as a repository secret.

#### A. Create an IAM User for GitHub Actions

1. Create an IAM user in your AWS account (e.g., `github-actions-eks-deployer`).
2. Create and attach an IAM policy that allows the user to describe the EKS cluster. Example policy:
   ```json
   {
       "Version": "2012-10-17",
       "Statement": [
           {
               "Effect": "Allow",
               "Action": [
                   "eks:DescribeCluster"
               ],
               "Resource": "arn:aws:eks:<region>:<account-id>:cluster/<cluster-name>"
           }
       ]
   }
   ```
3. Generate an **Access Key ID** and **Secret Access Key** for this user.
4. Add this user to the `aws-auth` ConfigMap in your EKS cluster (in the `kube-system` namespace) with `system:masters` permissions so it can create and manage resources.

#### B. Add GitHub Secrets

1. Go to your GitHub repository settings.
2. Navigate to **Secrets and variables** > **Actions**.
3. Add the following secrets:
   * `AWS_ACCESS_KEY_ID`: The Access Key ID generated in step A3.
   * `AWS_SECRET_ACCESS_KEY`: The Secret Access Key generated in step A3.
   * `KUBECONFIG`: The contents of your `~/.kube/config` file (or the specific kubeconfig for your cluster). You can extract just the current context using `kubectl config view --minify --flatten`.

### 2. Add Your IaC and Push the Code

1. Create a `terraform/` directory and add your Terraform configuration files.
2. Push the contents of this directory to your GitHub repository's `main` branch. The GitHub Actions workflow will automatically trigger and deploy the resources to your cluster.

```bash
git init
git add .
git commit -m "Initial commit: Add GitHub Actions for drift demo"
git branch -M main
git remote add origin <your-repo-url>
git push -u origin main
```

## Executing the Drift Detection Demo

Once you have added your IaC and the initial deployment is successful, you can demonstrate Cortex Cloud's drift detection capabilities by following these steps:

### Step 1: Establish the Baseline

1. Verify in Cortex Cloud that the resources you deployed are discovered and mapped to this GitHub repository.
2. Show that Cortex Cloud reports **No Drift** for these resources, as the cluster state matches the IaC baseline.

### Step 2: Introduce Manual Drift

Simulate an out-of-band change by manually modifying a resource directly in the Kubernetes cluster using `kubectl` or the AWS Console.

For example, if you deployed a Kubernetes deployment, change the number of replicas:

```bash
kubectl scale deployment <your-deployment-name> --replicas=5 -n <your-namespace>
```

### Step 3: Observe Drift in Cortex Cloud

1. Navigate back to Cortex Cloud.
2. Wait for the next scan cycle or manually trigger a scan.
3. Cortex Cloud will detect the discrepancy between the cluster state and the IaC definition in GitHub.
4. Show the **Drift Detected** alert in the Cortex Cloud UI, highlighting the specific fields that differ.

### Step 4: Remediate the Drift

You can remediate the drift in two ways:

**Option A: Revert the manual change (Align Cluster to IaC)**
Run the GitHub Actions workflow again to revert the cluster state back to the IaC definition.

**Option B: Update the IaC (Align IaC to Cluster)**
If the manual change was intentional, update your IaC files to match the new cluster state, commit, and push the change.

After pushing the update, Cortex Cloud will re-evaluate and report that the drift has been resolved.
 
