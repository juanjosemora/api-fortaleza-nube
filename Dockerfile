# ---------------------------------------------------------
# Dockerfile - api-fortaleza-nube
# Fase 1: Análisis y Contenerización Segura
# ---------------------------------------------------------

FROM node:20-alpine

RUN apk update && apk upgrade --no-cache

WORKDIR /usr/src/app

COPY package*.json ./

# Instalamos dependencias y luego eliminamos npm/corepack de la imagen final:
# la app se ejecuta con "node index.js" (no necesita npm en tiempo de
# ejecución), y así se eliminan también las vulnerabilidades de las
# herramientas internas que trae npm empaquetadas.
RUN npm install --omit=dev \
    && rm -rf /usr/local/lib/node_modules/npm \
    && rm -rf /usr/local/lib/node_modules/corepack \
    && rm -f /usr/local/bin/npm /usr/local/bin/npx /usr/local/bin/corepack

COPY . .

RUN chown -R node:node /usr/src/app

USER node

EXPOSE 8080

ENV PORT=8080

CMD ["node", "index.js"]
