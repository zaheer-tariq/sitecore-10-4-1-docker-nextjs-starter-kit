# escape=`

ARG BUILD_IMAGE

FROM ${BUILD_IMAGE} AS builder
ARG CM_HOST
ARG ID_HOST
ARG CLIENT_SECRET

# install sitecore cli
RUN dotnet new tool-manifest
RUN dotnet nuget add source -n Sitecore https://nuget.sitecore.com/resources/v3/index.json
RUN dotnet tool install Sitecore.CLI -g

SHELL ["powershell", "-Command", "$ErrorActionPreference = 'Stop'; $ProgressPreference = 'SilentlyContinue';"]
COPY sitecore.json /
COPY src/platform/ /src/platform/

RUN sitecore plugin list

SHELL ["powershell", "-Command", "$ErrorActionPreference = 'Stop'; $ProgressPreference = 'SilentlyContinue';"]
RUN sitecore login --cm "${env:CM_HOST}" --auth "${env:ID_HOST}" --allow-write true --client-id "SitecoreCLIServer" --client-secret "${env:CLIENT_SECRET}" --client-credentials true 
RUN sitecore ser push --publish