# application-stacks

Docker stacks applications for work.

## Portainer and Reverse proxy

La configuración del Portainer incluye la imagen EE y un proxy basado en Caddy que puede gestionar mediante labels cualquier servicio que se encuentre desplegado dentro del Portainer.

Para poder compartir la red del reverse_proxy se necesita crear una red manualmente: 

```bash
docker network create --driver=overlay proxy
```

Esta puede ser configurada en cada servicio como una red externa.

