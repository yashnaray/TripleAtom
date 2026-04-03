# Triple Atom

A full-stack Rust web application built with Leptos, Axum, and SSR/hydration support.

## Quick Start

### Local Development

1. Install the Rust nightly toolchain:
```bash
rustup toolchain install nightly
```

2. Install cargo-leptos:
```bash
cargo install cargo-leptos
```

3. Run the development server:
```bash
cargo leptos watch
```

### Building for Production

```bash
cargo leptos build --release
```

## Deployment

### Docker

Build and run with Docker:
```bash
docker build -t triple-atom .
docker run -p 3000:3000 triple-atom
```

### Docker Compose

```bash
docker-compose up -d
```

### Environment Variables

| Variable | Description | Default |
|----------|-------------|---------|
| `LEPTOS_SITE_ADDR` | Address and port to bind to | `0.0.0.0:3000` |
| `PORT` | Alternative port setting (overrides LEPTOS_SITE_ADDR port) | - |

### Manual Deployment

1. Build the release binary:
```bash
cargo build --release --features ssr
```

2. Run the binary:
```bash
./target/release/triple-atom
```

## Project Structure

- `src/main.rs` - SSR server entry point
- `src/lib.rs` - Client-side hydration entry point
- `src/app.rs` - Main application components
- `style/main.scss` - Global styles
- `public/` - Static assets

## License

MIT
