$tagNumber = 'latest' 
If($args.count -gt 0 -And $args[0] -ne $null){
    $tagNumber = $args[0]
}

# ## 1. Build docker container image
#  docker build -t "nks33/testapis:${tagNumber}" .

# ## 2. Push image to docker hub
# docker push "nks33/testapis:${tagNumber}"

## 3. Create infrastructure using Terraform (without image deployment)
# terraform init
# terraform plan

terraform apply -input=false -auto-approve

## 4. Deploy image to app service (Production slot) from docker hub
# az webapp config container set --name "test-api-rg-app-svc" --resource-group "test_api_rg" --docker-custom-image-name "nks33/testapis:${tagNumber}" --docker-registry-server-url docker.io/nks33

## 5. Deploy image to app service (Deployment slot) from docker hub
#az webapp config container set --name "test-api-rg-app-svc" --slot "deploy-slot" --resource-group "test_api_rg" --docker-custom-image-name "nks33/testapis:${tagNumber}" --docker-registry-server-url docker.io/nks33

### Swap slots (gate for manual approval)
# az webapp deployment slot swap --name "test-api-rg-app-svc" --resource-group "test_api_rg" --slot "deploy-slot" --target-slot "Production"

# Add secrets, how to allow access one resource to another
# separate script into build and deployment stages pipeline 
# try kubernetis may be--what is and how it works
# Polumi what is, how works 