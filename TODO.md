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


python:
    
    import code
    code.interact(local=dict(globals(), **locals()))
    import coloredlogs, logging
    coloredlogs.install() #coloredlogs.install(level='DEBUG')

[how-do-i-clone-a-subdirectory-only-of-a-git-repository](https://stackoverflow.com/a/13738951/7596401)
