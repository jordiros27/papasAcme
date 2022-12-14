# Documentaci贸n del proyecto

## 1潞: Configuraci贸n de una infraestructura local con contenedores para wordpress

### Pre-requisitos 馃搵

Tener instalado [Docker](http://docker.com) y [Terraform](http://terraform.io).

### Desarrollo del proyecto

Tras instalar los diferentes servicios para poder orquestar nuestra apalicaci贸n en local, he buscado lo que ser铆a el proveedor de Terraform para Docker al igual que sus Docs [Docker_Provider](https://registry.terraform.io/providers/kreuzwerker/docker/latest/docs).

Tras tener toda la base preparada, he iniciado buscando las imagenes de [Wordpress](https://hub.docker.com/_/wordpress) y [Mysql](https://hub.docker.com/_/mysql) en Docker para poder utilizarlas en el proyecto, as铆 como documentarme de ellas para poder crear contenedore funcionales y lanzar los servicios.

Cuando he terminado de montar los contendedores y volumenes que hacen falta para lanzar el proyecto, y he procedido a lanzar la aplicaci贸n (tras solucionar algunos peque帽os de conflictos de nombres) me he encontrado con el siguiente error:

![Image text](https://github.com/jordiros27/papasAcme/blob/main/readmeData/errorEstablishingADatabaseConnection.png)

Encontrar la soluci贸n no ha sido f谩cil, entend铆a el motivo, no hab铆a conexi贸n entre los dos contenedores pero no encontraba una soluci贸n. Primero he intentado abrir puertos en el contendor de mysql pero no he llegado a una soluci贸n correcta, he revisado los datos de acceso y segu铆a sin funcionar. 

Finalmente, con la ayuda de los [Docs](https://docs.docker.com) de Docker y revisando otros trabajos publicados [enlace](https://joachim8675309.medium.com/docker-the-terraform-way-part-2-e979369028a6), he entendido que creando una red entre los contendores y compratiendola, habr铆a una conexi贸n. Por eso, los dos contendeores tienen la sentencia _network_mode = "wordpress_net"_ y hay una red creada con el mismo nombre.

## 2潞: Creaci贸n de la instancia de la aplicaci贸n

Para est谩 parte he creado una instancia b谩sica, con los grupos de ssh y puerto 8080 para conectar con el balanceador. 

Tras la creaci贸n y ejecuci贸n del fichero app-acme.sh se reinicia la instancia, pero no se ejecuta el startup.sh ubicado en /etc/init.d. Me he peleado bastante con ello y no he encontrado ninguna soluci贸n, por lo que para poder ejecutar correctamente la app, se deberia conectar a la instancia por ssh mediante el ssh-key.pem y ejecutar la orden _sh /etc/init.d/startup.sh_. Alguna p谩gina de consulta sobre la ejecuci贸n tras reboot, [enlace](https://redessy.com/como-ejecutar-automaticamente-scripts-y-comandos-de-inicio-de-linux/).

[Como instalar terraform en ubuntu](https://conpilar.kryptonsolid.com/como-instalar-terraform-en-ubuntu-20-04/) y 
[Como instalar docker en ec2-linux](https://www.cyberciti.biz/faq/how-to-install-docker-on-amazon-linux-2/)

## 3潞: Creaci贸n de la instancia del balanceador

En est谩 instancia he usado el servicio ngnix. En el momento de la creaci贸n de la instancia se ejecutan una seria de comandos que provisonan el servicio. He dado una soluci贸n poco 贸ptima en este sentido, para la consulta de la ip privada de la instacia de la app y as铆 conectarlas. He intentado averiguar por medio de terraform alguna forma de hacerlo, pero no he encontrado nada.

Para la creaci贸n del fichero config, acced铆 al mismo que se ofrec铆a tras la instalaci贸n y habilite la parte del proxy, con escucha al pueto 8080 de la ip que modifico tras la creaci贸n del terraform, para generar un proxy inverso y mostrar el resultado con la ip del balanceador. [Enlace de ayuda para la creaaci贸n del proxy](https://www.nginx.com/resources/wiki/start/topics/examples/full/)

He intenado mapear el puerto p煤blico de la instacia con www.papasacmejros.com pero no me ha funcionado, puedes verlo directamenet con la orden _cat /etc/hosts_

## 4潞: Creaci贸n de redes p煤blicas y privadas

Como puedes ver en la carpeta private, se han creado la VPC en AWS y las diferentes subredes privadas y p煤blicas, adem谩s de la puerta a internet con una IP fija y las tablas de enrutamiento para las subredes. Est谩 parte sabia de su existencia, pero no sabia aprovisionarla, por lo que adapte el siguiente documento a mi fichero de terraform. [Enlace](https://medium.com/appgambit/terraform-aws-vpc-with-private-public-subnets-with-nat-4094ad2ab331)

He probado el funcionamiento, y si que funciona, pero me genera un timeout por culpa de tener que instalar el wordpress. He intentado a帽adir un wordpress instalado con su respectiva base de datos en el los volumenes de docker, pero me ha sido imposible, supongo que por falta de conocimineto en este sentido. 

Por eso he decido publicar la infraestructura toda p煤blica y ver que realmente funciona, aunque con el main de private se puede comprobar con las subredes privadas y p煤blicas. 

# Como lanzar la app

Ejecuta _sh execute.sh_ y accede a la instancia app para ejecutar _sh /etc/init.d/startup.sh_ tras el reinicio.

# Como destruir la app

Ejecuta _sh destroy.sh_ eliminaras toda la infraestructura aprovisionada y dejaras los documentos listos apra el siguiente lanzamiento.
