FROM node:18-alpine As Builder
WORKDIR /app

COPY package.json .
# cache and install dependencies
RUN npm ci
COPY . .

# build the project
RUN npm run build

#bundle static assets with nginx
FROM nginx:alpine as production
ENV NODE_ENV production

#copy assets from builder
COPY --from=Builder ./app/dist /usr/share/nginx/html
#
COPY /nginx/nginx.conf /etc/nginx/conf.d/default.conf

# port env
ENV PORT 8080
ENV HOST 0.0.0.0
EXPOSE 8080

#start ngnix
CMD [ "nginx","-g","daemon off;" ]