FROM debian:bookworm-slim
WORKDIR /app
COPY app/ /app/
RUN chmod +x /app/*.sh
ENTRYPOINT ["/app/app.sh"]
CMD ["help"]
