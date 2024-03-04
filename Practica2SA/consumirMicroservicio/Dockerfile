FROM node:14

WORKDIR /app

COPY package*.json ./
RUN npm install

COPY . .

# Expone el puerto que el servicio utiliza
EXPOSE 3001

# Comando para ejecutar el servicio
CMD ["node", "index.js"]
