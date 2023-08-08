# Use Ubuntu 20.04 as the base image
FROM ubuntu:20.04
COPY entrypoint.sh /usr/local/bin/
RUN chmod +x /usr/local/bin/entrypoint.sh
# Install necessary tools
RUN apt-get update && apt-get install -y sed

# Set the working directory inside the container
WORKDIR /app

# Step 1: Copy kcn-linux-amd64 and homi-linux-amd64 folders to /app in the container
# COPY kcn-linux-amd64 /app
# COPY homi-linux-amd64 /app
COPY . /app/

# # Step 2: Generate scripts with Homi]
# RUN chmod +x /app/homi-linux-amd64/bin/homi
# RUN /app/homi-linux-amd64/bin/homi setup local --cn-num 1

# # Step 3: Make 'data' and 'data/klay' folders
# RUN mkdir /app/kcn-linux-amd64/data
# RUN mkdir /app/kcn-linux-amd64/data/klay

# # Step 4: Move files to your_working_directory
# RUN cp /app/homi-linux-amd64/bin/homi-output/keys/keystore1 /app/kcn-linux-amd64/data

# RUN cp /app/homi-linux-amd64/bin/homi-output/keys/nodekey1 /app/kcn-linux-amd64/data/klay
# RUN cp /app/homi-linux-amd64/bin/homi-output/scripts/genesis.json /app/kcn-linux-amd64/data

# # Step 5: Edit configuration files using ENV
# ENV NETWORK_ID=2500
# ENV REWARDBASE="0x043c471bee060e00a56ccd02c0ca286808a5a436"
ENV DATA_DIR=/app/kcn-linux-amd64/data

# # Example: Set RPC configuration using ENV
# ENV RPC_PORT=8556

RUN echo ${DATA_DIR}

# # Apply the environment variables to the configuration file
RUN sed -i "s/^NETWORK_ID=.*/NETWORK_ID=${NETWORK_ID}/" /app/kcn-linux-amd64/conf/kcnd.conf && \
    sed -i "s/^REWARDBASE=.*/REWARDBASE=${REWARDBASE}/" /app/kcn-linux-amd64/conf/kcnd.conf && \
    sed -i "s#^DATA_DIR=.*#DATA_DIR=${DATA_DIR}#" /app/kcn-linux-amd64/conf/kcnd.conf
    # sed -i "s#^RPC_PORT=.*#RPC_PORT=${RPC_PORT}#" /app/kcn-linux-amd64/conf/kcnd.conf

# # Step 6: Initialize with genesis.json
RUN /app/kcn-linux-amd64/bin/kcn init --datadir /app/kcn-linux-amd64/data /app/kcn-linux-amd64/data/genesis.json

# Step 7: Start KCN
EXPOSE 8551

# CMD ["RUN", "entrypoint.sh"]
ENTRYPOINT ["entrypoint.sh"]