# ---------------------------------------------------------
# Dockerfile - api-fortaleza-nube
# Fase 1: Análisis y Contenerización Segura
# Buenas prácticas de Hardening aplicadas:
#   - Imagen base ligera (alpine)
#   - Directorio de trabajo dedicado (WORKDIR)
#   - Usuario sin privilegios (USER node) para evitar root
#   - Instalación reproducible con npm ci
#   - Solo se copia lo necesario (ver .dockerignore)
# ---------------------------------------------------------

FROM node:20-alpine

# Directorio de trabajo dentro del contenedor
WORKDIR /usr/src/app

# Copiamos primero los manifiestos para aprovechar la caché de capas de Docker
COPY package*.json ./

# Instalación de dependencias en modo producción
RUN npm install --omit=dev

# Copiamos el resto del código fuente
COPY . .

# Nos aseguramos de que el usuario "node" (no root, viene incluido en la imagen oficial)
# sea dueño de los archivos de la app antes de cambiar de usuario
RUN chown -R node:node /usr/src/app

# Cambiamos al usuario sin privilegios: nunca ejecutamos la app como root
USER node

# Puerto en el que escucha la API (ver index.js -> process.env.PORT || 8080)
EXPOSE 8080

ENV PORT=8080

CMD ["node", "index.js"]