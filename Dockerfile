FROM python:3.10-slim
LABEL maintainer="rasheed olabanjo <olabanjorasheed@gmail.com>"
COPY   app.py test.py /app/ 
WORKDIR /app
RUN pip install  flask pytest flake8
CMD ["python", "app.py"]