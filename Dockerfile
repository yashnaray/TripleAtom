FROM rust:1-slim AS chef
RUN apt-get update && apt-get install -y --no-install-recommends \
    pkg-config libssl-dev ca-certificates perl \
    && rm -rf /var/lib/apt/lists/*
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
