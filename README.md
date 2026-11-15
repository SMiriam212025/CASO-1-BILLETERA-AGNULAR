# Caso 1: Billetera Digital (Servlet + JSP + JSTL)

Aplicación web desarrollada en Java puro (Jakarta EE) utilizando Servlets, JSP, JSTL, HttpSession y Bootstrap 5.

## Versiones utilizadas
- **Java JDK:** 17 o superior
- **Apache Maven:** 3.9+
- **Servidor de Aplicaciones:** Apache Tomcat 10.1+ (Jakarta EE 10)
- **Bootstrap:** 5.3.3 (vía CDN)

## Pasos de ejecución y despliegue (.war)
1. Abrir una terminal en la carpeta `Caso1-Billetera-JSP-Servlet`.
2. Compilar y empaquetar el archivo `.war` ejecutando:
   ```bash
   mvn clean package
   ```
3. El archivo generado estará en `target/billetera-jsp.war`.
4. Copiar `billetera-jsp.war` dentro de la carpeta `webapps/` de Apache Tomcat e iniciar el servidor.
5. Abrir el navegador en: `http://localhost:8080/billetera-jsp/billetera`
