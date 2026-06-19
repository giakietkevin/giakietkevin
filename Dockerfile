# Sử dụng base image Python mượt và nhẹ
FROM python:3.10-slim

# Thiết lập thư mục làm việc trong container
WORKDIR /code

# Cài đặt các thư viện hệ thống cần thiết (ví dụ cho OpenCV, Git, hoặc build tools nếu cần)
RUN apt-get update && apt-get install -y \
    build-essential \
    curl \
    software-properties-common \
    git \
    libgl1-mesa-glx \
    libglib2.0-0 \
    && rm -rf /var/lib/apt/lists/*

# Copy file requirements vào trước để tận dụng Docker cache
COPY ./requirements.txt /code/requirements.txt

# Cài đặt các thư viện Python
RUN pip install --no-cache-dir --upgrade -r /code/requirements.txt

# Cấu hình một user mới (Hugging Face yêu cầu chạy quyền non-root để đảm bảo bảo mật)
RUN useradd -m -u 1000 user
USER user
ENV HOME=/home/user \
    PATH=/home/user/.local/bin:$PATH

# Thiết lập thư mục làm việc của user
WORKDIR $HOME/app

# Copy toàn bộ code từ GitHub vào container
COPY --chown=user . $HOME/app

# Khai báo Port mà Hugging Face Space sẽ lắng nghe (Mặc định bắt buộc là 7860)
EXPOSE 7860

# Lệnh để chạy ứng dụng của cốt khi container khởi động
# Ví dụ 1: Nếu chạy Streamlit app
CMD ["streamlit", "run", "app.py", "--server.port=7860", "--server.address=0.0.0.0"]

# Ví dụ 2: Nếu chạy Gradio app hoặc python script thuần
# CMD ["python", "app.py"]
