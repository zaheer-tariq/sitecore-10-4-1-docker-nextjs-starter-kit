# escape=`

ARG PARENT_IMAGE
ARG SPE_IMAGE
ARG SOLUTION_IMAGE
ARG TOOLS_IMAGE
ARG HORIZON_RESOURCES_IMAGE
ARG MANAGEMENT_SERVICES_IMAGE
ARG HEADLESS_SERVICES_IMAGE

FROM ${SOLUTION_IMAGE} as solution
FROM ${TOOLS_IMAGE} as tools
FROM ${SPE_IMAGE} as spe
FROM ${HORIZON_RESOURCES_IMAGE} as horizon_resources
FROM ${MANAGEMENT_SERVICES_IMAGE} AS management_services
FROM ${HEADLESS_SERVICES_IMAGE} AS headless_services
FROM ${PARENT_IMAGE}

ARG ENVIRONMENT

SHELL ["powershell", "-Command", "$ErrorActionPreference = 'Stop'; $ProgressPreference = 'SilentlyContinue';"]

WORKDIR C:\inetpub\wwwroot

RUN powershell -Command Add-WindowsFeature Web-WebSockets

RUN Write-Host "ENVIRONMENT:" $env:ENVIRONMENT

# Copy developer tools and entrypoint
COPY --from=tools C:\tools C:\tools

# Add SPE module
COPY --from=spe \module\cm\content .\

# Add horizon module
#COPY --from=horizon_resources \module\cm\content \inetpub\wwwroot

# Copy and init the JSS / Headless Services Module
COPY --from=headless_services C:\module\cm\content C:\inetpub\wwwroot
COPY --from=headless_services C:\module\tools C:\module\tools

RUN C:\module\tools\Initialize-Content.ps1 -TargetPath C:\inetpub\wwwroot; `
    Remove-Item -Path C:\module -Recurse -Force;

# Copy the Sitecore Management Services Module
COPY --from=management_services C:\module\cm\content C:\inetpub\wwwroot

# Copy solution website files
COPY --from=solution /artifacts/sitecore/ ./
COPY readme.md *.config*  c:\inetpub\wwwroot\App_Config\Include\

# Copy role transforms
COPY .\transforms\$ENVIRONMENT\App_Config \transforms\role\App_Config
COPY .\transforms\$ENVIRONMENT\Web.config.xdt \transforms\role\

COPY .\logging\LogMonitorConfig.json c:\logmonitor\

# Copy hotfixes
# COPY .\hotfixes C:\inetpub\wwwroot

# Perform role transforms
RUN C:\tools\scripts\Invoke-XdtTransform.ps1 -Path .\ -XdtPath C:\transforms\role
