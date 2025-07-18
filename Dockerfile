FROM scalr/runner

# Install git-crypt
RUN apt-get update && \
    apt-get install -y --no-install-recommends \
        git-crypt \
        ca-certificates \
        openssl && \
    rm -rf /var/lib/apt/lists/*

# Verify git-crypt installation
RUN git-crypt --version

# Set working directory
WORKDIR /workspace

# Copy the repository files
COPY . .

# Ensure scripts are executable
RUN chmod +x *.sh

# Default command
CMD ["/bin/bash"]
