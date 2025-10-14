const express = require('express');
const app = express();
const port = process.env.PORT || 8080;
app.get('/healthz', (_req, res) => res.json({ ok: true, service: 'api-gateway' }));
app.get('/', (_req, res) => res.send('Hello from api-gateway-node'));
app.listen(port, () => console.log(`api-gateway listening on :${port}`));
