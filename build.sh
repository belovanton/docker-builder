docker build -t d.tool-kit.tech/petrovich-ts . --no-cache
#docker push d.tool-kit.tech/petrovich-ts:latest
docker-compose stop
docker-compose rm -f
docker-compose up -d