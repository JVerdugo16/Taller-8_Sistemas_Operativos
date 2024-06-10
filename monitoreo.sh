#!/bin/bash

# Verificar si el número de argumentos es correcto
if [ $# -ne 1 ]; then
    echo "Uso: $0 <intervalo_en_segundos>"
    exit 1
fi

# Obtener el intervalo de tiempo del primer argumento
intervalo=$1

# Nombre del archivo CSV
archivo="recursos.csv"

# Encabezado del archivo CSV
echo "Fecha,Memoria(%),CPU(%)" > "$archivo"

# Función para obtener el uso de memoria y CPU
obtener_estadisticas() {
    fecha=$(date "+%Y-%m-%d %H:%M:%S")
    memoria=$(free | awk '/Mem:/ {print $3/$2 * 100}')
    cpu=$(top -bn1 | grep "Cpu(s)" | sed "s/.*, *\([0-9.]*\)%* id.*/\1/" | awk '{print 100 - $1}')
    echo "$fecha,$memoria,$cpu" >> "$archivo"
}

# Ejecutar la función cada N segundos en un bucle infinito
while true; do
    obtener_estadisticas
    sleep $intervalo
done
