## Deploying a Python Flask Web Application to App Engine Flexible



export region=us-east1
export PROJECT_ID=$(gcloud config get-value project)



gcloud storage cp -r gs://spls/gsp023/flex_and_vision/ .
cd flex_and_vision



gcloud iam service-accounts create qwiklab \
  --display-name "My Qwiklab Service Account"

gcloud projects add-iam-policy-binding ${PROJECT_ID} \
--member serviceAccount:qwiklab@${PROJECT_ID}.iam.gserviceaccount.com \
--role roles/owner

gcloud iam service-accounts keys create ~/key.json \
--iam-account qwiklab@${PROJECT_ID}.iam.gserviceaccount.com

export GOOGLE_APPLICATION_CREDENTIALS="/home/${USER}/key.json"




## Test the Application Locally



virtualenv -p python3 env
source env/bin/activate
pip install -r requirements.txt
AE_REGION=$region
gcloud app create --region=$AE_REGION
export CLOUD_STORAGE_BUCKET=${PROJECT_ID}
gsutil mb gs://${PROJECT_ID}



## Run the Application
python main.py


## CTRL + C
#Deploying the app to App Engine Flexible

echo "
manual_scaling:
  instances: 1
" >> app.yaml


gcloud config set app/cloud_build_timeout 1000
gcloud app deploy
 

## Access in https://<PROJECT_ID>.appspot.com
