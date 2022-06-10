# Application Optimization Accelerator
Assist the visibility into your organization's infrastructure so that you can confidently assess, diagnose and resolve incidents across mission-critical workloads.

- [Application Optimization Accelerator](#application-optimization-accelerator)
  - [How to run the Accelerator](#how-to-run-the-accelerator)
    - [Requesting an Environment](#requesting-an-environment)
    - [Provisioning a Cluster then Configuring it](#provisioning-a-cluster-then-configuring-it)
      - [Provisioning a Cluster](#provisioning-a-cluster)
      - [Configuring your Cluster](#configuring-your-cluster)
    - [Configuring your existing Cluster](#configuring-your-existing-cluster)

## How to run the Accelerator

Choose one of following methods to successfully run the Accelerator:

- Request an environment (the easiest)
- Provision a cluster, then configure it
- Configure your existing cluster 

### Requesting an Environment
[Go to the Application Optimization Accelerator IBM Technology Zone Collection](todo)

Reserve an `todo` environment.

Fill out your reservation with the following specs:
- todo

### Provisioning a Cluster then Configuring it

#### Provisioning a Cluster
[Go to the Custom ROKS & VMware Requests IBM Technology Zone Collection](https://techzone.ibm.com/collection/custom-roks-vmware-requests)

Reserve an `IBM RedHat Openshift Kubernetes Service (ROKS)` environment.

Fill out your reservation with the following specs:
- 5 Worker Node Count
- 16x64 with 100GB secondary storage Worker Node Flavor
- 2TB NFS Size
- OpenShift Version 4.8

#### Configuring your Cluster
curl -sfL https://github.com/IBM/application-optimization-accelerator/main/install-ai-manager.sh?| sh -

### Configuring your existing Cluster
curl -sfL https://github.com/IBM/application-optimization-accelerator/main/install-ai-manager.sh?| sh -
