# Use a minimal base image
FROM alpine:latest AS build

# Install dependencies
RUN apk add --no-cache git build-base

# Copy the local source code
COPY . /src

# Build the application
RUN cd /src && make

# Use a minimal runtime image based on Distroless
FROM gcr.io/distroless/base-debian10

# Copy the built application from the build stage
COPY --from=build /src/bin/app /app

# Set an environment variable
ENV EXAMPLE_ENV=example-value

# Run the application as a non-root user
RUN adduser -D -g '' appuser
USER appuser

# Expose the application's port
EXPOSE 8080

# Start the application using an entrypoint
ENTRYPOINT ["/app"]
