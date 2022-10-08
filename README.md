# Documentación del proyecto

**1º: Configuración de una infraestructura local con contenedores para wordpress**

## Comenzando 🚀

En está primera parte han predominado dos ideas, lanzar una prueba en local de lo que sería el nodo de la aplicación y ver el funcionamiento de Terraform para Docker.

Para resolver está parte hay que entender que para lanzar una aplicación wordpress nos basamos en dos servicios diferenciasdos, la aplicación wordpress y la base de datos para almacenar la información.

### Pre-requisitos 📋

Tener instalado [Docker](http://docker.com) y [Terraform](http://terraform.io).

### Desarrollo del proyecto

Tras instalar los diferentes servicios para poder orquestar nuestra apalicación en local, he buscado lo que sería el proveedor de Terraform para Docker al igual que sus Docs [Docker_Provider](https://registry.terraform.io/providers/kreuzwerker/docker/latest/docs).

Tras tener toda la base preparada, he iniciado buscando las imagenes de [Wordpress]() y [Mysql]() en Docker para poder utilizarlas en el proyecto, así como documentarme de ellas para poder crear contenedore funcionales y lanzar los servicios.

Cuando he terminado de montar los contendedores y volumenes que hacen falta para lanzar el proyecto, y he procedido a lanzar la aplicación (tras solucionar algunos pequeños de conflictos de nombres) me he encontrado con el siguiente error:

![Image text](/Users/jordiros/Documents/papasAcme/readmeData/errorEstablishingADatabaseConnection.png)

Encontrar la solución no ha sido fácil, entendía el motivo, no había conexión entre los dos contenedores pero no encontraba una solución. Primero he intentado abrir puertos en el contendor de mysql pero no he llegado a una solución correcta, he revisado los datos de acceso y seguía sin funcionar. 

Finalmente, con la ayuda de los [Docs](https://docs.docker.com) de Docker y revisando otros trabajos publicados [enlace](), he entendido que creando una red entre los contendores y compratiendola, habría una conexión. Por eso, los dos contendeores tienen la sentencia _network_mode = "wordpress_net"_ y hay una red creada con el mismo nombre.

### Ejecutando las pruebas ⚙️



