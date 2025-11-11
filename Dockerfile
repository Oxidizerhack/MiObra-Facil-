FROM php:8.2-cli

# Instalar extensiones necesarias para MySQL
RUN docker-php-ext-install pdo pdo_mysql

# Crear directorio de trabajo
WORKDIR /app

# Copiar archivos del backend
COPY backend/ .

# Puerto por defecto (Render lo sobrescribe con $PORT)
ENV PORT=10000
EXPOSE $PORT

# Comando de inicio - usa variable PORT de Render
CMD sh -c "php -S 0.0.0.0:${PORT} -t ."
