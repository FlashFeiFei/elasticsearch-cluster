FROM elasticsearch:6.8.5

#安装ik中文分词

ENV VERSION=6.8.5

RUN sh -c '/bin/echo -e "y" | ./bin/elasticsearch-plugin install https://github.com/medcl/elasticsearch-analysis-ik/releases/download/v${VERSION}/elasticsearch-analysis-ik-${VERSION}.zip'