$tagNumber = 'latest' 
If($args.count -gt 0 -And $args[0] -ne $null){
    $tagNumber = $args[0]
}

# ## 1. Build docker container image
#docker build -t "nks33/testapis:${tagNumber}" .

# ## 2. Push image to docker hub
#docker push "nks33/testapis:${tagNumber}"

## 3. Create infrastructure using Terraform (without image deployment)
# terraform init
#terraform apply -input=false -auto-approve

## 4. Deploy image to app service (Production slot) from docker hub
#az webapp config container set --name "test-api-rg-app-svc" --resource-group "test_api_rg" --docker-custom-image-name "nks33/testapis:${tagNumber}" --docker-registry-server-url docker.io/nks33

## 5. Deploy image to app service (Deployment slot) from docker hub
#az webapp config container set --name "test-api-rg-app-svc" --slot "deploy-slot" --resource-group "test_api_rg" --docker-custom-image-name "nks33/testapis:${tagNumber}" --docker-registry-server-url docker.io/nks33

### Swap slots
#az webapp deployment slot swap --name "test-api-rg-app-svc" --resource-group "test_api_rg" --slot "deploy-slot" --target-slot "Production"