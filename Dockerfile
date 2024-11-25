ARG PARENT_VERSION=2.2.2-node20.11.1
ARG PORT=3000
ARG PORT_DEBUG=9229

FROM defradigital/node-development:${PARENT_VERSION} AS development

USER root
RUN apk add iputils-tracepath && \
    apk add bind-tools && \
    apk add curl
USER node

ENV TZ="Europe/London"

ARG PARENT_VERSION
LABEL uk.gov.defra.ffc.parent-image=defradigital/node-development:${PARENT_VERSION}

ARG PORT
ARG PORT_DEBUG
ENV PORT ${PORT}
EXPOSE ${PORT} ${PORT_DEBUG}

COPY --chown=node:node package*.json ./

RUN npm install
COPY --chown=node:node . .
RUN npm run build

CMD [ "npm", "run", "docker:dev" ]

FROM development as productionBuild

ENV NODE_ENV production

RUN npm run build

FROM defradigital/node:${PARENT_VERSION} AS production

ENV TZ="Europe/London"

# Add curl to template.
# CDP PLATFORM HEALTHCHECK REQUIREMENT
USER root
RUN apk update && \
    apk add curl && \
    apk add iputils-tracepath && \
    apk add bind-tools
USER node

ARG PARENT_VERSION
LABEL uk.gov.defra.ffc.parent-image=defradigital/node:${PARENT_VERSION}

COPY --from=productionBuild /home/node/package*.json ./
COPY --from=productionBuild /home/node/.server ./.server/
COPY --from=productionBuild /home/node/.public/ ./.public/

RUN npm ci --omit=dev

ARG PORT
ENV PORT ${PORT}
EXPOSE ${PORT}

CMD [ "node", "." ]
