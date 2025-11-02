# escape=`

#
# Development-only image for running Next.js in a containerized environment.
# Assumes that the Next.js rendering host source is mounted to c:\app.
#

ARG PARENT_IMAGE
FROM ${PARENT_IMAGE} as debug

WORKDIR /app

ENV NODE_OPTIONS="--max-old-space-size=16384"

EXPOSE 3000
ENTRYPOINT "npm run start:connected"