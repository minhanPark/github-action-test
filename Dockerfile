FROM node:18.12.0-alpine as builder

WORKDIR /app

COPY ["package*.json", "./"]

RUN ["npm", "ci", "--omit=dev"]

COPY ["public", "./public"]

COPY ["src", "./src"]

COPY ["tsconfig.json", "./"]

COPY [".env*", "./"]

RUN ["npm", "run", "build"]

FROM nginx:latest

COPY ./nginx/default.conf /etc/nginx/conf.d/default.conf

COPY --from=builder /app/build /usr/share/nginx/html

EXPOSE 3000