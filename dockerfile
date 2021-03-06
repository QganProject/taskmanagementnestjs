
FROM node:16.13-alpine as build
WORKDIR /app
COPY package.json ./
COPY yarn.lock ./
RUN cd /app \
&& yarn install 
COPY . .
RUN yarn build
CMD ["yarn", "start"]

#webserver
FROM fholzer/nginx-brotli:v1.12.2
WORKDIR /etc/nginx
ADD nginx.conf /etc/nginx/nginx.conf
COPY --from=build /app/build /usr/share/nginx/html
EXPOSE 8080
CMD ["nginx", "-g", "daemon off;"]
