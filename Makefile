SHELL=/bin/bash
  
# Export variables
#TODO check the project id is set and is set properly
PROJECT_ID=$(shell gcloud config get-value core/project)
ZONE=us-east1-b
REGION=us-east1
INSTANCE_TYPE=e2-highcpu-32 #for testing use a smaller instance e2-standard-4
NUM_REPLICAS=2
NETWORK=""
SUBNETWORK=""
IMAGE_NAME=jupyterhub-singleuser
SERVICE_ACCOUNT="" # use a service account from the project (use need to have serviceaccount.user permissions)

delete-image:
	gcloud compute images delete ${IMAGE_NAME}

stop-instance:
	gcloud compute instances stop jupyterhub --project ${PROJECT_ID} --zone ${ZONE}

start-instance:
	gcloud compute instances start jupyterhub --project ${PROJECT_ID} --zone ${ZONE}

ssh-instance:
	gcloud beta compute ssh --zone ${ZONE} "jupyterhub" --tunnel-through-iap --project ${PROJECT_ID}

create-image:
	gcloud compute images create ${IMAGE_NAME} --project=${PROJECT_ID} --description="Jupyterhub instance" --source-disk=jupyterhub --source-disk-zone=${ZONE} --storage-location=${REGION}

delete-template:
	gcloud compute instance-templates delete ${IMAGE_NAME}

create-template:
	gcloud beta compute --project=${PROJECT_ID} instance-templates create ${IMAGE_NAME} \
    --machine-type=${INSTANCE_TYPE} \
    --subnet=${SUBNETWORK} \
    --no-address --maintenance-policy=MIGRATE --service-account=${SERVICE_ACCOUNT} \
    --scopes=https://www.googleapis.com/auth/servicecontrol,https://www.googleapis.com/auth/service.management.readonly,https://www.googleapis.com/auth/logging.write,https://www.googleapis.com/auth/monitoring.write,https://www.googleapis.com/auth/trace.append \
    --region=${REGION} --tags=${PROJECT_ID}-jupyterhub \
    --image=${IMAGE_NAME} --image-project=${PROJECT_ID} --boot-disk-size=50GB \
    --boot-disk-type=pd-balanced --boot-disk-device-name=${IMAGE_NAME} --no-shielded-secure-boot \
    --shielded-vtpm --shielded-integrity-monitoring --reservation-affinity=any

delete-managed-group:
	gcloud compute instance-groups managed delete jupyterhub --zone ${ZONE}

create-managed-group:
	gcloud beta compute --project=${PROJECT_ID} instance-groups managed create jupyterhub --base-instance-name=jupyterhub --template=${IMAGE_NAME} --size=${NUM_REPLICAS} --zone=${ZONE} --health-check=jupyter-managed-group-health-check --initial-delay=300
	gcloud beta compute --project ${PROJECT_ID} instance-groups managed set-autoscaling "jupyterhub" --zone ${ZONE} --cool-down-period "60" --max-num-replicas ${NUM_REPLICAS} --min-num-replicas ${NUM_REPLICAS} --target-cpu-utilization "0.6" --mode "off"
