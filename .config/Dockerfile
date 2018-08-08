FROM node:carbon
WORKDIR /usr/src/app

# install mongo
RUN apt-key adv --keyserver hkp://keyserver.ubuntu.com:80 --recv EA312927 \
 && echo "deb http://repo.mongodb.org/apt/debian jessie/mongodb-org/4.0 main" | tee /etc/apt/sources.list.d/mongodb-org-4.0.list \
 && apt-get update && apt-get install -y --force-yes mongodb-org

# install app dependencies
COPY . .
RUN npm install

CMD ["npm", "start"]
