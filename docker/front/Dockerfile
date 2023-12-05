FROM node:14

WORKDIR /app

RUN git clone https://github.com/djtoler/kurafpj.git .

WORKDIR /app/react

RUN npm install

EXPOSE 3000

CMD ["npm", "start"]
