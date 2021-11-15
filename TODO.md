# TODO

- Probar buildx 
- Hacer el builder (pero no matarme)
- Ficheros de usuario y root. 
- Hacer el instalador 
- Ver si bats tiene en doker las librerias. 
- https://github.com/sharkdp/vivid
- Ver la estrategia de pruebas
- Meter los colores en el profile.
- Usar el macbook probar o un vagrant.
- Ver si puedo usar el ENV tambien en mac que ya probe. y el launchd 
- Ver como se instala el nginx que lio tiene en el mac si no es nixosx 
- Ver cuanto pesa el PS1 
- Probar que se necesita en cada profile de cada maquina que he quitado y meterlo con funciones a lo mejore antes del mio que se hagan source. Copiarlas directamente ? 
- Necesito la fuente para el PS1 ? 
- Estaba con cual iba a usar de los directorios. Puedo generar los alias con pre-commit !

Kali network 

      sudo /etc/init.d/networking restart
      apt-get install -y ntpdate
      ntpdate -v pool.ntp.org

docker 

    docker exec -it f525926e0172 bash
    docker inspect ce84c1397ff0 --format '{{ .Config.Env | json }}' | python -m json.tool
    docker images
    docker ps
    docker rmi name_of_image
    docker rm $(docker ps -aq)
    docker logs -tf name_of_container
    docker-compose pull
    docker-compose up
    docker-compose up --force-recreate
    docker-compose up name_of_service #start a particular service defined in docker-compose file
    docker-compose down
    docker-compose -f docker-compose.debug.yml up --build
    docker stop $(docker ps -q)    #stop all containers, forcefully: -f
    docker rm $(docker ps -a -q)   #remove all containers, forcefully: -f
    docker rmi $(docker images -q) #remove all docker images, forcefully: -f
    docker volume ls -qf dangling=true | xargs -r docker volume rm #remove all docker volumes
    docker rm (docker ps -a |grep redis |awk '{print $1}') #Remove all containers by image.ex: remove all redis containers
    docker network create nginx-proxy


python:
    
    import code
    code.interact(local=dict(globals(), **locals()))
    import coloredlogs, logging
    coloredlogs.install() #coloredlogs.install(level='DEBUG')

[how-do-i-clone-a-subdirectory-only-of-a-git-repository](https://stackoverflow.com/a/13738951/7596401)


history | grep docker | awk '{print $1="", $0 }' | sort | uniq
