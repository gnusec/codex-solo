Buzón S3/MinIO
==============

Usa un almacén de objetos como buzón.

Entorno
```bash
export AWS_ACCESS_KEY_ID=...
export AWS_SECRET_ACCESS_KEY=...
export AWS_DEFAULT_REGION=us-east-1
export AWS_ENDPOINT_URL=http://127.0.0.1:9000   # MinIO opcional
export BUCKET=my-mailbox
```

Enviar (lado B)
```bash
KEY_PREFIX=proj1/ ./scripts/s3-mailbox/send.sh "review ok"
```

Sondeo (lado A)
```bash
KEY_PREFIX=proj1/ ./scripts/s3-mailbox/poll.sh
```

Notas
- En AWS S3 omite `AWS_ENDPOINT_URL`
- Puedes adjuntar metadatos JSON y parsearlos en el receptor

