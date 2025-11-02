# escape=`

ARG PARENT_IMAGE
ARG SPE_IMAGE
ARG HEADLESS_SERVICES_IMAGE

FROM ${SPE_IMAGE} as spe
FROM ${HEADLESS_SERVICES_IMAGE} AS headless_services
FROM ${PARENT_IMAGE}

ARG ENVIRONMENT

# Copy and init the JSS / Headless Services Module
COPY --from=headless_services C:\module\db C:\resources\jss