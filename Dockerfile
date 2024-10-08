FROM node:alpine as BUILD_IMAGE
WORKDIR /app
COPY package.json ./

# install dependencies
RUN npm install --frozen-lockfile
COPY . .
# build
RUN npm run build
# remove dev dependencies
RUN npm prune --production

FROM node:alpine
WORKDIR /app

# Install curl
RUN apk add --no-cache curl

# copy from build image
COPY --from=BUILD_IMAGE /app/package.json ./package.json
COPY --from=BUILD_IMAGE /app/node_modules ./node_modules
COPY --from=BUILD_IMAGE /app/.next ./.next
COPY --from=BUILD_IMAGE /app/public ./public

EXPOSE 80
CMD ["npm", "start"]
