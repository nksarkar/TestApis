#multi stage build 
#   - 1st stage with base image full .net sdk - copies everything, builds project and publishes artifacts to /app/out
#   - 2nd stage with sdk runtime(smaller than sdk), copies only published artifacts into container image, 
# leaves the rest (source code) in old stage, so new container has only .net runtime + build artifacts. makes image sizer small.
# base image - full .net sdk 
FROM mcr.microsoft.com/dotnet/sdk:5.0-buster-slim AS build
WORKDIR /app

# Copy everything from current dir to /app folder in container
COPY . ./
# install nuget packages for TestApi project
RUN dotnet restore "src/TestApi/TestApi.csproj"

# build with Release configuation and output into out folder in container
RUN dotnet publish "src/TestApi/TestApi.csproj" --configuration Release --output out

# Q. when and how did we install dependencies for test project?? 
# A. dotnet test restores internally
RUN dotnet test

#2nd stage: generate runtime image
FROM mcr.microsoft.com/dotnet/aspnet:5.0 AS final
WORKDIR /app
EXPOSE 80

#copy only published binaries from /app/out folder in build stage to current directory (/app)
# COPY --from=build - means copy from build stage
COPY --from=build /app/out .
ENTRYPOINT [ "dotnet", "TestApi.dll" ]