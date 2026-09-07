# ============================================================
# Stage 1: Build the Go binary
# ============================================================
# --platform=$BUILDPLATFORM  lets the builder stage run on
# the host's native arch for speed; TARGETARCH controls the
# final binary architecture for the target platform.
FROM --platform=$BUILDPLATFORM golang:1.27.1-alpine AS builder

ARG TARGETARCH

WORKDIR /build

# Copy module files first for better layer caching
COPY go.mod go.sum* ./
RUN go mod download 2>/dev/null; true

# Copy the rest of the source code
COPY . .

# Static, stripped build for the requested target architecture
RUN CGO_ENABLED=0 GOOS=linux GOARCH=${TARGETARCH} \
    go build -ldflags="-s -w" -o /app ./main.go

# ============================================================
# Stage 2: Minimal runtime image
# ============================================================
FROM scratch

# Copy the compiled binary
COPY --from=builder /app /app

USER 65534:65534

EXPOSE 32777

ENTRYPOINT ["/app"]