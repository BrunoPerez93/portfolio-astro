# Dockerfile
FROM node:18-alpine AS build

WORKDIR /app

# Copiar package.json y package-lock.json
COPY package*.json ./

# Instalar dependencias
RUN npm install

# Copiar el resto de los archivos
COPY . .

# Construir la aplicación
RUN npm run build

# Etapa de producción
FROM node:18-alpine

WORKDIR /app

# Copiar dependencias y archivos construidos
COPY --from=build /app/dist ./dist
COPY --from=build /app/node_modules ./node_modules
COPY --from=build /app/package.json ./package.json

# Exponer el puerto
EXPOSE 4321

# Comando para iniciar la aplicación
CMD ["npm", "run", "preview", "--", "--host", "0.0.0.0"]