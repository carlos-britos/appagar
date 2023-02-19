# README

## Get started

```
docker-compose -f docker-compose.yml -f docker-compose.override.yml build
docker-compose -f docker-compose.yml -f docker-compose.override.yml up
docker ps # this should show the app container, for instance: appagar_webapp_1
docker exec -it appagar_webapp_1 bash
bundle exec rake db:create db:migrate db:seed
```

Then go to the browser and try to visit localhost:3000.