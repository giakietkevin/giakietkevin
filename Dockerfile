FROM python:3.10-slim

RUN useradd -m -u 1000 user
USER user
ENV HOME=/home/user
WORKDIR $HOME/app

COPY --chown=user . $HOME/app

EXPOSE 7860

CMD ["python", "-m", "http.server", "7860"]
