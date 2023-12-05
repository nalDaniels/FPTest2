FROM node:14

WORKDIR /app

RUN git clone https://github.com/djtoler/kurafpj.git .

RUN npm install --force

EXPOSE 8000

CMD ["npm", "start"]
