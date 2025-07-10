# Dockerfile for PANTOOLS v4.3.3
FROM ubuntu:22.04

RUN ln -snf /usr/share/zoneinfo/$TZ /etc/localtime && echo $TZ > /etc/timezone

RUN apt-get update && apt-get install -y --no-install-recommends \
    maven \
    git \
    wget \
    curl \
    unzip \
    build-essential \
    zlib1g-dev \
    cmake \
    make \
    gcc \
    g++ \
    mcl \
    mafft \
    iqtree \
    fasttree \
    r-base \
    r-cran-ggplot2 \
    r-cran-ape \
    graphviz \
    bcftools \
    tabix \
    ncbi-blast+ \
    paml \
    libgsl-dev \
    python3-pip \
    kmc \
    mash \
    fastani \
    && apt-get clean
     
RUN apt-get update && apt-get install -y --no-install-recommends \
    openjdk-8-jdk
    
# Install pal2nal >= 14.1
RUN wget http://www.bork.embl.de/pal2nal/distribution/pal2nal.v14.tar.gz && \
    tar -xvzf pal2nal.v14.tar.gz && \
    cp pal2nal.v14/pal2nal.pl /usr/local/bin/ && chmod +x /usr/local/bin/pal2nal.pl && \
    rm -rf pal2nal*

# Install R-packages : cowplot et aster
RUN Rscript -e "install.packages(c('cowplot', 'aster'), repos='https://cloud.r-project.org/')"

# Install MCScanX (pas dans le conda.yaml mais dans la doc pantools https://pantools.readthedocs.io/en/latest/getting_started/install.html#install-from-download )

#RUN wget http://chibba.pgml.uga.edu/mcscan2/MCScanX.zip && \
#    unzip MCScanX.zip && \
#    cd MCScanX && \
#    make && \
#    cp MCScanX /usr/local/bin/

# Busco non installé : nécessite Conda/Python venv avec dépendances complexes

# Nettoyage
RUN apt-get clean && rm -rf /var/lib/apt/lists/*

# Définir Java 8 comme version par défaut
ENV JAVA_HOME=/usr/lib/jvm/java-8-openjdk-amd64
ENV PATH=$JAVA_HOME/bin:$PATH    
	
RUN git clone https://git.wur.nl/bioinformatics/pantools.git

WORKDIR pantools

RUN git checkout v4.3.3

RUN mvn package	

RUN echo "alias pantools='java -Xms20g -Xmx50g -jar ./target/pantools-4.3.3.jar'" >> ~/.bashrc

CMD [ "bash" ]
