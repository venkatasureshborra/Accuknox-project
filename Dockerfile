FROM debian:bullseye-slim

RUN apt-get update && apt-get install -y \
    cowsay fortune-mod netcat-openbsd bash \
    && rm -rf /var/lib/apt/lists/*
# set working directory for the application
WORKDIR /app

#Copy the Main Files
COPY wisecow.sh  /app/wisecow.sh

# Excute permission to  the file
RUN chmod +x  /app/wisecow.sh

# Changing the path
ENV PATH="/usr/games:${PATH}"


# Expose the port -- 4499
EXPOSE 4499

CMD ["./wisecow.sh"]
