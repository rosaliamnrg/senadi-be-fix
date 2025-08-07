FROM python:3.10-slim

ENV DEBIAN_FRONTEND=noninteractive
ENV HOME=/home/user
ENV PATH=$HOME/.local/bin:$PATH

# Install sistem dependensi
RUN apt-get update && apt-get install -y \
    libgl1-mesa-glx \
    libglib2.0-0 \
    build-essential \
    curl \
    && rm -rf /var/lib/apt/lists/*

# Tambahkan user non-root
RUN useradd -m -u 1000 user

USER user
WORKDIR $HOME

# Salin dan install dependencies
COPY --chown=user requirements.txt .
RUN pip install --upgrade pip && pip install -r requirements.txt

# Salin seluruh kode project
COPY --chown=user . .

EXPOSE 8080

# Jalankan aplikasi Flask dengan Gunicorn (4 worker)
CMD ["gunicorn", "-w", "1", "-b", "0.0.0.0:8080", "app:app"]