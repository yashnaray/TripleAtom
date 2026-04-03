FROM rust:1-slim AS chef
RUN apt-get update && apt-get install -y --no-install-recommends \
    pkg-config libssl-dev ca-certificates perl make build-essential curl \
    && rm -rf /var/lib/apt/lists/*
RUN curl -fsSL https://github.com/sass/dart-sass/releases/download/1.77.5/dart-sass-1.77.5-linux-x64.tar.gz | tar -xz -C /usr/local
ENV PATH="/usr/local/dart-sass:$PATH"
RUN rustup target add wasm32-unknown-unknown --toolchain nightly
RUN cargo install cargo-leptos --locked
WORKDIR /app

FROM chef AS planner
COPY . .
RUN cargo leptos build --release -vv

FROM chef AS builder
COPY . .
COPY --from=planner /app/target/leptos/ /app/target/leptos/
RUN cargo leptos build --release

FROM debian:bookworm-slim AS runtime
RUN apt-get update && apt-get install -y --no-install-recommends \
    ca-certificates openssl \
    && rm -rf /var/lib/apt/lists/*
WORKDIR /app
COPY --from=builder /app/target/site ./site
COPY --from=builder /app/target/release/triple-atom ./bin
ENV LEPTOS_SITE_ADDR=0.0.0.0:3000
EXPOSE 3000
CMD ["./bin"]
