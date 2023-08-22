FROM python:3.11
WORKDIR /code
RUN pip install --upgrade pip && pip install poetry
COPY /backend/pyproject.toml .
RUN poetry install
# lockファイルをrequirements.txtへ出力
# --without-hashes: 出力したファイルのハッシュを除外
# -o(output) requirements.txt：requirements.txtとして出力
RUN poetry export -f requirements.txt --without-hashes -o requirements.txt
