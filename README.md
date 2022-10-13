# Documentación del proyecto

## 1º: Configuración de una infraestructura local con contenedores para wordpress

### Pre-requisitos 📋

Tener instalado [Docker](http://docker.com) y [Terraform](http://terraform.io).

### Desarrollo del proyecto

Tras instalar los diferentes servicios para poder orquestar nuestra apalicación en local, he buscado lo que sería el proveedor de Terraform para Docker al igual que sus Docs [Docker_Provider](https://registry.terraform.io/providers/kreuzwerker/docker/latest/docs).

Tras tener toda la base preparada, he iniciado buscando las imagenes de [Wordpress](https://hub.docker.com/_/wordpress) y [Mysql](https://hub.docker.com/_/mysql) en Docker para poder utilizarlas en el proyecto, así como documentarme de ellas para poder crear contenedore funcionales y lanzar los servicios.

Cuando he terminado de montar los contendedores y volumenes que hacen falta para lanzar el proyecto, y he procedido a lanzar la aplicación (tras solucionar algunos pequeños de conflictos de nombres) me he encontrado con el siguiente error:

![Image text](https://github.com/jordiros27/papasAcme/blob/main/readmeData/errorEstablishingADatabaseConnection.png)

Encontrar la solución no ha sido fácil, entendía el motivo, no había conexión entre los dos contenedores pero no encontraba una solución. Primero he intentado abrir puertos en el contendor de mysql pero no he llegado a una solución correcta, he revisado los datos de acceso y seguía sin funcionar. 

Finalmente, con la ayuda de los [Docs](https://docs.docker.com) de Docker y revisando otros trabajos publicados [enlace](https://joachim8675309.medium.com/docker-the-terraform-way-part-2-e979369028a6), he entendido que creando una red entre los contendores y compratiendola, habría una conexión. Por eso, los dos contendeores tienen la sentencia _network_mode = "wordpress_net"_ y hay una red creada con el mismo nombre.

## 2º: Creación de la instancia de la aplicación

Para está parte he creado una instancia básica, con los grupos de ssh y puerto 8080 para conectar con el balanceador. 

Tras la creación y ejecución del fichero app-acme.sh se reinicia la instancia, pero no se ejecuta el startup.sh ubicado en /etc/init.d. Me he peleado bastante con ello y no he encontrado ninguna solución, por lo que para poder ejecutar correctamente la app, se deberia conectar a la instancia por ssh mediante el ssh-key.pem y ejecutar la orden _sh /etc/init.d/startup.sh_. Alguna página de consulta sobre la ejecución tras reboot, [enlace](https://redessy.com/como-ejecutar-automaticamente-scripts-y-comandos-de-inicio-de-linux/).

[Como instalar terraform en ubuntu](https://conpilar.kryptonsolid.com/como-instalar-terraform-en-ubuntu-20-04/) y 
[Como instalar docker en ec2-linux](https://www.cyberciti.biz/faq/how-to-install-docker-on-amazon-linux-2/)

## 3º: Creación de la instancia del balanceador

En está instancia he usado el servicio ngnix. En el momento de la creación de la instancia se ejecutan una seria de comandos que provisonan el servicio. He dado una solución poco óptima en este sentido, para la consulta de la ip privada de la instacia de la app y así conectarlas. He intentado averiguar por medio de terraform alguna forma de hacerlo, pero no he encontrado nada.

Para la creación del fichero config, accedí al mismo que se ofrecía tras la instalación y habilite la parte del proxy, con escucha al pueto 8080 de la ip que modifico tras la creación del terraform, para generar un proxy inverso y mostrar el resultado con la ip del balanceador. [Enlace de ayuda para la creaación del proxy](https://www.nginx.com/resources/wiki/start/topics/examples/full/)

He intenado mapear el puerto público de la instacia con www.papasacmejros.com pero no me ha funcionado, puedes verlo directamenet con la orden _cat /etc/hosts_

## 4º: Creación de redes públicas y privadas

Como puedes ver en la carpeta private, se han creado la VPC en AWS y las diferentes subredes privadas y públicas, además de la puerta a internet con una IP fija y las tablas de enrutamiento para las subredes. Está parte sabia de su existencia, pero no sabia aprovisionarla, por lo que adapte el siguiente documento a mi fichero de terraform. [Enlace](https://medium.com/appgambit/terraform-aws-vpc-with-private-public-subnets-with-nat-4094ad2ab331)

He probado el funcionamiento, y si que funciona, pero me genera un timeout por culpa de tener que instalar el wordpress. He intentado añadir un wordpress instalado con su respectiva base de datos en el los volumenes de docker, pero me ha sido imposible, supongo que por falta de conocimineto en este sentido. 

Por eso he decido publicar la infraestructura toda pública y ver que realmente funciona, aunque con el main de private se puede comprobar con las subredes privadas y públicas. 

# Como lanzar la app

Ejecuta _sh execute.sh_ y accede a la instancia app para ejecutar _sh /etc/init.d/startup.sh_ tras el reinicio.

# Como destruir la app

Ejecuta _sh destroy.sh_ eliminaras toda la infraestructura aprovisionada y dejaras los documentos listos apra el siguiente lanzamiento.
