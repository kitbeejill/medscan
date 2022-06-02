ARG APP_BASE_IMAGE_TAG
FROM artifactory.medline.com/medline-docker/node:$APP_BASE_IMAGE_TAG AS build
ARG WORK_DIR=/app
WORKDIR $WORK_DIR
COPY package.json .npmrc ./
# Copy source and node_modules
COPY . .
ARG BUILD_ENV
ENV NODE_ENV $BUILD_ENV
# Build the app
RUN npm run build

FROM artifactory.medline.com/medline-docker/node:$APP_BASE_IMAGE_TAG
LABEL MAINTAINER="ECOMOperations@medline.com"
LABEL APP="preference-view"

ARG GID=5000
ARG USER=ecomuser
RUN groupadd --gid $GID $USER \
    && useradd --home-dir /home/$USER --create-home --uid $GID \
        --gid $GID --shell /bin/sh --skel /dev/null $USER

ARG WORK_DIR=/app
WORKDIR $WORK_DIR
COPY package.json .npmrc ./
COPY public ./public
ARG NPM_REGISTRY=http://artifactory.medline.com/artifactory/api/npm/npm-repo/
RUN npm -g config set registry $NPM_REGISTRY && npm install --global nodemon --registry=$NPM_REGISTRY
COPY --from=build app/dist ./dist
RUN chown -R $GID:$USER $WORK_DIR && chmod -R 755 $WORK_DIR

USER $USER
CMD ["npm", "run", "startHost"]
